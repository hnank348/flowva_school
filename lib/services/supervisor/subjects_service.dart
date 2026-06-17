import 'package:dio/dio.dart';
import '../../models/supervisor/subject_model.dart'; // تأكد من مطابقة مسار الموديل لديك
import '../api_service.dart';
import '../constant_api.dart';

class SubjectsService {
  final ApiService _apiService;

  SubjectsService(this._apiService);

  /// جلب قائمة المواد المتاحة للمرحلة أو الصف الدراسي
  Future<List<SubjectModel>> getSubjects({required String token}) async {
    try {
      final response = await _apiService.get(
        ConstantApi.subjects,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // 📥 طباعة النتيجة تحت في الـ Log للمراقبة الفورية أثناء الفحص
      print('🌐 [SubjectsService] Response Data: ${response.data}');
      print('📊 [SubjectsService] Status Code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> rawList = response.data['data'];

        // تحويل المصفوفة القادمة من السيرفر إلى قائمة من الـ SubjectModel
        return rawList.map((json) => SubjectModel.fromJson(json)).toList();
      }

      throw Exception(response.data['message'] ?? 'فشل جلب قائمة المواد من السيرفر');
    } catch (e) {
      // تنظيف نص الخطأ لتمريره بشكل نقي إلى الـ Cubit ثم الواجهات
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}