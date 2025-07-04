import 'package:darklet/src/home/widget/search_field_widget.dart';
import 'package:darklet/src/onboarding/view/splash_screen.dart';
import 'package:darklet/src/utils/constants/asset_store.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            kHeight25,
            Center(
              child: RichText(
                text: TextSpan(
                    text: 'Wish',
                    style: FontStyles().randomTextStylePoppins(
                        size: 25, weight: FontWeight.bold, color: color.kGrey),
                    children: [
                      TextSpan(
                        text: 'list',
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
                      border: Border.all(color: color.kLightGrey, width: 0.5),
                      image: DecorationImage(
                          image: AssetImage(AssetStore().filterIcon))),
                )
              ],
            ),
            kHeight30,
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    height: 123,
                    decoration: BoxDecoration(
                      color: color.kWhite,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: color.kLightGrey, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        kWidth15,
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              width: 144,
                              decoration: BoxDecoration(
                                color: color.kLightGrey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                    'https://pngimg.com/uploads/iphone16/iphone16_PNG13.png'),
                              ),
                            ),
                            SizedBox(
                              width: 144,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: color.kWhite,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                color.kBlack.withOpacity(0.2),
                                            blurRadius: 1,
                                            offset: const Offset(0, 0),
                                          )
                                        ],
                                      ),
                                      child: Icon(Icons.favorite_rounded,
                                          color: color.primaryDarkColor,
                                          size: 20)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        kWidth10,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              kHeight15,
                              Text(
                                'iPhone 16 Pro Max',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: FontStyles().randomTextStylePoppins(
                                    size: 16,
                                    weight: FontWeight.w600,
                                    color: color.kBlack),
                              ),
                              kHeight5,
                              Text(
                                'iIts a 256 GB internal storage with Natural Titanium color',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: FontStyles().randomTextStylePoppins(
                                    size: 12,
                                    weight: FontWeight.w400,
                                    color: color.kBlackSecondary),
                              ),
                              const Spacer(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '\$799.00',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: FontStyles().randomTextStylePoppins(
                                        size: 15,
                                        weight: FontWeight.w600,
                                        color: color.kBlack),
                                  ),
                                  const Spacer(),
                                  Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: color.kBlack,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                color.kBlack.withOpacity(0.2),
                                            blurRadius: 1,
                                            offset: const Offset(0, 0),
                                          )
                                        ],
                                      ),
                                      child: Transform.rotate(
                                        angle: 310 * 3.14 / 180,
                                        child: Icon(
                                            Icons.arrow_right_alt_rounded,
                                            color: color.kWhite,
                                            size: 40),
                                      )),
                                  kWidth5
                                ],
                              ),
                              kHeight5
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => kHeight15,
                itemCount: 10),
            kHeight60
          ],
        ),
      ),
    )));
  }
}
