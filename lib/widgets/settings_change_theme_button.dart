import 'package:flutter/material.dart';
import 'package:school_app/functions/grades_class.dart';

import 'package:school_app/Global.dart' as global;
import 'package:school_app/themes/app/app_theme.dart';

class SettingsChangeThemeButton extends StatefulWidget {
  const SettingsChangeThemeButton({super.key, this.classID = -1});

  final int classID;

  @override
  State<SettingsChangeThemeButton> createState() => _SettingsChangeThemeButtonState();
}

class _SettingsChangeThemeButtonState extends State<SettingsChangeThemeButton> {

  Grades get grades => global.user!.grades;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bool isDarkMode = global.themeNotifier.value == ThemeMode.dark;

    return GestureDetector(
      onTap: () { global.setThemeMode(null); },
      child: Container(
        width: double.infinity,
        height: 50, 
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: AppTheme.buttonRadius,
          // boxShadow: AppTheme.defaultShadow,
        ),
        child: Row(
          children: [
            Icon(
              isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              color: colors.onSurface,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Alternar Tema",
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              isDarkMode ? "ESCURO" : "CLARO",
              style: TextStyle(
                color: isDarkMode ? Colors.white38 : Colors.black38,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
