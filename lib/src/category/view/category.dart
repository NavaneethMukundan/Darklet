import 'package:darklet/src/home/widget/search_field_widget.dart';
import 'package:darklet/src/onboarding/view/splash_screen.dart';
import 'package:darklet/src/products/view/products.dart';
import 'package:darklet/src/utils/constants/asset_store.dart';
import 'package:darklet/src/utils/constants/screen_route.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  kHeight25,
                  Center(
                    child: RichText(
                      text: TextSpan(
                          text: 'Cate',
                          style: FontStyles().randomTextStylePoppins(
                              size: 25,
                              weight: FontWeight.bold,
                              color: color.kGrey),
                          children: [
                            TextSpan(
                              text: 'gory',
                              style: FontStyles().randomTextStylePoppins(
                                  size: 25,
                                  weight: FontWeight.bold,
                                  color: const Color(0XFF6CAC00)),
                            ),
                          ]),
                    ),
                  ),
                  kHeight15,
                  Row(
                    children: [
                      const Expanded(
                        child: SearchFieldWidget(
                          content: 'Search Products....',
                        ),
                      ),
                      kWidth10,
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: color.kWhite,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: color.kLightGrey, width: 0.5),
                            image: DecorationImage(
                                image: AssetImage(AssetStore().filterIcon))),
                      )
                    ],
                  ),
                  kHeight30,
                  GestureDetector(
                    onTap: () {
                      pushRoute(context, const ProductScreen());
                    },
                    child: categoryTiles(const Color(0XFFA98E7A),
                        'iPhone section', AssetStore().iphoneCategory),
                  ),
                  kHeight15,
                  categoryTiles(const Color(0XFF722A3F), 'Laptop section',
                      AssetStore().laptopCategory),
                  kHeight15,
                  categoryTiles(const Color(0XFF8E9AD9), 'Console section',
                      AssetStore().consoleCategory),
                  kHeight15,
                  categoryTiles(const Color(0XFF005F16), 'Audio section',
                      AssetStore().headphoneCategory),
                  kHeight15,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container categoryTiles(Color gradientColor, String title, String imagePath) {
    return Container(
      height: 123,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: color.kLightGrey.withOpacity(0.8),
            blurRadius: 4,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
        gradient: LinearGradient(
          colors: [
            gradientColor,
            const Color.fromARGB(255, 237, 237, 237),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          kWidth15,
          Text(
            title,
            style: FontStyles().randomTextStylePoppins(
              size: 18,
              weight: FontWeight.w700,
              color: color.kWhite,
            ),
          ),
          const Spacer(),
          Image.asset(imagePath)
        ],
      ),
    );
  }
}
