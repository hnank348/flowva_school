import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flowva_school/cubit/profile/profile_update_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import 'package:flowva_school/models/mutual/user_model.dart';
import 'package:flowva_school/app_localizations.dart';
import 'package:flowva_school/widget/button.dart';
import 'profile_avatar_section.dart';
import 'profile_form_fields.dart';

class ProfileCard extends StatelessWidget {
  final UserModel user;
  final String userToken;
  final bool isDark;
  final LocaleState localeState;

  const ProfileCard({
    super.key,
    required this.user,
    required this.userToken,
    required this.isDark,
    required this.localeState,
  });

  String _displayName(BuildContext context) {
    final isAr = localeState.currentLanguage == 'AR';
    return isAr
        ? (user.fullNameAr.isNotEmpty ? user.fullNameAr : user.fullName)
        : (user.fullName.isNotEmpty ? user.fullName : user.fullNameAr);
  }

  String _formatDate(String? raw) {
    if (raw == null) return '';
    try {
      return intl.DateFormat('yyyy / MM / dd').format(DateTime.parse(raw));
    } catch (_) {
      return '';
    }
  }

  String? _toApiDate(String display) {
    try {
      final parts = display.replaceAll(' ', '').split('/');
      if (parts.length == 3) return '${parts[0]}-${parts[1]}-${parts[2]}';
    } catch (_) {}
    return null;
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  Future<void> _pickImage(BuildContext context) async {
    final cubit = context.read<ProfileUpdateCubit>();
    try {
      final picker = ImagePicker();
      final img = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (img != null) {
        cubit.setPickedImage(File(img.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _save(
      BuildContext context,
      TextEditingController nameCtrl,
      TextEditingController phoneCtrl,
      TextEditingController birthDateCtrl,
      ) {
    final isAr = localeState.currentLanguage == 'AR';
    final parts = nameCtrl.text.trim().split(' ');
    final first = parts.isNotEmpty ? parts.first : '';
    final last = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    context.read<ProfileUpdateCubit>().updateProfile(
      userId: user.id,
      userToken: userToken,
      firstName: isAr ? null : first,
      firstNameAr: isAr ? first : null,
      lastName: isAr ? null : last,
      lastNameAr: isAr ? last : null,
      phone: phoneCtrl.text.trim(),
      dateOfBirth: _toApiDate(birthDateCtrl.text),
    );
  }

  void _cancel(
      BuildContext context,
      TextEditingController nameCtrl,
      TextEditingController phoneCtrl,
      TextEditingController birthDateCtrl,
      ) {
    final name = _displayName(context);
    nameCtrl.text = name;
    phoneCtrl.text = user.phone ?? '';
    birthDateCtrl.text = _formatDate(user.dateOfBirth);
    context.read<ProfileUpdateCubit>().toggleEditing(false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cardWidth = MediaQuery.of(context).size.width > 600 ? 450.0 : double.infinity;

    final name = _displayName(context);
    final nameCtrl = TextEditingController(text: name);
    final phoneCtrl = TextEditingController(text: user.phone ?? '');
    final birthDateCtrl = TextEditingController(text: _formatDate(user.dateOfBirth));

    return BlocConsumer<ProfileUpdateCubit, ProfileUpdateState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          _snack(context, state.message, const Color(0xFF0F766E));
          context.read<ProfileUpdateCubit>().reset();
        }
        if (state is ProfileUpdateError) {
          _snack(context, state.errorMessage, cs.error);
        }
      },
      builder: (context, updateState) {
        final isEditing = updateState.isEditing;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Center(
            child: SizedBox(
              width: cardWidth,
              child: Card(
                elevation: isDark ? 4 : 12,
                shadowColor: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color: cs.outlineVariant.withOpacity(isDark ? 0.4 : 0.5),
                  ),
                ),
                color: cs.surfaceContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProfileAvatarSection(
                        initials: _initials(name),
                        hasValidAvatar: (user.avatarUrl ?? '').isNotEmpty,
                        avatarUrl: user.avatarUrl ?? '',
                        isEditing: isEditing,
                        pickedImage: updateState.pickedImage,
                        onPickImage: () => _pickImage(context),
                      ),
                      const SizedBox(height: 28),
                      isEditing
                          ? ProfileEditFields(
                        nameCtrl: nameCtrl,
                        phoneCtrl: phoneCtrl,
                        birthDateCtrl: birthDateCtrl,
                      )
                          : ProfileViewFields(
                        displayName: name,
                        phone: user.phone,
                        birthDate: birthDateCtrl.text.isNotEmpty
                            ? birthDateCtrl.text
                            : context.tr('profile_not_specified'),
                      ),
                      const SizedBox(height: 28),
                      isEditing
                          ? ProfileEditButtons(
                        onSave: () => _save(context, nameCtrl, phoneCtrl, birthDateCtrl),
                        onCancel: () => _cancel(context, nameCtrl, phoneCtrl, birthDateCtrl),
                      )
                          : Button(
                        text: context.tr('profile_btn_edit'),
                        color: cs.primary,
                        colorText: Colors.white,
                        onPressed: () => context.read<ProfileUpdateCubit>().toggleEditing(true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _snack(BuildContext ctx, String msg, Color color) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(
          color == const Color(0xFF0F766E)
              ? Icons.check_circle_rounded
              : Icons.error_outline_rounded,
          color: Colors.white,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            msg,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
          ),
        ),
      ]),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ));
  }
}