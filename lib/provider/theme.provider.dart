import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  // 1: Light; 2: Dark; 3: High Contrast
  int theme = 3;
  ThemeProvider() {
    loadThemeFromPrefs();
  }

  void setTheme(int value) {
    theme = value;
    saveThemeToPrefs(value);
    notifyListeners();
  }

  Future<void> loadThemeFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    theme = prefs.getInt('theme') ?? 3;
    notifyListeners();
  }

  Future<void> saveThemeToPrefs(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme', value);
  }
}
