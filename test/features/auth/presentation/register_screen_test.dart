import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:gastrack_app/core/routing/router.dart';
import 'package:gastrack_app/features/auth/data/auth_repository.dart';
import 'package:gastrack_app/features/auth/presentation/register_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../mock_auth.dart';

void main() {
  testWidgets('RegisterScreen shows email and password fields', (tester) async {
    final mockAuth = MockAuthNotifier(Dio(), const FlutterSecureStorage());
    mockAuth.state = AuthState(isAuthenticated: false, isLoading: false, error: null);

    final router = GoRouter(
      initialLocation: '/register',
      routes: [
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => mockAuth),
          appRouterProvider.overrideWithValue(router),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Register'), findsWidgets);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Already have an account? Login'), findsOneWidget);
  });
}
