import 'package:darklet/src/utils/widgets/network_connection.dart';
import 'package:flutter/material.dart';

popRoute(context) async {
  Navigator.of(context).pop();
  await connectionCheck();
}

pushRemoveUntilRoute(context, Widget widget) async {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => widget), (route) => false);
  await connectionCheck();
}

pushReplacementRoute(context, Widget widget) async {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (ctx) => widget));
  await connectionCheck();
}

pushRoute(context, Widget widget) async {
  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => widget));
  await connectionCheck();
}
