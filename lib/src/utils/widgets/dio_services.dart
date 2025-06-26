import 'package:darklet/src/utils/resource/routes/routes.dart';
import 'package:darklet/src/utils/widgets/network_connection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Future<T?> dioCompanyApiRequest<T>({
  required String endpoint,
  required String method,
  Object? data,
  required T Function(Map<String, dynamic>) fromJson,
  required Function(String message) modelMessage,
  required BuildContext context,
  bool? isTokenNeeded,
}) async {
  // final auth = Provider.of<AuthController>(context, listen: false);
  // final token = await auth.storage.read(key: 'userToken');
  const accessToken = "Bearer 'token'";

  final dio = Dio();

  if (await connectionCheck()) {
    try {
      final response = await dio.request(
        Routes().baseUrl + endpoint,
        options: Options(
          method: method,
          headers: {
            "X-App-Type": 'mobile',
            'Accept': 'application/json',
            "Content-Type": 'application/json',
            "Authorization": accessToken,
          },
        ),
        data: data,
      );

      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        return fromJson(response.data);
      } else {
        return modelMessage('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return modelMessage(
            "That page is missing. Please try going back or searching for something else");
      } else if (e.response != null && e.response!.statusCode == 200) {
        return modelMessage(e.response!.data['message']);
      } else if (e.response?.statusCode == 402) {
        return modelMessage(e.response!.data['message']);
      } else if (e.response?.statusCode == 401) {
        return modelMessage(
            'Unauthorized access. Please re-login to continue.');
      } else if (e.response?.statusCode == 422) {
        return modelMessage(
            "Invalid input. Please make sure all fields are filled out correctly and try again.");
      } else if (e.response?.statusCode == 500) {
        return modelMessage(
            "Due to temporary server difficulties, we're unable to process your request at this time. Please try again later.");
      }
    } catch (e) {
      return modelMessage('Something went wrong, please try again!');
    }
  } else {
    return modelMessage('Please check internet connection');
  }
  return null;
}
