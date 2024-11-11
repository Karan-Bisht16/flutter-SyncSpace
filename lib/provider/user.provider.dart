import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncspace/models/api.response.model.dart';

class UserProvider with ChangeNotifier {
  AuthAPIResponse? userData;
  bool isLoggedIn = false;

  // Map<String, dynamic>? get userData => userData;
  // bool get isLoggedIn => isLoggedIn;

  void setUser(AuthAPIResponse data) {
    userData = data;
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() async {
    userData = null;
    isLoggedIn = false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    await prefs.remove("userData");
    await prefs.remove("isLoggedIn");
    await prefs.remove("accessToken");
    await prefs.remove("refreshToken");
    notifyListeners();
  }
}
