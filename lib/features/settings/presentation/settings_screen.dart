import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/preferences_repository.dart';
import '../../auth/data/auth_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(preferencesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Account', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile not implemented yet')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('Vehicles', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.motorcycle),
            title: const Text('My Vehicles'),
            onTap: () => context.goNamed('my_vehicles'),
          ),
          const Divider(),
          const ListTile(
            title: Text('Notification Preferences', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          prefsAsync.when(
            data: (prefs) => Column(
              children: [
                SwitchListTile(
                  title: const Text('Email Notifications'),
                  subtitle: const Text('Receive maintenance reminders via email'),
                  value: prefs.emailEnabled,
                  onChanged: (val) {
                    ref.read(preferencesProvider.notifier).updatePreferences(
                      prefs.copyWith(emailEnabled: val),
                    );
                  },
                ),
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Receive maintenance reminders on this device'),
                  value: prefs.pushEnabled,
                  onChanged: (val) {
                    ref.read(preferencesProvider.notifier).updatePreferences(
                      prefs.copyWith(pushEnabled: val),
                    );
                  },
                ),
              ],
            ),
            loading: () => const Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator())),
            error: (err, st) => Padding(padding: const EdgeInsets.all(16.0), child: Text('Error: $err')),
          ),
        ],
      ),
    );
  }
}
