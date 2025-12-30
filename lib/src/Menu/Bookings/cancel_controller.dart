import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/widgets/loder.dart';
import 'package:dio/dio.dart' as d;
import '../../../utils/baseconstant.dart';
import '../../../widgets/showSnackBar.dart';

class CancelController extends GetxController {
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController cancelReasonController = TextEditingController();
  final TextEditingController reAccountNumberController =
      TextEditingController();

  RxString cancelReason = "Why are you cancelling".obs;

  Future<void> cancelBooking(BuildContext context,
      {required String bookingID,
      required String startDateString,
      required String checkout}) async {
    try {
      loaderShow(context);
      DateTime startDate = DateTime.parse(startDateString);
      DateTime now = DateTime.now();
      int diff = now.difference(startDate).inDays;
      Map<String, dynamic> params = {
        "booking_id": bookingID,
        "day_left": diff.toString(),
        "cancel_reason": cancelReason.value,
        "cancel_message": cancelReasonController.text.trim(),
        "customer_bank_name": bankNameController.text.trim(),
        "customer_account_no": accountNumberController.text.trim(),
        "customer_ifsc_code": ifscController.text.trim(),
        "checkout": checkout
      };
      print("Params ::: $params");
      d.Dio dio = d.Dio();
      d.Response response = await dio.post(
        BaseConstant.BASE_URL + EndPoint.cancelBooking,
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
            message: "Booking Cancel Successfully...",
            color: Colors.green,
          );
          Get.back(
            canPop: true,
            closeOverlays: true,
          );
          Get.back(
            result: true,
            canPop: true,
            closeOverlays: true,
          );
          bankNameController.clear();
          cancelReason.value = 'Why are you cancelling';
          cancelReasonController.clear();
          bankNameController.clear();
          accountNumberController.clear();
          reAccountNumberController.clear();
          ifscController.clear();
        } else {
          showSnackBar(
            title: "Error",
            message: "Something went wrong...Please contact admin",
          );
        }
        update();
      } else {
        showSnackBar(
          title: "Error",
          message: "Something went wrong...Please contact admin",
        );
      }
      update();
    } catch (e) {
      print("Erorr :$e");
    } finally {
      loaderHide();
    }
  }
}
