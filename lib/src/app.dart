import 'package:darklet/src/utils/constants/space_helper.dart';
import 'package:darklet/src/utils/resource/provider_notifier.dart';
import 'package:darklet/src/utils/themes/colors/colors.dart';
import 'package:darklet/src/utils/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: MultiProvider(
        providers: providers,
        child: MaterialApp(
          title: 'Pepper Brain',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: ColorManager().kWhite,
            useMaterial3: true,
            primarySwatch: Colors.blue,
          ),
          home: Builder(builder: (context) {
            ScreenUtil.init(context);
            return BottomNavigation();
          }),
        ),
      ),
    );
  }
}
