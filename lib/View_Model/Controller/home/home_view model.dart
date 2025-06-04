import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../Data/responce/api_status.dart';
import '../../../Repositry/home_repositry/home_repositry.dart';
import '../../../models/home/user_ListModel.dart';
//get api
class HomeController extends GetxController{
  final _api= HomeRepositry();
  final rxReqrestStatus=Status.LOADING.obs;// ai amar status class thaka payasie aga ai ta create kora naya hoisa
  final userList=UserListModel().obs;
  RxString error="".obs;

  void setRxReqrestStatus(Status _value)=> rxReqrestStatus.value= _value;
  void setUserList(UserListModel _value)=> userList.value= _value;
  void setError(String _value)=> error.value= _value;

  void userListApi(){
    //setRxReqrestStatus(Status.LOADING);
    _api.userListApi().then((value){
      setRxReqrestStatus(Status.COMPLEATED);
      setUserList(value);
    }).onError((error, stackTrace) {
      setRxReqrestStatus(Status.ERROR);
      setError(error.toString());
      Get.snackbar("error", "$error");
      print(error.toString());
    });
  }

  void refreshApi(){
      setRxReqrestStatus(Status.LOADING);
    _api.userListApi().then((value){
      setRxReqrestStatus(Status.COMPLEATED);
      setUserList(value);
    }).onError((error, stackTrace) {
      setRxReqrestStatus(Status.ERROR);
      setError(error.toString());
      Get.snackbar("error", "$error");
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}