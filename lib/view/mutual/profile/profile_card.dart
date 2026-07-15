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

class ProfileCard extends StatefulWidget {
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

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _isEditing = false;
  File? _pickedImage;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _birthDateCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl      = TextEditingController(text: _displayName);
    _phoneCtrl     = TextEditingController(text: widget.user.phone ?? '');
    _birthDateCtrl = TextEditingController(text: _formatDate(widget.user.dateOfBirth));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _birthDateCtrl.dispose();
    super.dispose();
  }

  String get _displayName {
    final isAr = widget.localeState.currentLanguage == 'AR';
    return isAr
        ? (widget.user.fullNameAr.isNotEmpty ? widget.user.fullNameAr : widget.user.fullName)
        : (widget.user.fullName.isNotEmpty   ? widget.user.fullName   : widget.user.fullNameAr);
  }

  String _formatDate(String? raw) {
    if (raw == null) return '';
    try { return intl.DateFormat('yyyy / MM / dd').format(DateTime.parse(raw)); }
    catch (_) { return ''; }
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

  bool get _hasValidAvatar {
    final url = widget.user.avatarUrl ?? '';
    return url.startsWith('http://') || url.startsWith('https://');
  }

  Future<void> _pickImage() async {
    final img = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (img != null) setState(() => _pickedImage = File(img.path));
  }

  void _save() {
    final isAr  = widget.localeState.currentLanguage == 'AR';
    final parts = _nameCtrl.text.trim().split(' ');
    final first = parts.isNotEmpty ? parts.first : '';
    final last  = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    context.read<ProfileUpdateCubit>().updateProfile(
      userId:      widget.user.id,
      userToken:   widget.userToken,
      firstName:   isAr ? null : first,
      firstNameAr: isAr ? first : null,
      lastName:    isAr ? null : last,
      lastNameAr:  isAr ? last  : null,
      phone:       _phoneCtrl.text.trim(),
      dateOfBirth: _toApiDate(_birthDateCtrl.text),
      avatar:      _pickedImage,
    );
  }

  void _cancel() {
    _nameCtrl.text      = _displayName;
    _phoneCtrl.text     = widget.user.phone ?? '';
    _birthDateCtrl.text = _formatDate(widget.user.dateOfBirth);
    setState(() { _isEditing = false; _pickedImage = null; });
  }

  @override
  Widget build(BuildContext context) {
    final cs        = Theme.of(context).colorScheme;
    final cardWidth = MediaQuery.of(context).size.width > 600 ? 450.0 : double.infinity;

    return BlocListener<ProfileUpdateCubit, ProfileUpdateState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          setState(() { _isEditing = false; _pickedImage = null; });
          _snack(context, state.message, const Color(0xFF0F766E));
          context.read<ProfileUpdateCubit>().reset();
        }
        if (state is ProfileUpdateError) _snack(context, state.errorMessage, cs.error);
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Center(
          child: SizedBox(
            width: cardWidth,
            child: Card(
              elevation:   widget.isDark ? 4 : 12,
              shadowColor: Colors.black.withOpacity(widget.isDark ? 0.4 : 0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: cs.outlineVariant.withOpacity(widget.isDark ? 0.4 : 0.5),
                ),
              ),
              color: cs.surfaceContainer,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfileAvatarSection(
                      initials:       _initials(_displayName),
                      hasValidAvatar: _hasValidAvatar,
                      avatarUrl:      widget.user.avatarUrl ?? '',
                      isEditing:      _isEditing,
                      pickedImage:    _pickedImage,
                      onPickImage:    _pickImage,
                    ),
                    const SizedBox(height: 28),

                    _isEditing
                        ? ProfileEditFields(
                      nameCtrl:      _nameCtrl,
                      phoneCtrl:     _phoneCtrl,
                      birthDateCtrl: _birthDateCtrl,
                    )
                        : ProfileViewFields(
                      displayName: _displayName,
                      phone:       widget.user.phone,
                      birthDate:   _birthDateCtrl.text.isNotEmpty
                          ? _birthDateCtrl.text
                          : context.tr('profile_not_specified'),
                    ),

                    const SizedBox(height: 28),

                    _isEditing
                        ? ProfileEditButtons(onSave: _save, onCancel: _cancel)
                        : Button(
                      text:      context.tr('profile_btn_edit'),
                      color:     cs.primary,
                      colorText: Colors.white,
                      onPressed: () => setState(() => _isEditing = true),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _snack(BuildContext ctx, String msg, Color color) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(color == const Color(0xFF0F766E)
            ? Icons.check_circle_rounded : Icons.error_outline_rounded,
            color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(msg, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13))),
      ]),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ));
  }
}