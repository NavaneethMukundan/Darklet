import 'package:darklet/src/utils/widgets/network_connection.dart';
import 'package:flutter/material.dart';

popRoute(context) async {
  Navigator.of(context).pop(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 100),
      pageBuilder: (_, __, ___) => const SizedBox(),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
  await connectionCheck();
}

pushRemoveUntilRoute(context, Widget widget) async {
  Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) => widget,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      (route) => false);

  await connectionCheck();
}

pushReplacementRoute(context, Widget widget) async {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) => widget,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
  await connectionCheck();
}

pushRoute(context, Widget widget) async {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) => widget,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
  await connectionCheck();
}
