import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'db_functions.dart' as db;

class ScheduleItem {
  List<ScheduleClass> classes = [];
  List<ScheduleTest> tests = [];
  List<ScheduleActivity> activities = [];

  void clear() {
    classes.clear();
    tests.clear();
    activities.clear();
  }

}

class Schedule{

  String? token;
  int? resistrationId;
  int? teachingType;

  DateTime lastTimeUpdated = DateTime(0);
  bool fromEPV = false;
  bool loaded = false;
  bool loadingFromEPV = false;
  ScheduleItem schedule = ScheduleItem();

  Future<void> update({bool force = false}) async {
    if (!shouldUpdate() && !force) {
      //print("Schedule not updated! (was updated recently)");
      return;
    }

    fromEPV = false;

    if (!loaded) {
      loadFromPrefs();
    }

    print("Loading schedule from EPV...");
    
    loadingFromEPV = true;
    dynamic data = await db.getSchedule(token, resistrationId, teachingType);
    if (data != null) {
      fromEPV = true;
      await loadFromJson(data);
    }
    loadingFromEPV = false;
  }

  Future<void> loadFromJson(dynamic data) async {
    if (data is! Map<String, dynamic> || data.isEmpty || !data.containsKey("aulas")) {
      return;
    }
    
    schedule.clear();
    for (var item in data["aulas"]) {;
      schedule.classes.add(ScheduleClass.fromJson(item));
    }
    for (var item in data["testes"]) {;
      schedule.tests.add(ScheduleTest.fromJson(item));
    }
    for (var item in data["atividades"]) {;
      schedule.activities.add(ScheduleActivity.fromJson(item));
    }

    lastTimeUpdated = DateTime.now();
    loaded = true;

    print("Schedule loaded!");

    // print(
    //   "Schedule loaded! (\n"
    //   "  ${schedule.classes.length} classes,\n"
    //   "  ${schedule.tests.length} tests,\n"
    //   "  ${schedule.activities.length} activities,\n"
    //   ")"
    // );

    if (!fromEPV) return;
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('schedule', jsonEncode(data));
    print("Schedule saved!");
  }

  Future<bool> loadFromPrefs() async {
    print("Loading schedule from prefs...");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String json = prefs.getString('schedule') ?? '';
    
    if (json.isEmpty) {
      print("Failed to load schedule from prefs.");
      return false;
    }

    fromEPV = false;
    await loadFromJson(jsonDecode(json));

    return true;
  }

  bool shouldUpdate() {
    if (loadingFromEPV) return false;
    if (!loaded) return true;
    if (!fromEPV) return true;
    if (DateTime.now().difference(lastTimeUpdated).inMinutes > 5) return true;
    return false;
  }
}

class ScheduleClass {
  final String label;
  final String subject;
  final String room;

  final String teacher;
  
  final DateTime startTime;
  final DateTime endTime;
  

  const ScheduleClass({
    required this.label,
    required this.subject,
    required this.room,
    required this.teacher,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleClass.fromJson(Map<String, dynamic> json) {
    return ScheduleClass(
      label: json['sigla'] ?? '',
      subject: json['disciplina'] ?? '',
      room: json['sala'] ?? '',
      teacher: json['professor'] ?? 'N/A',
      startTime: DateTime.parse(json['inicio']),
      endTime: DateTime.parse(json['fim'])
    );
  }

}

class ScheduleTest {
  final String title;
  final String teacher;
  final DateTime startTime;
  final DateTime endTime;

  const ScheduleTest({
    required this.title,
    required this.teacher,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleTest.fromJson(Map<String, dynamic> json) {
    return ScheduleTest(
      title: json['titulo'] ?? '',
      teacher: json['professor'] ?? 'N/A',
      startTime: DateTime.parse(json['inicio']),
      endTime: DateTime.parse(json['fim'])
    );
  }
}

class ScheduleActivity {
  final String title;
  final DateTime startTime;
  final DateTime endTime;

  const ScheduleActivity({
    required this.title,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleActivity.fromJson(Map<String, dynamic> json) {
    return ScheduleActivity(
      title: json['titulo'] ?? '',
      startTime: DateTime.parse(json['inicio']),
      endTime: DateTime.parse(json['fim'])
    );
  }
}
