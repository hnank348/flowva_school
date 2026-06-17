// lib/cubit/supervisor/state_supervisor/classes_state.dart
import '../../../models/supervisor/class_details_model.dart';
abstract class ClassesState {
  final SectionModel? selectedSection; // السيكشن النشط حالياً لتلوين الكبسولة في الواجهة

  const ClassesState({this.selectedSection});
}

// 1. الحالة الابتدائية عند فتح الصفحة
class ClassesInitial extends ClassesState {
  const ClassesInitial() : super(selectedSection: null);
}

// 2. حالة جاري جلب الأقسام من الباكيند (مؤشر التحميل)
class ClassesLoading extends ClassesState {
  const ClassesLoading({SectionModel? selectedSection}) : super(selectedSection: selectedSection);
}

// 3. حالة نجاح جلب الأقسام من الباكيند وبداخلها تفاصيل الصف كاملة
class ClassesLoaded extends ClassesState {
  final ClassDetailsModel classDetails;

  const ClassesLoaded({
    required this.classDetails,
    required SectionModel selectedSection, // السيكشن المختار حالياً من المصفوفة
  }) : super(selectedSection: selectedSection);
}

// 4. حالة حدوث خطأ بالاتصال
class ClassesError extends ClassesState {
  final String message;

  const ClassesError(this.message, {SectionModel? selectedSection})
      : super(selectedSection: selectedSection);
}