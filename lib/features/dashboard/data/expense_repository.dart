import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/expense_analytics.dart';

class ExpenseRepository {
  final Dio _dio;

  ExpenseRepository(this._dio);

  Future<ExpenseAnalytics> getExpenseAnalytics(String vehicleId) async {
    final response = await _dio.get('/api/vehicles/$vehicleId/expenses');
    return ExpenseAnalytics.fromJson(response.data);
  }
}

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ExpenseRepository(dio);
});

final expenseAnalyticsProvider = FutureProvider.family<ExpenseAnalytics, String>((ref, vehicleId) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getExpenseAnalytics(vehicleId);
});
