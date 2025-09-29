// base_api_servicrs.dart
import 'dart:io';

abstract class BaseApiServices {

  Future<dynamic> getApi(String url, {bool requireAuth = false});

  Future<dynamic> postApi(var data, String url, {bool requireAuth = false});


  Future<dynamic> putApi(var data, String url, {bool requireAuth = false});

  Future<dynamic> deleteApi(String url, {bool requireAuth = false, var data});


  Future<dynamic> postMultipartApi({
    required String url,
    required Map<String, dynamic> data,
    File? imageFile,
    String imageFieldName = "image",
    bool requireAuth = false,
  });

}