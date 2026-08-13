import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/supervisor/classes_service.dart'; // استيراد سيرفس الصفوف المفصولة
import 'classes_state.dart';

class ClassesCubit extends Cubit<ClassesState> {
  final ClassesService _classesService; // استخدام السيرفس الصحيحة
  final String userToken;

  ClassesCubit({
    required ClassesService classesService,
    required this.userToken,
  })  : _classesService = classesService,
        super(ClassesInitial());

  // دالة جلب الكلاس والسيكشنز التابعة له من الـ API
  Future<void> fetchClassesAndSections() async {
    emit(ClassesLoading());
    try {
      // السيرفس الجديدة تتولى التعامل مع الديو والـ Response بالداخل وتُرجع موديل جاهزاً
      final classDetails = await _classesService.getClassesDetails(
        classId: 1,
        token: userToken,
      );

      if (classDetails.sections.isNotEmpty) {
        emit(ClassesLoaded(
          classDetails: classDetails,
          selectedSection: classDetails.sections.first,
        ));
      } else {
        emit(ClassesError("لا توجد شعب أو أقسام مسجلة داخل هذا الكلاس"));
      }
    } catch (e) {
      emit(ClassesError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  // 🔥 إضافة الدالة المفقودة لتغيير الشعبة وتحديث الواجهة (تمنع الخطأ الأحمر في الـ View)
  void selectSection(dynamic section) {
    if (state is ClassesLoaded) {
      final currentState = state as ClassesLoaded;
      emit(ClassesLoaded(
        classDetails: currentState.classDetails,
        selectedSection: section, // تعيين الشعبة الجديدة التي ضغط عليها المستخدم
      ));
    }
  }
}