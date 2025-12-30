import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:gleekeyu/src/SubPages/PropertyAllDetails/promocode_model.dart';
import 'package:gleekeyu/utils/baseconstant.dart';

class MyCouponsController extends GetxController {
  bool isLoading = false;
  List<PromocodeModel> coupons = [];
  List<PromocodeModel> filteredCoupons = [];
  TextEditingController searchController = TextEditingController();
  bool initialPopupShown = false;

  @override
  void onInit() {
    super.onInit();
    fetchCoupons();
  }

  Future<void> fetchCoupons() async {
    try {
      isLoading = true;
      update();

      final token = currUser?.accessToken ?? '';
      print('MyCoupons fetchCoupons token: $token');
      print('MyCoupons fetchCoupons Authorization: Bearer $token');

      http.Response response = await http.get(
        Uri.parse(BaseConstant.BASE_URL + EndPoint.couponList),
        headers: {
          'Authorization': 'Bearer ${currUser != null ? currUser?.accessToken : ""}',
        },
      );

      print('coupon_list status: ${response.statusCode}');
      print('coupon_list body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        List<dynamic> rawList;
        if (decoded is List) {
          rawList = decoded;
        } else if (decoded is Map && decoded['data'] is List) {
          rawList = decoded['data'];
        } else if (decoded is Map && decoded['coupons'] is List) {
          rawList = decoded['coupons'];
        } else {
          rawList = [];
        }

        coupons = rawList.map((e) => PromocodeModel.fromJson(e)).toList();
        filteredCoupons = List<PromocodeModel>.from(coupons);
      } else {
        coupons = [];
        filteredCoupons = [];
      }
    } catch (e) {
      coupons = [];
      filteredCoupons = [];
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<bool> addCoupon(String code) async {
    try {
      isLoading = true;
      update();

      final token = currUser?.accessToken ?? '';
      print('MyCoupons addCoupon token: $token');
      print('MyCoupons addCoupon Authorization: Bearer $token');

      final response = await http.post(
        Uri.parse(BaseConstant.BASE_URL + EndPoint.couponAdd),
        headers: {
          'Authorization':
              'Bearer ${currUser != null ? currUser?.accessToken : ""}',
        },
        body: {
          'coupon_code': code,
        },
      );

      if (response.statusCode == 200) {
        await fetchCoupons();
        return true;
      }
    } catch (e) {}

    return false;
  }

  Future<List<dynamic>> fetchCouponProperties(String batchId) async {
    try {
      final token = currUser?.accessToken ?? '';
      print('MyCoupons fetchCouponProperties batchId: $batchId');
      print('MyCoupons fetchCouponProperties token: $token');

      final response = await http.get(
        Uri.parse(
          BaseConstant.BASE_URL + EndPoint.couponProperties + '/$batchId',
        ),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('coupon_properties status: ${response.statusCode}');
      print('coupon_properties body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        // Expecting something like { status, message, data: [...] } or a raw list.
        if (decoded is List) {
          return decoded;
        } else if (decoded is Map && decoded['data'] is List) {
          return List<dynamic>.from(decoded['data']);
        }
      }
    } catch (e) {
      print('fetchCouponProperties error: $e');
    }

    // On error or unexpected response, return empty list so UI can show fallback/dummy data.
    return [];
  }

  void onSearchChanged(String? query) {
    String q = query?.trim().toLowerCase() ?? '';
    if (q.isEmpty) {
      filteredCoupons = List<PromocodeModel>.from(coupons);
    } else {
      filteredCoupons = coupons.where((coupon) {
        final code = (coupon.code ?? '').toLowerCase();
        final title = (coupon.title ?? '').toLowerCase();
        return code.contains(q) || title.contains(q);
      }).toList();
    }
    update();
  }

  List<PromocodeModel> _dummyCoupons() {
    final now = DateTime.now();
    final validFrom = now.toIso8601String();
    final validTill = now.add(const Duration(days: 30)).toIso8601String();

    return [
      PromocodeModel(
        id: 1,
        title: 'Welcome Offer',
        code: 'WELCOME10',
        promoCodeType: 'percentage',
        codeAmount: 10,
        validFrom: validFrom,
        validTill: validTill,
        promoCodeContent: 'Get 10% off on your first booking.',
        useLimite: 1,
        status: 'active',
        availability: '1',
      ),
      PromocodeModel(
        id: 2,
        title: 'Festive Sale',
        code: 'FESTIVE15',
        promoCodeType: 'percentage',
        codeAmount: 15,
        validFrom: validFrom,
        validTill: validTill,
        promoCodeContent: 'Flat 15% off during festive season.',
        useLimite: 5,
        status: 'active',
        availability: '1',
      ),
    ];
  }
}
