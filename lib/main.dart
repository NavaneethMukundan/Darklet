import 'package:darklet/src/app.dart';
import 'package:darklet/src/app_dependencies.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final deps = await AppDependencies.create();
  runApp(MyApp(deps: deps));
}
