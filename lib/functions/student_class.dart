import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:school_app/functions/db_functions.dart' as db;

import 'schedule_class.dart';
import 'grades_class.dart';

class Student {
  final String epvName;
  final String epvPassword;
  
  Student({
    required this.epvName,
    required this.epvPassword
  });
  
  bool isLoaded = false;

  String name = "";
  String className = "";

  Grades grades = Grades();
  Schedule schedule = Schedule();

  Uint8List? image;

  DateTime lastTimeUpdated = DateTime(0);
  bool isLoadedFromEPV = false;
  bool loadingFromEPV = false;

  String? token;
  int? resistrationId;
  int? teachingType;


  Future<void> loadUser({bool force = false}) async {
    if (!shouldUpdate() && !force) {
      return;
    }

    print("Loading user info...");
    
    isLoadedFromEPV = false;
    
    await loadUserFromPrefs();

    print("Loading user info from EPV...");

    loadingFromEPV = true;

    dynamic data = await db.getUserInfo(epvName, epvPassword);
    
    if (data == null) {
      print("Falied to load user info from EPV!");
      loadingFromEPV = false;
      return;
    }

    await _loadUserFromData(data);

    isLoaded = true;
    loadingFromEPV = false;
    isLoadedFromEPV = true;
    lastTimeUpdated = DateTime.now();

    data["epvName"] = epvName;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_info", jsonEncode(data));
    print("User info saved to prefs!");
  }

  Future<void> loadUserFromPrefs({bool force = false}) async {
    if (isLoaded && !force) {
      //print("User already loaded!");
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic data = prefs.getString("user_info");

    if (data == null) {
      print("Failed to load user info from prefs!");
      return;
    }

    print("Loading user info from prefs...");
    
    data = jsonDecode(data);
    await _loadUserFromData(data);

    isLoaded = true;
  }

  Future<void> _loadUserFromData(dynamic data) async {
    if (data["epvName"] != null) {
      if (data["epvName"] != epvName) {
        print("User info from prefs is not from this user!");
        return;
      }
    }

    name = data["name"];
    className = data["class"];
    token = data["token"];
    resistrationId = data["resistrationId"];
    teachingType = data["teachingType"];

    if (data["image"] != null) {
      image = base64Decode(data["image"]);
    }else {
      image = null;
    }
    setVars();
    print("User info loaded!");
    
  }

  void setVars() {
    schedule.token = token;
    schedule.resistrationId = resistrationId;
    schedule.teachingType = teachingType;

    grades.token = token;
    grades.resistrationId = resistrationId;
    grades.teachingType = teachingType;
  }

  String getName() {
    final List<String> splitName = name.split(" ");
    return splitName.first + (" ") + splitName.last;
  }

  Future<void> updateUserData({bool force = false}) async {
    await loadUser(force: force);
    schedule.update(force: force);
    grades.update(force: force);
  }

  bool shouldUpdate() {
    if (loadingFromEPV) return false;
    if (!isLoaded) return true;
    if (DateTime.now().difference(lastTimeUpdated).inMinutes > 5) return true;
    return false;
  }
}
