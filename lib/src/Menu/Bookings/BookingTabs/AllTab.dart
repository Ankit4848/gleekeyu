import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Menu/Bookings/Booking%20Card/bookingAllCard.dart';
import 'package:gleekeyu/src/Menu/Bookings/bookings_controller.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/utils/style/palette.dart';

import 'package:gleekeyu/widgets/Shimmer/property_shimmer.dart';

class AllTab extends StatelessWidget {
  const AllTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingsController>(
      initState: (a) {},
      builder: (a) {
        return a.isDataLoaded
            ? a.allBookings.isNotEmpty
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Your Trips",
                          style: Palette.bestText,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: a.allBookings.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: ((context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BookingAllCard(
                                    allBookings: a.allBookings[index],
                                  ),
                                  index != a.allBookings.length - 1
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
                  return const SizedBox(
                    height: 24,
                  );
                },
                itemCount: 3,
                itemBuilder: ((context, index) {
                  return const PropertyShimmer();
                }));
      },
    );
  }
}
