// NetworkApiServices.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:nikosafe/utils/token_manager.dart';
import '../Exceptation_Handle.dart';
import 'base_api_servicrs.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices extends BaseApiServices {

  // Method to get headers with optional auth
  Future<Map<String, String>> _getHeaders({bool requireAuth = false}) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (requireAuth) {
      final token = await TokenManager.getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  @override
  Future<dynamic> getApi(String url, {bool requireAuth = false}) async {
    if (kDebugMode) {
      print(url);
    }
    dynamic responceJson;
    try {
      final headers = await _getHeaders(requireAuth: requireAuth);
      final responce = await http.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 10));
      responceJson = returnResponce(responce);
    } on SocketException {
      throw InternetException("");
    } on RequestTimeOut {
      throw RequestTimeOut("");
    }
    return responceJson;
  }

  // Update postMultipartApi method with optional auth
  Future<dynamic> postMultipartApi({
    required String url,
    required Map<String, dynamic> data,
    File? imageFile,
    String imageFieldName = "image",
    bool requireAuth = false,
  }) async {
    if (kDebugMode) {
      print('POST MULTIPART to: $url');
      print('Data: $data');
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers with optional auth
      final headers = await _getHeaders(requireAuth: requireAuth);
      request.headers.addAll(headers);

      // Add all fields to the request
      data.forEach((key, value) {
        if (value != null) {
          if (key == 'profileData' && value is Map) {
            value.forEach((nestedKey, nestedValue) {
              if (nestedValue != null) {
                request.fields['profileData[$nestedKey]'] = nestedValue.toString();
              }
            });
          } else if (value is List) {
            for (int i = 0; i < value.length; i++) {
              if (value[i] != null) {
                request.fields['$key[$i]'] = value[i].toString();
              }
            }
          } else {
            request.fields[key] = value.toString();
          }
        }
      });

      if (imageFile != null && imageFile.existsSync()) {
        var fileStream = await http.MultipartFile.fromPath(
          imageFieldName,
          imageFile.path,
        );
        request.files.add(fileStream);
      }

      if (kDebugMode) {
        print('Final request fields: ${request.fields}');
        print('Request files: ${request.files.map((f) => '${f.field}: ${f.filename}')}');
      }

      var streamedResponse = await request.send().timeout(const Duration(seconds: 45));
      var response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print('Response Status: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }

      return returnResponce(response);
    } catch (e) {
      if (kDebugMode) {
        print('Multipart request error: $e');
      }
      rethrow;
    }
  }

  @override
  Future<dynamic> postApi(var data, String url, {bool requireAuth = false}) async {
    if (kDebugMode) {
      print("URL: $url");
      print("Data: $data");
    }

    dynamic responseJson;

    try {
      final stopwatch = Stopwatch()..start();
      final headers = await _getHeaders(requireAuth: requireAuth);

      final response = await http
          .post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      )
          .timeout(const Duration(seconds: 45));

      stopwatch.stop();

      if (kDebugMode) {
        print("⏱ Backend response time: ${stopwatch.elapsedMilliseconds} ms");
      }

      responseJson = returnResponce(response);
    } on SocketException {
      throw InternetException("No Internet");
    } on RequestTimeOut {
      throw RequestTimeOut("Request timed out");
    }

    if (kDebugMode) {
      print("Response: $responseJson");
    }

    return responseJson;
  }

  dynamic returnResponce(http.Response response) {
    if (kDebugMode) {
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }

    switch (response.statusCode) {
      case 200:
      case 201:
      case 400:
      case 401:
      case 403:
      case 404:
      case 422:
      case 500:
        dynamic responceJson = jsonDecode(response.body);
        return responceJson;
      default:
        throw FatchDataExceptation("Error occurred with status code: ${response.statusCode}");
    }
  }
}