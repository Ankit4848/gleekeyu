import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/services/razorpay_services.dart';

class RazorPayController extends GetxController {
  final RazorpayService _razorpayService = RazorpayService();

  RazorPayController() {
    _razorpayService.initialize();
  }

  set onSuccess(Function(String paymentID)? callback) =>
      _razorpayService.onSuccess = callback;
  set onError(VoidCallback? callback) => _razorpayService.onError = callback;

  void openCheckout({
    required int amount,
    required String key,
    required String name,
    required String number,
    required String orderId,
  }) {
    _razorpayService.openCheckout(
      amount: amount,
      key: key,
      name: name,
      number: number,
      orderId: orderId,
    );
    _razorpayService.printInfo();
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }
}
