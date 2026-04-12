import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:school_app/functions/student_class.dart';
import 'package:school_app/themes/app/app_theme.dart';

import 'package:school_app/widgets/main_navigation.dart';

import 'package:school_app/Global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  List<dynamic> accounts = [];

  bool addingAccount = true;
  bool removingAccount = false;
  bool isLoading = false;

  int lastLoginId = -1;

  @override
  void initState() {
    super.initState();
    if (global.user != null) {
      print("User already logged in!");
      return;
    }

    loadUsers();
  }
  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  Future<void> loadUsers() async {
    final _users = await global.getSavedAccounts();
    if (_users.isEmpty) return;
    
    setState(() {
      addingAccount = false;
      accounts = _users;
    });
    _checkLastLogin();
  }

  void _checkLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    lastLoginId = prefs.getInt("lastLoginId") ?? -1;
    if (lastLoginId == -1) return;
    
    if (lastLoginId < accounts.length) {
      _usernameController.text = accounts[lastLoginId][1];
      _passwordController.text = accounts[lastLoginId][2];
      _login(waitLoading: false);
    }
  }

  void _addAccount() async {
    print("Add account button pressed!");
    setState(() {
      isLoading = true;
    });

    Student tmp = Student(
      epvName: _usernameController.text,
      epvPassword: _passwordController.text, 
    );
    
    for (int i = 0; i < accounts.length; i++) {
      if (accounts[i][1] == tmp.epvName) {
        lastLoginId = i;
        _login();
        return;
      }
    }
    
    await tmp.loadUser();

    if (!tmp.isLoadedFromEPV) {
      print("Login failed!");
      setState(() {
        isLoading = false;
      });
      return;
    }
    
    global.user = tmp;

    accounts.add([tmp.name, tmp.epvName, tmp.epvPassword, tmp.image]);
    await global.saveAccounts(accounts);
    lastLoginId = accounts.length - 1;

    _gotoMainScreen();
  }

  void _login({bool waitLoading = true}) async {
    //await global.saveAccounts([]);
    print("Login button pressed!");
    setState(() {
      isLoading = true;
    });

    global.user = Student(
      epvName: _usernameController.text,
      epvPassword: _passwordController.text, 
    );

    if (waitLoading){
      await global.user!.updateUserData();
    }else{
      global.user!.updateUserData();
    }
    _gotoMainScreen();
  }

  void _deleteAccountWithId(int id) {
    setState(() {
      accounts.removeAt(id);
    });
    global.saveAccounts(accounts);
  }

  void _gotoMainScreen() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("lastLoginId", lastLoginId);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final colors = theme.colorScheme;

    return Scaffold(
      body: Center(
        child: isLoading
          ? buildLoading(context)
          : buildMainContainer(context),
      )
    );
  }

  Widget buildLoading(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "A carregar...",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const CircularProgressIndicator(),
      ],
    );
  }

  Widget buildMainContainer(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: 500,
      constraints: const BoxConstraints(
        minHeight: 400,
      ),
      decoration: BoxDecoration(
        borderRadius: AppTheme.containerRadius,
        color: colors.surface,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            addingAccount ? "Adicionar Conta" : "Escolher Conta",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 48), 
          if (addingAccount)
            buildLoginFields(context)
          else
            buildAccountSelectionScreen(context),
        ],
      ),
    );
  }

  Widget buildAccountSelectionScreen(BuildContext context) {
    // final theme = Theme.of(context);
    // final colors = theme.colorScheme;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        for (int i = 0; i < accounts.length; i++) ...[
          _buidAccountButton(context, i),
          Divider(),
        ],
        _buidAccountButton(
          context, 
          -1,
          text: "Adicionar Conta", 
          onPressed: () {
            setState(() {
              addingAccount = true;
              removingAccount = false;
            });
          }
        ),
        Divider(),
        if (!removingAccount) ...[
          _buidAccountButton(
            context, 
            -2,
            icon: Icons.person_remove_outlined,
            text: "Remover uma conta", 
            onPressed: () {
              setState(() {
                removingAccount = true;
              });
            }
          ),
          Divider(),
        ]else ...[
          const SizedBox(width: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    removingAccount = false;
                  });
                }, 
                child: Text("Terminar")
              ),
            ],
          ),
        ],
        
        
      ],
    );
  }

  Widget _buidAccountButton(BuildContext context, int id, {String? text, String? subText, Uint8List? image, IconData icon = Icons.account_circle_outlined, VoidCallback? onPressed}) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    double height = 50;
    
    if (id >= 0) {
      final splitName = accounts[id][0].split(" ");
      text ??= splitName[0] + " " + splitName[splitName.length - 1];
      subText ??= accounts[id][1];
      image ??= accounts[id][3];

      onPressed ??= () {
        lastLoginId = id;
        _usernameController.text = accounts[id][1];
        _passwordController.text = accounts[id][2];
        _login();
      };
    }else{
      height = 30;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: colors.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.buttonRadius,
        ),
        
        shadowColor: Colors.transparent
        
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: SizedBox(
          width: 500,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              SizedBox(
                width: 40,
                child: Center(
                  child: [
                    if (image != null)
                      CircleAvatar(
                        backgroundImage: MemoryImage(image),
                        radius: 20,
                        backgroundColor: Colors.transparent,
                      )
                    else Icon(
                      icon,
                      color: colors.onSurface,
                      size: 25,
                      
                    )][0],
                ),
              ),
              
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (text != null)
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colors.onSurface,
                        ),
                      ),
                    if (subText != null) 
                      Text(
                        subText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: colors.onSurface,
                        ),
                      ),
                  ],
                ),
              ),
              if (id >= 0 && removingAccount)
                FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  foregroundColor: colors.error,
                  tooltip: "Remover Conta",
                  mini: true,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.buttonRadius,
                  ),
                  onPressed: () {_deleteAccountWithId(id);},
                  child: Icon(
                    Icons.remove_circle_outline,
                    size: 30,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoginFields(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    
    return Column(
      spacing: 15,
      children: [
        buildInputField(context, "Username", _usernameController),
        buildInputField(context, "Password", _passwordController, obscureText: true),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.surface,
                  foregroundColor: colors.onSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.buttonRadius,
                  ),
                  shadowColor: Colors.transparent
                ),
                onPressed: () {
                  setState(() {
                    addingAccount = false;
                  });
                }, 
                child: Text("Já tenho uma conta"),
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: _addAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.buttonRadius,
                  ),
                ),
                child: Text("Login"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildInputField(BuildContext context, String label, TextEditingController controller, {bool obscureText = false}) {
    // final theme = Theme.of(context);
    // final colors = theme.colorScheme;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
      ),
    );
  }
}
