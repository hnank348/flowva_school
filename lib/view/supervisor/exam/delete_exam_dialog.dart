import 'package:flutter/material.dart';
import 'package:flowva_school/models/supervisor/exam_model.dart';
import '../../../widget/custom_confirmation_dialog.dart';

class DeleteExamDialog {
  static Future<bool?> show(BuildContext context, ExamModel exam) {
    return CustomConfirmationDialog.show(
      context,
      titleKey: 'exam_delete_dialog_title',
      bodyKey: 'exam_delete_dialog_body',
      confirmBtnKey: 'exam_delete_confirm',
      cancelBtnKey: 'session_btn_cancel',
      isDanger: true,
    );
  }
}