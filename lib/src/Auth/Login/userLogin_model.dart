// // ignore_for_file: file_names, camel_case_types

// class User_model {
//   var status;
//   var message;
//   Data? data;
//   var accessToken;
//   var tokenType;

//   User_model(
//       {this.status, this.message, this.data, this.accessToken, this.tokenType});

//   User_model.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//     accessToken = json['access_token'];
//     tokenType = json['token_type'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     data['access_token'] = this.accessToken;
//     data['token_type'] = this.tokenType;
//     return data;
//   }
// }

// class Data {
//   var id;
//   var firstName;
//   var lastName;
//   var email;
//   var phone;
//   var formattedPhone;
//   var carrierCode;
//   var defaultCountry;
//   var profileImage;
//   var balance;
//   var status;
//   var createdAt;
//   var updatedAt;
//   var profileSrc;

//   Data(
//       {this.id = '',
//       this.firstName = 'User',
//       this.lastName = 'Name',
//       this.email = 'user@email.com',
//       this.phone,
//       this.formattedPhone,
//       this.carrierCode,
//       this.defaultCountry,
//       this.profileImage = '',
//       this.balance,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.profileSrc =
//           'https://as2.ftcdn.net/v2/jpg/02/15/84/43/1000_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg'});

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     email = json['email'];
//     phone = json['phone'];
//     formattedPhone = json['formatted_phone'];
//     carrierCode = json['carrier_code'];
//     defaultCountry = json['default_country'];
//     profileImage = json['profile_image'];
//     balance = json['balance'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     profileSrc = json['profile_src'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['first_name'] = this.firstName;
//     data['last_name'] = this.lastName;
//     data['email'] = this.email;
//     data['phone'] = this.phone;
//     data['formatted_phone'] = this.formattedPhone;
//     data['carrier_code'] = this.carrierCode;
//     data['default_country'] = this.defaultCountry;
//     data['profile_image'] = this.profileImage;
//     data['balance'] = this.balance;
//     data['status'] = this.status;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['profile_src'] = this.profileSrc;
//     return data;
//   }
// }

// ignore_for_file: prefer_typing_uninitialized_variables

class User_model {
  bool? status;
  String? message;
  int? totalBookingCount;
  Data? data;
  UserDetails? userDetails;
  String? accessToken;
  String? tokenType;

  User_model({
    this.status,
    this.message,
    this.data,
    this.userDetails,
    this.accessToken,
    this.tokenType,
    this.totalBookingCount,
  });

  User_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    totalBookingCount = json['total_booking_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (userDetails != null) {
      data['user_details'] = userDetails!.toJson();
    }
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['total_booking_count'] = totalBookingCount;
    return data;
  }
}

class Data {
  int? id;
  String? userStatus;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? formattedPhone;
  String? carrierCode;
  String? defaultCountry;
  String? address;
  String? address2;
  var countryId;
  var stateId;
  var cityId;
  var pincode;
  String? countyName;
  String? stateName;
  String? cityName;
  String? profileImage;
  var balance;
  var totalPenalty;
  var totalPendingPenalty;
  var totalRecoverPenalty;
  String? rzContactId;
  String? rzFundAccount;
  String? status;
  var sponserCode;
  String? referralCode;
  var userProMember;
  var userAgent;
  var userHost;
  var agentRequest;
  var hostRequest;
  var promemberRequest;
  var isAgent;
  var isGst;
  String? createdAt;
  String? updatedAt;
  var isDelete;
  String? oauthProvider;
  String? oauthUid;
  String? deviceToken;
  String? fcmToken;
  int? totalRecivedAmount;
  var totalPendingAmount;
  int? totalProperty;
  int? totalListed;
  int? totalPending;
  int? totalReservation;
  String? kycStatus;
  String? kycHost;
  String? profileSrc;

  Data({
    this.id,
    this.userStatus,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.formattedPhone,
    this.carrierCode,
    this.defaultCountry,
    this.address,
    this.address2,
    this.countryId,
    this.stateId,
    this.cityId,
    this.pincode,
    this.profileImage,
    this.balance,
    this.totalPenalty,
    this.totalPendingPenalty,
    this.totalRecoverPenalty,
    this.rzContactId,
    this.rzFundAccount,
    this.status,
    this.sponserCode,
    this.referralCode,
    this.userProMember,
    this.userAgent,
    this.userHost,
    this.agentRequest,
    this.hostRequest,
    this.promemberRequest,
    this.isAgent,
    this.isGst,
    this.createdAt,
    this.updatedAt,
    this.isDelete,
    this.oauthProvider,
    this.oauthUid,
    this.deviceToken,
    this.fcmToken,
    this.totalRecivedAmount,
    this.totalPendingAmount,
    this.totalProperty,
    this.totalListed,
    this.totalPending,
    this.totalReservation,
    this.kycStatus,
    this.kycHost,
    this.profileSrc,
    this.cityName,
    this.countyName,
    this.stateName,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userStatus = json['user_status'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    formattedPhone = json['formatted_phone'];
    carrierCode = json['carrier_code'];
    defaultCountry = json['default_country'];
    address = json['address'];
    address2 = json['address_2'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    pincode = json['pincode'];
    profileImage = json['profile_image'];
    balance = json['balance'];
    totalPenalty = json['total_penalty'];
    totalPendingPenalty = json['total_pending_penalty'];
    totalRecoverPenalty = json['total_recover_penalty'];
    rzContactId = json['rz_contact_id'];
    rzFundAccount = json['rz_fund_account'];
    status = json['status'];
    sponserCode = json['sponser_code'];
    referralCode = json['referral_code'];
    userProMember = json['user_pro_member'];
    userAgent = json['user_agent'];
    userHost = json['user_host'];
    agentRequest = json['agent_request'];
    hostRequest = json['host_request'];
    promemberRequest = json['promember_request'];
    isAgent = json['is_agent'];
    isGst = json['is_gst'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDelete = json['is_delete'];
    oauthProvider = json['oauth_provider'];
    oauthUid = json['oauth_uid'];
    deviceToken = json['device_token'];
    fcmToken = json['fcm_token'];
    totalRecivedAmount = json['total_recived_amount'];
    totalPendingAmount = json['total_pending_amount'];
    totalProperty = json['total_property'];
    totalListed = json['total_listed'];
    totalPending = json['total_pending'];
    totalReservation = json['total_reservation'];
    kycStatus = json['kyc_status'];
    kycHost = json['kyc_host'];
    profileSrc = json['profile_src'];
    countyName = json['country_name'];
    stateName = json['state_name'];
    cityName = json['city_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_status'] = userStatus;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['formatted_phone'] = formattedPhone;
    data['carrier_code'] = carrierCode;
    data['default_country'] = defaultCountry;
    data['address'] = address;
    data['address_2'] = address2;
    data['country_id'] = countryId;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['pincode'] = pincode;
    data['profile_image'] = profileImage;
    data['balance'] = balance;
    data['total_penalty'] = totalPenalty;
    data['total_pending_penalty'] = totalPendingPenalty;
    data['total_recover_penalty'] = totalRecoverPenalty;
    data['rz_contact_id'] = rzContactId;
    data['rz_fund_account'] = rzFundAccount;
    data['status'] = status;
    data['sponser_code'] = sponserCode;
    data['referral_code'] = referralCode;
    data['user_pro_member'] = userProMember;
    data['user_agent'] = userAgent;
    data['user_host'] = userHost;
    data['agent_request'] = agentRequest;
    data['host_request'] = hostRequest;
    data['promember_request'] = promemberRequest;
    data['is_agent'] = isAgent;
    data['is_gst'] = isGst;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_delete'] = isDelete;
    data['oauth_provider'] = oauthProvider;
    data['oauth_uid'] = oauthUid;
    data['device_token'] = deviceToken;
    data['fcm_token'] = fcmToken;
    data['total_recived_amount'] = totalRecivedAmount;
    data['total_pending_amount'] = totalPendingAmount;
    data['total_property'] = totalProperty;
    data['total_listed'] = totalListed;
    data['total_pending'] = totalPending;
    data['total_reservation'] = totalReservation;
    data['kyc_status'] = kycStatus;
    data['kyc_host'] = kycHost;
    data['profile_src'] = profileSrc;
    data['city_name'] = cityName;
    data['state_name'] = stateName;
    data['country_name'] = countyName;
    return data;
  }
}

class UserDetails {
  String? dateOfBirth;
  String? about;
  String? gender;

  UserDetails({this.dateOfBirth, this.about, this.gender});

  UserDetails.fromJson(Map<String, dynamic> json) {
    dateOfBirth = json['date_of_birth'];
    about = json['about'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date_of_birth'] = dateOfBirth;
    data['about'] = about;
    data['gender'] = gender;
    return data;
  }
}
