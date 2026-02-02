import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'policy_screen.dart';

const String privacyPolicyText = '''# Privacy Policy for cTracker

**Effective date:** 29 January 2026

## Overview

cTracker is a local-first application. Your data stays on your device.

We do not collect, transmit, sell, or share personal data.

---

## Information We Collect

**None.**

cTracker does not:

* Require user accounts
* Request personal information
* Collect analytics
* Track usage
* Access the network for data transmission

All records created in the app are stored **locally on your device only**.

---

## Data Storage

* All app data is stored locally using on-device storage.
* No data is uploaded to any server.
* No backups are created by us.
* Removing the app deletes all associated data.

---

## Third-Party Services

cTracker does **not** use:

* Analytics services
* Advertising networks
* Tracking SDKs
* Cloud storage providers

Any libraries used are strictly for local functionality.

---

## Permissions

cTracker does not request sensitive device permissions.

---

## Children’s Privacy

cTracker does not knowingly collect data from anyone, including children. Since no data collection occurs, there is no risk of personal data exposure.

---

## Changes to This Policy

If the privacy policy changes, the updated version will be made available within the app or repository.

---

## Contact

If you have questions about this policy, you can reach the developer through the official project repository or listed contact channels.

---

## Summary (Plain English)

* Your data stays on your phone
* We don’t see it
* We don’t want it
* We can’t access it''';

const String termsOfServiceText = '''# Terms of Service for cTracker

**Effective date:** 29 January 2026

## Acceptance of Terms

By downloading, installing, or using **cTracker**, you agree to these Terms of Service.
If you do not agree, do not use the app.

---

## Description of Service

cTracker is a local-first application designed to help users track customer change owed.
All functionality operates **entirely on the user’s device**.

We reserve the right to modify, suspend, or discontinue the app at any time without notice.

---

## User Responsibilities

You are responsible for:

* The accuracy of any data you enter
* How you use the app and its outputs
* Maintaining backups if you consider the data important

cTracker is a **tool**, not a financial authority or accounting service.

---

## No Warranties

cTracker is provided **“as is” and “as available.”**

We make no guarantees that:

* The app will be error-free
* Data will never be lost
* The app will meet all of your requirements
* Results produced by the app are suitable for legal, tax, or accounting purposes

Use it at your own risk.

---

## Limitation of Liability

To the maximum extent permitted by law:

The developer shall **not** be liable for:

* Data loss
* Financial loss
* Business disputes
* Missed payments
* Incorrect calculations
* Any indirect or consequential damages

If the app breaks, misbehaves, or causes loss — responsibility does not transfer to the developer.

---

## Data & Privacy

cTracker does not collect, transmit, or store personal data externally.

All data remains on your device.
Refer to the **Privacy Policy** for full details.

---

## Intellectual Property

* The app, name, branding, and source code are protected by applicable intellectual property laws.
* You may not reverse engineer, redistribute, or resell the app unless explicitly permitted by its license.

---

## Termination

You may stop using cTracker at any time by uninstalling it.

We may restrict or terminate access to the app if these terms are violated.

---

## Changes to These Terms

These Terms may be updated from time to time.
Continued use of the app after changes constitutes acceptance of the revised terms.

---

## Governing Law

These Terms are governed by applicable local laws, without regard to conflict-of-law principles.

---

## Contact

Questions about these Terms should be directed through the official project repository or developer contact channels.

---

## Plain-English Summary

* You use the app at your own risk
* Your data is yours, not ours
* We don’t guarantee perfection
* We’re not liable for losses''';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void _toggleDarkMode(bool val) {
    setState(() => _darkMode = val);
    _saveSetting('darkMode', val);

    ThemeModeNotifier.instance.value = val ? ThemeMode.dark : ThemeMode.light;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Theme change will fully apply after app restart'),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PolicyScreen(
                    title: 'Privacy Policy',
                    content: privacyPolicyText,
                  ),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text('Terms of Service'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PolicyScreen(
                    title: 'Terms of Service',
                    content: termsOfServiceText,
                  ),
                ),
              );
            },
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
