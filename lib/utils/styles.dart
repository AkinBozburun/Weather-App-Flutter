import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles
{
  static Color whiteColor = Color(0xffF3F3F3);
  static Color softGreyColor = Color(0xFFE3E3E3);
  static Color blackColor = Color(0xff0E0E0E);

  static Color panelWhiteColor = Colors.white10;
  static Color panelBlackColor = Colors.black12;

  final mainDiscribeText = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
  final mainWeatherText = TextStyle(fontSize: 48, fontWeight: FontWeight.bold);
  final mainDetailsText = TextStyle(fontSize: 18, fontWeight: FontWeight.normal);


  final hourlyForecastTitle = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  final hourlyForecastListText = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  final hourlyForecastChartText = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
  
  final dailyForecastText = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  
  final alertTitle = GoogleFonts.inter(fontSize: 18, color: blackColor, fontWeight: FontWeight.w600);
  final alertButtonText = GoogleFonts.inter(fontSize: 14, color: blackColor, fontWeight: FontWeight.w600);

  final bottomSheetText1 = GoogleFonts.inter(fontSize: 16, color: blackColor, fontWeight: FontWeight.w500);
  final bottomSheetText2 = GoogleFonts.inter(fontSize: 18, color: blackColor, fontWeight: FontWeight.w600);

  final cityListText = GoogleFonts.inter(fontSize: 18, color: blackColor, fontWeight: FontWeight.w600);
  final cityListTextSub = GoogleFonts.inter(fontSize: 16, color: blackColor, fontWeight: FontWeight.w400);

  final favsText = GoogleFonts.inter(fontSize: 14, color: blackColor, fontWeight: FontWeight.w400);
}