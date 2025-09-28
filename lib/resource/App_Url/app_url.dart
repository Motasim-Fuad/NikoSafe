class AppUrl{
  static const String base_url='https://completing-ripe-latino-identified.trycloudflare.com';
  static const String userRegisterUrl='$base_url/api/basicuser/register/';
  static const String verifyEmailUrl='$base_url/api/basicuser/verify-otp/';
  static const String resendOtpUrl='$base_url/api/basicuser/resend-otp/';
  static const String setPasswordUrl='$base_url/api/basicuser/set-password/';
  static const String loginUrl = '$base_url/api/basicuser/login/';
  static const String forgotPasswordUrl = '$base_url/api/basicuser/password/reset-request/';
  static const String verifyPasswordResetOtpUrl = '$base_url/api/basicuser/password/reset-verify-otp/';
  static const String confirmPasswordResetUrl = '$base_url/api/basicuser/password/reset-confirm/';
  static const String resendPasswordResetOtpUrl = '$base_url/api/basicuser/password/reset-request/';


            ///---------------------user-----------------///
                     ///------home-----------///
  static const String socialPostTypes = '$base_url/api/social/post-types/';
}