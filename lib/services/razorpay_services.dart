import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';

class RazorpayService {
  final _razorpay = Razorpay();

  Function(String paymentID)? _onSuccess;
  VoidCallback? _onError;

  set onSuccess(Function(String paymentID)? callback) => _onSuccess = callback;
  set onError(VoidCallback? callback) => _onError = callback;

  void initialize() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (_onSuccess != null) _onSuccess!(response.paymentId ?? '');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error Response : ${response.error}");
    if (_onError != null) _onError!();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet event
  }

  void openCheckout(
      {required int amount,
      required String key,
      required String name,
      required String number,
      required String orderId}) {
    final options = {
      'key': key,
      'amount': amount,
      'currency': "INR",
      'name': "Gleekey",
      'timeout': 120,
      // 'order_id': orderId,
      'description': 'Booking Advance Payment',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': number, 'name': name},
    };
    try {
      _razorpay.open(options);
    } catch (error) {
      throw Exception("RazorPay error$error");
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
