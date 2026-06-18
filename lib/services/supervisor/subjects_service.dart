import 'package:dio/dio.dart';
import '../../models/supervisor/subject_model.dart';
import '../api_service.dart';
import '../constant_api.dart';

class SubjectsService {
  final ApiService _apiService;

  SubjectsService(this._apiService);

  Future<List<SubjectModel>> getSubjects({required String token}) async {
    try {
      // 🚀 تم تمرير الـ token هنا كمتغير مباشر لضمان تشفيره بالطلب فورا
      final response = await _apiService.get(
        ConstantApi.subjects,
      );

      print('🌐 [SubjectsService] Response Data: ${response.data}');
      print('📊 [SubjectsService] Status Code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> rawList = response.data['data'];

        return rawList.map((json) => SubjectModel.fromJson(json)).toList();
      }

      throw Exception(response.data['message'] ?? 'فشل جلب قائمة المواد من السيرفر');
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}