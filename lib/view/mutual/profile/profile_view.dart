import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/profile/profile_cubit.dart';
import 'package:flowva_school/cubit/profile/profile_state.dart';
import 'package:flowva_school/cubit/profile/profile_update_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import 'package:flowva_school/services/api_service.dart' as services;
import 'package:flowva_school/services/auth/profile_service.dart';
import 'package:flowva_school/app_localizations.dart';
import 'package:flowva_school/widget/button.dart';
import 'profile_card.dart';

class ProfileView extends StatelessWidget {
  final String userToken;

  const ProfileView({super.key, required this.userToken});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs     = Theme.of(context).colorScheme;

    return BlocProvider<ProfileCubit>(
      create: (_) {
        final api = services.ApiService();
        return ProfileCubit(ProfileService(api))
          ..fetchUserProfile(token: userToken);
      },
      child: Builder(
        builder: (ctx) => BlocProvider<ProfileUpdateCubit>(
          create: (_) => ProfileUpdateCubit(
            ProfileService(services.ApiService()),
            ctx.read<ProfileCubit>(),
          ),
          child: Scaffold(
            backgroundColor: cs.surface,
            appBar: _buildAppBar(context, isDark),
            body: SafeArea(
              child: BlocBuilder<LocaleCubit, LocaleState>(
                builder: (context, localeState) {
                  return BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 2.5,
                          ),
                        );
                      }
                      if (state is ProfileError) {
                        return _ErrorBody(
                          message: state.errorMessage,
                          onRetry: () => context
                              .read<ProfileCubit>()
                              .fetchUserProfile(token: userToken),
                        );
                      }
                      if (state is ProfileLoaded) {
                        return ProfileCard(
                          user:        state.user,
                          userToken:   userToken,
                          isDark:      isDark,
                          localeState: localeState,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      title: Text(
        context.tr('profile_title'),
        style: const TextStyle(
          fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24),
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }
}



class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: cs.error.withOpacity(0.6)),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: cs.onSurface)),
            const SizedBox(height: 20),
            Button(
              text:      context.tr('profile_retry'),
              color:     cs.primary,
              colorText: Colors.white,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}