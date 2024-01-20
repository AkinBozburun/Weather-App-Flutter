import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles
{
  static Color whiteColor = Color(0xffF3F3F3);
  static Color softGreyColor = Color(0xFFE3E3E3);
  static Color blackColor = Color(0xff0E0E0E);

  final hourlyForecastTitle = TextStyle(fontSize: 18, color: whiteColor, fontWeight: FontWeight.w600);
  final hourlyForecastListText = TextStyle(fontSize: 16, color: whiteColor, fontWeight: FontWeight.w500);
  final hourlyForecastChartText = TextStyle(fontSize: 14, color: whiteColor, fontWeight: FontWeight.w600);
  
  final dailyForecastText = GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500);
  
  final alertTitle = GoogleFonts.inter(fontSize: 18, color: blackColor, fontWeight: FontWeight.w600);
  final alertButtonText = GoogleFonts.inter(fontSize: 14, color: blackColor, fontWeight: FontWeight.w600);

  final bottomSheetText1 = GoogleFonts.inter(fontSize: 16, color: blackColor, fontWeight: FontWeight.w500);
  final bottomSheetText2 = GoogleFonts.inter(fontSize: 18, color: blackColor, fontWeight: FontWeight.w600);

  final cityListText = GoogleFonts.inter(fontSize: 18, color: blackColor, fontWeight: FontWeight.w600);
  final cityListTextSub = GoogleFonts.inter(fontSize: 16, color: blackColor, fontWeight: FontWeight.w400);

  final favsText = GoogleFonts.inter(fontSize: 14, color: blackColor, fontWeight: FontWeight.w400);
}