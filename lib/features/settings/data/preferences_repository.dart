import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/preferences.dart';

class PreferencesRepository {
  final Dio _dio;

  PreferencesRepository(this._dio);

  Future<NotificationPreferences> getPreferences() async {
    final response = await _dio.get('/api/users/preferences');
    return NotificationPreferences.fromJson(response.data);
  }

  Future<NotificationPreferences> updatePreferences(NotificationPreferences prefs) async {
    final response = await _dio.put(
      '/api/users/preferences',
      data: prefs.toJson(),
    );
    return NotificationPreferences.fromJson(response.data);
  }
}

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return PreferencesRepository(dio);
});

final preferencesProvider = StateNotifierProvider<PreferencesNotifier, AsyncValue<NotificationPreferences>>((ref) {
  final repository = ref.watch(preferencesRepositoryProvider);
  return PreferencesNotifier(repository);
});

class PreferencesNotifier extends StateNotifier<AsyncValue<NotificationPreferences>> {
  final PreferencesRepository _repository;

  PreferencesNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await _repository.getPreferences();
      state = AsyncValue.data(prefs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePreferences(NotificationPreferences prefs) async {
    state = const AsyncValue.loading();
    try {
      final updated = await _repository.updatePreferences(prefs);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
