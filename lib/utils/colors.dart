import 'package:flutter/material.dart';

class AppColor {
  // Primary Colors
  static const Color primaryColor = Color(0xFF1976D2); // SBI Blue
  static const Color primaryColorDark = Color(0xFF1565C0);
  static const Color primaryColorLight = Color(0xFF42A5F5);
  
  // Secondary Colors
  static const Color secondaryColor = Color(0xFFFF6F00); // SBI Orange
  static const Color secondaryColorDark = Color(0xFFE65100);
  static const Color secondaryColorLight = Color(0xFFFFB74D);
  
  // Background Colors
  static const Color bodyBackground = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color dialogBackground = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textColorBlack = Color(0xFF212121);
  static const Color textColorGrayDark = Color(0xFF616161);
  static const Color textColorGray = Color(0xFF9E9E9E);
  static const Color textColorGrayLight = Color(0xFFBDBDBD);
  static const Color textColorWhite = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = Color(0xFF2196F3);
  
  // Button Colors
  static const Color primaryBtnColor = Color(0xFF1976D2);
  static const Color primaryBtnTextColor = Color(0xFFFFFFFF);
  static const Color secondaryBtnColor = Color(0xFFE0E0E0);
  static const Color secondaryBtnTextColor = Color(0xFF424242);
  static const Color disabledBtnColor = Color(0xFFBDBDBD);
  static const Color disabledBtnTextColor = Color(0xFF9E9E9E);
  
  // Transaction Status Colors
  static const Color creditColor = Color(0xFF4CAF50);
  static const Color debitColor = Color(0xFFF44336);
  static const Color pendingColor = Color(0xFFFFC107);
  
  // Border Colors
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color borderColorDark = Color(0xFFBDBDBD);
  static const Color focusedBorderColor = Color(0xFF1976D2);
  static const Color errorBorderColor = Color(0xFFF44336);
  
  // Icon Colors
  static const Color iconColorPrimary = Color(0xFF1976D2);
  static const Color iconColorSecondary = Color(0xFF757575);
  static const Color iconColorLight = Color(0xFFBDBDBD);
  
  // Divider Colors
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color dividerColorDark = Color(0xFFBDBDBD);
  
  // Shadow Colors
  static const Color shadowColor = Color(0x1A000000);
  static const Color shadowColorDark = Color(0x33000000);
  
  // Chart Colors
  static const Color chartColor1 = Color(0xFF1976D2);
  static const Color chartColor2 = Color(0xFF42A5F5);
  static const Color chartColor3 = Color(0xFF66BB6A);
  static const Color chartColor4 = Color(0xFFFFA726);
  static const Color chartColor5 = Color(0xFFEF5350);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, primaryColorLight],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryColor, secondaryColorLight],
  );
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCardBackground = Color(0xFF1E1E1E);
  static const Color darkDividerColor = Color(0xFF373737);
  static const Color darkTextColor = Color(0xFFE0E0E0);
  static const Color darkTextColorSecondary = Color(0xFFB0B0B0);
  
  // Alpha Colors
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color transparentColor = Colors.transparent;
  
  // Opacity Colors
  static Color getColorWithOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  // Get Material Color
  static MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(color.value, shades);
  }
}