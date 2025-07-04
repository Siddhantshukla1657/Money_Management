import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/person.dart';

class StorageService {
  static const String _personsKey = 'persons';

  static Future<List<Person>> loadPersons() async {
    final prefs = await SharedPreferences.getInstance();
    final String? personsJson = prefs.getString(_personsKey);
    
    if (personsJson == null) {
      return [];
    }

    final List<dynamic> personsList = json.decode(personsJson);
    return personsList.map((personJson) => Person.fromJson(personJson)).toList();
  }

  static Future<void> savePersons(List<Person> persons) async {
    final prefs = await SharedPreferences.getInstance();
    final String personsJson = json.encode(persons.map((person) => person.toJson()).toList());
    await prefs.setString(_personsKey, personsJson);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
