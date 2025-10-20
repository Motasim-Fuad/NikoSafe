// data/app_url.dart - UPDATED WITH PAYMENT ENDPOINTS

class AppUrl {
  static const String base_url = 'https://brief-produces-filter-stockings.trycloudflare.com';
  static const String ws_base_url = 'wss://brief-produces-filter-stockings.trycloudflare.com';

  // ====== REGISTRATION ENDPOINTS ======
  static const String userRegisterUrl = "$base_url/api/accounts/register/";
  static const String providerRegisterUrl = "$base_url/api/provider/register/";
  static const String vendorRegisterUrl = "$base_url/api/hospitality/register/";

  // ====== LOGIN ENDPOINTS ======
  static const String LoginUrl = "$base_url/api/accounts/login/";

  // ====== DESIGNATIONS & SERVICE PROVIDERS ======
  static const String getDesignationsUrl = "$base_url/api/provider/designations/";
  static const String getAllServiceProvidersUrl = "$base_url/api/basicuser/providers/";
  static const String getSavedProvidersUrl = "$base_url/api/basicuser/saved-providers/";

  // ====== VENUE TYPES ======
  static const String getVenueTypesUrl = "$base_url/api/hospitality/types/";

  // ====== EMAIL VERIFICATION ======
  static const String verifyEmailUrl = "$base_url/api/accounts/verify-otp/";
  static const String resendOtpUrl = "$base_url/api/accounts/resend-otp/";
  static const String setPasswordUrl = "$base_url/api/accounts/set-password/";

  // ====== FORGOT PASSWORD ======
  static const String forgotPasswordUrl = "$base_url/api/accounts/forgot-password/";
  static const String verifyPasswordResetOtpUrl = "$base_url/api/accounts/verify-password-reset-otp/";
  static const String resendPasswordResetOtpUrl = "$base_url/api/accounts/resend-password-reset-otp/";
  static const String confirmPasswordResetUrl = "$base_url/api/accounts/confirm-password-reset/";

  // ====== SOCIAL/POST URLs ======
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

  // ====== FRIENDS/CONNECT URLs ======
  static const String socialSearchUsers = '$base_url/api/social/users/search/';
  static const String socialGetUserProfile = '$base_url/api/social/users/';
  static const String socialUserFriends = '$base_url/api/social/friends/';
  static const String socialMakeFriends = '$base_url/api/social/friends/';
  static const String socialAcceptFriendRequest = '$base_url/api/social/friends/';
  static const String socialDeclineFriendRequest = '$base_url/api/social/friends/';

  // ====== VENUE/EXPLORE ENDPOINTS ======
  static const String getAllVenuesUrl = "$base_url/api/hospitality/venues/";
  static const String getVenueReviewsUrl = "$base_url/api/hospitality/venues/";
  static const String createVenueReviewUrl = "$base_url/api/hospitality/venues/";
  static const String followVenueUrl = "$base_url/api/hospitality/venues/";
  static const String favoriteVenueUrl = "$base_url/api/hospitality/venues/";

  // ====== BANNER ENDPOINTS ======
  static const String getAllBannersUrl = "$base_url/api/dashboard/admin/banners/all/";

  // ====== BOOKING ENDPOINTS ======
  static const String createBookingUrl = "$base_url/api/basicuser/bookings/create/";

  // ====== PAYMENT ENDPOINTS ======
  static const String createPaymentIntentUrl = "$base_url/api/payments/create-payment-intent/";
  static const String confirmPaymentUrl = "$base_url/api/payments/confirm-payment/";

  // ====== SERVICE PROVIDER HELPER METHODS ======
  static String getProviderDetailsUrl(int providerId) {
    return '$getAllServiceProvidersUrl$providerId/';
  }

  static String saveProviderUrl(int providerId) {
    return '$getAllServiceProvidersUrl$providerId/save/';
  }

  // ====== USER PROFILE HELPER METHODS ======
  static String getUserProfileUrl(int userId) {
    return '${socialGetUserProfile}$userId/profile/';
  }

  static String getAcceptFriendRequestUrl(int requestId) {
    return '${socialAcceptFriendRequest}$requestId/accept/';
  }

  static String getDeclineFriendRequestUrl(int requestId) {
    return '${socialDeclineFriendRequest}$requestId/decline/';
  }

  // ====== VENUE HELPER METHODS ======
  static String getVenueReviewsApiUrl(int venueId) {
    return '${getVenueReviewsUrl}$venueId/reviews/';
  }

  static String createReviewApiUrl(int venueId) {
    return '${createVenueReviewUrl}$venueId/reviews/create/';
  }

  static String followVenueApiUrl(int venueId) {
    return '${followVenueUrl}$venueId/follow/';
  }

  static String favoriteVenueApiUrl(int venueId) {
    return '${favoriteVenueUrl}$venueId/favorite/';
  }

  // FAQ Endpoints
  static const String faqEndpoint = '$base_url/api/core/faqs/';

  // Support Ticket Endpoints
  static const String createTicketEndpoint = '$base_url/api/core/tickets/create/';

  // User my profile
  static const String myProfile = '$base_url/api/basicuser/profile/';

  // ====== SETTINGS/PRIVACY ENDPOINTS ======
  static const String privacyPolicyUrl = "$base_url/api/core/privacy-policy/";
  static const String termsConditionsUrl = "$base_url/api/core/terms-and-conditions/";
  static const String aboutUsUrl = "$base_url/api/core/about-us/";


  //========QrCodeScanner SECTION =====
  static String getMenuItemsUrl(int venueId) {
    return '$base_url/api/hospitality/venues/$venueId/menu-items/';
  }

  // ====== PROVIDER SECTION ======
  static const String providerProfileUrl = "$base_url/api/provider/profile/";
  static const String providerBookingsUrl = "$base_url/api/provider/bookings/";
  static String getBookingDetailsUrl(int bookingId) {
    return '$providerBookingsUrl$bookingId/';
  }
  static String acceptRejectBookingUrl(int bookingId) {
    return '$base_url/api/provider/bookings/$bookingId/accept-reject/';
  }

  static const String sendQuoteUrl = "$base_url/api/provider/bookings/send-quote/";




}