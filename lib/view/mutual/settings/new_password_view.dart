import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app_localizations.dart';
import '../../../app_theme.dart';
import '../../../cubit/locale/locale_cubit.dart';
import '../../../cubit/locale/locale_state.dart';
import '../../../cubit/profile/profile_cubit.dart';
import '../../../cubit/profile/profile_state.dart';
import '../../../cubit/change_password/change_password_cubit.dart';
import '../../../services/api_service.dart';
import '../../../services/auth/profile_service.dart';
import '../../../services/auth/change_password_service.dart';
import '../../../widget/button.dart';
import '../../../widget/password_field.dart';
import '../../../widget/field_styles.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final String userToken;

  const ForgetPasswordScreen({super.key, required this.userToken});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService()..forceUpdateToken(userToken);

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(ProfileService(apiService))
            ..fetchUserProfile(token: userToken),
        ),
        BlocProvider<ChangePasswordCubit>(
          create: (_) =>
              ChangePasswordCubit(ChangePasswordService(apiService)),
        ),
      ],
      child: const _ChangePasswordContent(),
    );
  }
}

class _ChangePasswordContent extends StatelessWidget {
  const _ChangePasswordContent();

  void _submit(
      BuildContext context,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController,
      ) {
    final pw = passwordController.text.trim();
    final cpw = confirmPasswordController.text.trim();

    if (pw.length < 8) {
      _showSnack(context, message: context.tr('change_pw_error_length'), isError: true);
      return;
    }

    if (pw != cpw) {
      _showSnack(context, message: context.tr('change_pw_error_match'), isError: true);
      return;
    }

    final profileState = context.read<ProfileCubit>().state;

    if (profileState is! ProfileLoaded) {
      _showSnack(
        context,
        message: context.tr('change_pw_user_not_found'),
        isError: true,
      );
      return;
    }

    context.read<ChangePasswordCubit>().changePassword(
      userId: profileState.user.id,
      newPassword: pw,
      confirmPassword: cpw,
      tr: context.tr,
    );
  }

  void _showSnack(BuildContext context, {required String message, required bool isError}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
          ),
          backgroundColor: isError ? Colors.red.shade600 : AppColors.primaryTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    // 🟢 تعريف المتحكمات مباشرة داخل الـ build الخاص بالـ StatelessWidget
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final isPasswordVisible = ValueNotifier<bool>(false);
    final isConfirmPasswordVisible = ValueNotifier<bool>(false);

    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          _showSnack(context, message: state.message, isError: false);
          passwordController.clear();
          confirmPasswordController.clear();
          context.read<ChangePasswordCubit>().reset();
          Future.delayed(const Duration(milliseconds: 400), () {
            if (context.mounted) Navigator.pop(context);
          });
        }
        if (state is ChangePasswordError) {
          _showSnack(context, message: state.errorMessage, isError: true);
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        body: BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            return Directionality(
              textDirection: localeState.textDirection,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.42,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/Images/ronaldo1.png',
                            fit: BoxFit.cover,
                            alignment: Alignment.topRight,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  cs.surface.withOpacity(0.8),
                                  cs.surface,
                                ],
                                stops: const [0.5, 0.85, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // كارت المدخلات
                    Transform.translate(
                      offset: const Offset(0, -20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: isDark ? cs.surfaceContainerHigh : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: cs.outlineVariant.withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                                blurRadius: 20,
                                spreadRadius: 1,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              PasswordField(
                                controller: passwordController,
                                isVisibleNotifier: isPasswordVisible,
                                label: context.tr('change_pw_new_password'),
                                icon: Icons.lock_outline_rounded,
                                decoration: FieldStyles.authInputDecoration(
                                  label: context.tr('change_pw_new_password'),
                                  icon: Icons.lock_outline_rounded,
                                ),
                              ),
                              const SizedBox(height: 16),
                              PasswordField(
                                controller: confirmPasswordController,
                                isVisibleNotifier: isConfirmPasswordVisible,
                                label: context.tr('change_pw_confirm_password'),
                                icon: Icons.shield_outlined,
                                decoration: FieldStyles.authInputDecoration(
                                  label: context.tr('change_pw_confirm_password'),
                                  icon: Icons.shield_outlined,
                                ),
                              ),
                              const SizedBox(height: 24),
                              BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                                builder: (context, state) {
                                  final isLoading = state is ChangePasswordLoading;
                                  if (isLoading) {
                                    return const SizedBox(
                                      height: 50,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primaryTeal,
                                        ),
                                      ),
                                    );
                                  }
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: Button(
                                      text: context.tr('change_pw_update'),
                                      color: AppColors.primaryTeal,
                                      colorText: Colors.white,
                                      onPressed: () => _submit(
                                        context,
                                        passwordController,
                                        confirmPasswordController,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // العبارة 1
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_reset_rounded,
                            size: 18,
                            color: AppColors.primaryTeal,
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              context.tr('change_pw_heading'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: cs.onSurfaceVariant.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // العبارة 2
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            size: 18,
                            color: cs.primary.withOpacity(0.8),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              context.tr('change_pw_subtitle'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: cs.onSurfaceVariant.withOpacity(0.65),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // العبارة 3
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: cs.primary.withOpacity(0.8),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              context.tr('change_pw_error_length'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: cs.onSurfaceVariant.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}