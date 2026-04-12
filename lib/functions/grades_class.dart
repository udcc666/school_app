import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'db_functions.dart' as db;

class Grades{

  String? token;
  int? resistrationId;
  int? teachingType;

  DateTime lastTimeUpdated = DateTime(0);

  bool loaded = false;
  bool isLoading = false;
  bool fromEPV = false;
  List<GradesClass> classes = [];
  
  Future<void> update({bool force = false}) async{
    if (token == null || resistrationId == null || teachingType == null){
      return;
    }
    if (!force && !shouldUpdate()){
      return;
    }
    print("Loading user grades");
    
    isLoading = true;

    dynamic data = await tryLoadData();

    if (data != null){
      handleData(data);
      loaded = true;
      fromEPV = false;
    }
    
    data = await db.getUserGrades(token, resistrationId, teachingType);
    
    if (data == null){
      isLoading = false;
      return;
    }
    
    handleData(data);
    
    lastTimeUpdated = DateTime.now();
    isLoading = false;
    fromEPV = true;
    
    print("User grades loaded");
    saveData(data);
  }

  void handleData(dynamic data){
    classes.clear();
    for (dynamic classData in data){
      GradesClass classe = GradesClass();
      classe.name = classData['name'];

      for (dynamic moduleData in classData['modules']){
        classe.modules.add(
          GradesModule(
            name: moduleData['name'], 
            grade: int.tryParse(moduleData['grade']) ?? -1, 
            year: int.tryParse(moduleData['year']) ?? -1,
            date: DateTime.parse(moduleData['date']),
          ),
        );
      }
      classe.calculateVars();
      classes.add(classe);
    }
    loaded = true;
  }

  Future<void> saveData(dynamic data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('grades', jsonEncode(data));
    print("Grades saved!");
  }

  dynamic tryLoadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic data = prefs.getString('grades');
    if (data == null) return null;
    return jsonDecode(data);
  }

  bool shouldUpdate(){
    if (isLoading) return false;
    if (!fromEPV) return true;
    if (!loaded) return true;
    if (DateTime.now().difference(lastTimeUpdated).inMinutes > 5) return true;
    return false;
  }

  double getAverage(){
    int possiblePoints = 0;
    int points = 0;

    for (GradesClass classe in classes){
      if (classe.modulesCompleted == 0) continue;

      possiblePoints += 20 * classe.modulesCompleted;

      points += (classe.average * classe.modulesCompleted).round();
    }
    double res = (possiblePoints > 0) 
      ? (points / possiblePoints * 20) 
      : 0.0;

    return res;
  }

}

class GradesClass {
  String name = "";
  double average = 0.0;
  int modulesCompleted = 0;
  List<GradesModule> modules = [];

  void calculateVars() {
    modulesCompleted = 0;
    average = 0.0;

    for (GradesModule module in modules){
      if (module.grade == -1) continue;
      
      modulesCompleted++;
      average += module.grade;
    }
    if (average > 0){
      average /= modulesCompleted;
    }
  }

}

class GradesModule {
  late String name;
  late int grade;
  late int year;
  late DateTime date;

  GradesModule({
    required this.name,
    required this.grade,
    required this.year,
    required this.date,
  });
}
