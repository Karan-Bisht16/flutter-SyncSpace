import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncspace/api/api.dart';
import 'package:syncspace/models/api.response.model.dart';

class User {
  final APIService api = APIService();

  Future<APIResponse> login(
    String email,
    String password,
  ) async {
    APIResponse response = await api.post('user/login', {
      'userEmail': email,
      'userPassword': password,
    });

    if (response.statusCode == 200) {
      var responseData = response.responseData;
      AuthAPIResponse userData = AuthAPIResponse.fromJson(responseData.data);

      List<String> cookieString = responseData.headers['set-cookie'];

      String accessToken = cookieString[0].split('=')[1].split(';')[0];
      String refreshToken = cookieString[1].split('=')[1].split(';')[0];
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('accessToken', accessToken);
      await prefs.setString('refreshToken', refreshToken);
      await prefs.setString('userData', jsonEncode(userData).toString());
      response.message = 'Login Successful';
    }

    return response;
  }

  Future<APIResponse> register(
    String userName,
    String email,
    String password,
  ) async {
    APIResponse response = await api.post('user/register', {
      'userName': userName,
      'userEmail': email,
      'userPassword': password,
    });

    if (response.statusCode == 200) {
      var responseData = response.responseData;
      AuthAPIResponse userData = AuthAPIResponse.fromJson(responseData.data);

      List<String> cookieString = responseData.headers['set-cookie'];

      String accessToken = cookieString[0].split('=')[1].split(';')[0];
      String refreshToken = cookieString[1].split('=')[1].split(';')[0];
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('accessToken', accessToken);
      await prefs.setString('refreshToken', refreshToken);
      await prefs.setString('userData', jsonEncode(userData).toString());
      response.message = 'Account created successfully!';
    }

    return response;
  }

  Future<APIResponse> fetchUserInfo(
    String userName,
  ) async {
    APIResponse response = await api.get('user', {
      'userName': userName,
    });

    if (response.statusCode == 200) {
      var responseData = response.responseData;
      UserModel userData = UserModel.fromJson(responseData.data);
      response.responseData = userData;
      response.message = 'Got user info';
    }

    return response;
  }
}
