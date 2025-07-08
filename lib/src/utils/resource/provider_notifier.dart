import 'package:darklet/src/auth/controller/auth_controller.dart';
import 'package:darklet/src/home/controller/home_controller.dart';
import 'package:darklet/src/products/controller/products_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (context) => AuthController()),
  ChangeNotifierProvider(create: (context) => HomeController()),
  ChangeNotifierProvider(create: (context) => ProductsController()),
];
