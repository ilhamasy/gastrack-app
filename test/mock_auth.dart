import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrack_app/features/auth/data/auth_repository.dart';

class MockAuthNotifier extends AuthNotifier {
  MockAuthNotifier(super.dio, super.storage) {
    state = AuthState(isAuthenticated: true, isLoading: false, error: null);
  }

  @override
  Future<void> _checkAuthStatus() async {
    state = AuthState(isAuthenticated: true, isLoading: false, error: null);
  }

  @override
  Future<bool> login(String email, String password) async {
    return true;
  }

  @override
  Future<bool> register(String email, String password) async {
    return true;
  }

  @override
  Future<void> logout() async {
    state = AuthState(isAuthenticated: false, isLoading: false, error: null);
  }
}
