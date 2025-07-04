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
                      height: 100,
                      width: 100,
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
                      size: 30, weight: FontWeight.bold, color: color.kBlack),
                ),
                Text(
                  'Mukundan',
                  style: FontStyles().randomTextStylePoppins(
                      size: 25, weight: FontWeight.w500, color: color.kGrey),
                ),
                kHeight30,
                Text(
                  'Profile',
                  style: FontStyles().randomTextStylePoppins(
                      size: 20, weight: FontWeight.w600, color: color.kBlack),
                ),
                kHeight15,
                profileTile(const Color(0XFFE7F7CB), 'Manage Profile',
                    AssetStore().profileManageIcon),
                kHeight25,
                Text(
                  'Settings',
                  style: FontStyles().randomTextStylePoppins(
                      size: 20, weight: FontWeight.w600, color: color.kBlack),
                ),
                kHeight15,
                profileTile(const Color(0XFFE5BEF9), 'Notifications',
                    AssetStore().notificationIcon),
                kHeight20,
                profileTile(const Color(0XFF88ABB7), 'Dark Mode',
                    AssetStore().darkThemeIcon),
                kHeight20,
                profileTile(const Color(0XFF073F6C), 'Log Out',
                    AssetStore().logoutIcon),
                kHeight50,
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
          height: 55,
          width: 55,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors,
              image: DecorationImage(image: AssetImage(image))),
        ),
        kWidth15,
        Text(
          title,
          style: FontStyles().randomTextStylePoppins(
              size: 16, weight: FontWeight.w500, color: color.kBlackSecondary),
        ),
        const Spacer(),
        Container(
            padding:
                const EdgeInsets.only(left: 13, right: 11, top: 9, bottom: 9),
            decoration: BoxDecoration(
                color: color.kLightGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(AssetStore().rightArrowIcon))
      ],
    );
  }
}
