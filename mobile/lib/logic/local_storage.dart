import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // Save a value to local storage
  Future<void> saveValue(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(key, value);
    } catch (e) {
      throw ('Erro ao salvar valor: $e');
    }
  }

  // Retrieve a value from local storage
  Future<String?> getValue(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      throw ('Erro ao salvar valor: $e');
    }
  }

  // Remove a value from local storage
  Future<void> removeValue(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(key);
    } catch (e) {
      throw ('Erro ao remover valor: $e');
    }
  }

  // Clean all values from local storage
  Future<void> cleanValues() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
    } catch (e) {
      throw ('Erro ao limpar valores: $e');
    }
  }
}
