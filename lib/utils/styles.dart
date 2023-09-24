import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles
{
  static Color whiteColor = Color(0xffF3F3F3);
  static Color blackColor = Color(0xff0E0E0E);

  final dailyForecastText = GoogleFonts.inter(fontSize: 18, color: whiteColor, fontWeight: FontWeight.w500);
  
  final bottomSheetText1 = GoogleFonts.inter(fontSize: 18, color: whiteColor, fontWeight: FontWeight.w500);
  final bottomSheetText2 = GoogleFonts.inter(fontSize: 20, color: blackColor, fontWeight: FontWeight.w500);
}