import 'package:flutter/material.dart';
import 'package:restaurant_app/core/style/colors/main_color.dart';
import 'package:restaurant_app/core/style/textstyles/main_text_style.dart';

class MainTheme {
  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: MainTextStyle.displayLarge,
      displayMedium: MainTextStyle.displayMedium,
      displaySmall: MainTextStyle.displaySmall,
      headlineLarge: MainTextStyle.headlineLarge,
      headlineMedium: MainTextStyle.headlineMedium,
      headlineSmall: MainTextStyle.headlineSmall,
      titleLarge: MainTextStyle.titleLarge,
      titleMedium: MainTextStyle.titleMedium,
      titleSmall: MainTextStyle.titleSmall,
      bodyLarge: MainTextStyle.bodyLargeBold,
      bodyMedium: MainTextStyle.bodyLargeMedium,
      bodySmall: MainTextStyle.bodyLargeRegular,
      labelLarge: MainTextStyle.labelLarge,
      labelMedium: MainTextStyle.labelMedium,
      labelSmall: MainTextStyle.labelSmall,
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      toolbarTextStyle: _textTheme.titleLarge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      centerTitle: true,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: MainColor.green.color,
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorSchemeSeed: MainColor.green.color,
      brightness: Brightness.dark,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }
}
