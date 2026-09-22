import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gastrack_app/main.dart';
import 'package:gastrack_app/features/auth/data/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../mock_auth.dart';

void main() {
  testWidgets('LoginScreen shows email and password fields', (tester) async {
    final mockAuth = MockAuthNotifier(Dio(), const FlutterSecureStorage());
    mockAuth.state = AuthState(isAuthenticated: false, isLoading: false, error: null);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => mockAuth),
        ],
        child: const GasTrackApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Don\'t have an account? Register'), findsOneWidget);
  });
}
