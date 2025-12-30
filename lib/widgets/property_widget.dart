// ignore_for_file: must_be_immutable, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:gleekeyu/extras/app_colors.dart';

import '../src/Menu/DashBoard/dashBoard_model.dart';
import '../src/Menu/WishList/AddWishList_Widget/addWishlist_controller.dart';
import '../src/Menu/WishList/AddWishList_Widget/addWishlist_view.dart';
import '../src/SubPages/PropertyAllDetails/propertyAllDetails_view.dart';
import '../utils/style/constants.dart';
import '../utils/style/palette.dart';
import 'cNetworkImage.dart';
import 'commonText.dart';

bool isTodayDateInRange(DateTime startDate, DateTime endDate) {
  DateTime today = DateFormat(
    'yyyy-MM-dd',
  ).parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

  return (today == startDate || endDate == today) ||
      (today.isAfter(startDate) && today.isBefore(endDate));
}

class Property extends StatefulWidget {
  Properties properties;
  bool fromSearch;

  Property({super.key, required this.fromSearch, required this.properties});

  @override
  State<Property> createState() => _PropertyState();
}

class _PropertyState extends State<Property> {
  WishlistController getController = Get.find();

  @override
  void initState() {
    if (widget.properties.wishlist != null) {
      widget.properties.wishlist!
          ? getController.wishlistedID.add(widget.properties.id)
          : null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 150),
      onPressed: (() {
        Get.to(
          () => PropertyAllDetails(
            slug: widget.properties.slug!,
            fromSearch: widget.fromSearch,
            startDate: "",
            endDate: "",
            isPropertyActive:
                widget.properties.propertyStatus != "Inactive" ? true : false,
            id: widget.properties.id.toString(),
          ),
        );
      }),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.47,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFFFF7F4).withOpacity(0.9),
          border: Border.all(color: AppColors.colorFE6927.withOpacity(0.1)),
          //  const Color(0xFFFFF7F4),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: cNetworkImage(
                      widget.properties.coverPhoto!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Container(
                            color: kOrange,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              child: commonText(
                                text:
                                    widget.properties.propertyStatus ==
                                            "Inactive"
                                        ? "BOOKED"
                                        : widget.properties.propertyTypeName
                                            .toString()
                                            .toUpperCase(),
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),

                          if ((widget.properties.noOfDiscountBooking != null) &&
                                  ((widget.properties.totalBooking ?? 500) -
                                          500) <
                                      int.parse(
                                        widget.properties.noOfDiscountBooking,
                                      ) ||
                              (widget.properties.offerEnd != null &&
                                  isTodayDateInRange(
                                    DateFormat(
                                      'yyyy-MM-dd',
                                    ).parse(widget.properties.offerStart),
                                    DateFormat(
                                      'yyyy-MM-dd',
                                    ).parse(widget.properties.offerEnd),
                                  )))
                            Container(
                              color: kOrange,
                              margin: EdgeInsets.only(top: 10),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 6,
                                  right: 6,
                                ),
                                child: commonText(
                                  text: "Offer",
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),

                          const SizedBox(height: 10),

                          Container(
                            color: kOrange,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              child: commonText(
                                text:
                                    widget.properties.propertyCategory !=
                                            "normal"
                                        ? "Request To Book"
                                        : "Instant Booking",
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, right: 8),
                        child: addWishlistWidget(
                          PropertyID: widget.properties.id,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 10, 15, 6),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(
                      widget.properties.propertyName ?? "",
                      style: Palette.bestText.copyWith(fontSize: 12),
                    ),
                    const Spacer(),
                    // Image.asset(
                    //   "assets/images/star_icon.png",

                    //   color: kOrange,
                    //   width: 14,
                    //   height: 14,
                    // ),
                    // const SizedBox(width: 5),
                    // Text(
                    //   widget.properties.avgRating.toString(),
                    //   style: Palette.bestText1.copyWith(fontSize: 11),
                    // ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 15, 5),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: kBlack, size: 18),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      "Near ${widget.properties.propertyAddress?.city ?? ""}, ${widget.properties.propertyAddress?.state ?? ""}- ${widget.properties.propertyAddress?.postalCode ?? ""}, ${widget.properties.propertyAddress?.country ?? ""}",
                      style: Palette.bestText2.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 15, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      if ((widget.properties.noOfDiscountBooking != null) &&
                          ((widget.properties.totalBooking ?? 500) - 500) <
                              int.parse(
                                widget.properties.noOfDiscountBooking,
                              )) ...{
                        Text(
                          "${format.format((widget.properties.propertyDates != null && widget.properties.propertyDates!.isNotEmpty) ? widget.properties.propertyDates!.first.price ?? widget.properties.propertyPrice!.price!.toInt() : widget.properties.propertyPrice!.price!.toInt())} ",
                          // "${widget.properties.propertyPrice!.price!.toInt()} ",
                          style: Palette.bestText3.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          " ${format.format(widget.properties.propertyPrice!.discountPrice!.toInt())}*",
                          // "${widget.properties.propertyPrice!.discountPrice}*",
                          style: Palette.paymentBlack13.copyWith(
                            fontSize: 11,
                            color: AppColors.color32BD01,
                          ),
                        ),
                      } else if (widget.properties.offerStatus != null &&
                          widget.properties.offerStatus != '1' &&
                          widget.properties.offerPercentage != null &&
                          isTodayDateInRange(
                            DateFormat(
                              'yyyy-MM-dd',
                            ).parse(widget.properties.offerStart),
                            DateFormat(
                              'yyyy-MM-dd',
                            ).parse(widget.properties.offerEnd),
                          )) ...{
                        Text(
                          "${format.format((widget.properties.propertyDates != null && widget.properties.propertyDates!.isNotEmpty) ? widget.properties.propertyDates!.first.price ?? widget.properties.propertyPrice!.price!.toInt() : widget.properties.propertyPrice!.price!.toInt())} ",
                          // "${widget.properties.propertyPrice!.price!.toInt()} ",
                          style: Palette.bestText3.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          "${format.format(((int.parse((widget.properties.propertyPrice!.price ?? '0').toString())) - ((int.parse((widget.properties.propertyPrice!.price ?? '0').toString()) * int.parse((widget.properties.offerPercentage ?? '0').toString())) / 100)).customRound())}*",
                          style: Palette.paymentBlack13.copyWith(
                            fontSize: 12,
                            color: AppColors.color32BD01,
                          ),
                        ),
                      } else ...{
                        Text(
                          "${format.format((widget.properties.propertyDates != null && widget.properties.propertyDates!.isNotEmpty) ? widget.properties.propertyDates!.first.price ?? widget.properties.propertyPrice!.price!.toInt() : widget.properties.propertyPrice!.price!.toInt())}*",
                          // "${widget.properties.propertyPrice!.price!.toInt()}*",
                          style: Palette.paymentBlack13.copyWith(fontSize: 12),
                        ),
                      },

                      Text(
                        '/- per night',
                        style: Palette.paymentBlack13.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  if (((widget.properties.propertyDates != null &&
                              widget.properties.propertyDates!.isNotEmpty)
                          ? widget.properties.propertyDates!.first.minDay ?? 1
                          : widget.properties.minStay ??
                              widget.properties.minDay ??
                              1) >
                      1)
                    Text(
                      '(Minimum Stay ${(widget.properties.propertyDates != null && widget.properties.propertyDates!.isNotEmpty) ? widget.properties.propertyDates!.first.minDay ?? 1 : widget.properties.minStay ?? widget.properties.minDay ?? 1} nights)',
                      style: Palette.paymentBlack13.copyWith(
                        fontSize: 12,
                        color: kOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            if (((widget.properties.offerEnd != null &&
                widget.properties.offerStatus != '1' &&
                isTodayDateInRange(
                  DateFormat('yyyy-MM-dd').parse(widget.properties.offerStart),
                  DateFormat('yyyy-MM-dd').parse(widget.properties.offerEnd),
                ))))
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 15, 10),
                child: Row(
                  children: [
                    Text(
                      'Offer Valid till  ',
                      style: Palette.bestText2.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      // widget.properties.offerEnd,
                      // "(${(DateFormat('dd-MM-yyyy').format(DateFormat('dd-MM-yyyy').parse(widget.properties.offerEnd)))})",
                      "(${formatDate(DateFormat('yyyy-MM-dd').parse(widget.properties.offerEnd))})",
                      style: Palette.bestText2.copyWith(
                        color: AppColors.colorFE6927,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            Visibility(
              visible: widget.properties.propertyStatus != "Inactive",
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2, 0, 10, 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Bounce(
                          onPressed: () {
                            Get.to(
                              () => PropertyAllDetails(
                                slug: widget.properties.slug!,
                                fromSearch: widget.fromSearch,

                                startDate: "",
                                endDate: "",
                                isPropertyActive:
                                    widget.properties.propertyStatus ==
                                            "Inactive"
                                        ? false
                                        : true,
                                id: widget.properties.id.toString(),
                              ),
                            );
                          },
                          duration: const Duration(milliseconds: 200),
                          child: Card(
                            elevation: 3,
                            shape: Palette.cardShape,
                            color: kOrange,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  'Book Now',
                                  style: Palette.bestText4,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 21,
                        backgroundColor: kOrange.withOpacity(0.3),
                        child: Image.asset(
                          "assets/images/grup_icon.png",

                          color: kOrange,
                          width: 19,
                          height: 19,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyVertical extends StatefulWidget {
  Properties properties;
  bool fromSearch;
  String startDate;
  String endDate;

  PropertyVertical({
    super.key,
    required this.fromSearch,
    required this.startDate,
    required this.endDate,
    required this.properties,
  });

  @override
  State<PropertyVertical> createState() => _PropertyVerticalState();
}

class _PropertyVerticalState extends State<PropertyVertical> {
  WishlistController getController = Get.put(WishlistController());

  @override
  void initState() {
    if (widget.properties.wishlist != null) {
      widget.properties.wishlist!
          ? getController.wishlistedID.add(widget.properties.id)
          : null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 150),
      onPressed: (() {
        Get.to(
          () => PropertyAllDetails(
            slug: widget.properties.slug!,
            fromSearch: widget.fromSearch,
            startDate: widget.startDate,
            endDate: widget.endDate,
            isPropertyActive:
                widget.properties.propertyStatus != "Inactive" ? true : false,
            id: widget.properties.id.toString(),
          ),
        );
      }),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFFFF7F4).withOpacity(0.9),
          border: Border.all(color: AppColors.colorFE6927.withOpacity(0.1)),
          //  const Color(0xFFFFF7F4),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: cNetworkImage(
                      widget.properties.coverPhoto!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Container(
                            color: kOrange,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              child: commonText(
                                text:
                                    widget.properties.propertyStatus ==
                                            "Inactive"
                                        ? "BOOKED"
                                        : widget.properties.propertyTypeName
                                            .toString()
                                            .toUpperCase(),
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          if ((widget.properties.noOfDiscountBooking != null) &&
                                  ((widget.properties.totalBooking ?? 500) -
                                          500) <
                                      int.parse(
                                        widget.properties.noOfDiscountBooking,
                                      ) ||
                              (widget.properties.offerEnd != null &&
                                  isTodayDateInRange(
                                    DateFormat(
                                      'yyyy-MM-dd',
                                    ).parse(widget.properties.offerStart),
                                    DateFormat(
                                      'yyyy-MM-dd',
                                    ).parse(widget.properties.offerEnd),
                                  )))
                            const SizedBox(height: 10),
                          if ((widget.properties.noOfDiscountBooking != null) &&
                                  ((widget.properties.totalBooking ?? 500) -
                                          500) <
                                      int.parse(
                                        widget.properties.noOfDiscountBooking,
                                      ) ||
                              (widget.properties.offerEnd != null &&
                                  isTodayDateInRange(
                                    DateFormat(
                                      'yyyy-MM-dd',
                                    ).parse(widget.properties.offerStart),
                                    DateFormat(
                                      'yyyy-MM-dd',
                                    ).parse(widget.properties.offerEnd),
                                  )))
                            Container(
                              color: kOrange,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 6,
                                  right: 6,
                                ),
                                child: commonText(
                                  text: "Offer",
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),

                          const SizedBox(height: 10),

                          Container(
                            color: kOrange,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              child: commonText(
                                text:
                                    widget.properties.propertyCategory !=
                                            "normal"
                                        ? "Request To Book"
                                        : "Instant Booking",

                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, right: 8),
                        child: addWishlistWidget(
                          PropertyID: widget.properties.id,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 10, 15, 6),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(
                      widget.properties.propertyName ?? "",
                      style: Palette.bestText.copyWith(fontSize: 12),
                    ),
                    const Spacer(),
                    Image.asset(
                      "assets/images/star_icon.png",

                      color: kOrange,
                      width: 14,
                      height: 14,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.properties.avgRating.toString(),
                      style: Palette.bestText1.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 15, 5),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: kBlack, size: 18),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      "Near ${widget.properties.propertyAddress?.city ?? ""}, ${widget.properties.propertyAddress?.state ?? ""}- ${widget.properties.propertyAddress?.postalCode ?? ""}, ${widget.properties.propertyAddress?.country ?? ""}",
                      style: Palette.bestText2.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Text(
                      //   'Price ',
                      //   style: Palette.bestText2.copyWith(
                      //       color: Colors.grey.shade600,
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 11),
                      // ),
                      if ((widget.properties.noOfDiscountBooking != null) &&
                          ((widget.properties.totalBooking ?? 500) - 500) <
                              int.parse(
                                widget.properties.noOfDiscountBooking,
                              )) ...{
                        Text(
                          "${format.format((widget.properties.propertyDates != null && widget.properties.propertyDates!.isNotEmpty) ? widget.properties.propertyDates!.first.price ?? widget.properties.propertyPrice!.price!.toInt() : widget.properties.propertyPrice!.price!.toInt())} ",
                          // "${widget.properties.propertyPrice!.price!.toInt()} ",
                          style: Palette.bestText3.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          " ${format.format(widget.properties.propertyPrice!.discountPrice!.toInt())}*",
                          // "${widget.properties.propertyPrice!.discountPrice}*",
                          style: Palette.paymentBlack13.copyWith(
                            fontSize: 11,
                            color: AppColors.color32BD01,
                          ),
                        ),
                      } else if (widget.properties.offerStatus != null &&
                          widget.properties.offerStatus != '1' &&
                          widget.properties.offerPercentage != null &&
                          isTodayDateInRange(
                            DateFormat(
                              'yyyy-MM-dd',
                            ).parse(widget.properties.offerStart),
                            DateFormat(
                              'yyyy-MM-dd',
                            ).parse(widget.properties.offerEnd),
                          )) ...{
                        Text(
                          "${format.format((widget.properties.propertyDates != null && widget.properties.propertyDates!.isNotEmpty) ? widget.properties.propertyDates!.first.price ?? widget.properties.propertyPrice!.price!.toInt() : widget.properties.propertyPrice!.price!.toInt())} ",
                          // "${widget.properties.propertyPrice!.price!.toInt()} ",
                          style: Palette.bestText3.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          "${format.format(((int.parse((widget.properties.propertyPrice!.price ?? '0').toString())) - ((int.parse((widget.properties.propertyPrice!.price ?? '0').toString()) * int.parse((widget.properties.offerPercentage ?? '0').toString())) / 100)).customRound())}*",
                          style: Palette.paymentBlack13.copyWith(
                            fontSize: 12,
                            color: AppColors.color32BD01,
                          ),
                        ),
                      } else ...{
                        Text(
                          "${format.format((widget.properties.propertyDates != null && widget.properties.propertyDates!.isNotEmpty) ? widget.properties.propertyDates!.first.price ?? widget.properties.propertyPrice!.price!.toInt() : widget.properties.propertyPrice!.price!.toInt())}*",
                          // "${widget.properties.propertyPrice!.price!.toInt()}*",
                          style: Palette.paymentBlack13.copyWith(fontSize: 12),
                        ),
                      },
                      Text(
                        '/- per night',
                        style: Palette.paymentBlack13.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  if (((widget.properties.propertyDates != null &&
                              widget.properties.propertyDates!.isNotEmpty)
                          ? widget.properties.propertyDates!.first.minDay ?? 1
                          : widget.properties.minStay ??
                              widget.properties.minDay ??
                              1) >
                      1)
                    Text(
                      '(Minimum Stay ${(widget.properties.propertyDates != null && widget.properties.propertyDates!.isNotEmpty) ? widget.properties.propertyDates!.first.minDay ?? 1 : widget.properties.minStay ?? widget.properties.minDay ?? 1} nights)',
                      style: Palette.paymentBlack13.copyWith(
                        fontSize: 12,
                        color: kOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            if (((widget.properties.offerEnd != null &&
                widget.properties.offerStatus != '1' &&
                isTodayDateInRange(
                  DateFormat('yyyy-MM-dd').parse(widget.properties.offerStart),
                  DateFormat('yyyy-MM-dd').parse(widget.properties.offerEnd),
                ))))
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 15, 10),
                child: Row(
                  children: [
                    Text(
                      'Offer Valid till  ',
                      style: Palette.bestText2.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      // widget.properties.offerEnd,
                      // "(${(DateFormat('dd-MM-yyyy').format(DateFormat('dd-MM-yyyy').parse(widget.properties.offerEnd)))})",
                      "(${formatDate(DateFormat('yyyy-MM-dd').parse(widget.properties.offerEnd))})",
                      style: Palette.bestText2.copyWith(
                        color: AppColors.colorFE6927,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            Visibility(
              visible: widget.properties.propertyStatus != 'Inactive',
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2, 0, 10, 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Bounce(
                          onPressed: () {
                            Get.to(
                              () => PropertyAllDetails(
                                slug: widget.properties.slug!,
                                fromSearch: widget.fromSearch,

                                startDate: widget.startDate,
                                endDate: widget.endDate,
                                isPropertyActive:
                                    widget.properties.propertyStatus !=
                                            "Inactive"
                                        ? true
                                        : false,
                                id: widget.properties.id.toString(),
                              ),
                            );
                          },
                          duration: const Duration(milliseconds: 200),
                          child: Card(
                            elevation: 3,
                            shape: Palette.cardShape,
                            color: kOrange,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  'Book Now',
                                  style: Palette.bestText4,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 21,
                        backgroundColor: kOrange.withOpacity(0.3),
                        child: Image.asset(
                          "assets/images/grup_icon.png",

                          color: kOrange,
                          width: 19,
                          height: 19,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatDate(DateTime date) {
  // Format the date
  String formattedDate = DateFormat('dd MMM y').format(date);

  // Add the suffix to the day
  formattedDate = formattedDate.replaceFirst(
    " ",
    "${_daySuffix(int.parse(formattedDate.split(" ")[0]))} ",
  );
  formattedDate = formattedDate.replaceFirstMapped(
    RegExp(r'(\d+)(st|nd|rd|th)'),
    (match) =>
        '${match.group(1)}${_daySuffix(int.parse(match.group(1) ?? ''))}',
  );

  return formattedDate;
}

String _daySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

String htmlSymbol(String input) {
  List<String> parts = input.split(RegExp(r'[x;]'));
  String Symbol = String.fromCharCode(int.parse(parts[1], radix: 16));
  return Symbol; // "Amount: 200"
}

String htmlPrice(String input) {
  List<String> parts = input.split(RegExp(r'[ ]'));
  return parts[1];
}

class GleekeyChoicePropertyWidget extends StatefulWidget {
  Properties properties;

  GleekeyChoicePropertyWidget({super.key, required this.properties});

  @override
  State<GleekeyChoicePropertyWidget> createState() =>
      _GleekeyChoicePropertyWidgetState();
}

class _GleekeyChoicePropertyWidgetState
    extends State<GleekeyChoicePropertyWidget> {
  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 150),
      onPressed: (() {
        Get.to(
          () => PropertyAllDetails(
            slug: widget.properties.slug!,
            fromSearch: false,
            startDate: "",
            endDate: "",
            isPropertyActive:
                widget.properties.propertyStatus != "Inactive" ? true : false,
            id: widget.properties.id.toString(),
          ),
        );
      }),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFFFF7F4).withOpacity(0.9),
          border: Border.all(color: AppColors.colorFE6927.withOpacity(0.1)),
          //  const Color(0xFFFFF7F4),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width / 2.7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: cNetworkImage(
                      widget.properties.coverPhoto!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Container(
                            color: kOrange,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              child: commonText(
                                text:
                                    widget.properties.propertyStatus ==
                                            "Inactive"
                                        ? "BOOKED"
                                        : widget.properties.propertyTypeName
                                            .toString()
                                            .toUpperCase(),
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),

                          if ((widget.properties.noOfDiscountBooking != null) &&
                                  ((widget.properties.totalBooking ?? 500) -
                                          500) <
                                      int.parse(
                                        widget.properties.noOfDiscountBooking,
                                      ) ||
                              (widget.properties.offerEnd != null &&
                                  isTodayDateInRange(
                                    DateFormat(
                                      'yyyy-MM-dd',
                                    ).parse(widget.properties.offerStart),
                                    DateFormat(
                                      'yyyy-MM-dd',
                                    ).parse(widget.properties.offerEnd),
                                  )))
                            Container(
                              color: kOrange,
                              margin: EdgeInsets.only(top: 10),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 6,
                                  right: 6,
                                ),
                                child: commonText(
                                  text: "Offer",
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),

                          const SizedBox(height: 10),

                          Container(
                            color: kOrange,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              child: commonText(
                                text:
                                    widget.properties.propertyCategory !=
                                            "normal"
                                        ? "Request To Book"
                                        : "Instant Booking",
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, right: 8),
                        child: addWishlistWidget(
                          PropertyID: widget.properties.id,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 10, 8, 6),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 6,
                            child: SizedBox(
                              width: Get.width / 2,
                              child: Text(
                                "${widget.properties.propertyName ?? 'GLEEKEYFARMHOUSE'}",
                                style: Palette.bestText.copyWith(fontSize: 11),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          // Expanded(
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.end,
                          //     children: [
                          //       Image.asset(
                          //         "assets/images/star_icon.png",

                          //         color: kOrange,
                          //         width: 12,
                          //         height: 12,
                          //       ),
                          //       const SizedBox(width: 2),
                          //       Text(
                          //         widget.properties.avgRating.toString(),
                          //         style: Palette.bestText1.copyWith(
                          //           fontSize: 10,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 15, 5),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: kBlack, size: 18),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            "Near ${widget.properties.propertyAddress?.city ?? ""}, ${widget.properties.propertyAddress?.state ?? ""}- ${widget.properties.propertyAddress?.postalCode ?? ""}, ${widget.properties.propertyAddress?.country ?? ""}",
                            style: Palette.bestText2.copyWith(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 15, 10),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            if ((widget.properties.noOfDiscountBooking !=
                                    null) &&
                                ((widget.properties.totalBooking ?? 500) -
                                        500) <
                                    int.parse(
                                      widget.properties.noOfDiscountBooking,
                                    )) ...{
                              Text(
                                "${format.format((widget.properties.propertyDates != null && widget.properties.propertyDates!.isNotEmpty) ? widget.properties.propertyDates!.first.price ?? widget.properties.propertyPrice!.price!.toInt() : widget.properties.propertyPrice!.price!.toInt())} ",
                                // "${widget.properties.propertyPrice!.price!.toInt()} ",
                                style: Palette.bestText3.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                " ${format.format(widget.properties.propertyPrice!.discountPrice!.toInt())}*",
                                // "${widget.properties.propertyPrice!.discountPrice}*",
                                style: Palette.paymentBlack13.copyWith(
                                  fontSize: 11,
                                  color: AppColors.color32BD01,
                                ),
                              ),
                            } else if (widget.properties.offerStatus != null &&
                                widget.properties.offerStatus != '1' &&
                                widget.properties.offerPercentage != null &&
                                isTodayDateInRange(
                                  DateFormat(
                                    'yyyy-MM-dd',
                                  ).parse(widget.properties.offerStart),
                                  DateFormat(
                                    'yyyy-MM-dd',
                                  ).parse(widget.properties.offerEnd),
                                )) ...{
                              Text(
                                "${format.format((widget.properties.propertyDates != null && widget.properties.propertyDates!.isNotEmpty) ? widget.properties.propertyDates!.first.price ?? widget.properties.propertyPrice!.price!.toInt() : widget.properties.propertyPrice!.price!.toInt())} ",
                                // "${widget.properties.propertyPrice!.price!.toInt()} ",
                                style: Palette.bestText3.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                "${format.format(((int.parse((widget.properties.propertyPrice!.price ?? '0').toString())) - ((int.parse((widget.properties.propertyPrice!.price ?? '0').toString()) * int.parse((widget.properties.offerPercentage ?? '0').toString())) / 100)).customRound())}*",
                                style: Palette.paymentBlack13.copyWith(
                                  fontSize: 12,
                                  color: AppColors.color32BD01,
                                ),
                              ),
                            } else ...{
                              Text(
                                "${format.format((widget.properties.propertyDates != null && widget.properties.propertyDates!.isNotEmpty) ? widget.properties.propertyDates!.first.price ?? widget.properties.propertyPrice!.price!.toInt() : widget.properties.propertyPrice!.price!.toInt())}*",
                                // "${widget.properties.propertyPrice!.price!.toInt()}*",
                                style: Palette.paymentBlack13.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            },
                            Text(
                              '/- per night',
                              style: Palette.paymentBlack13.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (((widget.properties.propertyDates != null &&
                              widget.properties.propertyDates!.isNotEmpty)
                          ? widget.properties.propertyDates!.first.minDay ?? 1
                          : widget.properties.minDay ?? 1) >
                      1)
                    Text(
                      '(Minimum Stay ${(widget.properties.propertyDates != null && widget.properties.propertyDates!.isNotEmpty) ? widget.properties.propertyDates!.first.minDay ?? 1 : widget.properties.minDay ?? 1} nights)',
                      style: Palette.paymentBlack13.copyWith(
                        fontSize: 12,
                        color: kOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (widget.properties.offerEnd != null &&
                      widget.properties.offerStatus != '1' &&
                      isTodayDateInRange(
                        DateFormat(
                          'yyyy-MM-dd',
                        ).parse(widget.properties.offerStart),
                        DateFormat(
                          'yyyy-MM-dd',
                        ).parse(widget.properties.offerEnd),
                      ))
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 15, 10),
                      child: Row(
                        children: [
                          Text(
                            'Offer Valid till  ',
                            style: Palette.bestText2.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            // widget.properties.offerEnd,
                            // "(${(DateFormat('dd-MM-yyyy').format(DateFormat('dd-MM-yyyy').parse(widget.properties.offerEnd)))})",
                            "(${formatDate(DateFormat('yyyy-MM-dd').parse(widget.properties.offerEnd))})",
                            style: Palette.bestText2.copyWith(
                              color: AppColors.colorFE6927,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Visibility(
                    visible: widget.properties.propertyStatus != "Inactive",
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 10, 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Bounce(
                                onPressed: () {
                                  Get.to(
                                    () => PropertyAllDetails(
                                      slug: widget.properties.slug!,
                                      fromSearch: false,
                                      startDate: "",
                                      endDate: "",
                                      isPropertyActive:
                                          widget.properties.propertyStatus !=
                                                  "Inactive"
                                              ? true
                                              : false,
                                      id: widget.properties.id.toString(),
                                    ),
                                  );
                                },
                                duration: const Duration(milliseconds: 200),
                                child: Card(
                                  elevation: 3,
                                  shape: Palette.cardShape,
                                  color: kOrange,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                      child: Text(
                                        'Book Now',
                                        style: Palette.bestText4,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 21,
                              backgroundColor: kOrange.withOpacity(0.3),
                              child: Image.asset(
                                "assets/images/grup_icon.png",

                                color: kOrange,
                                width: 19,
                                height: 19,
                              ),
                            ),
                          ],
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
    );
  }
}
