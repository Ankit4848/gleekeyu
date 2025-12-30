// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:gleekeyu/utils/baseconstant.dart';
import 'package:gleekeyu/widgets/loder.dart';

import '../../SubPages/Receipt/receipt_view.dart';

class BookingsController extends GetxController {
  // Bookings_model? bookings_model;
  var isDataLoaded = false;
  int tabCurrIndex = 0;
  var completedBookings = [];
  var onGoingBookings = [];
  var canceledBookings = [];
  var inquiryStatusBookings = [];
  var allBookings = [];
  var upcomingBookings = [];
  var expiredBookings = [];
  var tripData;

  @override
  void onInit() {
    getApi();
    super.onInit();
  }

  getApi() async {
    print('Bearer ${currUser!=null?currUser?.accessToken:""}');
    print('Bearer ${BaseConstant.BASE_URL + EndPoint.bookings}');
    http.Response response = await http.post(
      Uri.parse(BaseConstant.BASE_URL + EndPoint.bookings),
      headers: {
        'Authorization': 'Bearer ${currUser!=null?currUser?.accessToken:""}',
      },
      body: {
        'offset': '0',
        'limit': '10000',},
    );
    print("Get response :${response.body}");
    allBookings.clear();
    expiredBookings.clear();
    onGoingBookings.clear();
    upcomingBookings.clear();
    completedBookings.clear();
    canceledBookings.clear();
    inquiryStatusBookings.clear();
    if (response.statusCode == 200) {
      tripData = json.decode(response.body);
      // bookings_model = Bookings_model.fromJson(result);
      isDataLoaded = true;
      allBookings.addAll(tripData['data']['bookings']);
      expiredBookings.addAll(tripData['data']['expired_bookings']);
      onGoingBookings.addAll(tripData['data']['current_bookings']);
      upcomingBookings.addAll(tripData['data']['upcoming_bookings']);
      completedBookings.addAll(tripData['data']['completed_bookings']);
      canceledBookings.addAll(tripData['data']['cancelled_bookings']);
      inquiryStatusBookings.addAll(tripData['data']['inquiry_status_bookings']);
      log("Bookings Controller -- > got the data from API");
    } else {
      printError(info: "Bookings Controller -- > Not get data from api");
    }
    update();
  }

  getAdvanceBookinReciept(int bookingId,
      {String? endPoints,
      bool isNavigatToHome = false,
      bool isMainPayment = false}) async {
    print('Bearer ${currUser!=null?currUser?.accessToken:""}  $bookingId');
    try {
      Map params = {};
      if (endPoints == EndPoint.refundVoucher) {
        params = {"id": bookingId.toString()};
      } else {
        params = {
          'booking_id': bookingId.toString(),
        };
      }
      http.Response response = await http.post(
        Uri.parse(BaseConstant.BASE_URL +
            (endPoints ?? EndPoint.bookingVoucherReciept)),
        headers: {
          'Authorization': 'Bearer ${currUser!=null?currUser?.accessToken:""}',
        },
        body: params,
      );
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        loaderHide();
        var data = await Get.to(() => ViewReceipt(
              code: result['data']['documents'],
              isNavigatToHome: isNavigatToHome,
              isMainPayment: isMainPayment,
            ));
        return data;
      } else {
        loaderHide();
        printError(info: "Bookings Controller -- > Not get data from api");
      }
    } catch (e) {
      loaderHide();
    }
    update();
  }
  getAdvanceBookinReciept1(int bookingId,
      {String? endPoints,
      bool isNavigatToHome = false,
      bool isMainPayment = false}) async {
    print('Bearer ${currUser!=null?currUser?.accessToken:""}  $bookingId');
    try {
      Map params = {};
      if (endPoints == EndPoint.refundVoucher) {
        params = {"id": bookingId.toString()};
      } else {
        params = {
          'booking_id': bookingId.toString(),
        };
      }
      http.Response response = await http.post(
        Uri.parse(BaseConstant.BASE_URL +
            (endPoints ?? EndPoint.bookingAdvanceReciept)),
        headers: {
          'Authorization': 'Bearer ${currUser!=null?currUser?.accessToken:""}',
        },
        body: params,
      );
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        loaderHide();
        var data = await Get.to(() => ViewReceipt(
              code: result['data']['documents'],
              isNavigatToHome: isNavigatToHome,
              isMainPayment: isMainPayment,
            ));
        return data;
      } else {
        loaderHide();
        printError(info: "Bookings Controller -- > Not get data from api");
      }
    } catch (e) {
      loaderHide();
    }
    update();
  }

  getCancellationReciept(
      int bookingId, Function(String, dynamic) onSuccess) async {
    print('Bearer ${currUser!=null?currUser?.accessToken:""} $bookingId');
    try {
      http.Response response = await http.post(
        Uri.parse(BaseConstant.BASE_URL + EndPoint.userCancelReciept),
        headers: {
          'Authorization': 'Bearer ${currUser!=null?currUser?.accessToken:""}',
        },
        body: {
          'booking_id': bookingId.toString(),
        },
      );
      print("Get response :${response.body}");
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        print("Response : ${result['data']['documents']}");

        loaderHide();
        onSuccess(result['data']['documents'],
            result['data']['data']['cancelled_charge']);
      } else {
        loaderHide();
        printError(info: "Bookings Controller -- > Not get data from api");
      }
    } catch (e) {
      loaderHide();
    }
    update();
  }
}
