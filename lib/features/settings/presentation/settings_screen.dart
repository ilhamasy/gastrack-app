import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/preferences_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(preferencesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: prefsAsync.when(
        data: (prefs) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text('Notification Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
