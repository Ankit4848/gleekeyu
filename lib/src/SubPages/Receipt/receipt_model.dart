// ignore_for_file: prefer_typing_uninitialized_variables

class Receipt_model {
  var status;
  var message;
  Data? data;

  Receipt_model({this.status, this.message, this.data});

  Receipt_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Booking? booking;
  List<DatePrice>? datePrice;
  var title;
  var additionalTitle;

  Data({this.booking, this.datePrice, this.title, this.additionalTitle});

  Data.fromJson(Map<String, dynamic> json) {
    booking =
        json['booking'] != null ? new Booking.fromJson(json['booking']) : null;
    if (json['date_price'] != null) {
      datePrice = <DatePrice>[];
      json['date_price'].forEach((v) {
        datePrice!.add(new DatePrice.fromJson(v));
      });
    }
    title = json['title'];
    additionalTitle = json['additional_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (booking != null) {
      data['booking'] = booking!.toJson();
    }
    if (datePrice != null) {
      data['date_price'] = datePrice!.map((v) => v.toJson()).toList();
    }
    data['title'] = title;
    data['additional_title'] = additionalTitle;
    return data;
  }
}

class Booking {
  var id;
  var propertyId;
  var code;
  var hostId;
  var userId;
  var startDate;
  var endDate;
  var status;
  var guest;
  var totalNight;
  var perNight;
  var customPriceDates;
  var basePrice;
  var voucherCode;
  var cleaningCharge;
  var guestCharge;
  var serviceCharge;
  var securityMoney;
  var ivaTax;
  var accomodationTax;
  var dateWithPrice;
  var hostFee;
  var couponcode;
  var couponcodeAmount;
  var bookingAmount;
  var total;
  var bookingType;
  var currencyCode;
  var cancellation;
  var transactionId;
  var paymentMethodId;
  var acceptedAt;
  var attachment;
  var bookingLastName;
  var bankId;
  var note;
  var expiredAt;
  var declinedAt;
  var cancelledAt;
  var bookingFirstName;
  var adults;
  var infant;
  var children;
  var cancelledBy;
  var advanceAmount;
  var createdAt;
  var updatedAt;
  var isAgent;
  var hostPayout;
  var labelColor;
  var dateRange;
  var expirationTime;
  ReceiptProperties? properties;

  Booking(
      {this.id,
      this.propertyId,
      this.code,
      this.hostId,
      this.userId,
      this.startDate,
      this.endDate,
      this.status,
      this.children,
      this.guest,
      this.totalNight,
      this.perNight,
      this.adults,
      this.infant,
      this.advanceAmount,
      this.customPriceDates,
      this.basePrice,
      this.cleaningCharge,
      this.guestCharge,
      this.bookingFirstName,
      this.serviceCharge,
      this.voucherCode,
      this.securityMoney,
      this.bookingLastName,
      this.ivaTax,
      this.accomodationTax,
      this.dateWithPrice,
      this.hostFee,
      this.couponcode,
      this.couponcodeAmount,
      this.bookingAmount,
      this.total,
      this.bookingType,
      this.currencyCode,
      this.cancellation,
      this.transactionId,
      this.paymentMethodId,
      this.acceptedAt,
      this.attachment,
      this.bankId,
      this.note,
      this.expiredAt,
      this.declinedAt,
      this.cancelledAt,
      this.cancelledBy,
      this.createdAt,
      this.updatedAt,
      this.isAgent,
      this.hostPayout,
      this.labelColor,
      this.dateRange,
      this.expirationTime,
      this.properties});

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    code = json['code'];
    hostId = json['host_id'];
    userId = json['user_id'];
    startDate = json['start_date'];
    infant = json['infant'];
    children = json['children'];
    endDate = json['end_date'];
    advanceAmount = json['advance_amount'];
    status = json['status'];
    guest = json['guest'];
    totalNight = json['total_night'];
    perNight = json['per_night'];
    bookingFirstName = json['booking_first_name'];
    bookingLastName = json['booking_last_name'];
    customPriceDates = json['custom_price_dates'];
    adults = json['adults'];
    basePrice = json['base_price'];
    cleaningCharge = json['cleaning_charge'];
    guestCharge = json['guest_charge'];
    serviceCharge = json['service_charge'];
    voucherCode = json['voucher_code'];
    securityMoney = json['security_money'];
    ivaTax = json['iva_tax'];
    accomodationTax = json['accomodation_tax'];
    dateWithPrice = json['date_with_price'];
    hostFee = json['host_fee'];
    couponcode = json['couponcode'];
    couponcodeAmount = json['couponcode_amount'];
    bookingAmount = json['booking_amount'];
    total = json['total'];
    bookingType = json['booking_type'];
    currencyCode = json['currency_code'];
    cancellation = json['cancellation'];
    transactionId = json['transaction_id'];
    paymentMethodId = json['payment_method_id'];
    acceptedAt = json['accepted_at'];
    attachment = json['attachment'];
    bankId = json['bank_id'];
    note = json['note'];
    expiredAt = json['expired_at'];
    declinedAt = json['declined_at'];
    cancelledAt = json['cancelled_at'];
    cancelledBy = json['cancelled_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isAgent = json['is_agent'];
    hostPayout = json['host_payout'];
    labelColor = json['label_color'];
    dateRange = json['date_range'];
    expirationTime = json['expiration_time'];
    properties = json['properties'] != null
        ? new ReceiptProperties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['property_id'] = propertyId;
    data['code'] = code;
    data['host_id'] = hostId;
    data['user_id'] = userId;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['children'] = children;
    data['status'] = status;
    data['guest'] = guest;
    data['total_night'] = totalNight;
    data['per_night'] = perNight;
    data['custom_price_dates'] = customPriceDates;
    data['base_price'] = basePrice;
    data['advance_amount'] = advanceAmount;
    data['infant'] = infant;
    data['cleaning_charge'] = cleaningCharge;
    data['voucher_code'] = voucherCode;
    data['guest_charge'] = guestCharge;
    data['service_charge'] = serviceCharge;
    data['adults'] = adults;
    data['booking_first_name'] = bookingFirstName;
    data['booking_last_name'] = bookingLastName;
    data['security_money'] = securityMoney;
    data['iva_tax'] = ivaTax;
    data['accomodation_tax'] = accomodationTax;
    data['date_with_price'] = dateWithPrice;
    data['host_fee'] = hostFee;
    data['couponcode'] = couponcode;
    data['couponcode_amount'] = couponcodeAmount;
    data['booking_amount'] = bookingAmount;
    data['total'] = total;
    data['booking_type'] = bookingType;
    data['currency_code'] = currencyCode;
    data['cancellation'] = cancellation;
    data['transaction_id'] = transactionId;
    data['payment_method_id'] = paymentMethodId;
    data['accepted_at'] = acceptedAt;
    data['attachment'] = attachment;
    data['bank_id'] = bankId;
    data['note'] = note;
    data['expired_at'] = expiredAt;
    data['declined_at'] = declinedAt;
    data['cancelled_at'] = cancelledAt;
    data['cancelled_by'] = cancelledBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_agent'] = isAgent;
    data['host_payout'] = hostPayout;
    data['label_color'] = labelColor;
    data['date_range'] = dateRange;
    data['expiration_time'] = expirationTime;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    return data;
  }
}

class ReceiptProperties {
  var id;
  var agentId;
  var name;
  var slug;
  var urlName;
  var hostId;
  var bedrooms;
  var beds;
  var bedType;
  var bathrooms;
  var guest;
  var extraMattress;
  var livingRooms;
  var kitchen;
  var amenities;
  var propertyType;
  var spaceType;
  var accommodates;
  var bookingType;
  var propertyName;
  var cancellation;
  var status;
  var recomended;
  var squareFeet;
  var constructedSquareFeet;
  var stayTiming;
  var verifiedProperty;
  var isAgree;
  var viewCount;
  var deletedAt;
  var createdAt;
  var updatedAt;
  var isApprove;
  var stepsCompleted;
  var spaceTypeName;
  var propertyTypeName;
  var propertyPhoto;
  var hostName;
  var bookMark;
  var reviewsCount;
  var overallRating;
  var coverPhoto;
  var avgRating;

  ReceiptProperties(
      {this.id,
      this.agentId,
      this.name,
      this.slug,
      this.urlName,
      this.hostId,
      this.bedrooms,
      this.propertyName,
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
      this.constructedSquareFeet,
      this.stayTiming,
      this.verifiedProperty,
      this.isAgree,
      this.viewCount,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.isApprove,
      this.stepsCompleted,
      this.spaceTypeName,
      this.propertyTypeName,
      this.propertyPhoto,
      this.hostName,
      this.bookMark,
      this.reviewsCount,
      this.overallRating,
      this.coverPhoto,
      this.avgRating});

  ReceiptProperties.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    agentId = json['agent_id'];
    name = json['name'];
    slug = json['slug'];
    urlName = json['url_name'];
    propertyName = json['property_name'];
    hostId = json['host_id'];
    bedrooms = json['bedrooms'];
    beds = json['beds'];
    bedType = json['bed_type'];
    bathrooms = json['bathrooms'];
    guest = json['guest'];
    extraMattress = json['extra_mattress'];
    livingRooms = json['living_rooms'];
    kitchen = json['kitchen'];
    amenities = json['amenities'];
    propertyType = json['property_type'];
    spaceType = json['space_type'];
    accommodates = json['accommodates'];
    bookingType = json['booking_type'];
    cancellation = json['cancellation'];
    status = json['status'];
    recomended = json['recomended'];
    squareFeet = json['square_feet'];
    constructedSquareFeet = json['constructed_square_feet'];
    stayTiming = json['stay_timing'];
    verifiedProperty = json['verified_property'];
    isAgree = json['is_agree'];
    viewCount = json['view_count'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isApprove = json['is_approve'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['agent_id'] = agentId;
    data['name'] = name;
    data['slug'] = slug;
    data['url_name'] = urlName;
    data['host_id'] = hostId;
    data['bedrooms'] = bedrooms;
    data['beds'] = beds;
    data['bed_type'] = bedType;
    data['bathrooms'] = bathrooms;
    data['guest'] = guest;
    data['extra_mattress'] = extraMattress;
    data['living_rooms'] = livingRooms;
    data['kitchen'] = kitchen;
    data['amenities'] = amenities;
    data['property_type'] = propertyType;
    data['space_type'] = spaceType;
    data['accommodates'] = accommodates;
    data['booking_type'] = bookingType;
    data['property_name'] = propertyName;
    data['cancellation'] = cancellation;
    data['status'] = status;
    data['recomended'] = recomended;
    data['square_feet'] = squareFeet;
    data['constructed_square_feet'] = constructedSquareFeet;
    data['stay_timing'] = stayTiming;
    data['verified_property'] = verifiedProperty;
    data['is_agree'] = isAgree;
    data['view_count'] = viewCount;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_approve'] = isApprove;
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
    return data;
  }
}

class DatePrice {
  var price;
  var date;
  var perDayTax;
  var ivataxGstPer;
  var discount;
  var discountPercentage;
  DatePrice(
      {this.price,
      this.date,
      this.discount,
      this.discountPercentage,
      this.ivataxGstPer,
      this.perDayTax});

  DatePrice.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    date = json['date'];
    perDayTax = json['per_day_tax'];
    ivataxGstPer = json['ivatax_gst_per'];
    discount = json['discount'];
    discountPercentage = json['discount_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['per_day_tax'] = perDayTax;
    data['ivatax_gst_per'] = ivataxGstPer;
    data['discount'] = discount;
    data['discount_percentage'] = discountPercentage;
    data['date'] = date;
    return data;
  }
}
