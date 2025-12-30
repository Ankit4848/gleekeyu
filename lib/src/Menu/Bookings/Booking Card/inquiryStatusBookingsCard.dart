// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Menu/Bookings/bookings_controller.dart';

import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/utils/style/palette.dart';
import 'package:intl/intl.dart';

import '../../../../extras/commonWidget.dart';
import '../../../../utils/baseconstant.dart';
import '../../../../widgets/loder.dart';
import '../../../SubPages/PropertyAllDetails/propertyAllDetails_view.dart';

// ignore: must_be_immutable
class inquiryStatusBookingsCard extends StatelessWidget {
  var inquiryStatusBookings;
  inquiryStatusBookingsCard({Key? key, required this.inquiryStatusBookings})
      : super(key: key);
  BookingsController getController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Bounce(
            duration: const Duration(milliseconds: 200),
            onPressed: () {
              Get.to(
                () => PropertyAllDetails(
                  slug: inquiryStatusBookings['properties']['slug'],
                  fromSearch: false,
                  isPropertyActive: inquiryStatusBookings['properties']
                              ['property_status'] ==
                          "Inactive"
                      ? false
                      : true,
                  startDate:"",
                  endDate: "",
                  id: inquiryStatusBookings['properties']['id'].toString(),
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
                      image: NetworkImage(inquiryStatusBookings['properties']
                              ['cover_photo'] ??
                          ''))),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                        color: kRed,
                      ),
                      height: 40,
                      child: SizedBox(
                        width: Get.width*0.25,
                        child: Center(
                          child: Text(
                            "${inquiryStatusBookings['status'].toString().capitalizeFirst}"
                            /* inquiryStatusBookings['status']=="rejected" || inquiryStatusBookings['status']=="pending"?"${inquiryStatusBookings['status'].toString().capitalizeFirst}"
                            : inquiryStatusBookings['status']=="accepted" && inquiryStatusBookings['is_booked']=="1"  ?"Booked":
                            inquiryStatusBookings['status']=="accepted" && inquiryStatusBookings['is_booked']=="0"  ?"Booked"*/,
                            style: Palette.topText,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Container(
                  //     clipBehavior: Clip.antiAliasWithSaveLayer,
                  //     decoration: const BoxDecoration(
                  //       borderRadius: BorderRadius.only(
                  //           bottomLeft: Radius.circular(12),
                  //           bottomRight: Radius.circular(12)),
                  //       color: kOrange,
                  //     ),
                  //     height: 40,
                  //     child: SizedBox(
                  //       width: double.maxFinite,
                  //       child: Center(
                  //         child: Text(
                  //           "Cancelled And Refunded",
                  //           style: Palette.topText,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
                    inquiryStatusBookings['properties']['property_name'],
                    style: Palette.bestText,
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(inquiryStatusBookings['properties']['avg_rating'].toString(),
                      style: Palette.bestText1),
                  const Icon(
                    Icons.star_rounded,
                    color: kOrange,
                    size: 18,
                  ),
                  Text(
                      "(${inquiryStatusBookings['properties']['reviews_count'].toString()})",
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
                    (inquiryStatusBookings['id']).toString(),
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
                        .format(DateTime.parse(inquiryStatusBookings['created_at'])),
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
                                "${DateFormat.d().format(DateTime.parse(inquiryStatusBookings['check_in']))} ${DateFormat.MMM().format(DateTime.parse(inquiryStatusBookings['check_in']))} ${DateFormat.y().format(DateTime.parse(inquiryStatusBookings['check_in']))}",
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
                              "${DateFormat.d().format(DateTime.parse(inquiryStatusBookings['check_out']))} ${DateFormat.MMM().format(DateTime.parse(inquiryStatusBookings['check_out']))} ${DateFormat.y().format(DateTime.parse(inquiryStatusBookings['check_out']))}",
                          style: Palette.bestText3,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 45,
                  width: double.maxFinite,
                  child: CommonButton(
                      onPressed: () async {
                        loaderShow(context);
                        await getController.getAdvanceBookinReciept(
                            inquiryStatusBookings['id'],
                            endPoints: EndPoint.userCancelReciept);
                      },
                      name: "Cancellation receipt"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
