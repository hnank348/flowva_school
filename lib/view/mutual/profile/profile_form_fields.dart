import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/profile/profile_update_cubit.dart';
import 'package:flowva_school/app_localizations.dart';
import 'package:flowva_school/widget/button.dart';
import 'package:flowva_school/widget/custom_text_field.dart';
import 'package:flowva_school/widget/field_styles.dart';
import 'package:flowva_school/widget/date.dart';


class ProfileViewFields extends StatelessWidget {
  final String displayName;
  final String? phone;
  final String birthDate;

  const ProfileViewFields({
    super.key,
    required this.displayName,
    required this.phone,
    required this.birthDate,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        ProfileInfoTile(
          icon:  Icons.person_outline_rounded,
          label: context.tr('profile_full_name'),
          value: displayName.isNotEmpty ? displayName : context.tr('profile_not_specified'),
        ),
        Divider(height: 24, thickness: 1, color: cs.outlineVariant.withOpacity(0.5)),
        ProfileInfoTile(
          icon:      Icons.phone_android_outlined,
          label:     context.tr('profile_phone_number'),
          value:     phone ?? context.tr('profile_not_added'),
          isMissing: phone == null,
        ),
        Divider(height: 24, thickness: 1, color: cs.outlineVariant.withOpacity(0.5)),
        ProfileInfoTile(
          icon:  Icons.cake_outlined,
          label: context.tr('profile_birth_date'),
          value: birthDate,
        ),
      ],
    );
  }
}

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isMissing;

  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isMissing = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: cs.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                    fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.w600,
                    color: cs.onSurfaceVariant,
                  )),
              const SizedBox(height: 3),
              Text(value,
                  style: TextStyle(
                    fontFamily: 'Cairo', fontSize: 14,
                    fontWeight: isMissing ? FontWeight.w500 : FontWeight.w600,
                    fontStyle: isMissing ? FontStyle.italic : FontStyle.normal,
                    color: isMissing ? cs.onSurfaceVariant : cs.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}


class ProfileEditFields extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController birthDateCtrl;

  const ProfileEditFields({
    super.key,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.birthDateCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: nameCtrl,
          hintText:   context.tr('profile_full_name'),
          decoration: FieldStyles.authInputDecoration(
            label: context.tr('profile_full_name'),
            icon:  Icons.person_outline_rounded,
          ),
        ),
        const SizedBox(height: 18),
        CustomTextField(
          controller:   phoneCtrl,
          hintText:     context.tr('profile_phone_number'),
          keyboardType: TextInputType.phone,
          decoration:   FieldStyles.authInputDecoration(
            label: context.tr('profile_phone_number'),
            icon:  Icons.phone_android_outlined,
          ),
        ),
        const SizedBox(height: 18),
        GestureDetector(
          onTap: () => Date.selectDate(context, birthDateCtrl),
          child: AbsorbPointer(
            child: CustomTextField(
              controller: birthDateCtrl,
              hintText:   context.tr('profile_birth_date'),
              readOnly:   true,
              decoration: FieldStyles.authInputDecoration(
                label: context.tr('profile_birth_date'),
                icon:  Icons.cake_outlined,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── أزرار التعديل ───────────────────────────────────────────────────────────

class ProfileEditButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const ProfileEditButtons({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
      builder: (context, state) {
        final isLoading = state is ProfileUpdateLoading;
        return Column(
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator(color: cs.primary, strokeWidth: 2.5))
                : Button(
              text: context.tr('profile_btn_save'),
              color: cs.primary, colorText: Colors.white,
              onPressed: onSave,
            ),
            const SizedBox(height: 12),
            Button(
              text:         context.tr('profile_btn_cancel'),
              color:        cs.surfaceContainerLow,
              colorText:    cs.primary,
              colorOutline: cs.primary,
              onPressed:    isLoading ? () {} : onCancel,
            ),
          ],
        );
      },
    );
  }
}