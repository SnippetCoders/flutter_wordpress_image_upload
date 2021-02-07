import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:wordpress_image_upload/model/login_model.dart';
import 'package:wordpress_image_upload/service/shared_service.dart';

class APIServices {
  static var client = http.Client();
  static String apiURL = "http://192.168.0.105:8888/news-app";

  static Future<bool> uploadImage(filePath) async {
    String url = "$apiURL/wp-json/wp/v2/media";

    String fileName = filePath.path.split('/').last;
    LoginResponseModel loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Authorization':
          'Bearer ${loginDetails.data.token}',
      'Content-Disposition': 'attachment; filename=$fileName',
      'Content-Type': 'image/jpeg'
    };

    List<int> imageBytes = File(filePath.path).readAsBytesSync();
    var request = http.Request('POST', Uri.parse(url));
    request.headers.addAll(requestHeaders);
    request.bodyBytes = imageBytes;
    var res = await request.send();

    return res.statusCode == 201 ? true : false;
  }

  static Future<bool> loginCustomer(
    String username,
    String password,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
    };

    var response = await client.post(
      "$apiURL/wp-json/jwt-auth/v1/token",
      headers: requestHeaders,
      body: {
        "username": username,
        "password": password,
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      LoginResponseModel responseModel = loginResponseFromJson(jsonString);

      if (responseModel.statusCode == 200) {
        SharedService.setLoginDetails(responseModel);
      }

      return responseModel.statusCode == 200 ? true : false;
    } else {
      return false;
    }
  }
}
