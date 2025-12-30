// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Menu/Bookings/bookings_controller.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/src/Menu/Bookings/Booking%20Card/bookingCompletedCard.dart';
import 'package:gleekeyu/widgets/Shimmer/property_shimmer.dart';

import '../../../../utils/style/palette.dart';

class CompletedTab extends StatelessWidget {
  const CompletedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingsController>(
      initState: (a) {},
      builder: (a) {
        return a.isDataLoaded
            ? a.completedBookings.isNotEmpty
                ? SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Completed",
                          style: Palette.bestText,
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: a.completedBookings.length,
                            itemBuilder: ((context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BookingCompletedCard(
                                    completedBookings:
                                        a.completedBookings[index],
                                  ),
                                  index != a.completedBookings.length - 1
                                      ? const Divider(
                                          color: kDarkGrey,
                                          height: 1,
                                        )
                                      : const SizedBox()
                                ],
                              );
                            })),
                      ],
                    ),
                  )
                : Center(
                    child: Image.asset("assets/images/noData.png", cacheHeight: 500,
                      cacheWidth: 500,),
                  )
            : ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 24,
                  );
                },
                itemCount: 3,
                itemBuilder: ((context, index) {
                  return PropertyShimmer();
                }));
      },
    );
  }
}
