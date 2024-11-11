import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncspace/provider/theme.provider.dart';
import 'package:syncspace/routes/route.config.dart';
import 'package:syncspace/themes/themes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final int theme = themeProvider.theme;

    return MaterialApp.router(
      routerConfig: AppRouter.returnRouter(),
      title: 'SyncSpace',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: theme == 1
            ? Themes.lightTheme
            : theme == 2
                ? Themes.darkTheme
                : Themes.highContrastDarkTheme,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
    );
  }
}
