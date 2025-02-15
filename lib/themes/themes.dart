import 'package:flutter/material.dart';

class Themes {
  static const lightTheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff0090c1),
    surfaceTint: Color(0xff36618e),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xffd1e4ff),
    onPrimaryContainer: Color(0xff001d36),
    secondary: Color(0xff37618e),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xffd2e4ff),
    onSecondaryContainer: Color(0xff001c37),
    tertiary: Color(0xff36618e),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xffd1e4ff),
    onTertiaryContainer: Color(0xff001d36),
    error: Color(0xff904a43),
    onError: Color(0xffffffff),
    errorContainer: Color(0xffffdad6),
    onErrorContainer: Color(0xff3b0907),
    surface: Color(0xfff8f9ff),
    onSurface: Color(0xff191c20),
    onSurfaceVariant: Color(0xff43474e),
    outline: Color(0xff73777f),
    outlineVariant: Color(0xffc3c7cf),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff2e3135),
    inversePrimary: Color(0xffa0cafd),
    primaryFixed: Color(0xffd1e4ff),
    onPrimaryFixed: Color(0xff001d36),
    primaryFixedDim: Color(0xffa0cafd),
    onPrimaryFixedVariant: Color(0xff194975),
    secondaryFixed: Color(0xffd2e4ff),
    onSecondaryFixed: Color(0xff001c37),
    secondaryFixedDim: Color(0xffa1c9fd),
    onSecondaryFixedVariant: Color(0xff1b4975),
    tertiaryFixed: Color(0xffd1e4ff),
    onTertiaryFixed: Color(0xff001d36),
    tertiaryFixedDim: Color(0xffa0cafd),
    onTertiaryFixedVariant: Color(0xff194975),
    surfaceDim: Color(0xffd8dae0),
    surfaceBright: Color(0xFFC5C5C5),
    surfaceContainerLowest: Color(0xffffffff),
    surfaceContainerLow: Color(0xfff2f3fa),
    surfaceContainer: Color(0xffeceef4),
    surfaceContainerHigh: Color(0xffe6e8ee),
    surfaceContainerHighest: Color(0xFF707070),
  );

  static const darkTheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xff0090c1),
    surfaceTint: Color(0xffa0cafd),
    onPrimary: Color(0xff003258),
    primaryContainer: Color(0xff194975),
    onPrimaryContainer: Color(0xffd1e4ff),
    secondary: Color(0xffa1c9fd),
    onSecondary: Color(0xff003259),
    secondaryContainer: Color(0xff1b4975),
    onSecondaryContainer: Color(0xffd2e4ff),
    tertiary: Color(0xffa0cafd),
    onTertiary: Color(0xff003258),
    tertiaryContainer: Color(0xff194975),
    onTertiaryContainer: Color(0xffd1e4ff),
    error: Color(0xffffb4ab),
    onError: Color(0xff561e19),
    errorContainer: Color(0xff73332d),
    onErrorContainer: Color(0xffffdad6),
    surface: Color(0xff111418),
    onSurface: Color(0xffe1e2e8),
    onSurfaceVariant: Color(0xffc3c7cf),
    outline: Color(0xff8d9199),
    outlineVariant: Color(0xff43474e),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffe1e2e8),
    inversePrimary: Color(0xff36618e),
    primaryFixed: Color(0xffd1e4ff),
    onPrimaryFixed: Color(0xff001d36),
    primaryFixedDim: Color(0xffa0cafd),
    onPrimaryFixedVariant: Color(0xff194975),
    secondaryFixed: Color(0xffd2e4ff),
    onSecondaryFixed: Color(0xff001c37),
    secondaryFixedDim: Color(0xffa1c9fd),
    onSecondaryFixedVariant: Color(0xff1b4975),
    tertiaryFixed: Color(0xffd1e4ff),
    onTertiaryFixed: Color(0xff001d36),
    tertiaryFixedDim: Color(0xffa0cafd),
    onTertiaryFixedVariant: Color(0xff194975),
    surfaceDim: Color(0xff111418),
    surfaceBright: Color(0xff36393e),
    surfaceContainerLowest: Color(0xff0b0e13),
    surfaceContainerLow: Color(0xff191c20),
    surfaceContainer: Color(0xff1d2024),
    surfaceContainerHigh: Color(0xff272a2f),
    surfaceContainerHighest: Color(0xFF7F8183),
  );

  static const highContrastDarkTheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xfffafaff),
    surfaceTint: Color(0xffa0cafd),
    onPrimary: Color(0xff000000),
    primaryContainer: Color(0xffa6ceff),
    onPrimaryContainer: Color(0xff000000),
    secondary: Color(0xfffafaff),
    onSecondary: Color(0xff000000),
    secondaryContainer: Color(0xffa8ceff),
    onSecondaryContainer: Color(0xff000000),
    tertiary: Color(0xfffafaff),
    onTertiary: Color(0xff000000),
    tertiaryContainer: Color(0xffa6ceff),
    onTertiaryContainer: Color(0xff000000),
    error: Color(0xfffff9f9),
    onError: Color(0xff000000),
    errorContainer: Color(0xffffbab1),
    onErrorContainer: Color(0xff000000),
    surface: Color(0xff000000),
    onSurface: Color(0xffffffff),
    onSurfaceVariant: Color(0xfffafaff),
    outline: Color(0xffc7cbd3),
    outlineVariant: Color(0xffc7cbd3),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffe1e2e8),
    inversePrimary: Color(0xff002b4e),
    primaryFixed: Color(0xffd9e8ff),
    onPrimaryFixed: Color(0xff000000),
    primaryFixedDim: Color(0xffa6ceff),
    onPrimaryFixedVariant: Color(0xff00172d),
    secondaryFixed: Color(0xffd9e8ff),
    onSecondaryFixed: Color(0xff000000),
    secondaryFixedDim: Color(0xffa8ceff),
    onSecondaryFixedVariant: Color(0xff00172e),
    tertiaryFixed: Color(0xffd9e8ff),
    onTertiaryFixed: Color(0xff000000),
    tertiaryFixedDim: Color(0xffa6ceff),
    onTertiaryFixedVariant: Color(0xff00172d),
    surfaceDim: Color(0xff111418),
    surfaceBright: Color(0xff36393e),
    surfaceContainerLowest: Color(0xff0b0e13),
    surfaceContainerLow: Color(0xFF050505),
    surfaceContainer: Color(0xff1d2024),
    surfaceContainerHigh: Color(0xff272a2f),
    surfaceContainerHighest: Color(0xFF7F8183),
  );
}
