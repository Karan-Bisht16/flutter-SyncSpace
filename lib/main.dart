import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncspace/app/app.dart';
import 'package:syncspace/provider/theme.provider.dart';
import 'package:syncspace/provider/user.provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
    ],
    child: const App(),
  ));
}
