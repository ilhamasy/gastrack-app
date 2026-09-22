/// Route path and name constants for GasTrack navigation.
abstract class AppRoutes {
  // Paths
  static const String dashboard = '/';
  static const String history = '/history';
  static const String maintenance = '/maintenance';
  static const String settings = '/settings';

  // Names
  static const String dashboardName = 'dashboard';
  static const String historyName = 'history';
  static const String maintenanceName = 'maintenance';
  static const String settingsName = 'settings';

  static const String myVehicles = 'my-vehicles';
  static const String myVehiclesName = 'my-vehicles';
  
  static const String addVehicle = 'add-vehicle';
  static const String addVehicleName = 'add-vehicle';

  static const String editVehicle = 'edit-vehicle/:id';
  static const String editVehicleName = 'edit-vehicle';

  static const String odometerHistory = 'odometer-history';
  static const String odometerHistoryName = 'odometer-history';

  static const String login = '/login';
  static const String loginName = 'login';

  static const String register = '/register';
  static const String registerName = 'register';
}
