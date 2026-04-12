import 'dart:convert';
import 'package:http/http.dart' as http;

const host = "https://school-api-h0r8.onrender.com"; // add /dummy to use dummy data (for testing)
const defaultHeaders = {
  "Content-Type": "application/json",
  "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
};
//const host = "http://192.168.1.66/API/school"; // add /dummy to use dummy data (for testing)
//
Future<dynamic> getSchedule(String? token, int? resistrationId, int? teachingType, {bool force = false}) async {
  if (token == null || resistrationId == null || teachingType == null){
    print("Failed to load schedule! Missing function parameters");
    return;
  }
  
  dynamic response;
  try{
    response = await http.post(
      Uri.parse('$host/get_schedule.php'),
      headers: defaultHeaders,
      body: jsonEncode({
        'token': token,
        'resistrationId': resistrationId,
        'teachingType': teachingType,
      }),
    );
  }catch(e) {
    print("Error loading schedule: $e");
    return;
  }
  
  if (response.statusCode != 200 || response.body.isEmpty) {
    print("Schedule not loaded! Status code: ${response.statusCode}");
    return;
  }

  dynamic data = jsonDecode(response.body);
  
  if (data["error"] != null){
    print("Schedule not loaded! Error: ${data["error"]}");
    return;
  }

  return data;

}

Future<dynamic> getUserInfo(String epvName, String epvPassword) async {
  dynamic response;
  try{
    response = await http.post(
      Uri.parse('$host/get_user_info.php'),
      headers: defaultHeaders,
      body: jsonEncode({
        "username": epvName, 
        "password": epvPassword
      }),
    );
  }catch(e) {
    print("Error loading user info: $e");
    return null;
  }

  if (response.statusCode != 200 || response.body.isEmpty) {
    print("User info not loaded! Status code: ${response.statusCode}");
    print("Response body: ${response.body}");
    return null;
  }
  if (response.body.contains("error")) {
    print("User info not loaded! Error: ${response.body}");
    return null;
  }

  print("User info loaded!");
  return jsonDecode(response.body);
}

Future<dynamic> getUserGrades(String? token, int? resistrationId, int? teachingType) async{
  if (token == null || resistrationId == null || teachingType == null){
    print("Failed to load grades! Missing function parameters");
    return;
  }

  dynamic response;
  try{
    response = await http.post(
      Uri.parse('$host/get_grades.php'),
      headers: defaultHeaders,
      body: jsonEncode({
        'token': token,
        'resistrationId': resistrationId,
        'teachingType': teachingType,
      }),
    );
  }catch(e) {
    print("Error loading schedule: $e");
    return;
  }

  if (response.statusCode != 200 || response.body.isEmpty) {
    print("Schedule not loaded! Status code: ${response.statusCode}");
    return;
  }

  dynamic data = jsonDecode(response.body);
  
  if (data["error"] != null){
    print("Schedule not loaded! Error: ${data["error"]}");
    return;
  }

  return data['data'];

}
