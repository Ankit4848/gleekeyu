// ignore_for_file: prefer_typing_uninitialized_variables

class PropertyAllDetails_model {
  var status;
  var message;
  Data? data;

  PropertyAllDetails_model({this.status, this.message, this.data});

  PropertyAllDetails_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  var propertySlug;
  Result? result;
  var propertyId;
  var bookingStatus;
  List<PropertyPhotos>? propertyPhotos;
  int? bookingCount;
  var amenities;
  var safetyAmenities;
  var checkin;
  var checkout;
  var guests;
  var title;
  var symbol;
  var shareLink;

  var dateFormat;
  List<HouseRules>? houseRules;
  List<CustomHouseRules>? customHouseRules;
  var reviewsFromGuests;

  Data(
      {this.propertySlug,
      this.result,
      this.propertyId,
      this.bookingStatus,
      this.propertyPhotos,
      this.amenities,
      this.safetyAmenities,
      this.checkin,
      this.checkout,
      this.guests,
      this.title,
      this.symbol,
      this.bookingCount,
      this.shareLink,
      this.dateFormat,
      this.houseRules,
      this.customHouseRules,
      this.reviewsFromGuests});

  Data.fromJson(Map<String, dynamic> json) {
    propertySlug = json['property_slug'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
    propertyId = json['property_id'];
    bookingStatus = json['booking_status'];
    if (json['property_photos'] != null) {
      propertyPhotos = <PropertyPhotos>[];
      json['property_photos'].forEach((v) {
        propertyPhotos!.add(PropertyPhotos.fromJson(v));
      });
    }
    amenities = json['amenities'];
    bookingCount = json['booking_count'];
    safetyAmenities = json['safety_amenities'];

    checkin = json['checkin'];

    checkout = json['checkout'];
    guests = json['guests'];
    title = json['title'];
    symbol = json['symbol'];
    shareLink = json['shareLink'];
    dateFormat = json['date_format'];
    if (json['house_rules'] != null) {
      houseRules = <HouseRules>[];
      json['house_rules'].forEach((v) {
        houseRules!.add(HouseRules.fromJson(v));
      });
    }
    if (json['custom_house_rules'] != null) {
      customHouseRules = <CustomHouseRules>[];
      json['custom_house_rules'].forEach((v) {
        customHouseRules!.add(CustomHouseRules.fromJson(v));
      });
    }
    reviewsFromGuests = json['reviews_from_guests'];
  }
}

class Result {
  var id;
  var propertyName;
  var propertyCategory;
  var isInquirySend;
  var agentId;
  var name;
  var slug;
  var urlName;
  var hostId;
  var bedrooms;
  var beds;
  var noOfDiscountBooking;
  var bedType;
  var bathrooms;
  var guest;
  var extraMattress;
  var livingRooms;
  var kitchen;
  var totalBooking;
  var amenities;
  var propertyType;
  var spaceType;
  var accommodates;
  var bookingType;
  var cancellation;
  var status;
  var recomended;
  var squareFeet;
  var constructedSquareFeet;
  var stayTiming;
  var verifiedProperty;
  var isAgree;
  var viewCount;
  var ownerNumber;
  var careTakerNumber;
  var emergencyNumber;
  var isOwnerNumber;
  var isCareTakerNumber;
  var isEmergencyNumber;
  var isFirstBooking;
  var isOtherWebsite;
  var otherWebsite;
  var otherWebsiteName;
  var nameOtherWebsite;
  var adminHouseRule;
  var deletedAt;
  var createdAt;
  var updatedAt;
  var isApprove;
  var propertyRejectNote;
  var stepsCompleted;
  var spaceTypeName;
  var propertyTypeName;
  var propertyPhoto;
  var hostName;
  var bookMark;
  var nightExtraMattress;
  var reviewsCount;
  var overallRating;
  var coverPhoto;
  var avgRating;
  var accuracyAvgRating;
  var checkinAvgRating;
  var propertyExperienceAvgRating;
  var propertyCommunicationAvgRating;
  var locationAvgRating;
  var communicationAvgRating;
  var cleanlinessAvgRating;
  var valueAvgRating;
  Users? users;
  PropertyDescription? propertyDescription;
  PropertyPrice? propertyPrice;
  PropertyAddress? propertyAddress;

  Result(
      {this.id,
      this.propertyName,
      this.propertyCategory,
      this.isInquirySend,
      this.agentId,
      this.accuracyAvgRating,
      this.cleanlinessAvgRating,
      this.checkinAvgRating,
      this.propertyExperienceAvgRating,
      this.propertyCommunicationAvgRating,
      this.locationAvgRating,
      this.communicationAvgRating,
      this.valueAvgRating,
      this.name,
      this.slug,
      this.urlName,
      this.hostId,
      this.bedrooms,
      this.noOfDiscountBooking,
      this.beds,
      this.bedType,
      this.bathrooms,
      this.guest,
      this.extraMattress,
      this.livingRooms,
      this.kitchen,
      this.amenities,
      this.propertyType,
      this.spaceType,
      this.accommodates,
      this.bookingType,
      this.cancellation,
      this.status,
      this.recomended,
      this.squareFeet,
      this.totalBooking,
      this.constructedSquareFeet,
      this.stayTiming,
      this.verifiedProperty,
      this.isAgree,
      this.viewCount,
      this.ownerNumber,
      this.careTakerNumber,
      this.emergencyNumber,
      this.isOwnerNumber,
      this.isCareTakerNumber,
      this.isEmergencyNumber,
      this.isFirstBooking,
      this.isOtherWebsite,
      this.otherWebsite,
      this.otherWebsiteName,
      this.nameOtherWebsite,
      this.adminHouseRule,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.isApprove,
      this.propertyRejectNote,
      this.stepsCompleted,
      this.spaceTypeName,
      this.propertyTypeName,
      this.propertyPhoto,
      this.hostName,
      this.bookMark,
      this.nightExtraMattress,
      this.reviewsCount,
      this.overallRating,
      this.coverPhoto,
      this.avgRating,
      this.users,
      this.propertyDescription,
      this.propertyPrice,
      this.propertyAddress});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyName = json['property_name'];
    propertyCategory = json['property_category'];
    isInquirySend = json['is_inquiry_send'];
    agentId = json['agent_id'];
    name = json['name'];
    slug = json['slug'];
    urlName = json['url_name'];
    hostId = json['host_id'];
    bedrooms = json['bedrooms'];
    beds = json['beds'];
    bedType = json['bed_type'];
    bathrooms = json['bathrooms'];
    guest = json['guest'];
    extraMattress = json['extra_mattress'];
    nightExtraMattress = json['night_extra_charge'];
    livingRooms = json['living_rooms'];
    kitchen = json['kitchen'];
    amenities = json['amenities'];
    propertyType = json['property_type'];
    spaceType = json['space_type'];
    totalBooking = json['total_bookings'];
    accommodates = json['accommodates'];
    bookingType = json['booking_type'];
    noOfDiscountBooking = json['no_of_discount_bookings'];
    cancellation = json['cancellation'];
    status = json['status'];
    recomended = json['recomended'];
    squareFeet = json['square_feet'];
    constructedSquareFeet = json['constructed_square_feet'];
    stayTiming = json['stay_timing'];
    verifiedProperty = json['verified_property'];
    isAgree = json['is_agree'];
    viewCount = json['view_count'];
    ownerNumber = json['owner_number'];
    careTakerNumber = json['care_taker_number'];
    emergencyNumber = json['emergency_number'];
    isOwnerNumber = json['is_owner_number'];
    isCareTakerNumber = json['is_care_taker_number'];
    isEmergencyNumber = json['is_emergency_number'];
    isFirstBooking = json['is_first_booking'];
    isOtherWebsite = json['is_other_website'];
    otherWebsite = json['other_website'];
    otherWebsiteName = json['other_website_name'];
    nameOtherWebsite = json['name_other_website'];
    adminHouseRule = json['admin_house_rule'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isApprove = json['is_approve'];
    propertyRejectNote = json['property_reject_note'];
    stepsCompleted = json['steps_completed'];
    spaceTypeName = json['space_type_name'];
    propertyTypeName = json['property_type_name'];
    propertyPhoto = json['property_photo'];
    hostName = json['host_name'];
    bookMark = json['book_mark'];
    reviewsCount = json['reviews_count'];
    overallRating = json['overall_rating'];
    coverPhoto = json['cover_photo'];
    avgRating = json['avg_rating'];
    accuracyAvgRating = json['accuracy_avg_rating'];
    locationAvgRating = json['location_avg_rating'];
    communicationAvgRating = json['communication_avg_rating'];
    checkinAvgRating = json['checkin_avg_rating'];
    propertyExperienceAvgRating = json['property_experience_avg_rating'];
    propertyCommunicationAvgRating = json['property_communication_avg_rating'];
    cleanlinessAvgRating = json['cleanliness_avg_rating'];
    valueAvgRating = json['value_avg_rating'];
    users = json['users'] != null ? Users.fromJson(json['users']) : null;
    propertyDescription = json['property_description'] != null
        ? PropertyDescription.fromJson(json['property_description'])
        : null;
    propertyPrice = json['property_price'] != null
        ? PropertyPrice.fromJson(json['property_price'])
        : null;
    propertyAddress = json['property_address'] != null
        ? PropertyAddress.fromJson(json['property_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['property_name'] = propertyName;
    data['property_category'] = propertyCategory;
    data['is_inquiry_send'] = isInquirySend;
    data['agent_id'] = agentId;
    data['name'] = name;
    data['slug'] = slug;
    data['url_name'] = urlName;
    data['host_id'] = hostId;
    data['total_bookings'] = totalBooking;
    data['bedrooms'] = bedrooms;
    data['beds'] = beds;
    data['bed_type'] = bedType;
    data['bathrooms'] = bathrooms;
    data['guest'] = guest;
    data['extra_mattress'] = extraMattress;
    data['night_extra_charge'] = nightExtraMattress;
    data['living_rooms'] = livingRooms;
    data['kitchen'] = kitchen;
    data['amenities'] = amenities;
    data['property_type'] = propertyType;
    data['no_of_discount_bookings'] = noOfDiscountBooking;
    data['space_type'] = spaceType;
    data['accommodates'] = accommodates;
    data['booking_type'] = bookingType;
    data['cancellation'] = cancellation;
    data['status'] = status;
    data['recomended'] = recomended;
    data['square_feet'] = squareFeet;
    data['constructed_square_feet'] = constructedSquareFeet;
    data['stay_timing'] = stayTiming;
    data['verified_property'] = verifiedProperty;
    data['is_agree'] = isAgree;
    data['view_count'] = viewCount;
    data['owner_number'] = ownerNumber;
    data['care_taker_number'] = careTakerNumber;
    data['emergency_number'] = emergencyNumber;
    data['is_owner_number'] = isOwnerNumber;
    data['is_care_taker_number'] = isCareTakerNumber;
    data['is_emergency_number'] = isEmergencyNumber;
    data['is_first_booking'] = isFirstBooking;
    data['is_other_website'] = isOtherWebsite;
    data['other_website'] = otherWebsite;
    data['other_website_name'] = otherWebsiteName;
    data['name_other_website'] = nameOtherWebsite;
    data['admin_house_rule'] = adminHouseRule;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_approve'] = isApprove;
    data['property_reject_note'] = propertyRejectNote;
    data['steps_completed'] = stepsCompleted;
    data['space_type_name'] = spaceTypeName;
    data['property_type_name'] = propertyTypeName;
    data['property_photo'] = propertyPhoto;
    data['host_name'] = hostName;
    data['book_mark'] = bookMark;
    data['reviews_count'] = reviewsCount;
    data['overall_rating'] = overallRating;
    data['cover_photo'] = coverPhoto;
    data['avg_rating'] = avgRating;
    data['accuracy_avg_rating'] = accuracyAvgRating;
    data['location_avg_rating'] = locationAvgRating;
    data['communication_avg_rating'] = communicationAvgRating;
    data['checkin_avg_rating'] = checkinAvgRating;
    data['property_experience_avg_rating'] = propertyExperienceAvgRating;
    data['property_communication_avg_rating'] = propertyCommunicationAvgRating;

    data['cleanliness_avg_rating'] = cleanlinessAvgRating;
    data['value_avg_rating'] = valueAvgRating;
    if (users != null) {
      data['users'] = users!.toJson();
    }
    if (propertyDescription != null) {
      data['property_description'] = propertyDescription!.toJson();
    }
    if (propertyPrice != null) {
      data['property_price'] = propertyPrice!.toJson();
    }
    if (propertyAddress != null) {
      data['property_address'] = propertyAddress!.toJson();
    }
    return data;
  }
}

class Users {
  var id;
  var firstName;
  var lastName;
  var email;
  var phone;
  var formattedPhone;
  var carrierCode;
  var defaultCountry;
  var address;
  var address2;
  var countryId;
  var stateId;
  var cityId;
  var pincode;
  var profileImage;
  var balance;
  var status;
  var sponserCode;
  var referralCode;
  var userProMember;
  var userAgent;
  var userHost;
  var agentRequest;
  var hostRequest;
  var promemberRequest;
  var isAgent;
  var isGst;
  var createdAt;
  var updatedAt;
  var profileSrc;

  Users(
      {this.id,
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
      this.profileSrc});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    profileSrc = json['profile_src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
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
    data['profile_src'] = profileSrc;
    return data;
  }
}

class PropertyDescription {
  var id;
  var propertyId;
  var summary;
  var houseRulesPolicy;
  var placeIsGreatFor;
  var aboutPlace;
  var guestCanAccess;
  var interactionGuests;
  var other;
  var aboutNeighborhood;
  var getAround;

  PropertyDescription(
      {this.id,
      this.propertyId,
      this.summary,
      this.houseRulesPolicy,
      this.placeIsGreatFor,
      this.aboutPlace,
      this.guestCanAccess,
      this.interactionGuests,
      this.other,
      this.aboutNeighborhood,
      this.getAround});

  PropertyDescription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    summary = json['summary'];
    houseRulesPolicy = json['house_rules_policy'];
    placeIsGreatFor = json['place_is_great_for'];
    aboutPlace = json['about_place'];
    guestCanAccess = json['guest_can_access'];
    interactionGuests = json['interaction_guests'];
    other = json['other'];
    aboutNeighborhood = json['about_neighborhood'];
    getAround = json['get_around'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['property_id'] = propertyId;
    data['summary'] = summary;
    data['house_rules_policy'] = houseRulesPolicy;
    data['place_is_great_for'] = placeIsGreatFor;
    data['about_place'] = aboutPlace;
    data['guest_can_access'] = guestCanAccess;
    data['interaction_guests'] = interactionGuests;
    data['other'] = other;
    data['about_neighborhood'] = aboutNeighborhood;
    data['get_around'] = getAround;
    return data;
  }
}

class PropertyPrice {
  var id;
  var propertyId;
  var cleaningFee;
  var guestAfter;
  var guestFee;
  var securityFee;
  var discountPrice;
  var price;
  var weekendPrice;
  var weeklyDiscount;
  var monthlyDiscount;
  var currencyCode;
  var originalCleaningFee;
  var originalGuestFee;
  var originalPrice;
  var originalWeekendPrice;
  var originalSecurityFee;
  var defaultCode;
  var defaultSymbol;
  var discountAmount;

  PropertyPrice(
      {this.id,
      this.propertyId,
      this.cleaningFee,
      this.guestAfter,
      this.guestFee,
      this.securityFee,
      this.discountPrice,
      this.price,
      this.weekendPrice,
      this.weeklyDiscount,
      this.monthlyDiscount,
      this.currencyCode,
      this.originalCleaningFee,
      this.originalGuestFee,
      this.originalPrice,
      this.originalWeekendPrice,
      this.originalSecurityFee,
      this.defaultCode,
      this.discountAmount,
      this.defaultSymbol});

  PropertyPrice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    cleaningFee = json['cleaning_fee'];
    guestAfter = json['guest_after'];
    discountPrice = json['discount_price'];
    guestFee = json['guest_fee'];
    securityFee = json['security_fee'];
    price = json['price'];
    weekendPrice = json['weekend_price'];
    weeklyDiscount = json['weekly_discount'];
    monthlyDiscount = json['monthly_discount'];
    currencyCode = json['currency_code'];
    originalCleaningFee = json['original_cleaning_fee'];
    originalGuestFee = json['original_guest_fee'];
    originalPrice = json['original_price'];
    originalWeekendPrice = json['original_weekend_price'];
    originalSecurityFee = json['original_security_fee'];
    defaultCode = json['default_code'];
    discountAmount = json['discount_amt'];
    defaultSymbol = json['default_symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['property_id'] = propertyId;
    data['cleaning_fee'] = cleaningFee;
    data['guest_after'] = guestAfter;
    data['guest_fee'] = guestFee;
    data['security_fee'] = securityFee;
    data['discount_amt'] = discountAmount;
    data['price'] = price;
    data['weekend_price'] = weekendPrice;
    data['weekly_discount'] = weeklyDiscount;
    data['monthly_discount'] = monthlyDiscount;
    data['discount_price'] = discountPrice;
    data['currency_code'] = currencyCode;
    data['original_cleaning_fee'] = originalCleaningFee;
    data['original_guest_fee'] = originalGuestFee;
    data['original_price'] = originalPrice;
    data['original_weekend_price'] = originalWeekendPrice;
    data['original_security_fee'] = originalSecurityFee;
    data['default_code'] = defaultCode;
    data['default_symbol'] = defaultSymbol;
    return data;
  }
}

class PropertyAddress {
  var id;
  var propertyId;
  var addressLine1;
  var addressLine2;
  var latitude;
  var longitude;
  var city;
  var state;
  var country;
  var postalCode;

  PropertyAddress(
      {this.id,
      this.propertyId,
      this.addressLine1,
      this.addressLine2,
      this.latitude,
      this.longitude,
      this.city,
      this.state,
      this.country,
      this.postalCode});

  PropertyAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postalCode = json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['property_id'] = propertyId;
    data['address_line_1'] = addressLine1;
    data['address_line_2'] = addressLine2;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['postal_code'] = postalCode;
    return data;
  }
}

class PropertyPhotos {
  var id;
  var image;
  var message;

  PropertyPhotos({this.id, this.image, this.message});

  PropertyPhotos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['image'] = image;
    data['message'] = message;
    return data;
  }
}

class HouseRules {
  var id;
  var userId;
  var propertyId;
  var checkInTime;
  var checkOutTime;
  var guestAllowed;
  var petFriendly;
  var poolTime;
  var poolOpenTime;
  var poolCloseTime;
  var loudMusicTime;
  var loudMusicOpenTime;
  var loudMusicCloseTime;
  var foodAllowed;
  var isAlcoholAllowed;
  var alcoholAllowedSide;
  var isSmokingAllowed;
  var smokingAllowed;
  var title;
  var status;
  var isRole;
  var image;
  var createdAt;
  var updatedAt;

  HouseRules(
      {this.id,
      this.userId,
      this.propertyId,
      this.checkInTime,
      this.checkOutTime,
      this.guestAllowed,
      this.petFriendly,
      this.poolTime,
      this.poolOpenTime,
      this.poolCloseTime,
      this.loudMusicTime,
      this.loudMusicOpenTime,
      this.loudMusicCloseTime,
      this.foodAllowed,
      this.isAlcoholAllowed,
      this.alcoholAllowedSide,
      this.isSmokingAllowed,
      this.smokingAllowed,
      this.title,
      this.status,
      this.isRole,
      this.image,
      this.createdAt,
      this.updatedAt});

  HouseRules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    propertyId = json['property_id'];
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    guestAllowed = json['guest_allowed'];
    petFriendly = json['pet_friendly'];
    poolTime = json['pool_time'];
    poolOpenTime = json['pool_open_time'];
    poolCloseTime = json['pool_close_time'];
    loudMusicTime = json['loud_music_time'];
    loudMusicOpenTime = json['loud_music_open_time'];
    loudMusicCloseTime = json['loud_music_close_time'];
    foodAllowed = json['food_allowed'];
    isAlcoholAllowed = json['is_alcohol_allowed'];
    alcoholAllowedSide = json['alcohol_allowed_side'];
    isSmokingAllowed = json['is_smoking_allowed'];
    smokingAllowed = json['smoking_allowed'];
    title = json['title'];
    status = json['status'];
    isRole = json['is_role'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['property_id'] = propertyId;
    data['check_in_time'] = checkInTime;
    data['check_out_time'] = checkOutTime;
    data['guest_allowed'] = guestAllowed;
    data['pet_friendly'] = petFriendly;
    data['pool_time'] = poolTime;
    data['pool_open_time'] = poolOpenTime;
    data['pool_close_time'] = poolCloseTime;
    data['loud_music_time'] = loudMusicTime;
    data['loud_music_open_time'] = loudMusicOpenTime;
    data['loud_music_close_time'] = loudMusicCloseTime;
    data['food_allowed'] = foodAllowed;
    data['is_alcohol_allowed'] = isAlcoholAllowed;
    data['alcohol_allowed_side'] = alcoholAllowedSide;
    data['is_smoking_allowed'] = isSmokingAllowed;
    data['smoking_allowed'] = smokingAllowed;
    data['title'] = title;
    data['status'] = status;
    data['is_role'] = isRole;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class CustomHouseRules {
  var id;
  var userId;
  var propertyId;
  var title;
  var createdAt;
  var updatedAt;

  CustomHouseRules(
      {this.id,
      this.userId,
      this.propertyId,
      this.title,
      this.createdAt,
      this.updatedAt});

  CustomHouseRules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    propertyId = json['property_id'];
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['property_id'] = propertyId;
    data['title'] = title;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}


