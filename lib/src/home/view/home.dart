import 'package:darklet/src/home/controller/home_controller.dart';
import 'package:darklet/src/home/widget/screen_gradient_widget.dart';
import 'package:darklet/src/home/widget/search_field_widget.dart';
import 'package:darklet/src/onboarding/view/splash_screen.dart';
import 'package:darklet/src/utils/constants/asset_store.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenGradientWidget(
      child: Scaffold(
        backgroundColor: color.kTransparent,
        body: Consumer<HomeController>(builder: (context, controller, _) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                              color: color.kLightGrey.withOpacity(0.5),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image:
                                      AssetImage(AssetStore().profilePicture))),
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
                                      style: FontStyles()
                                          .randomTextStylePoppins(
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
                                border: Border.all(
                                    color: color.kLightGrey, width: 0.5),
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
                    kHeight30,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Categories',
                            style: FontStyles().randomTextStylePoppins(
                                size: 22,
                                weight: FontWeight.w600,
                                color: color.kBlackSecondary)),
                        Text('View all',
                            style: FontStyles().randomTextStylePoppins(
                                size: 15,
                                weight: FontWeight.w400,
                                color: color.primaryDarkColor)),
                      ],
                    ),
                    kHeight20,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          4,
                          (index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    width: 85,
                                    height: 85,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const RadialGradient(colors: [
                                        Color(0XFFD6F3A2),
                                        Color(0XFFF3F3F3),
                                      ]),
                                      image: DecorationImage(
                                          image: AssetImage(controller
                                              .homeCategoriesImages[index])),
                                    ),
                                  ),
                                  kHeight5,
                                  Text(
                                    controller.homeCategoriesName[index],
                                    style: FontStyles().randomTextStylePoppins(
                                        size: 15,
                                        weight: FontWeight.w500,
                                        color: color.kBlackSecondary),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    kHeight25,
                    Row(
                      children: [
                        Text('Flash Sales',
                            style: FontStyles().randomTextStylePoppins(
                                size: 22,
                                weight: FontWeight.w600,
                                color: color.kBlackSecondary)),
                        kWidth5,
                        Container(
                          height: 20,
                          width: 75,
                          decoration: BoxDecoration(color: color.primaryColor),
                          child: Center(
                            child: Text('22.50.45',
                                style: FontStyles().randomTextStylePoppins(
                                    size: 13,
                                    weight: FontWeight.w400,
                                    color: color.kBlack)),
                          ),
                        ),
                      ],
                    ),
                    kHeight15,
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.flashSaleImages.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: color.kWhite,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.kBlack.withOpacity(0.2),
                                    blurRadius: 2,
                                    offset: const Offset(0, 0),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 115,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: color.kLightGrey.withOpacity(0.2),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(22),
                                        topRight: Radius.circular(22),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                          controller.flashSaleImages[index]),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'iPhone 16 Pro Max 256GB Natural Titanium',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: FontStyles()
                                            .randomTextStylePoppins(
                                                size: 14,
                                                weight: FontWeight.w400,
                                                color: color.kBlack)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text('\$799',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: FontStyles()
                                            .randomTextStylePoppins(
                                                size: 16,
                                                weight: FontWeight.w600,
                                                color: color.kBlack)),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: MediaQuery.of(context).size.width / 2.81,
                              child: Container(
                                height: 33,
                                width: 33,
                                decoration: BoxDecoration(
                                  color: color.kWhite,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.kBlack.withOpacity(0.2),
                                      blurRadius: 1,
                                      offset: const Offset(0, 0),
                                    )
                                  ],
                                ),
                                child: Image.asset(AssetStore().wishlistIcon),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                    kHeight60
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
