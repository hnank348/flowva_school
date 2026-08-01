import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/app_theme.dart';
import '../cubit/messages_cubit.dart';

class MessagesHeaderWidget extends StatefulWidget {
  const MessagesHeaderWidget({super.key});

  @override
  State<MessagesHeaderWidget> createState() => _MessagesHeaderWidgetState();
}

class _MessagesHeaderWidgetState extends State<MessagesHeaderWidget> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;
    final outlineColor = isDark ? AppColors.darkOutlineColor : AppColors.outlineColor;

    return Container(
      color: primaryColor, 
      padding: const EdgeInsets.only(
        top: AppSizes.paddingLarge + 10.0,
        bottom: AppSizes.paddingMedium,
        left: AppSizes.paddingMedium,
        right: AppSizes.paddingMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.chat_bubble_rounded, 
                color: Colors.white, 
                size: 24,
              ),
              const SizedBox(width: AppSizes.paddingSmall),
              Text(
                'الرسائل',
                style: AppStyles.titleStyle.copyWith(
                  color: Colors.white, 
                  fontSize: AppSizes.fontSizeSubtitle + 2.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
              border: Border.all(color: outlineColor),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSmall),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded, 
                  size: 20, 
                  color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText
                ),
                const SizedBox(width: AppSizes.paddingSmall),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => context.read<MessagesCubit>().updateSearchQuery(val),
                    style: AppStyles.labelStyle.copyWith(
                      color: isDark ? Colors.white : AppColors.primaryText,
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'ابحث عن اسم أو رسالة...',
                      hintStyle: AppStyles.labelStyle.copyWith(
                        color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
