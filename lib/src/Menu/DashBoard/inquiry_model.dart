class InquiryModel {
  bool? status;
  String? message;
  InquiryModelData? inquiryModelData;

  InquiryModel({this.status, this.message, this.inquiryModelData});

  InquiryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    inquiryModelData = json['data'] != null ?  InquiryModelData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.inquiryModelData != null) {
      data['data'] = this.inquiryModelData!.toJson();
    }
    return data;
  }
}

class InquiryModelData {
  String? inquiryId;
  int? userId;
  String? dateTime;
  String? type;
  String? slug;
  int? propertyId;
  Data? data;

  InquiryModelData(
      {this.inquiryId,
        this.userId,
        this.dateTime,
        this.type,
        this.slug,
        this.propertyId,
        this.data});

  InquiryModelData.fromJson(Map<String, dynamic> json) {
    inquiryId = json['inquiry_id'];
    userId = json['user_id'];
    dateTime = json['date_time'];
    type = json['type'];
    propertyId = json['property_id'];
    slug = json['slug'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inquiry_id'] = this.inquiryId;
    data['user_id'] = this.userId;
    data['date_time'] = this.dateTime;
    data['type'] = this.type;
    data['property_id'] = this.propertyId;
    data['slug'] = this.slug;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? propertyId;
  int? userId;
  int? hostId;
  String? checkIn;
  String? checkOut;
  int? adult;
  int? child;
  int? infant;
  int? totalGuest;
  String? couponCode;
  String? hostOfferDisStatus;
  String? offerDis;
  String? nightPrice;
  String? subTotal;
  String? totalTax;
  String? total;
  String? discountPer;
  String? discountAmt;
  String? status;
  String? isBooked;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.propertyId,
        this.userId,
        this.hostId,
        this.checkIn,
        this.checkOut,
        this.adult,
        this.child,
        this.infant,
        this.totalGuest,
        this.couponCode,
        this.hostOfferDisStatus,
        this.offerDis,
        this.nightPrice,
        this.subTotal,
        this.totalTax,
        this.total,
        this.discountPer,
        this.discountAmt,
        this.status,
        this.isBooked,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    propertyId = json['property_id'];
    userId = json['user_id'];
    hostId = json['host_id'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    adult = json['adult'];
    child = json['child'];
    infant = json['infant'];
    totalGuest = json['total_guest'];
    couponCode = json['coupon_code'];
    hostOfferDisStatus = json['host_offer_dis_status'];
    offerDis = json['offer_dis'];
    nightPrice = json['night_price'];
    subTotal = json['sub_total'];
    totalTax = json['total_tax'];
    total = json['total'];
    discountPer = json['discount_per'];
    discountAmt = json['discount_amt'];
    status = json['status'];
    isBooked = json['is_booked'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_id'] = this.propertyId;
    data['user_id'] = this.userId;
    data['host_id'] = this.hostId;
    data['check_in'] = this.checkIn;
    data['check_out'] = this.checkOut;
    data['adult'] = this.adult;
    data['child'] = this.child;
    data['infant'] = this.infant;
    data['total_guest'] = this.totalGuest;
    data['coupon_code'] = this.couponCode;
    data['host_offer_dis_status'] = this.hostOfferDisStatus;
    data['offer_dis'] = this.offerDis;
    data['night_price'] = this.nightPrice;
    data['sub_total'] = this.subTotal;
    data['total_tax'] = this.totalTax;
    data['total'] = this.total;
    data['discount_per'] = this.discountPer;
    data['discount_amt'] = this.discountAmt;
    data['status'] = this.status;
    data['is_booked'] = this.isBooked;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
