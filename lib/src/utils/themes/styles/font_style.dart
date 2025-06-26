import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontStyles {
  TextStyle headLineLightBold = GoogleFonts.poppins(
      textStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: ColorManager().kWhite));

  TextStyle subHeadLineDark = GoogleFonts.poppins(
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600));

  TextStyle subHeadLinebold = GoogleFonts.poppins(
      textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: ColorManager().kBlack));

  TextStyle hintTextWhite = GoogleFonts.karla(
      textStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: ColorManager().kWhite));

  TextStyle hintTextBlack = GoogleFonts.karla(
      textStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: ColorManager().kBlack));

  TextStyle textFieldName = GoogleFonts.karla(
      textStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: ColorManager().kBlack));

  TextStyle randomTextBlack = GoogleFonts.karla(
      textStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: ColorManager().kBlack));

  TextStyle buttonNameWhite = GoogleFonts.karla(
      textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: ColorManager().kWhite));

  TextStyle buttonNameBlack = GoogleFonts.karla(
      textStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ColorManager().kBlack));

  TextStyle randomTextStyle({
    double? size,
    FontWeight? weight,
    Color? color,
  }) {
    return GoogleFonts.karla(
      textStyle: TextStyle(
        fontSize: size ?? 15,
        fontWeight: weight ?? FontWeight.w500,
        color: color ?? ColorManager().kGrey,
      ),
    );
  }

  TextStyle randomTextStylePoppins(
      {double? size,
      FontWeight? weight,
      Color? color,
      bool? isItalic,
      bool? isUnderLined}) {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        decorationColor: color,
        decoration: isUnderLined == true ? TextDecoration.underline : null,
        fontStyle: isItalic == true ? FontStyle.italic : null,
        fontSize: size ?? 15,
        decorationThickness: 2,
        fontWeight: weight ?? FontWeight.w500,
        color: color ?? ColorManager().kGrey,
      ),
    );
  }
}
