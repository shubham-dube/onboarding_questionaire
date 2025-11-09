import '../../../../core/network/dio_client.dart';
import '../../domain/models/experience_model.dart';

class OnboardingRepository {
  final DioClient _dioClient;

  OnboardingRepository(this._dioClient);

  Future<List<ExperienceModel>> getExperiences({bool activeOnly = true}) async {
    try {
      final response = await _dioClient.get(
        '/experiences',
        queryParameters: {'active': activeOnly},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data['data'] != null) {
          final experiencesData = data['data']['experiences'] as List?;

          if (experiencesData != null) {
            return experiencesData
                .map((json) => ExperienceModel.fromMap(json as Map<String, dynamic>))
                .where((exp) => exp.isValid)
                .toList();
          }
        }
      }

      return [];
    } catch (e) {
      print('Error fetching experiences: $e');
      throw Exception('Failed to load experiences: $e');
    }
  }
}