import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadJsonData(String pathFile) async {
  String jsonString = await rootBundle.loadString(pathFile);
  return jsonString;
}

Future<List<dynamic>> loadData(String pathFile) async {
  String jsonData = await loadJsonData(pathFile);
  final jsonResult = json.decode(jsonData);
  return jsonResult;
}