

import '../../Data/Network/Network_api_services.dart';
import '../../resource/App_Url/app_url.dart';

class LoginRepositry{
  final _apiservices= NetworkApiServices();

  Future <dynamic> loginApi(var data)async{
    final responce= await _apiservices.postApi(data, AppUrl.loginApi,);
    return responce;
  }
}