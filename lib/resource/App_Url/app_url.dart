// Path: data/app_url.dart
// Copy this ENTIRE file

class AppUrl {
  static const String base_url = 'https://resolutions-responded-stages-prepare.trycloudflare.com';

  // Auth URLs
  static const String userRegisterUrl = '$base_url/api/basicuser/register/';
  static const String verifyEmailUrl = '$base_url/api/basicuser/verify-otp/';
  static const String resendOtpUrl = '$base_url/api/basicuser/resend-otp/';
  static const String setPasswordUrl = '$base_url/api/basicuser/set-password/';
  static const String loginUrl = '$base_url/api/basicuser/login/';
  static const String forgotPasswordUrl = '$base_url/api/basicuser/password/reset-request/';
  static const String verifyPasswordResetOtpUrl = '$base_url/api/basicuser/password/reset-verify-otp/';
  static const String confirmPasswordResetUrl = '$base_url/api/basicuser/password/reset-confirm/';
  static const String resendPasswordResetOtpUrl = '$base_url/api/basicuser/password/reset-request/';

  // Social/Post URLs
  static const String socialPostTypes = '$base_url/api/social/post-types/';
  static const String socialPrivacyOptions = '$base_url/api/social/privacy-options/';
  static const String socialCreatePosts = '$base_url/api/social/posts/';
  static const String socialCreatePolls = '$base_url/api/social/posts/';
  static const String socialCreateCheckIn = '$base_url/api/social/posts/';
  static const String socialFeedTimeline = '$base_url/api/social/feed/';
  static const String socialPostReactions = '$base_url/api/social/posts/';
  static const String socialHidePost = '$base_url/api/social/posts/';
  static const String socialUnhidePost = '$base_url/api/social/posts/';
  static const String socialDeletePosts = '$base_url/api/social/posts/';
  static const String socialUpdatePosts = '$base_url/api/social/posts/';
  static const String socialPollVoting = '$base_url/api/social/posts/';
  static const String socialRemovePollVote = '$base_url/api/social/posts/';
  static const String socialPollVotingResult = '$base_url/api/social/posts/';
  static const String socialComments = '$base_url/api/social/comments/';
  static const String socialReplyComment = '$base_url/api/social/comments/';

  // Friends/Connect URLs
  static const String socialSearchUsers = '$base_url/api/social/users/search/';
  static const String socialGetUserProfile = '$base_url/api/social/users/';
  static const String socialUserFriends = '$base_url/api/social/friends/';
  static const String socialMakeFriends = '$base_url/api/social/friends/';
  static const String socialAcceptFriendRequest = '$base_url/api/social/friends/';
  static const String socialDeclineFriendRequest = '$base_url/api/social/friends/';

  static String getUserProfileUrl(int userId) {
    return '${socialGetUserProfile}$userId/profile/';
  }

  static String getAcceptFriendRequestUrl(int requestId) {
    return '${socialAcceptFriendRequest}$requestId/accept/';
  }

  static String getDeclineFriendRequestUrl(int requestId) {
    return '${socialDeclineFriendRequest}$requestId/decline/';
  }
}