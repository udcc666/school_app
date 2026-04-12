import 'package:flutter/material.dart';

import 'package:school_app/pages/login_page.dart';

import 'package:school_app/Global.dart' as global;
import 'package:school_app/themes/app/app_theme.dart';
import 'package:school_app/widgets/settings_change_theme_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    void logOut() async {
      await global.logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            SettingsChangeThemeButton(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: AppTheme.buttonRadius,
                ),
              ),
              onPressed: logOut, 
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Center(child: Text("Logout"))
              ),
            ),
          ],
        ),
      ),
    );
  }
}
