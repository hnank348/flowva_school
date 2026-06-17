import '../../../models/supervisor/subject_model.dart';

abstract class SubjectsState {}

// الحالة الابتدائية
class SubjectsInitial extends SubjectsState {}

// حالة التحميل أثناء جلب البيانات من السيرفر
class SubjectsLoading extends SubjectsState {}

// حالة النجاح واسترجاع مصفوفة المواد بنجاح
class SubjectsSuccess extends SubjectsState {
  final List<SubjectModel> subjects;
  SubjectsSuccess(this.subjects);
}

// حالة الفشل مع تمرير نص الخطأ لعرضه للمستخدم
class SubjectsError extends SubjectsState {
  final String errorMessage;
  SubjectsError(this.errorMessage);
}