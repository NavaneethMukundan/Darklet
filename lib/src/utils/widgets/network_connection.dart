import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> connectionCheck() async {
  bool result = await InternetConnectionChecker.createInstance().hasConnection;
  return result;
}
