// base_api_servicrs.dart
abstract class BaseApiServices {

  Future<dynamic> getApi(String url, {bool requireAuth = false});

  Future<dynamic> postApi(var data, String url, {bool requireAuth = false});

}