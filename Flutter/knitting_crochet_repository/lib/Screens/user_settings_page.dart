import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Notifiers/theme_notifier.dart';

class UserSettingPage extends StatefulWidget {
  const UserSettingPage({super.key});

  @override
  State<UserSettingPage> createState() => _UserSettingPageState();
}

class _UserSettingPageState extends State<UserSettingPage> {
  @override
  Widget build(BuildContext context) {
    @override
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SwitchListTile(
        title: Text('High Contrast Mode'),
        value: Provider.of<ThemeNotifier>(context).isHighContrast, // Read the value
        onChanged: (bool newValue) {
          themeNotifier.toggleTheme(); // Call the toggle method
        },
      ),
    );
  }
}