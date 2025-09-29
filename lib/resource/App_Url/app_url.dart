// data/app_url.dart

class AppUrl {
  static const String base_url = 'https://completing-ripe-latino-identified.trycloudflare.com';

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

  // ---------- Social/Post URLs ----------

  // Post Types & Privacy
  static const String socialPostTypes = '$base_url/api/social/post-types/';
  static const String socialPrivacyOptions = '$base_url/api/social/privacy-options/';

  // Create Posts
  static const String socialCreatePosts = '$base_url/api/social/posts/';
  static const String socialCreatePolls = '$base_url/api/social/posts/';
  static const String socialCreateCheckIn = '$base_url/api/social/posts/';

  // Feed/Timeline
  static const String socialFeedTimeline = '$base_url/api/social/feed/';

  // Post Actions
  static const String socialPostReactions = '$base_url/api/social/posts/'; // + {id}/react/
  static const String socialHidePost = '$base_url/api/social/posts/'; // + {id}/hide/
  static const String socialUnhidePost = '$base_url/api/social/posts/'; // + {id}/unhide/
  static const String socialDeletePosts = '$base_url/api/social/posts/'; // + {id}/
  static const String socialUpdatePosts = '$base_url/api/social/posts/'; // + {id}/

  // Poll Actions
  static const String socialPollVoting = '$base_url/api/social/posts/'; // + {id}/vote/
  static const String socialRemovePollVote = '$base_url/api/social/posts/'; // + {id}/vote/
  static const String socialPollVotingResult = '$base_url/api/social/posts/'; // + {id}/poll-results/

  // Comments (if needed for future)
  static const String socialComments = '$base_url/api/social/comments/';
  static const String socialReplyComment = '$base_url/api/social/comments/'; // + {id}/reply/
}