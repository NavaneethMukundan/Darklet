import 'package:darklet/src/onboarding/view/splash_screen.dart';
import 'package:darklet/src/utils/constants/asset_store.dart';
import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/themes/styles/font_style.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kHeight30,
                Row(
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          color: color.secondaryColor,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(AssetStore().profilePicture))),
                    ),
                    kWidth15,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: FontStyles().randomTextStylePoppins(
                                size: 20,
                                weight: FontWeight.bold,
                                color: color.kBlack),
                          ),
                          Text(
                            'Abcde@gmail.com ',
                            maxLines: 3,
                            overflow: TextOverflow.fade,
                            style: FontStyles().randomTextStylePoppins(
                                size: 20,
                                weight: FontWeight.w500,
                                color: color.kGrey),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                kHeight10,
                Text(
                  'Navaneeth',
                  style: FontStyles().randomTextStylePoppins(
                      size: 36, weight: FontWeight.bold, color: color.kBlack),
                ),
                Text(
                  'Mukundan',
                  style: FontStyles().randomTextStylePoppins(
                      size: 30, weight: FontWeight.w500, color: color.kGrey),
                ),
                kHeight50,
                Text(
                  'Profile',
                  style: FontStyles().randomTextStylePoppins(
                      size: 22, weight: FontWeight.w600, color: color.kBlack),
                ),
                kHeight15,
                profileTile(const Color(0XFFE7F7CB), 'Manage Profile',
                    AssetStore().profileManageIcon),
                kHeight25,
                Text(
                  'Settings',
                  style: FontStyles().randomTextStylePoppins(
                      size: 22, weight: FontWeight.w600, color: color.kBlack),
                ),
                kHeight15,
                profileTile(const Color(0XFFE5BEF9), 'Notifications',
                    AssetStore().notificationIcon),
                kHeight20,
                profileTile(const Color(0XFF88ABB7), 'Dark Mode',
                    AssetStore().darkThemeIcon),
                kHeight50,
                Container(
                  margin: const EdgeInsets.only(left: 35, right: 35),
                  height: 65,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: color.kBlackSecondary,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      'Log Out',
                      style: FontStyles().randomTextStylePoppins(
                          size: 20,
                          weight: FontWeight.w600,
                          color: color.kWhite),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row profileTile(Color colors, String title, String image) {
    return Row(
      children: [
        Container(
          height: 69,
          width: 69,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors,
              image: DecorationImage(image: AssetImage(image))),
        ),
        kWidth15,
        Text(
          title,
          style: FontStyles().randomTextStylePoppins(
              size: 18, weight: FontWeight.w500, color: color.kBlackSecondary),
        ),
        const Spacer(),
        Icon(
          Icons.keyboard_arrow_right_rounded,
          color: color.kGrey,
          size: 30,
        )
      ],
    );
  }
}
