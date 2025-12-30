// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, depend_on_referenced_packages, file_names, non_constant_identifier_names

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Menu/Bookings/bookings_controller.dart';
import 'package:gleekeyu/src/Menu/Bookings/cancel_booking.dart';
import 'package:gleekeyu/src/SubPages/PropertyAllDetails/propertyAllDetails_view.dart';
import 'package:gleekeyu/src/SubPages/confirm_n_pay/confirm_n_pay.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/utils/style/palette.dart';
import 'package:gleekeyu/widgets/commonText.dart';

import '../../../../widgets/loder.dart';
import '../../../SubPages/PropertyAllDetails/propertyAllDetails_controller.dart';

class BookingAllCard extends StatelessWidget {
  var allBookings;
  BookingAllCard({Key? key, required this.allBookings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime toDayDate = DateTime(now.year, now.month, now.day);
    BookingsController getController = Get.put(BookingsController());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Bounce(
            duration: const Duration(milliseconds: 200),
            onPressed: () {
              Get.to(
                () => PropertyAllDetails(
                  slug: allBookings['properties']['slug'],
                  startDate:"",
                  endDate: "",
                  fromSearch: false,
                  isPropertyActive:
                      allBookings['properties']['property_status'] == "Inactive"
                          ? false
                          : true,
                  id: allBookings['properties']['id'].toString(),
                ),
              );
            },
            child: Container(
              height: 200,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(allBookings['properties']['cover_photo']),
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                        color: allBookings['status'] == "Accepted"
                            ? kGreen
                            : allBookings['status'] == "Cancelled"
                                ? kRed
                                : kYellow,
                      ),
                      height: 40,
                      child: SizedBox(
                        width: 80,
                        child: Center(
                          child: Text(
                            allBookings['status'],
                            // ? "Paid"
                            // : "Unpaid",
                            style: Palette.topText,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   top: 15,
                  //   right: 15,
                  //   child: CircleAvatar(
                  //       radius: 16,
                  //       backgroundColor: kBlack.withOpacity(0.5),
                  //       child: Image.asset(
                  //         "assets/images/wishlist_icon_color.png",
                  //         color: kWhite,
                  //         height: 15,
                  //       )),
                  // )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              child: Row(
                children: [
                  Text(
                    allBookings['properties']['property_name'],
                    style: Palette.bestText,
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(allBookings['properties']['avg_rating'].toString(),
                      style: Palette.bestText1),
                  const Icon(
                    Icons.star_rounded,
                    color: kOrange,
                    size: 18,
                  ),
                  Text(
                      "(${allBookings['properties']['reviews_count'].toString()})",
                      style: Palette.bestText1),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              child: Row(
                children: [
                  Text(
                    'Booking ID : ',
                    style: Palette.bestText3.copyWith(color: Colors.black),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    (allBookings['code']).toString(),
                    style: Palette.bestText3,
                  ),
                  const Spacer(),
                  Text(
                    "Booked On : ",
                    style: Palette.bestText3.copyWith(color: Colors.black),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(allBookings['created_at'])),
                    style: Palette.bestText3,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: "From : ",
                      style: Palette.bestText2.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black),
                      children: [
                        TextSpan(
                          text:
                              "${DateFormat.d().format(DateTime.parse(allBookings['start_date']))} ${DateFormat.MMM().format(DateTime.parse(allBookings['start_date']))} ${DateFormat.y().format(DateTime.parse(allBookings['start_date']))}",
                          style: Palette.bestText3,
                        )
                      ]),
                ),
                RichText(
                  text: TextSpan(
                    text: "To : ",
                    style: Palette.bestText2.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            "${DateFormat.d().format(DateTime.parse(allBookings['end_date']))} ${DateFormat.MMM().format(DateTime.parse(allBookings['end_date']))} ${DateFormat.y().format(DateTime.parse(allBookings['end_date']))}",
                        style: Palette.bestText3,
                      )
                    ],
                  ),
                ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       'From',
                //       style: Palette.bestText2.copyWith(
                //           fontWeight: FontWeight.bold,
                //           fontSize: 14,
                //           color: Colors.black),
                //     ),
                //     const SizedBox(
                //       height: 8,
                //     ),
                //     Text(
                //       "${DateFormat.d().format(DateTime.parse(allBookings['start_date']))} ${DateFormat.MMM().format(DateTime.parse(allBookings['start_date']))} ${DateFormat.y().format(DateTime.parse(allBookings['start_date']))}",
                //       style: Palette.bestText3,
                //     ),
                //   ],
                // ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     Text(
                //       'To',
                //       style: Palette.bestText2.copyWith(
                //           fontWeight: FontWeight.bold,
                //           fontSize: 14,
                //           color: Colors.black),
                //     ),
                //     const SizedBox(
                //       height: 8,
                //     ),
                //     Text(
                //       "${DateFormat.d().format(DateTime.parse(allBookings['end_date']))} ${DateFormat.MMM().format(DateTime.parse(allBookings['end_date']))} ${DateFormat.y().format(DateTime.parse(allBookings['end_date']))}",
                //       style: Palette.bestText3,
                //     ),
                //   ],
                // ),
              ],
            )
                // Row(
                //   children: [
                //     Text(
                //       'Start From',
                //       style: Palette.bestText2,
                //     ),
                //     const SizedBox(
                //       width: 3,
                //     ),
                //     const Icon(
                //       Icons.currency_rupee_sharp,
                //       size: 12,
                //     ),
                //     Text(
                //       '${(allBookings['per_night'].toInt()).toString()}/Night',
                //       style: Palette.bestText3,
                //     ),
                //     const Spacer(),
                //     Image.asset(
                //       "assets/images/calender_icon.png",
                //       height: 15,
                //       width: 15,
                //       fit: BoxFit.contain,
                //     ),
                //     const SizedBox(
                //       width: 5,
                //     ),
                //     Text(
                //         "${DateFormat.d().format(DateTime.parse(allBookings['start_date']))}-${DateFormat.d().format(DateTime.parse(allBookings['end_date']))} ${DateFormat.MMM().format(DateTime.parse(allBookings['start_date']))} ${DateFormat.y().format(DateTime.parse(allBookings['start_date']))}",
                //         style: Palette.registerText1),
                //   ],
                // ),
                ),
          ),
          const SizedBox(
            height: 8,
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8),
          //   child: SizedBox(
          //     child: Row(
          //       children: [
          //         Text(
          //           'Start From',
          //           style: Palette.bestText2,
          //         ),
          //         const SizedBox(
          //           width: 3,
          //         ),
          //         const Icon(
          //           Icons.currency_rupee_sharp,
          //           size: 12,
          //         ),
          //         Text(
          //           '${(allBookings['per_night'].toInt()).toString()}/Night',
          //           style: Palette.bestText3,
          //         ),
          //         const Spacer(),
          //         Image.asset(
          //           "assets/images/calender_icon.png",
          //           height: 15,
          //           width: 15,
          //           fit: BoxFit.contain,
          //         ),
          //         const SizedBox(
          //           width: 5,
          //         ),
          //         Text(
          //             "${DateFormat.d().format(DateTime.parse(allBookings['start_date']))}-${DateFormat.d().format(DateTime.parse(allBookings['end_date']))} ${DateFormat.MMM().format(DateTime.parse(allBookings['start_date']))} ${DateFormat.y().format(DateTime.parse(allBookings['start_date']))}",
          //             style: Palette.registerText1),
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 22,
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: MaterialButton(
                            color: kOrange,
                            shape: Palette.subCardShape,
                            padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                            child: Text(
                              'View & Manage Booking',
                              style: Palette.topText,
                            ),
                            onPressed: () async {
                              loaderShow(context);
                              await getController
                                  .getAdvanceBookinReciept1(allBookings['id']);
                            }),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    if (allBookings['status'] == "Accepted" &&
                        ((DateTime.parse(allBookings['start_date']) ==
                                    toDayDate ||
                                ((DateTime.parse(allBookings['start_date'])
                                    .isBefore(toDayDate)))) &&
                            ((DateTime.parse(allBookings['end_date'])) ==
                                    toDayDate ||
                                ((DateTime.parse(allBookings['end_date'])
                                    .isAfter(toDayDate))))))
                      ...{}
                    else if (allBookings['customer_inv'].toString() != '0') ...{
                      SizedBox(
                        height: 45,
                        child: MaterialButton(
                          color: kOrange,
                          shape: Palette.subCardShape,
                          padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                          child: Text(
                            "Invoice",
                            style: Palette.topText,
                          ),
                          onPressed: () async {
                            loaderShow(context);
                            await getController.getAdvanceBookinReciept(
                                allBookings['id'],
                                endPoints: EndPoint.userInvoice);
                          },
                        ),
                      )
                    } else if (allBookings['status'] == "Cancelled") ...{
                      SizedBox(
                        height: 45,
                        child: MaterialButton(
                          color: kOrange,
                          shape: Palette.subCardShape,
                          padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                          child: Text(
                            "Refund Voucher",
                            style: Palette.topText,
                          ),
                          onPressed: () async {
                            loaderShow(context);
                            await getController.getAdvanceBookinReciept(
                              allBookings['id'],
                              endPoints: EndPoint.refundVoucher,
                            );
                          },
                        ),
                      ),
                    } else if (DateTime.parse(allBookings['end_date'])
                            .isAfter(toDayDate) &&
                        DateTime.parse(allBookings['start_date'])
                            .isAfter(toDayDate)) ...{
                      SizedBox(
                        height: 45,
                        child: MaterialButton(
                          color: kOrange,
                          shape: Palette.subCardShape,
                          padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                          child: Text(
                            "Cancel Booking",
                            style: Palette.topText,
                          ),
                          onPressed: () async {
                            loaderShow(context);
                            await getController.getCancellationReciept(
                              allBookings['id'],
                              (String value, dynamic refundAmount) async {
                                loaderHide();
                                var data = await Get.to(
                                  CancelBookingScreen(
                                    bookingID: allBookings['id'].toString(),
                                    endDate: allBookings['end_date'],
                                    startDate: allBookings['start_date'],
                                    code: value,
                                    isRefund: refundAmount == "No refund"
                                        ? false
                                        : true,
                                  ),
                                );
                                if (data == true) {
                                  allBookings['status'] = "Cancelled";
                                  getController.getApi();
                                  getController.update();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    },
                  ],
                ),
                if (allBookings['payment_type'].toString() == "0" &&
                    (allBookings['status'] != "Cancelled")) ...{
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 45,
                    width: double.maxFinite,
                    child: MaterialButton(
                      color: kOrange,
                      shape: Palette.subCardShape,
                      padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                      child: Text(
                        "Make Payment",
                        style: Palette.topText,
                      ),
                      onPressed: () async {
                        List tempList =
                            jsonDecode(allBookings['date_with_price']);
                        List<SelectedDateWithPrice> selectedDates = tempList
                            .map((e) => SelectedDateWithPrice.fromJson(e))
                            .toList();
                        print("Selected Dates Length : ${selectedDates.length}");
                        var result = await Get.to(
                          () => ConfirmNpay(
                            selectedDates: selectedDates,
                            coverImg: allBookings['properties']['cover_photo'],
                            totalPrice: double.parse(allBookings['total'].toString()).customRound(),
                            propertyType: allBookings['properties']['property_type_name'],
                            propertyID: allBookings['properties']['id'].toString(),
                            bookingID: allBookings['id'].toString(),
                            gstTex: allBookings['iva_tax'].toString(),
                            bookingData: allBookings,
                          ),
                        );
                        if (result == true) {
                          allBookings['payment_type'] = 1;
                          getController.update();
                        }
                      },
                    ),
                  ),
                }
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> BtmCancelSheet(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      context: context,
      builder: ((context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20)),
                    height: 4,
                    width: 40,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  commonText(
                    color: kBlack,
                    fontSize: 15,
                    text: "Cancel Booking",
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Divider(
                    color: kBlack.withOpacity(0.4),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: 250,
                    child: Center(
                      child: commonText(
                        textAlign: TextAlign.center,
                        color: kBlack,
                        fontSize: 15,
                        text: "Are You Sure Want To Cancel Your Hotel Booking",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  commonText(
                    textAlign: TextAlign.center,
                    color: kBlack.withAlpha(125),
                    fontSize: 14,
                    text:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever ",
                    fontWeight: FontWeight.w400,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 6,
                      right: 6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: (() {
                              Navigator.pop(context);
                            }),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: kOrange),
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              height: 45,
                              child: Center(
                                child: commonText(
                                  textAlign: TextAlign.center,
                                  color: kBlack,
                                  fontSize: 12,
                                  text: "Cancel",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: kOrange),
                                color: kOrange,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              height: 45,
                              child: Center(
                                child: commonText(
                                  textAlign: TextAlign.center,
                                  color: kWhite,
                                  fontSize: 12,
                                  text: "Yes, Continue",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
