


import 'package:flutter/material.dart';
import 'package:youth_power/core/constants/app_colors.dart';
import 'package:youth_power/core/constants/app_constant.dart';

ThemeData light = ThemeData(
    primaryColor: AppColors.primaryColor,
    //fontFamily: AppConstant.fontFamily,
    scaffoldBackgroundColor: AppColors.primaryColorLight,
  //  fontFamily: AppConstant.fontFamily,
    useMaterial3: true,
    // primarySwatch: const MaterialColor(0xff7c35a5,{}),
    textTheme: const TextTheme(
      titleSmall: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColorLight,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.black,
        fontSize: 18,
      ),
      bodySmall: TextStyle(color: AppColors.black26, fontSize: 10),
      labelSmall: TextStyle(
        fontSize: 12,
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.primaryColorLight,
      elevation: 0,
      foregroundColor: AppColors.black,
      centerTitle: true,
      scrolledUnderElevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primarySwatch,
      unselectedItemColor: AppColors.black26,
      showUnselectedLabels: true,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      height: 40,
    )
);