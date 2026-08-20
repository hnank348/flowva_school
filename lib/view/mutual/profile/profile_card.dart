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

  String _displayName() {
    final isAr = localeState.currentLanguage == 'AR';
    return isAr
        ? (user.fullNameAr.isNotEmpty ? user.fullNameAr : user.fullName)
        : (user.fullName.isNotEmpty ? user.fullName : user.fullNameAr);
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cardWidth = MediaQuery.of(context).size.width > 600 ? 450.0 : double.infinity;
    final name = _displayName();

    return BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
      builder: (context, updateState) {
        final isEditing = updateState.isEditing;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Center(
            child: SizedBox(
              width: cardWidth,
              child: Card(
                elevation: isDark ? 4 : 10,
                shadowColor: Colors.black.withOpacity(isDark ? 0.35 : 0.06),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color: cs.outlineVariant.withOpacity(isDark ? 0.35 : 0.45),
                  ),
                ),
                color: isDark ? cs.surfaceContainerHigh : Colors.white,
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
                      if (isEditing)
                        _EditBody(
                          user: user,
                          userToken: userToken,
                          localeState: localeState,
                        )
                      else
                        _ViewBody(
                          user: user,
                          displayName: name,
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
}

class _ViewBody extends StatelessWidget {
  final UserModel user;
  final String displayName;

  const _ViewBody({required this.user, required this.displayName});

  String _formatDate(String? raw) {
    if (raw == null) return '';
    try {
      return intl.DateFormat('yyyy / MM / dd').format(DateTime.parse(raw));
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final birthStr = _formatDate(user.dateOfBirth);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileViewFields(
          displayName: displayName,
          phone: user.phone,
          birthDate: birthStr.isNotEmpty ? birthStr : context.tr('profile_not_specified'),
        ),
        const SizedBox(height: 28),
        Button(
          text: context.tr('profile_btn_edit'),
          color: cs.primary,
          colorText: Colors.white,
          onPressed: () => context.read<ProfileUpdateCubit>().toggleEditing(true),
        ),
      ],
    );
  }
}

class _EditBody extends StatelessWidget {
  final UserModel user;
  final String userToken;
  final LocaleState localeState;

  const _EditBody({
    required this.user,
    required this.userToken,
    required this.localeState,
  });

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
    final tr = context.tr;

    context.read<ProfileUpdateCubit>().updateProfile(
      userId: user.id,
      userToken: userToken,
      firstName: isAr ? null : first,
      firstNameAr: isAr ? first : null,
      lastName: isAr ? null : last,
      lastNameAr: isAr ? last : null,
      phone: phoneCtrl.text.trim(),
      dateOfBirth: _toApiDate(birthDateCtrl.text),
      tr: tr,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = localeState.currentLanguage == 'AR';
    final currentName = isAr
        ? (user.fullNameAr.isNotEmpty ? user.fullNameAr : user.fullName)
        : (user.fullName.isNotEmpty ? user.fullName : user.fullNameAr);

    final nameCtrl = TextEditingController(text: currentName);
    final phoneCtrl = TextEditingController(text: user.phone ?? '');
    final birthDateCtrl = TextEditingController(text: _formatDate(user.dateOfBirth));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileEditFields(
          nameCtrl: nameCtrl,
          phoneCtrl: phoneCtrl,
          birthDateCtrl: birthDateCtrl,
        ),
        const SizedBox(height: 28),
        ProfileEditButtons(
          onSave: () => _save(context, nameCtrl, phoneCtrl, birthDateCtrl),
          onCancel: () {
            final cubit = context.read<ProfileUpdateCubit>();
            cubit.toggleEditing(false);
            cubit.reset();
          },
        ),
      ],
    );
  }
}