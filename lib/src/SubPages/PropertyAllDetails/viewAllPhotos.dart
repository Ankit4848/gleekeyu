import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/SubPages/PropertyAllDetails/propertyAllDetails_controller.dart';
import 'package:gleekeyu/src/SubPages/appBarWithTitleAndBack.dart';
import 'package:gleekeyu/utils/style/constants.dart';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:gleekeyu/widgets/cNetworkImage.dart';

class ViewAllPhotos extends StatelessWidget {
  const ViewAllPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    PropertyAllDetailsController a = Get.find();
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBarWithTitleAndBack(title: "Property Photos"),
      body: SingleChildScrollView(
        child: StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children:
                List.generate(a.PropertyData!.propertyPhotos!.length, ((index) {
              return Bounce(
                onPressed: () {
                  MultiImageProvider multiImageProvider = MultiImageProvider(
                      List.generate(a.PropertyData!.propertyPhotos!.length,
                          ((index) {
                        return Image(
                            image: CachedNetworkImageProvider(
                          a.PropertyData!.propertyPhotos![index].image,
                        )).image;
                      })),
                      initialIndex: index);
                  showImageViewerPager(context, multiImageProvider,
                      swipeDismissible: false,
                      doubleTapZoomable: true,
                      immersive: false,
                      useSafeArea: true);
                },
                duration: const Duration(milliseconds: 200),
                child: cNetworkImage(
                  a.PropertyData!.propertyPhotos![index].image,
                  fit: BoxFit.cover,
                ),
              );
            }))),
      ),
    );
  }
}
