import 'package:darklet/src/home/widget/screen_gradient_widget.dart';
import 'package:darklet/src/onboarding/view/splash_screen.dart';
import 'package:darklet/src/products/controller/products_controller.dart';
import 'package:darklet/src/utils/constants/asset_store.dart';
import 'package:darklet/src/utils/constants/screen_route.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenGradientWidget(
        child: Scaffold(
      backgroundColor: color.kTransparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: color.kTransparent,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                popRoute(context);
              },
              child: Container(
                  padding: const EdgeInsets.only(
                      left: 16, right: 18, top: 14, bottom: 14),
                  decoration: BoxDecoration(
                      color: color.kLightGrey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: color.kLightGrey.withOpacity(0.5))),
                  child: RotatedBox(
                      quarterTurns: 2,
                      child: Image.asset(AssetStore().rightArrowIcon))),
            ),
            kWidth15,
            Center(
              child: RichText(
                text: TextSpan(
                    text: 'Phone ',
                    style: FontStyles().randomTextStylePoppins(
                        size: 23,
                        weight: FontWeight.w600,
                        color: const Color(0XFF6CAC00)),
                    children: [
                      TextSpan(
                        text: 'Section',
                        style: FontStyles().randomTextStylePoppins(
                            size: 23,
                            weight: FontWeight.w600,
                            color: color.kGrey),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
      body: Consumer<ProductsController>(builder: (context, controller, _) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                kHeight15,
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.productsList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                      controller.productsList[index]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'iPhone 16 Pro Max 256GB Natural Titanium',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: FontStyles().randomTextStylePoppins(
                                        size: 14,
                                        weight: FontWeight.w400,
                                        color: color.kBlack)),
                              ),
                              Align(
                                alignment: AlignmentDirectional.bottomEnd,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text('\$799',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: FontStyles()
                                          .randomTextStylePoppins(
                                              size: 16,
                                              weight: FontWeight.w600,
                                              color: color.kBlack)),
                                ),
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
              ],
            ),
          ),
        );
      }),
    ));
  }
}
