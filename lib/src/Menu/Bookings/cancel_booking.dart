// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/extras/commonWidget.dart';
import 'package:gleekeyu/src/Menu/Bookings/cancel_controller.dart';

import '../../../utils/style/palette.dart';

class CancelBookingScreen extends StatelessWidget {
  CancelBookingScreen({
    super.key,
    required this.bookingID,
    required this.endDate,
    required this.startDate,
    required this.code,
    required this.isRefund,
  });
  final String bookingID;
  final String startDate;
  final String endDate;
  final String code;
  final bool isRefund;
  final CancelController a = Get.put(CancelController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Cancel Booking",
          style: Palette.appbarTitle,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height:
                    MediaQuery.of(context).size.height - (isRefund ? 400 : 200),
                width: double.maxFinite,
                child: Center(
                  child: PDF(
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: false,
                    pageFling: false,
                    onError: (error) {
                      print(error.toString());
                    },
                    onPageError: (page, error) {
                      print('$page: ${error.toString()}');
                    },
                    onPageChanged: (int? page, int? total) {
                      print('page change: $page/$total');
                    },
                  ).fromUrl(code),
                ),
              ),
              if (isRefund) ...{
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 35,
                        width: double.maxFinite,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: const Border(
                              bottom: BorderSide(color: Colors.grey)),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            "Bank Details",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                labelText: "Bank Name",
                                controller: a.bankNameController,
                                lableColor: Colors.grey.shade700,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Bank name can't be empty";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              CustomTextField(
                                labelText: "IFSC Code",
                                lableColor: Colors.grey.shade700,
                                controller: a.ifscController,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "IFSC code can't be empty";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              CustomTextField(
                                labelText: "Account Number",
                                lableColor: Colors.grey.shade700,
                                controller: a.accountNumberController,
                                textInputType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Account number can't be empty";
                                  } else if (value.trim().length < 10 ||
                                      value.trim().length > 16) {
                                    return "Account number length must be 10 to 16 digit long";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              CustomTextField(
                                labelText: "Re-Enter Account Number",
                                lableColor: Colors.grey.shade700,
                                controller: a.reAccountNumberController,
                                textInputType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Please Re-write account number";
                                  } else if (value.trim() !=
                                      a.accountNumberController.text.trim()) {
                                    return "Account number does not match";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              },
              const SizedBox(
                height: 20,
              ),
              CommonButton(
                  onPressed: () {
                    if (!isRefund || formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return writeCancellationReasonDialog(context, a);
                        },
                      );
                    }
                  },
                  name: 'Cancel Booking')
            ],
          ),
        ),
      ),
    );
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget writeCancellationReasonDialog(
      BuildContext context, CancelController controller) {
    return PopScope(
      canPop: true,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: SingleChildScrollView(
          child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                // height: 400,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, top: 12, bottom: 5),
                        child: Text(
                          "Cancel this Booking",
                          style: Palette.splashscreenskip,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0, top: 8, right: 8),
                        child: Text(
                          'Help us improve your experience.Please write down the main reason for Cancelling this Booking',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0, top: 8, right: 8),
                        child: Text(
                          'Your response will be shared with the host',
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w800,
                              fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0, top: 8, right: 8),
                        child: CustomDropdownField(
                          items: const [
                            "Why are you cancelling",
                            "I have changed my mind",
                            "Change in Plans/Personal Reasons",
                            "Weather Concerns",
                            "Group Availability Issue",
                            "Better Deal or Alternative Stay",
                            "Property-Related Concern",
                            "Other"
                          ],
                          value: a.cancelReason.value,
                          valueSuffix: '',
                          onChange: (p0) {
                            a.cancelReason.value = p0;
                          },
                          validator: (value) {
                            if (a.cancelReason.value ==
                                'Why are you cancelling') {
                              return "Please choose reason";
                            }
                            return null;
                          },
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: CustomTextField(
                              maxLine: 3,
                              controller: a.cancelReasonController,
                              labelText: "Why are you cancelling ?",
                              lableColor: Colors.grey.shade600,
                              validator: (value) {
                                if ((value == null || value.trim().isEmpty)) {
                                  return "Please Write Cancellation Reason";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          CommonButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                a.cancelBooking(context,
                                    bookingID: bookingID,
                                    startDateString: startDate,
                                    checkout: endDate);
                              }
                            },
                            name: 'Cancel Booking',
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
