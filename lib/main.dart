import 'package:flutter/material.dart';
import 'package:school_app/pages/first_time.dart';
import 'package:timezone/data/latest.dart' as tz;
//import 'package:shared_preferences/shared_preferences.dart';


import 'package:school_app/themes/app/app_theme.dart';

import 'package:school_app/Global.dart' as global;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await global.initTheme();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: global.themeNotifier,
      builder: (_, mode, _) {
        return MaterialApp(
          title: 'School App',
          theme: AppTheme.lightGoogleTheme,
          darkTheme: AppTheme.darkGoogleTheme,
          themeMode: mode,
          home: FirstTimePage(),
        );
      },
    );
  }
}
