import 'package:flutter/material.dart';
import 'package:school_app/pages/login_page.dart';
import 'package:school_app/themes/app/app_theme.dart';
import 'package:school_app/widgets/settings_change_theme_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_app/Global.dart' as global;

class FirstTimePage extends StatefulWidget {
  const FirstTimePage({super.key});

  @override
  State<FirstTimePage> createState() => _FirstTimePageState();
}

class _FirstTimePageState extends State<FirstTimePage> {

  bool show = false;

  @override
  void initState(){
    super.initState();
    initialCheck();
  }

  void initialCheck() async {
    show = await global.isFirstTime();
    setState(() {});
    if (show) return;
    //final SharedPreferences prefs = await SharedPreferences.getInstance();
    gotoLogin();
  }

  void close() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('seen', true);
    gotoLogin();
  }

  void gotoLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (!show) {
      return Center();
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 50,
            children: [
              Image(
                image: AssetImage('assets/epvalongo.png'),
                height: 80,
              ),
              Column(
                spacing: 5,
                children: [
                  Text(
                    'School App',
                    style: TextStyle(
                      fontSize: 32,
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Desenvolvida por ',
                        style: TextStyle(
                          fontSize: 20,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Nelson Martins',
                        style: TextStyle(
                          fontSize: 20,
                          color: colors.primary,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              Column(
                spacing: 10,
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
                    onPressed: () { close(); }, 
                    child: SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
