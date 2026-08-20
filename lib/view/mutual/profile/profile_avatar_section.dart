import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/profile/profile_update_cubit.dart';
import 'package:flowva_school/services/constant_api.dart';
import 'package:flowva_school/widget/custom_avatar.dart';

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
    const double avatarRadius = 100;

    return SizedBox(
      width: avatarRadius * 2,
      height: avatarRadius * 2,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.primary.withOpacity(0.08),
              border: Border.all(color: cs.primary.withOpacity(0.3), width: 3.5),
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: pickedImage != null
                ? ClipOval(
              child: Image.file(
                pickedImage!,
                fit: BoxFit.cover,
                width: avatarRadius * 2,
                height: avatarRadius * 2,
              ),
            )
                : CustomAvatar(
              imageUrl: fullAvatarUrl,
              radius: avatarRadius - 4,
              backgroundColor: cs.primary.withOpacity(0.12),
              iconColor: cs.primary,
            ),
          ),

          // ─── مؤشر التحميل ───
          BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
            builder: (context, state) {
              if (state is! ProfileUpdateLoading) return const SizedBox.shrink();

              return IgnorePointer(
                child: Container(
                  width: avatarRadius * 2,
                  height: avatarRadius * 2,
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
}