import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'functions/student_class.dart';


final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

Future<void> initTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final mode = prefs.getString("theme") ?? "dark";
  themeNotifier.value = mode == "dark" ? ThemeMode.dark : ThemeMode.light;
}

void setThemeMode(ThemeMode? mode) async {
  mode ??= themeNotifier.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  themeNotifier.value = mode;
  
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("theme", (mode == ThemeMode.dark ? "dark" : "light"));
}

Student? user;

Future<void> saveAccounts(List<dynamic> accounts) async {
  List<dynamic> toSave = [];
  for (var item in accounts) {
    String? imageBase64;

    if (item[3] != null && item[3] is Uint8List) {
      imageBase64 = base64Encode(item[3]);
    }

    toSave.add([
      item[0],
      item[1],
      item[2],
      imageBase64,
    ]);
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("accounts", jsonEncode(toSave));
}

Future<List<dynamic>> getSavedAccounts() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accountsJson = prefs.getString("accounts");

  if (accountsJson == null || accountsJson.isEmpty) {
    return [];
  }
  dynamic accounts = jsonDecode(accountsJson);
  for (var item in accounts) {
    if (item is! List) continue;
    if (item.length == 4){
      try {
        item[3] = base64Decode(item[3]);
      } catch (e) {
        item[3] = null;
        print("Error decoding account image: $e");
      }
    }else {
      item.add(null);
    }
  }
  return accounts;
}

Future<void> logout() async{
  final prefs = await SharedPreferences.getInstance();
  List<dynamic> _accouts = await getSavedAccounts();
  prefs.clear();
  prefs.setBool('seen', true);
  prefs.setString("theme", (themeNotifier.value == ThemeMode.dark ? "dark" : "light"));
  saveAccounts(_accouts);
  // prefs.setInt("lastLoginId", -1);
  user = null;
}

Future<bool> isFirstTime() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return !(prefs.getBool('seen') ?? false);
}
