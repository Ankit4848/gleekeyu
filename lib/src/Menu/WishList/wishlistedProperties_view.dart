import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Menu/WishList/AddWishList_Widget/addWishlist_controller.dart';
import 'package:gleekeyu/src/SubPages/appBarWithTitleAndBack.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/widgets/Shimmer/property_shimmer.dart';
import 'package:gleekeyu/widgets/property_widget.dart';
import 'wishlistedProperties_controller.dart';

class WishlistedProperties extends StatelessWidget {
  const WishlistedProperties({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WishlistedPropertiesController controller=Get.find();
    controller.getApi();

    return GetBuilder<WishlistedPropertiesController>(
      autoRemove: true,
      initState: (a) {},
      builder: (a) {
        return a.isDataLoaded
            ? Scaffold(
                backgroundColor: kWhite,
                appBar: AppBarWithTitleAndBack(
                    title: "Wishlist", backButton: false),
                body: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: a.wishlistedProperties_model!.data!.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: a.wishlistedProperties_model!.data!.length,
                          itemBuilder: ((context, index) {
                            WishlistController getController = Get.find();
                            getController.wishlistedID.contains(a
                                    .wishlistedProperties_model!
                                    .data![index]
                                    .properties!
                                    .id)
                                ? null
                                : getController.wishlistedID.add(a
                                    .wishlistedProperties_model!
                                    .data![index]
                                    .properties!
                                    .id);
                            // getController.update();
                            return PropertyVertical(
                              properties: a.wishlistedProperties_model!
                                  .data![index].properties!,
                              startDate: "",
                              endDate: "",
                              fromSearch: false,
                            );
                          }),
                        )
                      : Center(child: Image.asset("assets/images/noData.png", cacheHeight: 500,
                    cacheWidth: 500,)),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(24),
                child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 24,
                      );
                    },
                    itemCount: 3,
                    itemBuilder: ((context, index) {
                      return const PropertyShimmer();
                    })),
              );
      },
    );
  }
}
