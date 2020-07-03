import 'package:flutter/material.dart';
import 'package:preferences/preference_page.dart';
import 'package:preferences/preferences.dart';

class PreferencesScreen extends StatelessWidget {
  static const routeName = '/preferences';

  const PreferencesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences Demo'),
      ),
      body: PreferencePage([
        PreferenceTitle('General'),
        DropdownPreference(
          'Resolution',
          'episode_resolution',
          defaultVal: 'HD',
          values: ['SD', 'HD', 'Full HD'],
        ),
        PreferenceTitle('Personalization'),
        RadioPreference(
          'Light Theme',
          'light',
          'ui_theme',
          isDefault: true,
        ),
        RadioPreference(
          'Dark Theme',
          'dark',
          'ui_theme',
        ),
      ]),
    );
  }
}