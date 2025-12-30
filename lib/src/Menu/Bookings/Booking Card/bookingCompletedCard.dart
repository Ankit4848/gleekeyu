// ignore_for_file: depend_on_referenced_packages, file_names, must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:gleekeyu/extras/commonWidget.dart';
import 'package:gleekeyu/src/Menu/Bookings/bookings_controller.dart';
import 'package:gleekeyu/widgets/commonText.dart';
import 'package:gleekeyu/widgets/text_fields_widgets/custrom_textfield_paragraph.dart';

import '../../../../utils/baseconstant.dart';
import '../../../../utils/style/constants.dart';
import '../../../../utils/style/palette.dart';
import '../../../../widgets/loder.dart';
import '../../../SubPages/PropertyAllDetails/propertyAllDetails_view.dart';

TextEditingController reviewController = TextEditingController(
    text:
        "The application was great! It was easy to use and had all the features I needed. I would definitely recommend it.");

class BookingCompletedCard extends StatefulWidget {
  var completedBookings;
  BookingCompletedCard({
    required this.completedBookings,
    Key? key,
  }) : super(key: key);

  @override
  State<BookingCompletedCard> createState() => _BookingCompletedCardState();
}

class _BookingCompletedCardState extends State<BookingCompletedCard> {
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
              Get.to(() => PropertyAllDetails(
                  slug: widget.completedBookings['properties']['slug'],
                  startDate:"",
                  endDate: "",
                  fromSearch: false,
                  isPropertyActive: widget.completedBookings['properties']
                              ['property_status'] ==
                          "Inactive"
                      ? false
                      : true,
                  id: widget.completedBookings['properties']['id'].toString()));
            },
            child: Container(
              height: 200,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.completedBookings['properties']
                          ['cover_photo']))),
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
                        color: widget.completedBookings['status'] == "Accepted"
                            ? kGreen
                            : widget.completedBookings['status'] == "Cancelled"
                                ? kRed
                                : kYellow,
                      ),
                      height: 40,
                      child: SizedBox(
                        width: 80,
                        child: Center(
                          child: Text(
                            widget.completedBookings['status'],
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
                    widget.completedBookings['properties']['property_name'],
                    style: Palette.bestText,
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                      widget.completedBookings['properties']['avg_rating']
                          .toString(),
                      style: Palette.bestText1),
                  const Icon(
                    Icons.star_rounded,
                    color: kOrange,
                    size: 18,
                  ),
                  Text(
                      "(${widget.completedBookings['properties']['reviews_count'].toString()})",
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
                    (widget.completedBookings['code']).toString(),
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
                        DateTime.parse(widget.completedBookings['created_at'])),
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
                                "${DateFormat.d().format(DateTime.parse(widget.completedBookings['start_date']))} ${DateFormat.MMM().format(DateTime.parse(widget.completedBookings['start_date']))} ${DateFormat.y().format(DateTime.parse(widget.completedBookings['start_date']))}",
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
                              "${DateFormat.d().format(DateTime.parse(widget.completedBookings['end_date']))} ${DateFormat.MMM().format(DateTime.parse(widget.completedBookings['end_date']))} ${DateFormat.y().format(DateTime.parse(widget.completedBookings['end_date']))}",
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
                              widget.completedBookings['id']);
                        },
                        name: "View & Manage Booking")),
              ),
              const SizedBox(
                width: 8,
              ),
              if(widget.completedBookings['customer_inv']==1)
              SizedBox(
                height: 45,
                child: CommonButton(
                  onPressed: () async {
                    loaderShow(context);
                    await getController.getAdvanceBookinReciept(
                        widget.completedBookings['id'],
                        endPoints: EndPoint.userInvoice);
                  },
                  name: "Invoice",
                ),
              ),
              if(widget.completedBookings['customer_inv'].toString()=="true")
              SizedBox(
                height: 45,
                child: CommonButton(
                  onPressed: () async {
                    loaderShow(context);
                    await getController.getAdvanceBookinReciept(
                        widget.completedBookings['id'],
                        endPoints: EndPoint.userInvoice);
                  },
                  name: "Invoice",
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}

Future<dynamic> BtmReviewSheet(BuildContext context) {
  return showModalBottomSheet(
      isScrollControlled: true,
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
                topRight: Radius.circular(30),
              ),
            ),
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
                    text: "Leave a Review",
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
                        text: "How Your Experience with \nLonavala Resort",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_border_rounded,
                        size: 46,
                        color: kOrange,
                      ),
                      Icon(
                        Icons.star_border_rounded,
                        size: 46,
                        color: kOrange,
                      ),
                      Icon(
                        Icons.star_border_rounded,
                        size: 46,
                        color: kOrange,
                      ),
                      Icon(
                        Icons.star_border_rounded,
                        size: 46,
                        color: kOrange,
                      ),
                      Icon(
                        Icons.star_border_rounded,
                        size: 46,
                        color: kOrange,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: kBlack.withOpacity(0.4),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: commonText(
                      color: kBlack,
                      fontSize: 15,
                      text: "  Write Your Review",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    height: 120,
                    child: CustomTextfieldPara(
                        controller: reviewController, label: "", hint: ""),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 0,
                      right: 0,
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
                                color: kOrangeLite,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              height: 45,
                              child: Center(
                                child: commonText(
                                  textAlign: TextAlign.center,
                                  color: kOrange,
                                  fontSize: 12,
                                  text: "Maybe Later",
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
                                  text: "Submit",
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
