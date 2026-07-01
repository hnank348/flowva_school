import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flowva_school/cubit/profile/profile_cubit.dart';
import 'package:flowva_school/cubit/profile/profile_state.dart';
import 'package:flowva_school/models/teacher/user_model.dart';
import 'package:flowva_school/services/api_service.dart' as services;
import 'package:flowva_school/services/auth/profile_service.dart';
import 'package:flowva_school/app_localizations.dart';

class ProfileView extends StatelessWidget {
  final String userToken;

  const ProfileView({super.key, required this.userToken});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark      = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider<ProfileCubit>(
      create: (_) {
        final api = services.ApiService();
        return ProfileCubit(ProfileService(api))
          ..fetchUserProfile(token: userToken);
      },
      child: Scaffold(
        backgroundColor: isDark ? colorScheme.surface : const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: Text(
            context.tr('profile_title'),
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
              bottomLeft:  Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return Center(
                  child: CircularProgressIndicator(
                      color: colorScheme.primary, strokeWidth: 2.5),
                );
              }

              if (state is ProfileError) {
                return _ErrorBody(
                  message:  state.errorMessage,
                  onRetry:  () => context
                      .read<ProfileCubit>()
                      .fetchUserProfile(token: userToken),
                  colorScheme: colorScheme,
                );
              }

              if (state is ProfileLoaded) {
                return _ProfileBody(
                  user:    state.user,
                  isDark:  isDark,
                  colorScheme: colorScheme,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

// ─── Body الرئيسي ───────────────────────────────────────────────────────────

class _ProfileBody extends StatelessWidget {
  final UserModel user;
  final bool isDark;
  final ColorScheme colorScheme;

  const _ProfileBody({
    required this.user,
    required this.isDark,
    required this.colorScheme,
  });

  String _getFormattedBirthDate(BuildContext context) {
    if (user.dateOfBirth == null) return context.tr('profile_not_specified');
    try {
      return intl.DateFormat('yyyy / MM / dd')
          .format(DateTime.parse(user.dateOfBirth!));
    } catch (_) {
      return context.tr('profile_not_specified');
    }
  }

  String _getInitials(String displayName) {
    final parts = displayName.trim().split(' ');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0];
    return 'U';
  }

  bool get _hasValidAvatar {
    final url = user.avatarUrl ?? '';
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    // 🌟 فحص لغة التطبيق الحالية
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // 🌟 تطبيق الطريقة والشرط الذي طلبته تماماً لمعالجة وعرض الاسم
    String displayName = isArabic
        ? (user.fullNameAr.isNotEmpty
        ? user.fullNameAr
        : user.fullName)
        : (user.fullName.isNotEmpty
        ? user.fullName
        : user.fullNameAr);

    // في حال كان الحقلين فارغين من السيرفر، نضع مستخدم كقيمة افتراضية
    if (displayName.isEmpty) {
      displayName = context.tr('profile_default_user');
    }

    final initials = _getInitials(displayName);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 40 : 16,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              // الصفحة تنقلب بالكامل تلقائياً حسب اتجاه اللغة لترتيب البيانات على الجانب الصحيح دون Directionality ثابتة
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ─── Hero الأفاتار ───
                  _HeroSection(
                    initials:        initials,
                    displayName:     displayName,
                    email:           user.email,
                    hasValidAvatar:  _hasValidAvatar,
                    avatarUrl:       user.avatarUrl ?? '',
                    colorScheme:     colorScheme,
                    isDark:          isDark,
                  ),

                  const SizedBox(height: 28),

                  // ─── سيكشن البيانات ───
                  _SectionLabel(label: context.tr('profile_personal_info')),
                  const SizedBox(height: 8),
                  _InfoCard(
                    isDark:      isDark,
                    colorScheme: colorScheme,
                    items: [
                      _InfoItem(
                        icon:  Icons.person_outline_rounded,
                        label: context.tr('profile_full_name'),
                        value: displayName,
                      ),
                      _InfoItem(
                        icon:  Icons.phone_android_outlined,
                        label: context.tr('profile_phone_number'),
                        value: user.phone ?? context.tr('profile_not_added'),
                        isMissing: user.phone == null,
                      ),
                      _InfoItem(
                        icon:  Icons.cake_outlined,
                        label: context.tr('profile_birth_date'),
                        value: _getFormattedBirthDate(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Hero Section ────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final String initials;
  final String displayName;
  final String email;
  final bool hasValidAvatar;
  final String avatarUrl;
  final ColorScheme colorScheme;
  final bool isDark;

  const _HeroSection({
    required this.initials,
    required this.displayName,
    required this.email,
    required this.hasValidAvatar,
    required this.avatarUrl,
    required this.colorScheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // أفاتار
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.primary.withOpacity(0.1),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: hasValidAvatar
              ? ClipOval(
            child: Image.network(
              avatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _Initials(
                initials: initials,
                colorScheme: colorScheme,
              ),
            ),
          )
              : _Initials(initials: initials, colorScheme: colorScheme),
        ),

        const SizedBox(height: 14),

        // الاسم المفلتر حسب اللغة والشرط
        Text(
          displayName,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 4),

        // الإيميل
        Text(
          email,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
          textDirection: TextDirection.ltr, // يظل الإيميل من اليسار دائماً لكلا اللغتين
        ),

        const SizedBox(height: 10),

        // بادج الدور
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: colorScheme.primary.withOpacity(0.2), width: 0.8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shield_outlined, size: 13, color: colorScheme.primary),
              const SizedBox(width: 5),
              Text(
                context.tr('profile_role_supervisor'),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Initials extends StatelessWidget {
  final String initials;
  final ColorScheme colorScheme;

  const _Initials({required this.initials, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

// ─── Info Card ───────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final List<_InfoItem> items;
  final bool isDark;
  final ColorScheme colorScheme;

  const _InfoCard({
    required this.items,
    required this.isDark,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainer : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(isDark ? 0.3 : 0.6),
          width: 0.8,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i    = entry.key;
          final item = entry.value;
          return Column(
            children: [
              _InfoRow(item: item, colorScheme: colorScheme, isDark: isDark),
              if (i < items.length - 1)
                Divider(
                  height: 1,
                  thickness: 0.5,
                  indent: 56,
                  endIndent: 16,
                  color: colorScheme.outlineVariant.withOpacity(0.4),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final _InfoItem item;
  final ColorScheme colorScheme;
  final bool isDark;

  const _InfoRow({
    required this.item,
    required this.colorScheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(item.icon, size: 18, color: colorScheme.primary),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // يبدأ تلقائياً مع اتجاه الصفحة الحالي (يمين للعربي / يسار للإنجليزي)
              children: [
                Text(
                  item.label,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.value,
                  style: TextStyle(
                    fontFamily: item.isEmail ? 'Roboto' : 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: item.isMissing
                        ? colorScheme.onSurfaceVariant.withOpacity(0.4)
                        : colorScheme.onSurface,
                  ),
                  textDirection: item.isEmail ? TextDirection.ltr : null, // الإيميل فقط يثبت LTR
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final bool isMissing;
  final bool isEmail;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.isMissing = false,
    this.isEmail   = false,
  });
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurfaceVariant.withOpacity(0.6),
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final ColorScheme colorScheme;

  const _ErrorBody({
    required this.message,
    required this.onRetry,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 48, color: colorScheme.error.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(context.tr('profile_retry'),
                  style: const TextStyle(fontFamily: 'Cairo')),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(color: colorScheme.primary.withOpacity(0.3)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}