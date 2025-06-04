
import 'package:get/get.dart';
import 'package:nikosafe/binding/userLocation/user_location_binding.dart';
import 'package:nikosafe/binding/user_createPost/user_create_post_binding.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/view/Authentication/authentication.dart';
import 'package:nikosafe/view/Authentication/forgetpassword/forgetpassword_view.dart';
import 'package:nikosafe/view/Authentication/verification/email_view.dart';
import 'package:nikosafe/view/Authentication/verification/otp_view.dart';
import 'package:nikosafe/view/User/ProfileDetails/ProfileDetails.dart';
import 'package:nikosafe/view/User/UserHome/CreatePoll/create_poll_view.dart';
import 'package:nikosafe/view/User/UserHome/CreatePost/userCreatePostView.dart';
import 'package:nikosafe/view/User/UserHome/user_home.dart';
import 'package:nikosafe/view/User/userNotification/user_notification_view.dart';
import 'package:nikosafe/view/User/user_add_location_view/user_add_location_view.dart';
import 'package:nikosafe/view/User/user_btn_nav.dart';
import 'package:nikosafe/view/chat/chat_detail_view.dart';
import 'package:nikosafe/view/chat/chat_list_view.dart';
import 'package:nikosafe/view/provider/ProviderHome/provider_home.dart';

import '../../view/Authentication/forgetpassword/ResetPasswordView.dart';
import '../../view/Authentication/forgetpassword/otp_veryfication_for_pass_reset.dart';
import '../../view/Splash_view.dart';
import '../../view/home/home_view.dart';
import '../../view/provider/provider_btm_nav.dart';



class AppRouts {

  static approutes ()=>[
    GetPage(
        name: RouteName.splashScreen,
        page: ()=> SplashView(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
        name: RouteName.authView,
        page: ()=> AuthView(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    ) ,GetPage(
        name: RouteName.emailView,
        page: ()=> EmailView(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    ) ,GetPage(
        name: RouteName.oTPView,
        page: ()=> OTPView(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    )
  ,GetPage(
        name: RouteName.homeView,
        page: ()=> HomeView(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
        name: RouteName.forgotPasswordView,
        page: ()=> ForgetpasswordView(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
        name: RouteName.resetPasswordView,
        page: ()=> ResetPasswordView(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
        name: RouteName.otpVeryficationForPassResetView,
        page: ()=> OtpVeryficationForPassResetView(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
        name: RouteName.providerBtmNavView,
        page: ()=> ProviderBtmNavView(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
        name: RouteName.userBottomNavView,
        page: ()=> UserBtnNavView(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
        name: RouteName.userCreatePostView,
        page: ()=> UserCreatePostView(),
        binding: UserCreatePostBinding(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
        name: RouteName.userAddLocationView,
        page: ()=> UserAddLocationView(),
        binding: UserLocationBinding(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    ),

    GetPage(
        name: RouteName.createPollView,
        page: ()=> CreatePollView(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
        name: RouteName.userNotificationView,
        page: ()=> UserNotificationView(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
        name: RouteName.chatListView,
        page: ()=> ChatListView(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
        name: RouteName.chatDetailView,
        page: ()=> ChatDetailView(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    ),


    GetPage(
        name: RouteName.profileDetailsPage,
        page: ()=> ProfileDetailsPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: Duration(microseconds: 250),
    ),



  ];
}


// GetPage(
//     name: RouteName.userHomeView,
//     page: ()=> UserHomeView(),
//     transition: Transition.leftToRightWithFade,
//     transitionDuration: Duration(microseconds: 250),
// ),
// GetPage(
//     name: RouteName.prviderHomeView,
//     page: ()=> ProviderHomeView(),
//     transition: Transition.leftToRightWithFade,
//     transitionDuration: Duration(microseconds: 250),
// ),