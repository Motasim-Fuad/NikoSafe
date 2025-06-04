


import '../../../../models/Login/User_Responce_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UserPreferences {

  Future <bool>  saveUser(UserModel responceModel)async{
    SharedPreferences sp= await SharedPreferences.getInstance();
    sp.setString("token", responceModel.token.toString());

    return true;
  }

  Future <UserModel>  getUser()async{
    SharedPreferences sp= await SharedPreferences.getInstance();
   String? token= sp.getString("token");

    return UserModel(
      token: token
    );
  }


  Future<bool> removeuser()async{
    SharedPreferences sp= await SharedPreferences.getInstance();
    sp.clear();
    return true;
  }
}



