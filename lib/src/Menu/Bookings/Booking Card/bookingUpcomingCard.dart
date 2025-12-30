// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Menu/Bookings/bookings_controller.dart';
import 'package:intl/intl.dart';

import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/utils/style/palette.dart';

import '../../../../extras/commonWidget.dart';
import '../../../../widgets/loder.dart';
import '../../../SubPages/PropertyAllDetails/propertyAllDetails_view.dart';
import '../cancel_booking.dart';

class BookingUpcomingCard extends StatelessWidget {
  var upcomingProperties;
  BookingUpcomingCard({super.key, this.upcomingProperties});

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
                  isPropertyActive: upcomingProperties['properties']
                              ['property_status'] ==
                          "Inactive"
                      ? false
                      : true,
                  fromSearch: false,
                  startDate:"",
                  endDate: "",
                  slug: upcomingProperties['properties']['slug'],
                  id: upcomingProperties['properties']['id'].toString()));
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
                          upcomingProperties['properties']['cover_photo']))),
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
                        color: upcomingProperties['status'] == "Accepted"
                            ? kGreen
                            : upcomingProperties['status'] == "Cancelled"
                                ? kRed
                                : kYellow,
                      ),
                      height: 40,
                      child: SizedBox(
                        width: 80,
                        child: Center(
                          child: Text(
                            upcomingProperties['status'],
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
                    upcomingProperties['properties']['property_name'],
                    style: Palette.bestText,
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                      upcomingProperties['properties']['avg_rating'].toString(),
                      style: Palette.bestText1),
                  const Icon(
                    Icons.star_rounded,
                    color: kOrange,
                    size: 18,
                  ),
                  Text(
                      "(${upcomingProperties['properties']['reviews_count'].toString()})",
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
                    (upcomingProperties['code']).toString(),
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
                    DateFormat('yyyy-MM-dd').format(
                        DateTime.parse(upcomingProperties['created_at'])),
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
                                "${DateFormat.d().format(DateTime.parse(upcomingProperties['start_date']))} ${DateFormat.MMM().format(DateTime.parse(upcomingProperties['start_date']))} ${DateFormat.y().format(DateTime.parse(upcomingProperties['start_date']))}",
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
                              "${DateFormat.d().format(DateTime.parse(upcomingProperties['end_date']))} ${DateFormat.MMM().format(DateTime.parse(upcomingProperties['end_date']))} ${DateFormat.y().format(DateTime.parse(upcomingProperties['end_date']))}",
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
                          await getController.getAdvanceBookinReciept1(
                              upcomingProperties['id']);
                        },
                        name: "View & Manage Booking")),
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                height: 45,
                child: CommonButton(
                  onPressed: () async {
                    loaderShow(context);
                    await getController
                        .getCancellationReciept(upcomingProperties['id'],
                            (String value, dynamic refundAmount) async {
                      loaderHide();
                      var result = await Get.to(
                        CancelBookingScreen(
                          bookingID: upcomingProperties['id'].toString(),
                          endDate: upcomingProperties['end_date'],
                          startDate: upcomingProperties['start_date'],
                          code: value,
                          isRefund: refundAmount == "No refund" ? false : true,
                        ),
                      );
                      if (result == true) {
                        upcomingProperties['status'] = "Cancelled";
                        getController.update();
                      }
                    });
                  },
                  name: "Cancel Booking",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
