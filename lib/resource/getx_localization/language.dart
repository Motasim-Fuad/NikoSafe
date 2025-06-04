
import 'package:get/get_navigation/src/root/internacionalization.dart';

class Languages extends Translations{
  @override
  Map<String,Map<String,String>> get keys =>{
    'en_US' :{
      "email_hint":"enter email",
      'internet_Exception':"We're unable to show results ,\n please chack your data connection",
      'GeneralExceptation':"We're unable to proces your request,\nplease try again",
      'login_title' :'login',
      'emailhint':'Enter Email',
      'passhint':"Enter Password",
    },
    'bn_BD' :{
      "email_hint":"ইমেইল প্রদান করুন",
      'internetException':"আমরা ফলাফল দেখাতে অক্ষম।\n অনুগ্রহ করে আপনার ডেটা সংযোগ পরীক্ষা করুন",
      'GeneralExceptation':"আমরা আপনার অনুরোধ প্রক্রিয়া করতে অক্ষম,\nঅনুগ্রহ করে আবার try করুন",
      "login_title":'login',
    },
  };
}