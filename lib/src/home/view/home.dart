import 'package:darklet/src/home/widget/screen_gradient_widget.dart';
import 'package:darklet/src/home/widget/search_field_widget.dart';
import 'package:darklet/src/onboarding/view/splash_screen.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenGradientWidget(
      child: Scaffold(
        backgroundColor: color.kTransparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                          color: color.kLightGrey.withOpacity(0.5),
                          shape: BoxShape.circle,
                          image: const DecorationImage(image: AssetImage(''))),
                    ),
                    kWidth10,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello , Navaneeth',
                          style: FontStyles().randomTextStylePoppins(
                              size: 18,
                              weight: FontWeight.w500,
                              color: color.kBlack),
                        ),
                        RichText(
                          text: TextSpan(
                              text: 'Welcome to ',
                              style: FontStyles().randomTextStylePoppins(
                                  size: 14,
                                  weight: FontWeight.w500,
                                  color: color.kGrey),
                              children: [
                                TextSpan(
                                  text: 'Darklet',
                                  style: FontStyles().randomTextStylePoppins(
                                      size: 14,
                                      weight: FontWeight.w500,
                                      color: const Color(0XFF6CAC00)),
                                ),
                              ]),
                        )
                      ],
                    ),
                    const Spacer(),
                    Stack(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: color.kWhite,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: color.kLightGrey, width: 0.5),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications_none_rounded,
                              color: color.kGrey,
                              size: 30,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 38,
                          child: Icon(
                            Icons.circle,
                            color: color.primaryColor,
                            size: 16,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                kHeight25,
                const SearchFieldWidget(
                  content: 'Search Products....',
                ),
                kHeight20,
                Container(
                  width: double.infinity,
                  height: 168,
                  decoration: BoxDecoration(
                      color: color.kLightGrey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(22),
                      image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'https://media.very.co.uk/v/very/W57N6_SQ8_0000002889_DESERT_DVvL'))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
