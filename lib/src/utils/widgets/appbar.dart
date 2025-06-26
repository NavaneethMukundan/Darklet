import 'package:darklet/src/utils/constants/screen_route.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subTitle;
  final bool? willPop;
  final bool? enableSubTitle;
  final EdgeInsetsGeometry? titlePadding;
  final bool? willShowRadius;
  final double? appHeight;
  final Widget? trialing;
  const AppBarWidget(
      {super.key,
      this.title,
      this.willPop,
      this.subTitle,
      this.titlePadding,
      this.enableSubTitle,
      this.trialing,
      this.appHeight,
      this.willShowRadius});

  @override
  Size get preferredSize => Size.fromHeight(appHeight ?? 90);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color(0XFFD49932),
            Color(0XFF6E4F1A),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderRadius: willShowRadius == false
              ? null
              : const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                willPop == true
                    ? Padding(
                        padding: titlePadding ?? EdgeInsets.zero,
                        child: IconButton(
                            onPressed: () {
                              popRoute(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: ColorManager().kWhite,
                              size: 22,
                            )),
                      )
                    : const SizedBox.shrink(),
                willPop == true ? const SizedBox.shrink() : kWidth20,
                Padding(
                  padding: titlePadding ?? EdgeInsets.zero,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: Text(
                      title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyles().randomTextStylePoppins(
                          color: ColorManager().kWhite,
                          size: 18,
                          weight: FontWeight.bold),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                    padding: titlePadding ?? EdgeInsets.zero, child: trialing)
              ],
            ),
            enableSubTitle == true
                ? Padding(
                    padding: const EdgeInsets.only(left: 23),
                    child: Text(
                      subTitle ?? '',
                      style: FontStyles().randomTextStylePoppins(
                          color: ColorManager().kWhite,
                          size: 16,
                          weight: FontWeight.w600),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
