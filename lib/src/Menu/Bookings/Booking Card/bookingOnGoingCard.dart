// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Menu/Bookings/bookings_controller.dart';
import 'package:intl/intl.dart';

import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/utils/style/palette.dart';
import 'package:gleekeyu/widgets/commonText.dart';

import '../../../../widgets/loder.dart';
import '../../../SubPages/PropertyAllDetails/propertyAllDetails_view.dart';

class BookingOnGoingCard extends StatelessWidget {
  var onGoingBookings;
  BookingOnGoingCard({Key? key, required this.onGoingBookings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BookingsController getController = Get.find();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Bounce(
            duration: const Duration(milliseconds: 200),
            onPressed: () {
              Get.to(() => PropertyAllDetails(
                  isPropertyActive: onGoingBookings['properties']
                              ['property_status'] ==
                          "Inactive"
                      ? false
                      : true,
                  fromSearch: false,
                  startDate:"",
                  endDate: "",
                  slug: onGoingBookings['properties']['slug'],
                  id: onGoingBookings['properties']['id'].toString()));
            },
            child: Container(
              height: 200,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          onGoingBookings['properties']['cover_photo']))),
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
                        color: onGoingBookings['status'] == "Accepted"
                            ? kGreen
                            : onGoingBookings['status'] == "Cancelled"
                                ? kRed
                                : kYellow,
                      ),
                      height: 40,
                      child: SizedBox(
                        width: 80,
                        child: Center(
                          child: Text(
                            onGoingBookings['status'],
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
                    onGoingBookings['properties']['property_name'],
                    style: Palette.bestText,
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(onGoingBookings['properties']['avg_rating'].toString(),
                      style: Palette.bestText1),
                  const Icon(
                    Icons.star_rounded,
                    color: kOrange,
                    size: 18,
                  ),
                  Text(
                      "(${onGoingBookings['properties']['reviews_count'].toString()})",
                      style: Palette.bestText1),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
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
                    (onGoingBookings['code']).toString(),
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
                        .format(DateTime.parse(onGoingBookings['created_at'])),
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
                                "${DateFormat.d().format(DateTime.parse(onGoingBookings['start_date']))} ${DateFormat.MMM().format(DateTime.parse(onGoingBookings['start_date']))} ${DateFormat.y().format(DateTime.parse(onGoingBookings['start_date']))}",
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
                              "${DateFormat.d().format(DateTime.parse(onGoingBookings['end_date']))} ${DateFormat.MMM().format(DateTime.parse(onGoingBookings['end_date']))} ${DateFormat.y().format(DateTime.parse(onGoingBookings['end_date']))}",
                          style: Palette.bestText3,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                              .getAdvanceBookinReciept1(onGoingBookings['id']);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ViewReceipt(
                          //               code: onGoingBookings['code'],
                          //             )));
                        }),
                  ),
                ),
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
                          text:
                              "Are You Sure Want To Cancel Your Hotel Booking",
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
                                    borderRadius: BorderRadius.circular(6)),
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
                              onTap: (() {
                                Navigator.pop(context);
                              }),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: kOrange),
                                    color: kOrange,
                                    borderRadius: BorderRadius.circular(6)),
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
        }));
  }
}
