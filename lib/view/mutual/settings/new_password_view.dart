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

class _ChangePasswordContent extends StatefulWidget {
  const _ChangePasswordContent();

  @override
  State<_ChangePasswordContent> createState() => _ChangePasswordContentState();
}

class _ChangePasswordContentState extends State<_ChangePasswordContent> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isConfirmPasswordVisible =
  ValueNotifier<bool>(false);

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _isPasswordVisible.dispose();
    _isConfirmPasswordVisible.dispose();
    super.dispose();
  }

  void _submit() {
    final pw = _passwordController.text.trim();
    final cpw = _confirmPasswordController.text.trim();

    if (pw.length < 8) {
      _showSnack(message: context.tr('change_pw_error_length'), isError: true);
      return;
    }

    if (pw != cpw) {
      _showSnack(message: context.tr('change_pw_error_match'), isError: true);
      return;
    }

    final profileState = context.read<ProfileCubit>().state;

    if (profileState is! ProfileLoaded) {
      _showSnack(
        message: context.tr('change_pw_user_not_found'),
        isError: true,
      );
      return;
    }

    context.read<ChangePasswordCubit>().changePassword(
      userId: profileState.user.id,
      newPassword: pw,
      confirmPassword: cpw,
    );
  }

  void _showSnack({required String message, required bool isError}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
          ),
          backgroundColor:
          isError ? Colors.red.shade600 : AppColors.primaryTeal,
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

    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          _showSnack(message: state.message, isError: false);
          _passwordController.clear();
          _confirmPasswordController.clear();
          context.read<ChangePasswordCubit>().reset();
          Future.delayed(const Duration(milliseconds: 400), () {
            if (context.mounted) Navigator.pop(context);
          });
        }
        if (state is ChangePasswordError) {
          _showSnack(message: state.errorMessage, isError: true);
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: _buildAppBar(context, isDark),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              return Directionality(
                textDirection: localeState.textDirection,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 40 : 20,
                        vertical: 24,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 480),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _HeaderIcon(colorScheme: cs, isDark: isDark),
                              const SizedBox(height: 20),
                              _HeaderText(colorScheme: cs),
                              const SizedBox(height: 28),
                              _FormCard(
                                passwordController: _passwordController,
                                confirmPasswordController:
                                _confirmPasswordController,
                                isPasswordVisible: _isPasswordVisible,
                                isConfirmPasswordVisible:
                                _isConfirmPasswordVisible,
                                onSubmit: _submit,
                                isDark: isDark,
                                colorScheme: cs,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      title: Text(
        context.tr('change_pw_title'),
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.bold,
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
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final ColorScheme colorScheme;
  final bool isDark;
  const _HeaderIcon({required this.colorScheme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryTeal.withOpacity(0.85),
              AppColors.primaryTeal,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryTeal.withOpacity(isDark ? 0.4 : 0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.lock_reset_rounded,
          color: Colors.white,
          size: 44,
        ),
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final ColorScheme colorScheme;
  const _HeaderText({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.tr('change_pw_heading'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          context.tr('change_pw_subtitle'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: colorScheme.onSurfaceVariant.withOpacity(0.75),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _FormCard extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ValueNotifier<bool> isPasswordVisible;
  final ValueNotifier<bool> isConfirmPasswordVisible;
  final VoidCallback onSubmit;
  final bool isDark;
  final ColorScheme colorScheme;

  const _FormCard({
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.onSubmit,
    required this.isDark,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 14),
          PasswordField(
            controller: confirmPasswordController,
            isVisibleNotifier: isConfirmPasswordVisible,
            label: context.tr('change_pw_confirm_password'),
            icon: Icons.check_circle_outline_rounded,
            decoration: FieldStyles.authInputDecoration(
              label: context.tr('change_pw_confirm_password'),
              icon: Icons.check_circle_outline_rounded,
            ),
          ),
          const SizedBox(height: 28),
          BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
            builder: (context, state) {
              final isLoading = state is ChangePasswordLoading;
              if (isLoading) {
                return SizedBox(
                  height: 52,
                  child: Center(
                    child: SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        color: AppColors.primaryTeal,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
                );
              }
              return Button(
                text: context.tr('change_pw_update'),
                color: AppColors.primaryTeal,
                colorText: Colors.white,
                onPressed: onSubmit,
              );
            },
          ),
        ],
      ),
    );
  }
}