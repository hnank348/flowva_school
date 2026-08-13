import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/profile/profile_update_cubit.dart';
import 'package:flowva_school/services/constant_api.dart';

class ProfileAvatarSection extends StatelessWidget {
  final String initials;
  final bool hasValidAvatar;
  final String avatarUrl;
  final bool isEditing;
  final File? pickedImage;
  final VoidCallback onPickImage;

  const ProfileAvatarSection({
    super.key,
    required this.initials,
    required this.hasValidAvatar,
    required this.avatarUrl,
    required this.isEditing,
    required this.pickedImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final String? fullAvatarUrl = ConstantApi.getImageUrl(avatarUrl);

    // 🟢 مقاس الإطار الكامل للصورة (يمكنك تكبيره أو تصغيره كما تحب هنا)
    const double avatarSize = 220;

    return SizedBox(
      width: avatarSize,
      height: avatarSize,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // ─── 1. الصورة الشخصية (مطابقة لحجم الإطار 100%) ───
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.primary.withOpacity(0.1),
              border: Border.all(color: cs.primary.withOpacity(0.3), width: 3.5),
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: ClipOval(
              child: SizedBox(
                width: avatarSize,
                height: avatarSize,
                child: _buildAvatarImage(fullAvatarUrl, cs),
              ),
            ),
          ),

          // ─── 2. مؤشر التحميل ───
          BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
            builder: (context, state) {
              if (state is! ProfileUpdateLoading) return const SizedBox.shrink();

              return IgnorePointer(
                child: Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.35),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: cs.primary,
                      strokeWidth: 3.0,
                    ),
                  ),
                ),
              );
            },
          ),

          // ─── 3. زر الكاميرا ───
          if (isEditing)
            Positioned(
              bottom: 6,
              right: 6,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onPickImage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage(String? formattedUrl, ColorScheme cs) {
    if (pickedImage != null) {
      // 🟢 ملء حجم الإطار بالكامل
      return Image.file(
        pickedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (formattedUrl != null && formattedUrl.isNotEmpty) {
      // 🟢 ملء حجم الإطار بالكامل
      return Image.network(
        formattedUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _Initials(initials: initials, cs: cs),
      );
    }

    return _Initials(initials: initials, cs: cs);
  }
}

class _Initials extends StatelessWidget {
  final String initials;
  final ColorScheme cs;

  const _Initials({required this.initials, required this.cs});

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      initials,
      style: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 42,
        fontWeight: FontWeight.bold,
        color: cs.primary,
      ),
    ),
  );
}