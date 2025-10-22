import 'package:get/get.dart';
import 'package:nikosafe/binding/provider/service_chat_binding.dart';
import 'package:nikosafe/binding/userLocation/user_location_binding.dart';
import 'package:nikosafe/binding/user_chat_binding/user_chat_binding.dart';
import 'package:nikosafe/binding/user_createPost/user_create_post_binding.dart';
import 'package:nikosafe/binding/vendor/vendor_chat_binding.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/view/Authentication/authentication.dart';
import 'package:nikosafe/view/Authentication/forgetpassword/forgetpassword_view.dart';
import 'package:nikosafe/view/Authentication/verification/email_view.dart';
import 'package:nikosafe/view/Authentication/verification/otp_view.dart';
import 'package:nikosafe/view/Authentication/verification/password_view.dart';
import 'package:nikosafe/view/User/QrCodeScanner/menu_view.dart';
import 'package:nikosafe/view/User/UserHome/ProfileDetails.dart';
import 'package:nikosafe/view/User/UserHome/CreatePoll/create_poll_view.dart';
import 'package:nikosafe/view/User/UserHome/CreatePost/userCreatePostView.dart';
import 'package:nikosafe/view/User/UserHome/accept_connect_request_view.dart';
import 'package:nikosafe/view/User/UserProfile/Screen/user_about_us.dart';
import 'package:nikosafe/view/User/chat/chat_detail_view.dart';
import 'package:nikosafe/view/User/chat/chat_list_view.dart';

import 'package:nikosafe/view/User/userNotification/user_notification_view.dart';
import 'package:nikosafe/view/User/user_add_location_view/user_add_location_view.dart';
import 'package:nikosafe/view/User/user_btn_nav.dart';
import 'package:nikosafe/view/provider/ProviderEarning/ProviderEarningDetails/provider_erning_details_view.dart';
import 'package:nikosafe/view/provider/ProviderEarning/provider_withdrawals_view.dart';
import 'package:nikosafe/view/provider/chat/services_provider_chat_view.dart';
import 'package:nikosafe/view/vendor/Chat/vendor_chat_details_view.dart';

import '../../view/AllPayment/User/user_verification_view.dart';
import '../../view/Authentication/forgetpassword/ResetPasswordView.dart';
import '../../view/Authentication/forgetpassword/otp_veryfication_for_pass_reset.dart';
import '../../view/FAQ/faq_view.dart';
import '../../view/Splash_view.dart';
import '../../view/User/UserHome/checkIn/user_checkin.dart';
import '../../view/User/UserHome/user_home.dart';
import '../../view/User/UserProfile/Screen/Following_View/following_view.dart';
import '../../view/User/UserProfile/Screen/favariteScreen/favorites_screen.dart';
import '../../view/User/UserProfile/Screen/user_Settings/change_password/change_password_view.dart';
import '../../view/User/UserProfile/Screen/user_Settings/userDeleteAccount/userDeleteAccountView.dart';
import '../../view/User/UserProfile/Screen/user_Settings/user_Settings.dart';
import '../../view/User/UserProfile/Screen/user_edit_profile.dart';
import '../../view/User/UserProfile/Screen/user_emergency_contacts.dart';
import '../../view/User/UserProfile/Screen/user_history/user_history.dart';
import '../../view/User/UserProfile/Screen/user_history/user_parchase_details_view/user_parchase_details_view.dart';
import '../../view/User/UserProfile/Screen/user_history/user_review_view/user_review_view.dart';
import '../../view/User/UserProfile/Screen/user_privacy_policy.dart';
import '../../view/User/UserProfile/Screen/user_support.dart';
import '../../view/User/UserProfile/Screen/user_tearms&conditions.dart';
import '../../view/User/UserSearch/ClubEven/book_reservation_page.dart';
import '../../view/User/UserSearch/userServiceProvider/UserServiceProviderList/userServiceProviderListView.dart';
import '../../view/User/UserSearch/userServiceProvider/userServiseProviderDetailsView/booking_page_view.dart';
import '../../view/User/UserSearch/userServiceProvider/userServiseProviderDetailsView/userServiseProviderDetailsView.dart';
import '../../view/provider/ProviderEarning/provider_Withdraw/provider_withdraw_requestView.dart';
import '../../view/provider/ProviderHome/provider_notification_view.dart';

import '../../view/provider/ProviderHome/provider_task_detailsView.dart';
import '../../view/provider/ProviderHome/send_quote_view.dart';
import '../../view/provider/ProviderProfile/Screen/ProviderBankDetails/provider_bank_details_edit_view.dart';
import '../../view/provider/ProviderProfile/Screen/ProviderBankDetails/provider_bank_details_view.dart';
import '../../view/provider/ProviderProfile/Screen/porvider_support_view.dart';
import '../../view/provider/ProviderProfile/Screen/provderWithdrawCompleteView/provider_with_draw_complete_view.dart';
import '../../view/provider/provider_btm_nav.dart';

class AppRouts {
  static approutes() => [
    GetPage(
      name: RouteName.splashScreen,
      page: () => SplashView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.authView,
      page: () => AuthView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.emailView,
      page: () => EmailView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.oTPView,
      page: () => OTPView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.passwordView,
      page: () => PasswordView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.userHomeView,
      page: () => UserHomeView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.acceptConnectRequestView,
      page: () => AcceptConnectRequestView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.forgotPasswordView,
      page: () => ForgetpasswordView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.resetPasswordView,
      page: () => ResetPasswordView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.otpVeryficationForPassResetView,
      page: () => OtpVeryficationForPassResetView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.providerBtmNavView,
      page: () => ProviderBtmNavView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.userBottomNavView,
      page: () => UserBtnNavView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.userCreatePostView,
      page: () => UserCreatePostView(),
      binding: UserCreatePostBinding(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.userAddLocationView,
      page: () => UserAddLocationView(),
      binding: UserLocationBinding(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),

    GetPage(
      name: RouteName.createPollView,
      page: () => CreatePollView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.userNotificationView,
      page: () => UserNotificationView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.chatListView,
      page: () => ChatListView(),
      binding: UserChatListBinding(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.chatDetailView,
      page: () => ChatDetailView(),
      binding: UserChatBinding(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),

    GetPage(
      name: RouteName.profileDetailsPage,
      page: () => ProfileDetailsPage(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),

    GetPage(
      name: RouteName.userAboutUs,
      page: () => UserAboutUs(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.userEmergencyContactsView,
      page: () => UserEmergencyContactsView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.userPrivacyPolicy,
      page: () => UserPrivacyPolicy(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.userSupport,
      page: () => UserSupport(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.userTearmsConditions,
      page: () => UserTearmsConditions(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.userHistory,
      page: () => UserHistoryScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.userEditProfileView,
      page: () => UserEditProfileView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),

    GetPage(
      name: RouteName.userReviewPageView,
      page: () => UserReviewPageView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.userParchaseReceiptDetailsPage,
      page: () => UserParchaseReceiptDetailsPage(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.menu,
      page: () => const MenuView(),
    ),

    GetPage(
      name: RouteName.userSettingsView,
      page: () => UserSettingsView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.userChangePasswordView,
      page: () => UserChangePasswordView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),

    GetPage(
      name: RouteName.userDeleteAccauuntview,
      page: () => UserDeleteAccauuntview(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.userCheckInView,
      page: () => UserCheckInView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),


    GetPage(
      name: RouteName.userserviceproviderlistview,
      page: () => Userserviceproviderlistview(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.userServiceProviderDetailView,
      page: () => UserServiceProviderDetailView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),

    GetPage(
      name: RouteName.providerNotificationBottomSheet,
      page: () => ProviderNotificationBottomSheet(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.providerBankDetailsEditView,
      page: () => ProviderBankDetailsEditView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ), GetPage(
      name: RouteName.providerBankDetailsView,
      page: () => ProviderBankDetailsView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.porviderSupportView,
      page: () => ProviderSupportView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),

    GetPage(
      name: RouteName.providerWithDrawCompleteView,
      page: () => ProviderWithDrawCompleteView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),

    GetPage(
      name: RouteName.providerWithdrawRequestView,
      page: () => ProviderWithdrawRequestView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.followingView,
      page: () => FollowingView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.favoritesScreenView,
      page: () => FavoritesScreenView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),

    GetPage(
      name: RouteName.bookingPageView,
      page: () => BookingPageView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),

    GetPage(
      name: RouteName.userVerificationView,
      page: () => UserVerificationView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.providerTaskDetailView,
      page: () => ProviderTaskDetailsView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),

    GetPage(
      name: RouteName.providerSendQuoteView,
      page: () => ProviderSendQuoteView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
 GetPage(
      name: RouteName.providerEarningDataDetailsView,
      page: () => ProviderEarningDataDetailsView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.providerWithdrawalsView,
      page: () => ProviderWithdrawalsView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),

    GetPage(
      name: RouteName.userBookReservationView,
      page: () => UserBookReservationView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
    GetPage(
      name: RouteName.vendorChatDetailView,
      page: () => VendorChatDetailView(),
      binding: VendorChatBinding(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(milliseconds: 250),
    ),

    GetPage(
      name: RouteName.serviceChatDetailView,
      page: () => ServiceChatDetailView(),
      binding: ServiceChatBinding(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(milliseconds: 250),
    ),

    GetPage(
      name: RouteName.faqView,
      page: () => FaqView(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(microseconds: 250),
    ),
  ];
}

