import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/recommendation.dart';

class RecommendationRepository {
  final Dio _dio;

  RecommendationRepository(this._dio);

  Future<List<Recommendation>> getRecommendations(String vehicleId) async {
    final response = await _dio.get('/api/vehicles/$vehicleId/recommendations');
    final data = response.data as List;
    return data.map((json) => Recommendation.fromJson(json)).toList();
  }
}

final recommendationRepositoryProvider = Provider<RecommendationRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return RecommendationRepository(dio);
});

final recommendationsProvider = FutureProvider.family<List<Recommendation>, String>((ref, vehicleId) {
  final repository = ref.watch(recommendationRepositoryProvider);
  return repository.getRecommendations(vehicleId);
});
