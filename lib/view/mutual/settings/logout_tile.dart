import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/logout/logout_cubit.dart';
import 'package:flowva_school/cubit/logout/logout_state.dart';
import 'package:flowva_school/app_localizations.dart';
import 'package:flowva_school/view/auth/login/login_view.dart';

class LogoutTile extends StatelessWidget {
  final ColorScheme colorScheme;
  final bool isDark;
  final String label;

  const LogoutTile({
    super.key,
    required this.colorScheme,
    required this.isDark,
    required this.label,
  });

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          context.tr('logout_confirm_title'),
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        content: Text(
          context.tr('logout_confirm_body'),
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              context.tr('logout_cancel'),
              style: TextStyle(fontFamily: 'Cairo', color: colorScheme.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<LogoutCubit>().logout();
            },
            child: Text(
              context.tr('logout_confirm_btn'),
              style: TextStyle(
                fontFamily: 'Cairo',
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
          );
        }

        if (state is LogoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      child: BlocBuilder<LogoutCubit, LogoutState>(
        builder: (context, state) {
          final isLoading = state is LogoutLoading;

          return Container(
            decoration: BoxDecoration(
              color: isDark ? colorScheme.surfaceContainer : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.error.withOpacity(0.3),
                width: 0.8,
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: isLoading ? null : () => _confirmLogout(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: colorScheme.error.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: isLoading
                          ? Padding(
                        padding: const EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.error,
                        ),
                      )
                          : Icon(Icons.logout_rounded,
                          size: 18, color: colorScheme.error),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}