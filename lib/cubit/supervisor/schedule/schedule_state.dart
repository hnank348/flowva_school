import '../../../models/supervisor/schedule_session_model.dart';

abstract class ScheduleState {
  final String selectedClass;
  ScheduleState({required this.selectedClass});
}

// الحالة الابتدائية
class ScheduleInitial extends ScheduleState {
  ScheduleInitial({required super.selectedClass});
}

// حالة تحميل البيانات من السيرفر
class ScheduleLoading extends ScheduleState {
  ScheduleLoading({required super.selectedClass});
}

class ScheduleLoaded extends ScheduleState {
  final List<ScheduleSessionModel> sessions;
  final String selectedClass;
  final int selectedSemester; // 🎯 أضفنا هذا المتغير هنا

  ScheduleLoaded({
    required this.sessions,
    required this.selectedClass,
    this.selectedSemester = 1, // القيمة الافتراضية
  }) : super(selectedClass: selectedClass);
}

// حالة حدوث خطأ في أي عملية (جلب، رفع، تعديل، حذف)
class ScheduleError extends ScheduleState {
  final String message;
  ScheduleError({required this.message, required super.selectedClass});
}

// حالة نجاح الرفع أو التعديل لإظهار Toast أو SnackBar تأكيدي
class ScheduleActionSuccess extends ScheduleState {
  final String successMessage;
  ScheduleActionSuccess({required this.successMessage, required super.selectedClass});
}