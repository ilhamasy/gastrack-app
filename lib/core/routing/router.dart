import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../routing/app_shell.dart';
import '../routing/routes.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/dashboard/presentation/odometer_history_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/maintenance/presentation/maintenance_screen.dart';
import '../../features/maintenance/presentation/maintenance_config_screen.dart';
import '../../features/maintenance/presentation/add_edit_maintenance_screen.dart';
import '../../features/maintenance/domain/vehicle_maintenance.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/vehicles/domain/vehicle.dart';
import '../../features/vehicles/presentation/add_edit_vehicle_screen.dart';
import '../../features/vehicles/presentation/my_vehicles_screen.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authProvider,
      (_, __) => notifyListeners(),
    );
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      if (authState.isLoading) {
        return null;
      }

      final isAuth = authState.isAuthenticated;
      final isGoingToLogin = state.matchedLocation == AppRoutes.login;
      final isGoingToRegister = state.matchedLocation == AppRoutes.register;

      if (!isAuth && !isGoingToLogin && !isGoingToRegister) {
        return AppRoutes.login;
      }

      if (isAuth && (isGoingToLogin || isGoingToRegister)) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.registerName,
        builder: (context, state) => const RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                name: AppRoutes.dashboardName,
                builder: (context, state) => const DashboardScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutes.odometerHistory,
                    name: AppRoutes.odometerHistoryName,
                    builder: (context, state) {
                      final vehicleId = state.extra as String;
                      return OdometerHistoryScreen(vehicleId: vehicleId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                name: AppRoutes.historyName,
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.maintenance,
                name: AppRoutes.maintenanceName,
                builder: (context, state) => const MaintenanceScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: AppRoutes.settingsName,
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutes.myVehicles,
                    name: AppRoutes.myVehiclesName,
                    builder: (context, state) => const MyVehiclesScreen(),
                    routes: [
                      GoRoute(
                        path: AppRoutes.addVehicle,
                        name: AppRoutes.addVehicleName,
                        builder: (context, state) => const AddEditVehicleScreen(),
                      ),
                      GoRoute(
                        path: AppRoutes.editVehicle,
                        name: AppRoutes.editVehicleName,
                        builder: (context, state) {
                          final vehicle = state.extra as Vehicle?;
                          return AddEditVehicleScreen(vehicle: vehicle);
                        },
                      ),
                      GoRoute(
                        path: AppRoutes.maintenanceConfig,
                        name: AppRoutes.maintenanceConfigName,
                        builder: (context, state) {
                          final vehicle = state.extra as Vehicle;
                          return MaintenanceConfigScreen(vehicle: vehicle);
                        },
                        routes: [
                          GoRoute(
                            path: AppRoutes.addMaintenance,
                            name: AppRoutes.addMaintenanceName,
                            builder: (context, state) {
                              final vehicleId = state.pathParameters['vehicleId']!;
                              return AddEditMaintenanceScreen(vehicleId: vehicleId);
                            },
                          ),
                          GoRoute(
                            path: AppRoutes.editMaintenance,
                            name: AppRoutes.editMaintenanceName,
                            builder: (context, state) {
                              final vehicleId = state.pathParameters['vehicleId']!;
                              final maintenance = state.extra as VehicleMaintenance;
                              return AddEditMaintenanceScreen(vehicleId: vehicleId, maintenance: maintenance);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
