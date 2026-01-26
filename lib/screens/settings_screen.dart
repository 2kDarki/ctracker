import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
      _notifications = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void _toggleDarkMode(bool val) {
    setState(() => _darkMode = val);
    _saveSetting('darkMode', val);

    ThemeModeNotifier.instance.value =
        val ? ThemeMode.dark : ThemeMode.light;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Theme change will fully apply after app restart'),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleNotifications(bool val) {
    setState(() => _notifications = val);
    _saveSetting('notifications', val);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Preferences
          const Text('Preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme for the app'),
            value: _darkMode,
            onChanged: _toggleDarkMode,
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Enable notifications for reminders'),
            value: _notifications,
            onChanged: _toggleNotifications,
          ),
          const Divider(height: 32),

          // About
          const Text('About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('App Info'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'cTracker',
                applicationVersion: 'v1.0.0 (1)',
                applicationIcon: Image.asset(
                  'assets/images/splash.png',
                  width: 48,
                  height: 48,
                ),
                children: const [
                  Text(
                      'Simple app to track change owed to customers efficiently.'),
                ],
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () => _launchUrl('https://yourwebsite.com/privacy'),
          ),

          const Divider(height: 32),
          const Text('Contact & Socials',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('GitHub'),
            onTap: () => _launchUrl('https://github.com/2kDarki'),
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('LinkedIn'),
            onTap: () => _launchUrl('https://linkedin.com/in/caleb-sibanda'),
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Reddit'),
            onTap: () => _launchUrl('https://reddit.com/user/2kdarki'),
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('X'),
            onTap: () => _launchUrl('https://x.com/2kdarki'),
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('IG'),
            onTap: () => _launchUrl('https://instagram.com/2kdarki'),
          ),
        ],
      ),
    );
  }
}

/// Global notifier to allow dynamic theme changes
class ThemeModeNotifier {
  ThemeModeNotifier._();
  static final instance = ValueNotifier<ThemeMode>(ThemeMode.light);
}
