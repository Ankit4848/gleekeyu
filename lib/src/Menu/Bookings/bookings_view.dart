import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Menu/Bookings/BookingTabs/AllTab.dart';
import 'package:gleekeyu/src/Menu/Bookings/BookingTabs/cancelledTab.dart';
import 'package:gleekeyu/src/Menu/Bookings/BookingTabs/compltedTab.dart';
import 'package:gleekeyu/src/Menu/Bookings/BookingTabs/inqTab.dart';
import 'package:gleekeyu/src/Menu/Bookings/BookingTabs/onGoingTab.dart';
import 'package:gleekeyu/src/Menu/Bookings/BookingTabs/upcomingTab.dart';
import 'package:gleekeyu/src/Menu/Bookings/bookings_controller.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/utils/style/palette.dart';

import 'BookingTabs/reviewTab.dart';

late TabController _controller;
List<String> tabNames = [
  "All",
  "Ongoing Trips",
  "Completed Trips",
  "Upcoming Trips",
  "Canceled Trips",
  "Inquires",
  "Review",
];
List<Widget> bookingTabs = [
  const AllTab(),
  const OnGoingtab(),
  const CompletedTab(),
  const UpcomingTab(),
  const CencelledTab(),
  const InqTab(),
  ReviewTab(),
];

class Bookings extends StatefulWidget {
  const Bookings({Key? key}) : super(key: key);

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> with TickerProviderStateMixin {
  BookingsController getController = Get.find();
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabNames.length, vsync: this);
    getController.tabCurrIndex = _controller.index;
    getController.update();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: kWhite,
        shadowColor: kWhite,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "My Booking",
              style: Palette.headerText,
            ),
          ],
        ),
        bottom: TabBar(
          // physics: const NeverScrollableScrollPhysics(),

          indicatorColor: kWhite,
          controller: _controller,
          onTap: (index) {
            _controller.index = index;
            getController.tabCurrIndex = index;
            getController.update();
          },
          padding: const EdgeInsets.only(left: 8),
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          tabs: tabs,
          dividerColor: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
        child: GetBuilder<BookingsController>(builder: (getController) {
          return TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _controller,
              children: bookingTabs);
        }),
      ),
    );
  }
}

var tabs = List.generate(
  tabNames.length,
  ((index) {
    return GetBuilder<BookingsController>(
      initState: (a) {},
      builder: (a) {
        return Container(
          height: 40,
          decoration: BoxDecoration(
            border: a.tabCurrIndex == index ? Border.all(color: kOrange) : null,
            borderRadius: BorderRadius.circular(6),
            boxShadow: a.tabCurrIndex == index
                ? null
                : [
                    BoxShadow(
                      blurRadius: 4,
                      spreadRadius: 1,
                      color: kBlack.withOpacity(0.2),
                    )
                  ],
            color: a.tabCurrIndex == index ? kOrange.withOpacity(0.2) : kWhite,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                index==6?"${tabNames[index]}": "${tabNames[index]} (${index == 0 ? a.allBookings.length : index == 1 ? a.onGoingBookings.length : index == 2 ? a.completedBookings.length : index == 3 ? a.upcomingBookings.length :  index == 4 ? a.canceledBookings.length : a.inquiryStatusBookings.length})",
                maxLines: 1,
                style: a.tabCurrIndex == index
                    ? Palette.bookingTabSelected
                    : Palette.bookingTabunSelected,
              ),
            ),
          ),
        );
      },
    );
  }),
);
