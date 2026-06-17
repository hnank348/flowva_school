import 'package:dio/dio.dart';
import '../../models/supervisor/class_details_model.dart';
import '../api_service.dart';
import '../constant_api.dart';

class ClassesService {
  final ApiService _apiService;

  // الكونستركتور متوافق وجاهز للـ Dependency Injection والـ Providers
  ClassesService(this._apiService);

  Future<ClassDetailsModel> getClassesDetails({
    required int classId,
    required String token,
  }) async {
    try {
      final response = await _apiService.get(
        '${ConstantApi.classes}/$classId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final data = response.data;

      // طباعة السجلات للتأكد من البيانات أثناء التطوير (Debug Logs)
      print('🌐 [ClassesService] Response Data: $data');
      print('📊 [ClassesService] Status Code: ${response.statusCode}');

      if (data != null && data['success'] == true && data['data'] != null) {
        // تحويل البيانات القادمة إلى الموديل المطلوب بنجاح
        return ClassDetailsModel.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? "فشل في جلب بيانات الصفوف من السيرفر");
      }
    } catch (e) {
      // تمرير نص الخطأ الصافي بدون كلمة "Exception:" لتظهر للمستخدم بشكل لائق في الواجهة
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}