import '../src/Auth/Login/userLogin_model.dart';

class BaseConstant {
  //Production
  static const String BASE_URL = "https://gleekey.in/api/";
  static const String BASE_IMG_URL = "https://gleekey.in/public/images/";
  static const String BASE_PROPERTY_IMG_URL =
      "https://gleekey.in/public/images/property/";
  static const String BASE_PROPERTY_TYPE_IMG_URL =
      "https://gleekey.in/public/images/property_type/";

  //Stage
  // static const String BASE_URL = "https://glee.sharenow.live/api/";
  // static const String BASE_IMG_URL = "https://glee.sharenow.live/public/images/";
  // static const String BASE_PROPERTY_IMG_URL =
  //     "https://glee.sharenow.live/public/images/property/";
  // static const String BASE_PROPERTY_TYPE_IMG_URL =
  //     "https://glee.sharenow.live/public/images/property_type/";
}

class EndPoint {
  static const String home = "home";
  static const String reviews = "reviews";
  static const String reviewsAdd = "reviews/add";
  static const String propertyTypeById = 'property-type/';
  static const String ragister = "register";
  static const String login = "login";
  static const String socialLogin = "social_media_login";
  static const String sendOTP = "send-otp";
  static const String propertyAllDetails = "viewProperties/";
  static const String validateCoupenCode = "validate_coupan_code";
  static const String promoCodeList = "promo-code-list";
  static const String createBooking = "payments/create_booking";
  static const String cancelBooking = "cancel_booking";
  static const String amenities = "amenitie/1/";
  static const String addWishlist = "addEditWishlist";
  static const String wishlist = "wishlist";
  static const String bookings = "trips/active";
  static const String receipt = "booking/receipt/";
  static const String forgetPassword = "forgot_password";
  static const String searchResult = "searchResult";
  static const String updateProfile = "users/profile";
  static const String sendInquiry = "property/send/inquiry";
  static const String getInquiry = "property/get/inquiry";
  static const String userChangePassword = "user_change_password";
  static const String filter = "search";
  static const String getCountry = "get_country";
  static const String getState = "get_state";
  static const String getCity = "get_city";
  static const String bookingAdvanceReciept = "booking_advance_reciept";
  static const String refundVoucher = "refund_voucher";
  static const String userCancelReciept = "user_cancel_reciept";
  static const String userInvoice = "user_invoice";
  static const String bookingVoucherReciept = "booking_voucher_reciept";
  static const String couponList = "coupon_list";
  static const String couponAdd = "coupon_add";
  static const String couponProperties = "coupon_properties";
}

const String googleMapsApi = "AIzaSyAsXCP8XNZCYRH6jcRQD1codAVPG8KJVs4";
User_model? currUser;
