import 'package:dio/dio.dart';
import '../../models/supervisor/teacher_model.dart'; // تأكد من مطابقة مسار موديل المعلم لديك
import '../api_service.dart';
import '../constant_api.dart';

class TeachersService {
  final ApiService _apiService;

  TeachersService(this._apiService);

  /// جلب قائمة المعلمين المتاحين بالمدرسة
  Future<List<TeacherModel>> getTeachers({required String token}) async {
    try {
      final response = await _apiService.get(
        ConstantApi.teachers, // 💡 تأكد من إضافة المتغير 'teachers' داخل ملف ConstantApi وقيمته 'api/teachers'
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // 📥 طباعة النتيجة تحت في الـ Log للمراقبة الفورية أثناء الفحص
      print('🌐 [TeachersService] Response Data: ${response.data}');
      print('📊 [TeachersService] Status Code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> rawList = response.data['data'];

        // تحويل المصفوفة القادمة من السيرفر إلى قائمة من الـ TeacherModel
        return rawList.map((json) => TeacherModel.fromJson(json)).toList();
      }

      throw Exception(response.data['message'] ?? 'فشل جلب قائمة المعلمين من السيرفر');
    } catch (e) {
      // تنظيف نص الخطأ لتمريره بشكل نقي إلى الـ Cubit ثم الواجهات
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}