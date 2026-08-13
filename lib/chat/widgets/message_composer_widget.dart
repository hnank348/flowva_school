import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';

class MessageComposerWidget extends StatefulWidget {
  const MessageComposerWidget({
    super.key,
    required this.onSend,
    required this.onChanged,
    required this.hasDraft,
  });

  final Function(String) onSend;
  final Function(String) onChanged;
  final bool hasDraft;

  @override
  State<MessageComposerWidget> createState() => _MessageComposerWidgetState();
}

class _MessageComposerWidgetState extends State<MessageComposerWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;

    return Container(
      color: isDark ? AppColors.darkSurface : Colors.white,
      padding: const EdgeInsets.all(AppSizes.paddingSmall),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
              child: TextField(
                controller: _controller,
                onChanged: widget.onChanged,
                style: TextStyle(color: isDark ? Colors.white : AppColors.primaryText),
                decoration: const InputDecoration(border: InputBorder.none, hintText: 'اكتب رسالة...'),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.paddingSmall),
          IconButton(
            icon: Icon(Icons.send_rounded, color: widget.hasDraft ? primaryColor : Colors.grey),
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                widget.onSend(_controller.text);
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}