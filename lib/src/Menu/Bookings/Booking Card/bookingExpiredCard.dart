// ignore_for_file: depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Menu/Bookings/bookings_controller.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/utils/style/palette.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/loder.dart';
import '../../../SubPages/PropertyAllDetails/propertyAllDetails_view.dart';

class BookingExpiredCard extends StatelessWidget {
  var expiredProperties;
  BookingExpiredCard({super.key, this.expiredProperties});

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
                  slug: expiredProperties['properties']['slug'],
                  startDate:"",
                  endDate: "",
                  fromSearch: false,
                  isPropertyActive: expiredProperties['properties']
                              ['property_status'] ==
                          "Inactive"
                      ? false
                      : true,
                  id: expiredProperties['properties']['id'].toString()));
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
                          expiredProperties['properties']['cover_photo']))),
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
                        width: 80,
                        child: Center(
                          child: Text(
                            'Expired',
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
                    expiredProperties['properties']['property_name'],
                    style: Palette.bestText,
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(expiredProperties['properties']['avg_rating'].toString(),
                      style: Palette.bestText1),
                  const Icon(
                    Icons.star_rounded,
                    color: kOrange,
                    size: 18,
                  ),
                  Text(
                      "(${expiredProperties['properties']['reviews_count'].toString()})",
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
                    (expiredProperties['code']).toString(),
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
                        DateTime.parse(expiredProperties['created_at'])),
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
                  Column(
                    children: [
                      Text(
                        'From',
                        style: Palette.bestText2,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "${DateFormat.d().format(DateTime.parse(expiredProperties['start_date']))} ${DateFormat.MMM().format(DateTime.parse(expiredProperties['start_date']))} ${DateFormat.y().format(DateTime.parse(expiredProperties['start_date']))}",
                        style: Palette.bestText3,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'To',
                        style: Palette.bestText2,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "${DateFormat.d().format(DateTime.parse(expiredProperties['end_date']))} ${DateFormat.MMM().format(DateTime.parse(expiredProperties['end_date']))} ${DateFormat.y().format(DateTime.parse(expiredProperties['end_date']))}",
                        style: Palette.bestText3,
                      ),
                    ],
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
                              .getAdvanceBookinReciept1(expiredProperties['id']);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ViewReceipt(
                          //               code: expiredProperties['code'],
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
}
