import 'package:darklet/src/onboarding/view/splash_screen.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';

class SearchFieldWidget extends StatelessWidget {
  final String content;
  const SearchFieldWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: double.infinity,
      decoration: BoxDecoration(
          color: color.kWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.kLightGrey,
            width: 0.5,
          )),
      child: Row(
        children: [
          kWidth15,
          Icon(
            Icons.search_rounded,
            color: color.kBlackSecondary,
          ),
          kWidth10,
          Text(
            content,
            style: FontStyles().randomTextStylePoppins(
                size: 15,
                weight: FontWeight.w500,
                color: color.kBlackSecondary),
          )
        ],
      ),
    );
  }
}
