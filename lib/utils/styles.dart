import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles
{
  static Color whiteColor = Color(0xffF3F3F3);
  static Color softGreyColor = Color(0xffE3E3E3);
  static Color blackColor = Color(0xff0E0E0E);

  final dailyForecastText = GoogleFonts.inter(fontSize: 16, color: whiteColor, fontWeight: FontWeight.w600);
  
  final bottomSheetText1 = GoogleFonts.inter(fontSize: 16, color: blackColor, fontWeight: FontWeight.w500);
  final bottomSheetText2 = GoogleFonts.inter(fontSize: 18, color: blackColor, fontWeight: FontWeight.w600);

  final cityListText = GoogleFonts.inter(fontSize: 18, color: blackColor, fontWeight: FontWeight.w500);
  final cityListTextSub = GoogleFonts.inter(fontSize: 16, color: blackColor, fontWeight: FontWeight.w400);

  final favsText = GoogleFonts.inter(fontSize: 14, color: blackColor, fontWeight: FontWeight.w500);
}