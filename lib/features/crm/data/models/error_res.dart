import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/configrations/general_configrations.dart';
import '../../../../core/utils/app_widgets/custom_app_text.dart';

class ErrorResponse {
  ErrorResponse({
    this.error,
    this.errorDescription,
  });

  Error? error;
  String? errorDescription;

  factory ErrorResponse.fromJson(Map<String, dynamic>? json) => ErrorResponse(
        errorDescription: json?["error_description"] ?? "",
        error: Error?.fromJson(json?["error"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error?.toJson(),
        "error_description": errorDescription,
      };

  static handelError(BuildContext? context, Object e, String name) {
    if (e is DioError) {
 if(GeneralConfigurations().isDebug){
      log('$name status code: ${e.response?.statusCode}');
 }

      if (e.response?.statusCode == 401) {
        //sl<NavigationService>().navigateToAndRemove(loginScreen);
      } else {
        // sl<NavigationService>().navigateToAndRemove(loginScreen);
      }

      if (e.response?.data != null && e.response?.data is String) {
        //ErrorResponse errorResponse = ErrorResponse.fromJson(e.response?.data);
        //String message = e.response?.data["error"]["message"];

        showSnackBarErrorMessage(context, e.response?.data);
      } else if (e.response?.data["error"] != null) {
        showSnackBarErrorMessage(context, e.response?.data["error"]);
      } else if (e.response?.statusCode == 403 && context != null) {
        showSnackBarErrorMessage(context, "you_dont_have_permission");
      }
    }
  }

  static showSnackBarErrorMessage(BuildContext? context, String? text) {
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: customTextApp(
            size: 16,
            maxLine: 10,
            text: text ?? "-",
            color: Colors.white,
          ),
        ),
      );
    }
  }

  // dynamic _processResponse(statusCode) {
  //   switch (statusCode) {
  //     case 200:
  //       var responseJson = response.body;
  //       return responseJson;
  //     case 400: //Bad request
  //       throw BadRequestException(jsonDecode(response.body)['message']);
  //     case 401: //Unauthorized
  //       throw UnAuthorizedException(jsonDecode(response.body)['message']);
  //     case 403: //Forbidden
  //       throw UnAuthorizedException(jsonDecode(response.body)['message']);
  //     case 404: //Resource Not Found
  //       throw NotFoundException(jsonDecode(response.body)['message']);
  //     case 500: //Internal Server Error
  //     default:
  //       throw FetchDataException(
  //           'Something went wrong! ${response.statusCode}');
  //   }
  // }
}

class Error {
  String? code;
  String? message;

  Map<String?, dynamic>? errors;

  Error({this.code, this.message, this.errors});

  Error.fromJson(Map<String, dynamic>? json) {
    code = json?['code'];
    message = json?['message'];
    errors = json?['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    data['message'] = message;
    data['errors'] = errors;
    return data;
  }
}
