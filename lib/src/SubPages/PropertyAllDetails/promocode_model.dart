class PromocodeModel {
  int? id;
  String? title;
  String? code;
  String? promoCodeType;
  int? codeAmount;
  String? validFrom;
  String? validTill;
  String? promoCodeContent;
  int? useLimite;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? availability;

  // Fields for new coupon_list API shape
  String? coupon_name;
  String? discount_type;
  String? discount_value;
  String? batch_id;
  String? is_all;
  String? is_used;
  String? type; // 'promocode' or 'coupon'

  PromocodeModel(
      {this.id,
      this.title,
      this.code,
      this.promoCodeType,
      this.codeAmount,
      this.validFrom,
      this.validTill,
      this.promoCodeContent,
      this.useLimite,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.availability,
      this.coupon_name,
      this.discount_type,
      this.discount_value,
      this.batch_id,
      this.is_all,
      this.is_used,
      this.type});

  PromocodeModel.fromJson(Map<String, dynamic> json) {
    // New coupon_list shape with nested "coupon" object
    if (json['coupon'] != null && json['coupon'] is Map<String, dynamic>) {
      final c = json['coupon'] as Map<String, dynamic>;

      // Outer user-coupon fields
      id = json['id'];
      is_all = json['is_all']?.toString();
      is_used = json['is_used']?.toString();

      // Nested coupon fields
      batch_id = c['batch_id']?.toString();
      coupon_name = c['coupon_name']?.toString();
      code = c['coupon_code']?.toString();
      discount_type = c['discount_type']?.toString();
      discount_value = c['discount_value']?.toString();

      // Map into existing generic fields so old UI still works
      promoCodeType = discount_type;
      final dv = c['discount_value'];
      if (dv is num) {
        codeAmount = dv.toInt();
      } else if (dv is String) {
        codeAmount = int.tryParse(dv);
      }

      validTill = c['expiry_date']?.toString();
      validFrom = DateTime.now().toString().split(' ')[0]; // Current date as valid_from
      createdAt = c['created_at']?.toString();
      updatedAt = c['updated_at']?.toString();
    } else {
      // Original promo-code API shape or new coupon type without nested coupon object
      id = json['id'];
      title = json['title'] ?? json['coupon_name'];
      code = json['code'] ?? json['coupon_code'];
      promoCodeType = json['promo_code_type'] ?? json['discount_type'];
      codeAmount = json['code_amount'] ?? int.tryParse(json['discount_value']?.toString() ?? '');
      
      // Handle valid_from and valid_till
      if (json['valid_from'] != null) {
        validFrom = json['valid_from'];
      } else {
        // Set current date in yyyy-MM-dd format
        final now = DateTime.now();
        validFrom = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      }
      
      if (json['valid_till'] != null) {
        validTill = json['valid_till'];
      } else if (json['expiry_date'] != null) {
        // Convert expiry_date to yyyy-MM-dd format
        final expiryStr = json['expiry_date'].toString();
        if (expiryStr.contains('T')) {
          validTill = expiryStr.split('T')[0];
        } else {
          validTill = expiryStr;
        }
      }
      
      promoCodeContent = json['promo_code_content'];
      useLimite = json['use_limite'];
      status = json['status'];
      createdAt = json['created_at'];
      updatedAt = json['updated_at'];
      availability = json['availability']?.toString();
      
      // Additional fields for coupon type
      batch_id = json['batch_id']?.toString();
      coupon_name = json['coupon_name']?.toString();
      discount_type = json['discount_type']?.toString();
      discount_value = json['discount_value']?.toString();
      type = json['type']?.toString();
    }
  }

  /// Returns the discount symbol based on type and discount_type/promo_code_type
  String get discountSymbol {
    if (type == 'coupon') {
      // For coupon: flat = ₹, otherwise %
      return (discount_type?.toLowerCase() == 'flat') ? '₹' : '%';
    } else {
      // For promocode: INR = ₹, otherwise %
      return (promoCodeType?.toUpperCase() == 'INR') ? '₹' : '%';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['code'] = code;
    data['promo_code_type'] = promoCodeType;
    data['code_amount'] = codeAmount;
    data['valid_from'] = validFrom;
    data['valid_till'] = validTill;
    data['promo_code_content'] = promoCodeContent;
    data['use_limite'] = useLimite;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['availability'] = availability;

    data['coupon_name'] = coupon_name;
    data['discount_type'] = discount_type;
    data['discount_value'] = discount_value;
    data['batch_id'] = batch_id;
    data['is_all'] = is_all;
    data['is_used'] = is_used;
    return data;
  }
}
