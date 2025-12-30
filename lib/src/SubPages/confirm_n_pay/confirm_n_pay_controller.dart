import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Menu/Bookings/bookings_controller.dart';
import 'package:gleekeyu/src/SubPages/PropertyAllDetails/propertyAllDetails_controller.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/widgets/loder.dart';
import 'package:gleekeyu/widgets/showSnackBar.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../SearchPlaces/searchPlaces_controller.dart';

//TODo
//darora7829@rehezb.com
enum PaymentOption { Advance, Full }

class ConfrimNPayController extends GetxController {
  bool isPriceBreakup = false;
  TextEditingController promoCode = TextEditingController();
  TextEditingController firstName =
      TextEditingController(text: currUser!.data!.firstName);
  TextEditingController lastName =
      TextEditingController(text: currUser!.data!.lastName);
  TextEditingController email =
      TextEditingController(text: currUser!.data!.email);
  TextEditingController mobile =
      TextEditingController(text: currUser!.data!.phone);
  TextEditingController request = TextEditingController();
  double selectedRadioButton = 0;
  double selectedRadioButton1 = 0;
  PaymentOption paymentOption = PaymentOption.Full;
  RxBool isAgree = false.obs;
  onChange(PaymentOption value) {
    paymentOption = value;
    update();
  }

  checkDayDuration({required String startDate}) {
    try {
      DateTime dateTime = DateFormat('dd-MM-yyyy').parse(startDate);
      DateTime todayDate = DateTime.now();
      final difference = dateTime.difference(todayDate).inDays + 1;
      return difference;
    } catch (e) {}
  }

  toggleIsAgree() {
    isAgree.value = !isAgree.value;
    update();
  }

  Future<void> bookPropery({
    required BuildContext context,
    required String propertyID,
    required String paymentID,
    String? bookingID,
    Map<String, dynamic>? bookingData,
  }) async {
    try {
      loaderShow(context);
      PropertyAllDetailsController a = Get.find();
      SearchPlacesController searchPlacesController = Get.find();
      Map<String, dynamic> params = {
        "payment_country": "IN",
        "coupan_code_discount": bookingData == null ? a.coupenCode.value : "",
        "host_offer_discount_status": bookingData == null
            ? a.isHostOfferApplied.value
                ? "1"
                : "0"
            : 0,
        "discount_amount":
            bookingData == null ? (a.totalDiscount ?? 0).toString() : 0,
        "discount_percentage":
            bookingData == null ? (a.discountPercentage).toString() : 0,
        "property_id": propertyID,
        "checkin":
            bookingData == null ? a.startDate : bookingData['start_date'],
        "checkout": bookingData == null ? a.endDate : bookingData['end_date'],
        "number_of_guests": bookingData == null
            ? (int.parse(searchPlacesController.totalAdults.text) +
                int.parse(searchPlacesController.totalChildren.text) +
                (int.parse(searchPlacesController.totalInphant.text)))
            : bookingData['guest'],
        "number_of_adults": bookingData == null
            ? (int.parse(searchPlacesController.totalAdults.text)).toString()
            : bookingData['adults'],
        "number_of_children": bookingData == null
            ? int.parse(searchPlacesController.totalChildren.text).toString()
            : bookingData['children'],
        "number_of_infant": bookingData == null
            ? int.parse(searchPlacesController.totalInphant.text).toString()
            : bookingData['infant'],
        "payment_type": bookingData == null
            ? paymentOption == PaymentOption.Full
                ? "1"
                : "0"
            : "1",
        "advance_amount": bookingData == null
            ? paymentOption == PaymentOption.Full &&
                    a.PropertyData!.result!.noOfDiscountBooking != null &&
                    (a.isOfferApplied.value || a.isCoupenApplied.value)
                ? ((a.totalPriceAfterDiscount ?? 0) +
                        (a.totalGST ?? 0).customRound())
                    .toString()
                : paymentOption == PaymentOption.Full
                    ? ((a.totalPrice ?? 0) + (a.totalGST ?? 0).customRound())
                        .toString()
                    : ((double.parse(a.totalGST?.toStringAsFixed(1) ?? '0')
                                    .customRound() +
                                (a.totalPrice ?? 0)) /
                            2)
                        .toString()
            : ((bookingData['advance_amount'])).toString(),
        "booking_total": bookingData == null
            ? paymentOption == PaymentOption.Full &&
                    a.PropertyData!.result!.noOfDiscountBooking != null &&
                    (a.isOfferApplied.value || a.isCoupenApplied.value)
                ? ((a.totalPriceAfterDiscount ?? 0) +
                        (a.totalGST ?? 0).customRound())
                    .toString()
                : paymentOption == PaymentOption.Full
                    ? ((a.totalPrice ?? 0) + (a.totalGST ?? 0).customRound())
                        .toString()
                    : ((double.parse(a.totalGST?.toStringAsFixed(1) ?? '0')
                                .customRound() +
                            (a.totalPrice ?? 0)))
                        .toString()
            : bookingData['total'],
        "iva_tax_amt": bookingData == null
            ? (a.totalGST ?? 0).toString()
            : bookingData['iva_tax'],
        "transaction_id": paymentID,
        "fname": firstName.text.trim(),
        "lname": lastName.text.trim(),
        "email": email.text.trim(),

        "formatted_phone": "+91${mobile.text.trim()}",
        "message_to_host": request.text.trim()
      };

      params.addIf(bookingID != null, "booking_id", bookingID);

      print("Params ::: $params");
      print("Params ::: ${BaseConstant.BASE_URL + EndPoint.createBooking}");
      print("Params ::: ${currUser!=null?currUser?.accessToken:""}");


      d.Dio dio = d.Dio();
      d.Response response = await dio.post(
        BaseConstant.BASE_URL + EndPoint.createBooking,
        data: d.FormData.fromMap(params),
        options: d.Options(headers: {
          'Authorization': 'Bearer ${currUser!=null?currUser?.accessToken:""}',
        }),
      );
      print("Responseeeeee: ${response.data}");
      if (response.statusCode == 200) {
        if (response.data['status'] == true) {
          showSnackBar(
              title: "Success",
              message: "Booking Successfully...",
              color: Colors.green);
          BookingsController a = Get.put(BookingsController());
          loaderShow(context);
          var result = await a.getAdvanceBookinReciept(
              response.data['data']['id'],
              isNavigatToHome: true,
              isMainPayment: bookingData == null);
          loaderHide();
        } else {
          showSnackBar(
            title: "Error",
            message: "Something went wrong.33333333333..Please contact admin",
          );
        }
        update();
      } else {
        showSnackBar(
            title: "Error",
            message: "Something went wrong.222222222222..Please contact admin");
      }
      update();
    } catch (e) {
      print("Erorror r: $e");
      showSnackBar(
          title: "Error",
          message: "Something went wrong.111111111111..Please contact admin :$e");
    } finally {
      loaderHide();
    }
  }
}
