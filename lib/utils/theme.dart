import 'package:flutter/material.dart';

final brandTheme = ThemeData(
  fontFamily: 'Inter',

  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF34C6A8),

    //메인 컬러
    primary: const Color(0xFF34C6A8),     //청록색
    onPrimary: Colors.white,              //그 위 하얀색

    //표면/배경
    surface: Colors.white,                //흰색
    onSurface: const Color(0xFF111827),   //진회색(거의 검정) text

    // 보조
    secondary: const Color(0xFFE7F6EE),          //연초록
    onSecondary: const Color(0xFF111827),        //연초록 위 텍스트

    surfaceVariant: const Color(0xFFF3F4F6),     //연회색
    onSurfaceVariant: const Color(0xFF374151),   //연회색 위 텍스트

    outlineVariant: const Color(0xFFE5E7EB),     //divider등
  ),

  scaffoldBackgroundColor: Colors.white,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 18,
      height: 1.2,
      letterSpacing: 0.5,
      color: Color(0xFF111827), //진한회색(거의 검정)
    ),
  ),

  dividerColor: const Color(0xFFE5E7EB), // 연한 회색 Divider

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF3F4F6), //검색창/번역칸 배경 연회색
    hintStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 14), // placeholder
    prefixIconColor: const Color(0xFF9CA3AF), //아이콘 연회색
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: BorderSide.none,
    ),
  ),

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 20,
      height: 1.25,
      color: Color(0xFF111827), //Screen title용 큰 제목
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      height: 1.25,
      color: Color(0xFF111827), // 중간 제목
    ),
    bodyMedium: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 1.45,
      color: Color(0xFF374151), // 본문 (짙은 회색)
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 12,
      height: 1.2,
      color: Color(0xFF374151), // 태그/보조 텍스트
    ),
  ),
);
