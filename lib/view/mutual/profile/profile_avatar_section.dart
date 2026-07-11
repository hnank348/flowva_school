import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/profile/profile_update_cubit.dart';

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

    return Stack(
      children: [
        // ─── الدائرة ───
        Container(
          width: 150, height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cs.primary.withOpacity(0.1),
            border: Border.all(color: cs.primary.withOpacity(0.3), width: 3),
            boxShadow: [
              BoxShadow(color: cs.primary.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))
            ],
          ),
          child: ClipOval(
            child: pickedImage != null
                ? Image.file(pickedImage!, fit: BoxFit.cover)
                : (hasValidAvatar
                ? Image.network(avatarUrl, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _Initials(initials: initials, cs: cs))
                : _Initials(initials: initials, cs: cs)),
          ),
        ),

        // ─── زر الكاميرا ───
        if (isEditing)
          Positioned(
            bottom: 0, right: 0,
            child: GestureDetector(
              onTap: onPickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.primary, shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 2))],
                ),
                child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
              ),
            ),
          ),

        // ─── مؤشر التحميل ───
        BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
          builder: (context, state) {
            if (state is! ProfileUpdateLoading) return const SizedBox();
            return Positioned.fill(
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.35)),
                child: Center(child: CircularProgressIndicator(color: cs.primary, strokeWidth: 2.5)),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Initials extends StatelessWidget {
  final String initials;
  final ColorScheme cs;
  const _Initials({required this.initials, required this.cs});

  @override
  Widget build(BuildContext context) => Center(
    child: Text(initials,
        style: TextStyle(fontFamily: 'Cairo', fontSize: 32, fontWeight: FontWeight.bold, color: cs.primary)),
  );
}
