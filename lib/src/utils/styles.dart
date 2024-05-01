import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      primary: const Color(0xff161966),
      secondary: const Color(0xff494554),
      tertiary: const Color(0xff4DAA57),
      background: const Color(0xffFBFBFB),
      error: const Color(0xffCC444B),
      seedColor: Colors.white,

      brightness: Brightness.light,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Color(0xff022150)),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xff3E5C89)),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xff15224F)),
    ),
    
    hintColor: const Color(0xff969AA8)
);
