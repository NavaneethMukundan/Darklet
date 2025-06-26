import 'package:darklet/src/onboarding/view/splash_screen.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';

class OnboardingWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final int currentIndex;
  final GestureTapCallback onNext;
  const OnboardingWidget({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.currentIndex,
    required this.onNext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(image),
          Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: FontStyles().randomTextStylePoppins(
                    weight: FontWeight.bold, size: 36, color: color.kBlack),
              ),
              kHeight20,
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: FontStyles().randomTextStylePoppins(
                    weight: FontWeight.w400, size: 15, color: color.kBlack),
              ),
            ],
          ),
          GestureDetector(
            onTap: onNext,
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              height: 65,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: color.kBlack, borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: Text(
                  currentIndex == 3 ? 'Finish' : 'Next',
                  style: FontStyles().randomTextStylePoppins(
                      weight: FontWeight.w600, size: 20, color: color.kWhite),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              kWidth20,
              Icon(
                Icons.circle,
                size: 20,
                color: currentIndex == 1 ? color.primaryColor : color.kBlack,
              ),
              kWidth10,
              Icon(
                Icons.circle,
                size: 20,
                color: currentIndex == 2 ? color.primaryColor : color.kBlack,
              ),
              kWidth10,
              Icon(
                Icons.circle,
                size: 20,
                color: currentIndex == 3 ? color.primaryColor : color.kBlack,
              ),
              kWidth10
            ],
          ),
          kHeight5
        ],
      ),
    );
  }
}
