import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Menu/Bookings/bookings_controller.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/src/Menu/Bookings/Booking%20Card/bookingCancelledCard.dart';
import 'package:gleekeyu/widgets/Shimmer/property_shimmer.dart';

import '../../../../utils/style/palette.dart';
import '../Booking Card/inquiryStatusBookingsCard.dart';

class InqTab extends StatelessWidget {
  const InqTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingsController>(
      initState: (a) {},
      builder: (a) {
        return a.isDataLoaded
            ? a.inquiryStatusBookings.isNotEmpty
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Cancelled Bookings Trips",
                          style: Palette.bestText,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: a.inquiryStatusBookings.length,
                            itemBuilder: ((context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  inquiryStatusBookingsCard(inquiryStatusBookings: a.inquiryStatusBookings[index],),
                                  index != a.inquiryStatusBookings.length - 1
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
