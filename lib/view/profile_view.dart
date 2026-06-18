import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flowva_school/cubit/profile/profile_cubit.dart';
import 'package:flowva_school/cubit/profile/profile_state.dart';

import '../models/user_model.dart';
import '../services/api_service.dart' as services;
import '../services/auth/profile_service.dart';

class ProfileView extends StatelessWidget {
  // 🚀 استقبال التوكن مباشرة هنا لقطع الاعتماد على الـ Context المعزول
  final String userToken;

  const ProfileView({super.key, required this.userToken});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      ),
      body: BlocProvider<ProfileCubit>(
        // 🚀 حقن وإنشاء الكيوبيت محلياً بشكل مستقل وآمن تماماً
        create: (context) {
          final apiService = services.ApiService();
          return ProfileCubit(ProfileService(apiService))
            ..fetchUserProfile(token: userToken); // استخدام التوكن المستلم مباشرة
        },
        child: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: colorScheme.primary,
                  ),
                );
              }

              if (state is ProfileError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline_rounded, size: 60, color: colorScheme.error),
                        const SizedBox(height: 16),
                        Text(
                          state.errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            // إعادة المحاولة باستخدام التوكن المستلم في الـ Widget الأعلى
                            context.read<ProfileCubit>().fetchUserProfile(token: userToken);
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('إعادة المحاولة', style: TextStyle(fontFamily: 'Cairo')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is ProfileLoaded) {
                final UserModel user = state.user;

                // معالجة وتنسيق تاريخ الميلاد القادم من الـ API
                String formattedBirthDate = 'غير محدد';
                if (user.dateOfBirth != null) {
                  try {
                    final parsedDate = DateTime.parse(user.dateOfBirth!);
                    formattedBirthDate = intl.DateFormat('yyyy / MM / dd').format(parsedDate);
                  } catch (_) {
                    formattedBirthDate = 'غير محدد';
                  }
                }

                // 🛡️ فحص حماية الرابط لضمان عدم تمرير ملفات مؤقتة .tmp من نظام التشغيل
                final String rawUrl = user.avatarUrl ?? '';
                final bool isLinkValid = rawUrl.startsWith('http://') || rawUrl.startsWith('https://');

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    children: [
                      // 👤 هيدر الحساب العصري المحمي (Avatar Header)
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 115,
                              height: 115,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.primary,
                                    isDark ? colorScheme.surfaceContainer : colorScheme.primary.withOpacity(0.7)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withOpacity(isDark ? 0.15 : 0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  )
                                ],
                              ),
                              padding: const EdgeInsets.all(3),
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor: isDark ? colorScheme.surfaceContainerLow : Colors.white,
                                backgroundImage: isLinkValid ? NetworkImage(rawUrl) : null,
                                onBackgroundImageError: isLinkValid ? (exception, stackTrace) {
                                  debugPrint("⚠️ فشل جلب صورة الملف الشخصي: $exception");
                                } : null,
                                child: (!isLinkValid)
                                    ? Text(
                                  user.fullName.isNotEmpty ? user.fullName.substring(0, 1).toUpperCase() : 'U',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                )
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user.fullName.isNotEmpty ? user.fullName : 'مستخدم مجهول',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 13,
                                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🪪 حاوية كروت تفاصيل البيانات الشخصية الفخمة
                            Padding(
                              padding: const EdgeInsets.only(right: 6, bottom: 8),
                              child: Text(
                                'البيانات الشخصية',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: colorScheme.outlineVariant.withOpacity(isDark ? 0.4 : 0.7),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  )
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  _buildProfileTile(
                                    context,
                                    label: 'الاسم الكامل',
                                    value: user.fullName.isNotEmpty ? user.fullName : 'لا يوجد اسم مسجل',
                                    icon: Icons.person_outline_rounded,
                                  ),
                                  _buildDivider(context),
                                  _buildProfileTile(
                                    context,
                                    label: 'البريد الإلكتروني',
                                    value: user.email,
                                    icon: Icons.mail_outline_rounded,
                                    isEmail: true,
                                  ),
                                  _buildDivider(context),
                                  _buildProfileTile(
                                    context,
                                    label: 'رقم الهاتف',
                                    value: user.phone ?? 'لم يتم ربط رقم هاتف بعد',
                                    icon: Icons.phone_android_outlined,
                                    isMissing: user.phone == null,
                                  ),
                                  _buildDivider(context),
                                  _buildProfileTile(
                                    context,
                                    label: 'تاريخ الميلاد',
                                    value: formattedBirthDate,
                                    icon: Icons.cake_outlined,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTile(
      BuildContext context, {
        required String label,
        required String value,
        required IconData icon,
        bool isMissing = false,
        bool isEmail = false,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? colorScheme.surface : colorScheme.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: isEmail ? 'Roboto' : 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isMissing ? colorScheme.onSurfaceVariant.withOpacity(0.5) : colorScheme.onSurface,
                  ),
                  textDirection: isEmail ? TextDirection.ltr : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Divider(
      height: 1,
      thickness: 0.8,
      indent: 20,
      endIndent: 20,
      color: colorScheme.outlineVariant.withOpacity(0.4),
    );
  }
}