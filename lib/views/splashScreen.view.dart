import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncspace/constants.dart';
import 'package:syncspace/models/api.response.model.dart';
import 'package:syncspace/provider/user.provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var loading = false;
  AuthAPIResponse userDataFromStorage = AuthAPIResponse();

  @override
  void initState() {
    super.initState();
    loadUserInfo(context);
  }

  void loadUserInfo(BuildContext context) async {
    setState(() {
      loading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');
    String? refreshToken = prefs.getString('refreshToken');
    await Future.delayed(const Duration(seconds: 2));

    if (refreshToken != null && userData != null) {
      AuthAPIResponse userDataInJson = AuthAPIResponse.fromJson(
        jsonDecode(userData),
      );
      if (mounted) {
        setState(() {
          userDataFromStorage = userDataInJson;
          loading = false;
        });
      }
      if (context.mounted) {
        Provider.of<UserProvider>(
          context,
          listen: false,
        ).setUser(userDataInJson);
      }
    }
    if (context.mounted) {
      GoRouter.of(context).goNamed(AppRouteConstants.home);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img-syncspace-logo.png',
                width: 128.0,
                height: 128.0,
              ),
              Text(
                'SyncSpace',
                style: TextStyle(
                  fontSize: 48,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
