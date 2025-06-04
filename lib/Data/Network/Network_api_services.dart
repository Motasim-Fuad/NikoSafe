
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';


import '../Exceptation_Handle.dart';
import 'base_api_servicrs.dart';
import 'package:http/http.dart ' as http;
class NetworkApiServices extends BaseApiServices{
  @override

  Future <dynamic> getApi(String url)async{

    //jodi kisue print korta chai toba ai vaba print korbo
    if (kDebugMode) {
      print(url);

    }
    dynamic responceJson;
    try{
      final responce=await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      // backend devoloper bola diba time out a koto second hoba

      responceJson= returnResponce(responce);
    } on SocketException{
      throw InternetException("");
    }on RequestTimeOut{
      throw RequestTimeOut("");
    }

    return responceJson;
  }

  Future<dynamic> postMultipartApi({
    required String url,
    required Map<String, String> fields,
    File? imageFile,
    String imageFieldName = "profileImage", // or the field name your backend expects
  }) async {
    if (kDebugMode) {
      print('POST MULTIPART to: $url');
      print('Fields: $fields');
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(fields);

      if (imageFile != null) {
        var fileStream = await http.MultipartFile.fromPath(
          imageFieldName,
          imageFile.path,
        );
        request.files.add(fileStream);
      }

      var streamedResponse = await request.send().timeout(const Duration(seconds: 10));
      var response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print('Response: ${response.body}');
      }

      return returnResponce(response);
    } on SocketException {
      throw InternetException("No Internet");
    } on RequestTimeOut {
      throw RequestTimeOut("Request Timeout");
    }
  }


  Future<dynamic> postApi(var data, String url) async {
    if (kDebugMode) {
      print("URL: $url");
      print("Data: $data");
    }

    dynamic responseJson;

    try {
      final stopwatch = Stopwatch()..start(); // ⏱ Start measuring time

      final response = await http
          .post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      )
          .timeout(const Duration(seconds: 45));

      stopwatch.stop(); // ⏱ Stop measuring time

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



  // Future <dynamic> postApi(var data,String url)async{
  //   //jodi kisue print korta chai toba ai vaba print korbo
  //   if (kDebugMode) {
  //     print(url);
  //     print(data);
  //   }
  //
  //   dynamic responceJson;
  //   try{
  //     final responce= await http .post(Uri.parse(url),
  //       // headers: {
  //       //   "Authorization":"Token$token",
  //       //   "Content-Type":"application/json"
  //       // },
  //       body:data,// jsonEncode(data),//jodi row from a hoy taila body ai vaba
  //       // row from a na hola , body:data, ai hoba
  //
  //
  //
  //
  //     ).timeout(const Duration(seconds: 10));
  //     // backend developer bola diba time out a koto second hoba
  //
  //     responceJson= returnResponce(responce);
  //   } on SocketException{
  //     throw InternetException("");
  //   }on RequestTimeOut{
  //     throw RequestTimeOut("");
  //   }
  //   if (kDebugMode) {
  //     print(responceJson);
  //   }
  //   return responceJson;
  // }

  dynamic returnResponce(http.Response response){
    switch (response.statusCode){
      case 200:
        dynamic responceJson= jsonDecode(response.body);
        return responceJson;
      case 400:
        dynamic responceJson= jsonDecode(response.body);
        return responceJson;
      default:
        throw FatchDataExceptation(" "+response.statusCode.toString());
    }

  }

}