// ignore_for_file: depend_on_referenced_packages, must_be_immutable, non_constant_identifier_names, use_build_context_synchronously, equal_elements_in_set

import 'dart:async';
import 'dart:convert';

// import 'dart:developer';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/extras/app_colors.dart';
import 'package:gleekeyu/services/razorpay_controller.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_view.dart';
import 'package:gleekeyu/src/HomePage/homePage_view.dart';
import 'package:gleekeyu/src/Menu/WishList/AddWishList_Widget/addWishlist_view.dart';
import 'package:gleekeyu/src/SubPages/PropertyAllDetails/propertyAllDetails_controller.dart';
import 'package:gleekeyu/src/SubPages/confirm_n_pay/confirm_n_pay.dart';
import 'package:gleekeyu/src/SubPages/PropertyAllDetails/viewAllPhotos.dart';
import 'package:gleekeyu/src/SubPages/SearchPlaces/searchPlaces_controller.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/utils/style/palette.dart';
import 'package:gleekeyu/widgets/Shimmer/shimmer_box.dart';
import 'package:gleekeyu/widgets/cNetworkImage.dart';
import 'package:gleekeyu/widgets/commonText.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gleekeyu/widgets/loder.dart';
import 'package:gleekeyu/widgets/showSnackBar.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../extras/commonWidget.dart';
import '../../../extras/text_styles.dart';
import '../confirm_n_pay/confirm_n_pay_controller.dart';

final Completer<GoogleMapController> _controller =
    Completer<GoogleMapController>();

class PropertyAllDetails extends StatefulWidget {
  String slug;
  bool isPropertyActive;
  String id;
  String startDate;
  String endDate;
  bool fromSearch;

  PropertyAllDetails({
    Key? key,
    required this.slug,
    required this.id,
    required this.fromSearch,
    required this.startDate,
    required this.endDate,
    required this.isPropertyActive,
  }) : super(key: key);

  @override
  State<PropertyAllDetails> createState() => _PropertyAllDetailsState();
}

class _PropertyAllDetailsState extends State<PropertyAllDetails> {
  PropertyAllDetailsController getController = Get.find();
  RazorPayController getRazorpayController = Get.put(RazorPayController());
  SearchPlacesController as = Get.find();

  @override
  initState() {
    getController.startDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    getController.endDate = DateFormat(
      'dd-MM-yyyy',
    ).format(DateTime.now().add(const Duration(days: 1)));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getController.getApi(widget.slug, widget.id);

      print(getController.PropertyData!.result!.propertyName!);
      print(getController.PropertyData!.result!.accuracyAvgRating!);
      print(getController.PropertyData!.result!.locationAvgRating!);
      print("as.startDate!");

      print(as.startDate!.value.toString());
      print(as.endDate!.value.toString());
      print(widget.startDate);
      print(widget.endDate);

      int guestLimit = int.parse(
        getController.PropertyData!.result!.guest.toString(),
      );
      int adults = int.parse(as.totalAdults.text.toString());
      int children = int.parse(as.totalChildren.text.toString());

      if (widget.fromSearch) {
        if (widget.startDate != "") {
          getController.startDate = widget.startDate;
          as.startDate!.value = widget.startDate;
        }
        if (widget.endDate != "") {
          getController.endDate = widget.endDate;
          as.endDate!.value = widget.endDate;
        }

        if (as.startDate.value != "") {
          getController.startDate = as.startDate!.value;
        }
        if (as.endDate.value != "") {
          getController.endDate = as.endDate!.value;
        }
      }

      int total = adults + children;

      if (total > guestLimit) {
        if (adults >= guestLimit) {
          // Adults alone exceed or equal the guest limit
          as.totalAdults.text = guestLimit.toString();
          as.totalChildren.text = '0';
        } else {
          // Allocate remaining to children
          int remainingForChildren = guestLimit - adults;
          as.totalChildren.text = remainingForChildren.toString();
        }

        // Always set infants to 0
        as.totalInphant.text = '0';
      }

      totalReviews = int.parse(
        getController.PropertyData!.result!.reviewsCount!.toString(),
      );
      overallRating = getController.PropertyData!.result!.avgRating!.toString();
      if (getController.PropertyData!.reviewsFromGuests.length != 0) {
        ratings = {
          "Hygiene standards": double.parse(
            getController.PropertyData!.result!.cleanlinessAvgRating.toString(),
          ),
          "Responsiveness of Host": double.parse(
            getController.PropertyData!.result!.propertyCommunicationAvgRating
                .toString(),
          ),
          "Photos to Reality": double.parse(
            getController.PropertyData!.result!.accuracyAvgRating.toString(),
          ),
          "Neighbourhood & Surroundings": double.parse(
            getController.PropertyData!.result!.locationAvgRating.toString(),
          ),
          "Value for Money": double.parse(
            getController.PropertyData!.result!.valueAvgRating.toString(),
          ),
          "Overall Experience": double.parse(
            getController.PropertyData!.result!.propertyExperienceAvgRating
                .toString(),
          ),
        };
      }
      getController.priceUpdate();
      print(getController.PropertyData!.result!.avgRating!);
    });

    if (!widget.fromSearch) {
      as.totalAdults.text = 1.toString();
      as.totalChildren.text = 0.toString();
      as.totalInphant.text = 0.toString();
    }

    super.initState();
  }

  String overallRating = "0.0";
  int totalReviews = 0;
  Map<String, double> ratings = {
    "Hygiene standards": 0.0,
    "Responsiveness of Host": 0.0,
    "Photos to Reality": 0.0,
    "Neighbourhood & Surroundings": 0.0,
    "Value for Money": 0.0,
    "Overall Experience": 0.0,
  };
  final int rows = 3;
  final int cols = 5;
  List<List<int>> generateZigZagBottomUp() {
    int count = 1;
    int num = 1;
    List<List<int>> matrix = List.generate(rows, (_) => List.filled(cols, 0));

    for (int r = rows - 1; r >= 0; r--) {
      if ((rows - 1 - r) % 2 == 0) {
        // even row index from bottom: left to right
        for (int c = 0; c < cols; c++) {
          matrix[r][c] = num++;
        }
      } else {
        // odd row index from bottom: right to left
        for (int c = cols - 1; c >= 0; c--) {
          matrix[r][c] = num++;
        }
      }
    }

    print(matrix);

    return matrix;
  }

  @override
  Widget build(BuildContext context) {
    print("widget.startDate");
    print(widget.startDate);
    print(widget.endDate);
    generateZigZagBottomUp();
    return Scaffold(
      body: GetBuilder<PropertyAllDetailsController>(
        initState: (a) {},
        builder: (a) {
          return a.isDataLoaded
              ? Stack(
                children: [
                  topContainer(),
                  detailBottomSheet(),
                  reserve(),
                  // a.dateprice != null ? reserve() : const SizedBox.shrink()
                ],
              )
              : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ShimmerBox(250, dwidth),
                    const SizedBox(height: 12),
                    ShimmerBox(16, 200),
                    const SizedBox(height: 12),
                    Expanded(child: ShimmerBox(30, dwidth)),
                  ],
                ),
              );
        },
      ),
    );
  }

  Widget topContainer() {
    PropertyAllDetailsController getController = Get.put(
      PropertyAllDetailsController(),
    );
    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: kBlack.withOpacity(0.2),
        // image: DecorationImage(
        //     image:
        //         NetworkImage(getController.PropertyData!.result!.coverPhoto!),
        //     fit: BoxFit.cover)
      ),
      child: GetBuilder<PropertyAllDetailsController>(
        initState: (a) {},
        builder: (a) {
          return Stack(
            children: [
              CarouselSlider(
                items: List.generate(a.PropertyData!.propertyPhotos!.length, ((
                  index,
                ) {
                  return cNetworkImage(
                    a.PropertyData!.propertyPhotos![index].image,
                    fit: BoxFit.cover,
                  );
                })),
                carouselController: a.carouselController,
                options: CarouselOptions(
                  height: 380,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 2),
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                  // aspectRatio: 2.0,
                ),
              ),
              a.PropertyData!.propertyPhotos!.length >= 3
                  ? Positioned(
                    bottom: 70,
                    left: (dwidth - (150 + 24)) / 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Bounce(
                          onPressed: (() {
                            a.carouselController.animateToPage(0);
                          }),
                          duration: const Duration(milliseconds: 200),
                          child: CachedNetworkImage(
                            imageUrl:
                                a.PropertyData!.propertyPhotos![0].image
                                    .toString(),
                            imageBuilder:
                                (context, imageProvider) => Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kWhite, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                    color: kBlack.withOpacity(0.2),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      // colorFilter: const ColorFilter.mode(
                                      //     Colors.yr, BlendMode.colorBurn)
                                    ),
                                  ),
                                ),
                            placeholder:
                                (context, url) =>
                                    const CircularProgressIndicator(),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Bounce(
                          onPressed: (() {
                            a.carouselController.animateToPage(1);
                          }),
                          duration: const Duration(milliseconds: 200),
                          child: CachedNetworkImage(
                            imageUrl:
                                a.PropertyData!.propertyPhotos![1].image
                                    .toString(),
                            imageBuilder:
                                (context, imageProvider) => Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kWhite, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                    color: kBlack.withOpacity(0.2),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      // colorFilter: const ColorFilter.mode(
                                      //     Colors.red, BlendMode.colorBurn)
                                    ),
                                  ),
                                ),
                            placeholder:
                                (context, url) =>
                                    const CircularProgressIndicator(),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Bounce(
                          onPressed: (() {
                            Get.to(() => const ViewAllPhotos());
                          }),
                          duration: const Duration(milliseconds: 200),
                          child: CachedNetworkImage(
                            imageUrl:
                                a.PropertyData!.propertyPhotos![2].image
                                    .toString(),
                            imageBuilder:
                                (context, imageProvider) => Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kWhite, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: AutoSizeText(
                                            "+ ${a.PropertyData!.propertyPhotos!.length - 2}",
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w800,
                                              color: kWhite,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                        // child: commonText(
                                        //     maxlines: 1,
                                        //     textAlign: TextAlign.center,
                                        //     text:

                                        //         "+ ${a.PropertyData!.propertyPhotos!.length - 2}",
                                        //     color: kWhite,
                                        //     fontWeight: FontWeight.w800,
                                        //     fontSize: 24),
                                      ),
                                    ],
                                  ),
                                ),
                            placeholder:
                                (context, url) =>
                                    const CircularProgressIndicator(),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                          ),
                          // Container(
                          //   height: 50,
                          //   width: 50,
                          //   decoration: BoxDecoration(
                          //       border: Border.all(color: kWhite, width: 2),
                          //       borderRadius: BorderRadius.circular(8),
                          //       image: DecorationImage(
                          //           image: NetworkImage(a.PropertyData!
                          //               .propertyPhotos![2].image),
                          //           fit: BoxFit.cover)),
                          //   child: Stack(
                          //     children: [
                          //       Container(
                          //           decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(8),
                          //         color: Colors.black.withOpacity(0.6),
                          //       )),
                          //       Center(
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(8),
                          //           child: AutoSizeText(
                          //             "+ ${a.PropertyData!.propertyPhotos!.length - 2}",
                          //             style: const TextStyle(
                          //                 fontSize: 24,
                          //                 fontWeight: FontWeight.w800,
                          //                 color: kWhite),
                          //             maxLines: 1,
                          //           ),
                          //         ),
                          //         // child: commonText(
                          //         //     maxlines: 1,
                          //         //     textAlign: TextAlign.center,
                          //         //     text:

                          //         //         "+ ${a.PropertyData!.propertyPhotos!.length - 2}",
                          //         //     color: kWhite,
                          //         //     fontWeight: FontWeight.w800,
                          //         //     fontSize: 24),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                  )
                  : const SizedBox(),
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 10, 0),
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: kWhite,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Bounce(
                            duration: const Duration(milliseconds: 150),
                            onPressed: (() {
                              Share.share(
                                'Check this out on GleeKey \n${getController.PropertyData!.shareLink!}',
                              );
                            }),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: kBlack.withOpacity(0.3),
                              child: Image.asset(
                                "assets/images/share.png",
                                color: kWhite,
                                width: 15,
                                height: 15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          addWishlistWidget(
                            PropertyID: getController.PropertyData!.result!.id,
                            size: 18,
                            height: 15,
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Map<String, String>> buildHouseRules(
    PropertyAllDetailsController getController,
  ) {
    final rules = <Map<String, String>>[];

    final data =
        getController.PropertyData?.houseRules?.isNotEmpty == true
            ? getController.PropertyData!.houseRules![0]
            : null;

    if (data == null) return rules;

    if (data.checkInTime != null && data.checkInTime != "") {
      rules.add({
        "prefix": "Check-In Time",
        "suffix": data.checkInTime!.substring(0, 5),
      });
    }

    if (data.checkOutTime != null && data.checkOutTime != "") {
      rules.add({
        "prefix": "Check-Out Time",
        "suffix": data.checkOutTime!.substring(0, 5),
      });
    }

    if (data.petFriendly != null && data.petFriendly != "") {
      rules.add({"prefix": "Pet Friendly", "suffix": "${data.petFriendly}"});
    }

    if (data.poolTime != null && data.poolTime != "") {
      rules.add({"prefix": "Pool Timings", "suffix": "${data.poolTime}"});
    }

    if (data.loudMusicTime != null && data.loudMusicTime != "") {
      rules.add({
        "prefix": "Loud Music Timings",
        "suffix": "${data.loudMusicTime}",
      });
    }

    if (data.foodAllowed != null && data.foodAllowed != "") {
      rules.add({"prefix": "Food Allowed", "suffix": "${data.foodAllowed}"});
    }

    if (data.isAlcoholAllowed != null && data.isAlcoholAllowed != "") {
      rules.add({
        "prefix": "Alcohol Allowed",
        "suffix": "${data.isAlcoholAllowed}",
      });
    }

    if (data.smokingAllowed != null && data.smokingAllowed != "") {
      rules.add({
        "prefix": "Smoking Allowed",
        "suffix": "${data.smokingAllowed}",
      });
    }

    print(data.guestAllowed);

    if (data.guestAllowed != null && data.guestAllowed != "") {
      rules.add({"prefix": "Guest Allowed", "suffix": "${data.guestAllowed}"});
    }

    return rules;
  }

  final ConfrimNPayController a = Get.put(ConfrimNPayController());

  Widget detailBottomSheet() {
    PropertyAllDetailsController getController = Get.put(
      PropertyAllDetailsController(),
    );
    CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(
        double.parse(
          getController.PropertyData!.result!.propertyAddress!.latitude!,
        ),
        double.parse(
          getController.PropertyData!.result!.propertyAddress!.longitude!,
        ),
      ),
      zoom: 14.4746,
    );

    Set<Circle> circles = {
      Circle(
        fillColor: Colors.blueAccent.withOpacity(0.2),
        circleId: const CircleId("circleId"),
        center: LatLng(
          double.parse(
            getController.PropertyData!.result!.propertyAddress!.latitude!,
          ),
          double.parse(
            getController.PropertyData!.result!.propertyAddress!.longitude!,
          ),
        ),
        radius: 200,
        strokeWidth: 2,
        strokeColor: Colors.blueAccent,
      ),
    };

    print(getController.PropertyData!.houseRules?[0].poolTime);
    print(getController.PropertyData!.houseRules?[0].poolTime);
    print(getController.PropertyData!.houseRules?[0].poolTime);
    print(getController.PropertyData!.houseRules?[0].poolTime);

    buildHouseRules(getController);

    final controller = DateRangePickerController();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.6,
      builder: (BuildContext context, ScrollController scrollController) {
        return SafeArea(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: kWhite,
                boxShadow: [
                  BoxShadow(
                    color: kDarkGrey.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0.0, 5.0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 100),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getController.PropertyData!.result!.propertyName!,
                        style: Palette.detailText1.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '( ${getController.PropertyData!.result!.propertyAddress!.city}, ${getController.PropertyData!.result!.propertyAddress!.state}, ${getController.PropertyData!.result!.propertyAddress!.country} )',
                        style: Palette.detailText2,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        getController
                            .PropertyData!
                            .result!
                            .propertyDescription!
                            .summary,
                        style: Palette.bestText2.copyWith(
                          color: AppColors.color828282,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(color: kDarkGrey),
                      const SizedBox(height: 3),
                      // TODO remove devider
                      // Row(
                      //   children: [
                      //     Expanded(
                      //         child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           "${getController.PropertyData!.result!.name!} Hosted By ${getController.PropertyData!.result!.users!.firstName} ${getController.PropertyData!.result!.users!.lastName}",
                      //           style: Palette.detailText3,
                      //         ),
                      //         // const SizedBox(
                      //         //   height: 3,
                      //         // ),
                      //         // Text(
                      //         //   'simply dummy text',
                      //         //   style: Palette.bestText2,
                      //         // ),
                      //       ],
                      //     )),
                      //     CircleAvatar(
                      //       radius: 25,
                      //       backgroundImage: NetworkImage(getController
                      //           .PropertyData!.result!.users!.profileSrc),
                      //     )
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 3,
                      // ),
                      // const Divider(
                      //   color: kDarkGrey,
                      // ),
                      const SizedBox(height: 5),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12),
                            top: Radius.circular(12),
                          ),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.black.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amenities included',
                              style: Palette.headerText,
                            ),
                            const SizedBox(height: 5),
                            aminities(),
                            const SizedBox(height: 3),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: kDarkGrey),
                      const SizedBox(height: 8),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12),
                            top: Radius.circular(12),
                          ),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.black.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text('Basic Details', style: Palette.headerText),
                            theSpaceWidet(),
                            const SizedBox(height: 3),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: kDarkGrey),
                      const SizedBox(height: 8),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12),
                            top: Radius.circular(12),
                          ),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.black.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Booking',
                                        style: Palette.headerText,
                                      ),
                                      Container(
                                        height: 2,
                                        width: 75,
                                        color: AppColors.colorFE6927,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Check In",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () {
                                          getController.isCalenderShow.value =
                                              true;
                                          getController.update();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color: Colors.grey.shade300
                                                .withOpacity(0.7),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/calander.png',
                                                height: 16,
                                                width: 16,
                                                color: AppColors.colorFE6927,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                getController.startDate ?? '',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Check Out",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () {
                                          getController.isCalenderShow.value =
                                              true;
                                          getController.update();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color: Colors.grey.shade300
                                                .withOpacity(0.7),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/calander.png',
                                                height: 16,
                                                width: 16,
                                                color: AppColors.colorFE6927,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(getController.endDate ?? ''),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (getController.isCalenderShow.value) ...{
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: kOrange),
                                ),
                                child: GetBuilder<SearchPlacesController>(
                                  builder: (a) {
                                    return GetBuilder<
                                      PropertyAllDetailsController
                                    >(
                                      builder: (c) {
                                        return SfDateRangePicker(
                                          selectableDayPredicate: (
                                            DateTime dateTime,
                                          ) {
                                            if (dateTime ==
                                                DateTime(2024, 04, 22)) {
                                              return false;
                                            }
                                            return true;
                                          },
                                          initialSelectedRange: PickerDateRange(
                                            getController.startDate != null
                                                ? DateFormat(
                                                  'dd-MM-yyyy',
                                                ).parse(
                                                  getController.startDate ?? '',
                                                )
                                                : DateTime.now(),
                                            getController.endDate != null
                                                ? DateFormat(
                                                  'dd-MM-yyyy',
                                                ).parse(
                                                  getController.endDate ?? '',
                                                )
                                                : DateTime.now().add(
                                                  const Duration(days: 1),
                                                ),
                                          ),
                                          headerStyle:
                                              const DateRangePickerHeaderStyle(
                                                textAlign: TextAlign.center,
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                          minDate: DateTime.now(),
                                          maxDate: DateTime.now().add(
                                            const Duration(days: 45),
                                          ),
                                          // view: DateRangePickerView.month,
                                          viewSpacing: 25,
                                          navigationMode:
                                              DateRangePickerNavigationMode
                                                  .scroll,
                                          showActionButtons: false,
                                          selectionShape:
                                              DateRangePickerSelectionShape
                                                  .circle,
                                          monthCellStyle:
                                              const DateRangePickerMonthCellStyle(),
                                          enablePastDates: true,
                                          monthViewSettings:
                                              DateRangePickerMonthViewSettings(
                                                blackoutDates:
                                                    getController
                                                        .availableDates,
                                              ),
                                          onSelectionChanged: ((args) {
                                            if (args.value.startDate != null &&
                                                args.value.endDate != null) {
                                              getController.startDate =
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(
                                                        DateTime.parse(
                                                          args.value.startDate
                                                              .toString(),
                                                        ),
                                                      )
                                                      .toString();
                                              getController.endDate =
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(
                                                        DateTime.parse(
                                                          args.value.endDate
                                                              .toString(),
                                                        ),
                                                      )
                                                      .toString();
                                              getController
                                                  .isCalenderShow
                                                  .value = false;
                                              getController
                                                  .coupenSuccess
                                                  .value = false;
                                              getController.getPrice(
                                                params: {
                                                  "property_id":
                                                      getController
                                                          .PropertyData
                                                          ?.propertyId
                                                          .toString(),
                                                  "from_date":
                                                      getController.startDate,
                                                  "to_date":
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(
                                                            DateTime.now().add(
                                                              const Duration(
                                                                days: 45,
                                                              ),
                                                            ),
                                                          )
                                                          .toString(),
                                                },
                                                success: () async {
                                                  getController
                                                      .coupenSuccess
                                                      .value = false;
                                                  getController
                                                      .isCoupenApplied
                                                      .value = false;
                                                  getController
                                                      .coupenCode
                                                      .value = '';

                                                  getController.priceUpdate();
                                                },
                                              );
                                            }

                                            getController.update();
                                          }),
                                          selectionMode:
                                              DateRangePickerSelectionMode
                                                  .range,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            },
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: kDarkGrey),
                      const SizedBox(height: 8),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12),
                            top: Radius.circular(12),
                          ),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.black.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                commonText(
                                  text: "Total Guests",
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                commonText(
                                  text:
                                      getController.PropertyData!.result!.guest
                                          .toString(),
                                  color: kBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),
                            const Divider(color: kDarkGrey),
                            const SizedBox(height: 8),
                            GetBuilder<SearchPlacesController>(
                              builder: (a) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: commonText(
                                        text: "Adults",
                                        color: kBlack,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.03),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (a.totalAdults.text == '0') {
                                                return;
                                              }
                                              int totalCount = int.parse(
                                                a.totalAdults.text,
                                              );
                                              totalCount--;
                                              a.totalAdults.text =
                                                  totalCount.toString();
                                              a.update();
                                            },
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            child: Container(
                                              height: 40,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                  0.03,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.horizontal(
                                                      left: Radius.circular(10),
                                                    ),
                                                border: const Border(
                                                  right: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.remove,
                                                size: 18,
                                                color: AppColors.color000000,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                a.totalAdults.text.toString(),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (int.parse(
                                                    getController
                                                        .PropertyData!
                                                        .result!
                                                        .guest
                                                        .toString(),
                                                  ) <=
                                                  int.parse(
                                                        a.totalAdults.text,
                                                      ) +
                                                      int.parse(
                                                        a.totalChildren.text,
                                                      )) {
                                                if (int.parse(
                                                      a.totalChildren.text,
                                                    ) >=
                                                    1) {
                                                  int totalChildred = int.parse(
                                                    a.totalChildren.text,
                                                  );
                                                  totalChildred--;
                                                  a.totalChildren.text =
                                                      totalChildred.toString();
                                                }
                                              } else {}
                                              if (int.parse(
                                                    getController
                                                        .PropertyData!
                                                        .result!
                                                        .guest
                                                        .toString(),
                                                  ) <=
                                                  int.parse(
                                                    a.totalAdults.text,
                                                  )) {
                                                return;
                                              }
                                              int totalAdults = int.parse(
                                                a.totalAdults.text,
                                              );
                                              totalAdults++;
                                              a.totalAdults.text =
                                                  totalAdults.toString();
                                              a.update();
                                            },
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            child: Container(
                                              height: 40,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                  0.03,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.horizontal(
                                                      right: Radius.circular(
                                                        10,
                                                      ),
                                                    ),
                                                border: const Border(
                                                  left: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 18,
                                                color: AppColors.color000000,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            Divider(color: kDarkGrey.withOpacity(0.2)),
                            const SizedBox(height: 10),
                            GetBuilder<SearchPlacesController>(
                              builder: (a) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          commonText(
                                            text: "Children",
                                            color: kBlack,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          commonText(
                                            text: "(Above 5 Year)",
                                            color: kBlack.withAlpha(100),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (a.totalChildren.text == '0') {
                                                return;
                                              }
                                              int totalChildred = int.parse(
                                                a.totalChildren.text,
                                              );
                                              totalChildred--;
                                              a.totalChildren.text =
                                                  totalChildred.toString();
                                              a.update();
                                            },
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            child: Container(
                                              height: 40,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                  0.03,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.horizontal(
                                                      left: Radius.circular(10),
                                                    ),
                                                border: const Border(
                                                  right: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.remove,
                                                size: 18,
                                                color: AppColors.color000000,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                a.totalChildren.text.toString(),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (int.parse(
                                                    getController
                                                        .PropertyData!
                                                        .result!
                                                        .guest
                                                        .toString(),
                                                  ) <=
                                                  int.parse(
                                                        a.totalAdults.text,
                                                      ) +
                                                      int.parse(
                                                        a.totalChildren.text,
                                                      )) {
                                                if (int.parse(
                                                      a.totalAdults.text,
                                                    ) >=
                                                    1) {
                                                  int totalAdults = int.parse(
                                                    a.totalAdults.text,
                                                  );
                                                  totalAdults--;
                                                  a.totalAdults.text =
                                                      totalAdults.toString();
                                                }
                                              } else {}
                                              if (int.parse(
                                                    getController
                                                        .PropertyData!
                                                        .result!
                                                        .guest
                                                        .toString(),
                                                  ) <=
                                                  int.parse(
                                                    a.totalChildren.text,
                                                  )) {
                                                return;
                                              }
                                              int totalChildred = int.parse(
                                                a.totalChildren.text,
                                              );
                                              totalChildred++;
                                              a.totalChildren.text =
                                                  totalChildred.toString();
                                              a.update();
                                            },
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            child: Container(
                                              height: 40,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                  0.03,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.horizontal(
                                                      right: Radius.circular(
                                                        10,
                                                      ),
                                                    ),
                                                border: const Border(
                                                  left: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 18,
                                                color: AppColors.color000000,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            Divider(color: kDarkGrey.withOpacity(0.2)),
                            const SizedBox(height: 10),
                            GetBuilder<SearchPlacesController>(
                              builder: (a) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          commonText(
                                            text: "Children",
                                            color: kBlack,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          commonText(
                                            text: "(0 - 5 year)",
                                            color: kBlack.withAlpha(100),
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (a.totalInphant.text == '0') {
                                                return;
                                              }
                                              int totalInphant = int.parse(
                                                a.totalInphant.text,
                                              );
                                              totalInphant--;
                                              a.totalInphant.text =
                                                  totalInphant.toString();
                                              a.update();
                                            },
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            child: Container(
                                              height: 40,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                  0.03,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.horizontal(
                                                      left: Radius.circular(10),
                                                    ),
                                                border: const Border(
                                                  right: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.remove,
                                                size: 18,
                                                color: AppColors.color000000,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                a.totalInphant.text.toString(),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              int totalInphant = int.parse(
                                                a.totalInphant.text,
                                              );
                                              totalInphant++;
                                              a.totalInphant.text =
                                                  totalInphant.toString();
                                              a.update();
                                            },
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            child: Container(
                                              height: 40,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                  0.03,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.horizontal(
                                                      right: Radius.circular(
                                                        10,
                                                      ),
                                                    ),
                                                border: const Border(
                                                  left: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 18,
                                                color: AppColors.color000000,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                      const Divider(color: kDarkGrey),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12),
                            top: Radius.circular(12),
                          ),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.black.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await getController.getPromocodeList(
                                  propertyId: widget.id,
                                );
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return PromoCodeDialog(
                                      context,
                                      getController,
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 4,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Promo Code",
                                        style: TextStyle(
                                          color: AppColors.colorFE6927,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.colorFE6927,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        size: 12,
                                        color: AppColors.colorFE6927,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Obx(
                              () =>
                                  getController.isCoupenApplied.value
                                      ? Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 38,
                                              alignment: Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(9),
                                                border: Border.all(
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                ),
                                                child: Text(
                                                  getController
                                                      .coupenCode
                                                      .value,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          CommonButton(
                                            onPressed: () {
                                              getController.coupenCode.value =
                                                  '';
                                              getController
                                                  .coupenSuccess
                                                  .value = false;
                                              getController
                                                  .isCoupenApplied
                                                  .value = false;
                                              getController.messageCode.value =
                                                  '';
                                              getController.getPrice(
                                                params: {
                                                  "property_id":
                                                      getController
                                                          .PropertyData
                                                          ?.propertyId
                                                          .toString(),
                                                  "from_date":
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(
                                                            DateTime.now(),
                                                          )
                                                          .toString(),
                                                  "to_date":
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(
                                                            DateTime.now().add(
                                                              const Duration(
                                                                days: 45,
                                                              ),
                                                            ),
                                                          )
                                                          .toString(),
                                                },
                                                success: () async {
                                                  getController.update();
                                                  await getController
                                                      .priceUpdate();
                                                },
                                              );
                                            },
                                            name: 'Remove',
                                          ),
                                        ],
                                      )
                                      : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Obx(() {
                          if (getController.selectedOfferValue.value == 1 &&
                              getController.isOfferApplied.value) {
                            return const Text(
                              "Offer Applied",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          } else if (getController.selectedOfferValue.value ==
                                  1 &&
                              (getController.isOfferApplied.value == false)) {
                            return const Text(
                              "No Booking Offer",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }
                          return const SizedBox();
                        }),
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: kDarkGrey),
                      const SizedBox(height: 8),
                      if (getController.isDateAvailable.value) ...{
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(12),
                              top: Radius.circular(12),
                            ),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.black.withOpacity(0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 0),
                                spreadRadius: 0,
                                blurRadius: 1,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (getController.isDateAvailable.value) ...{
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${getController.selectedDateWithPrice.length} Nights",
                                          style: Palette.paymentBlack13
                                              .copyWith(fontSize: 15),
                                        ),
                                        Text(
                                          format.format(
                                            getController.totalPrice ?? 0,
                                          ),
                                          style: Palette.paymentBlack13
                                              .copyWith(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Bounce(
                                      onPressed: () {
                                        a.isPriceBreakup = !a.isPriceBreakup;
                                        a.update();
                                      },
                                      duration: const Duration(
                                        milliseconds: 150,
                                      ),
                                      child: const Row(
                                        children: [
                                          Text(
                                            "View Price Breakup",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: kOrange,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GetBuilder<ConfrimNPayController>(
                                      initState: (a) {},
                                      builder: (a) {
                                        return Visibility(
                                          visible: a.isPriceBreakup,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8,
                                            ),
                                            child: ListView.separated(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  getController
                                                      .selectedDateWithPrice
                                                      .length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "${getController.selectedDateWithPrice[index].date} (Tax ${getController.selectedDateWithPrice[index].ivataxGstPer}% ${format.format((double.parse(getController.selectedDateWithPrice[index].perDayTax?.toString().replaceAll(' ', '').replaceAll(',', '') ?? '0')).customRound())})",
                                                        style: Palette
                                                            .GreyText12w500.copyWith(
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ),
                                                    if (getController
                                                            .isOfferApplied
                                                            .value &&
                                                        getController
                                                                .selectedDateWithPrice[index]
                                                                .originalPrice
                                                                .toString() !=
                                                            (getController
                                                                    .selectedDateWithPrice[index]
                                                                    .price
                                                                    .toString()
                                                                    .replaceAll(
                                                                      "₹",
                                                                      '',
                                                                    )
                                                                    .replaceAll(
                                                                      " ",
                                                                      '',
                                                                    )
                                                                    .replaceAll(
                                                                      ",",
                                                                      '',
                                                                    )
                                                                    .toString())
                                                                .trim()) ...{
                                                      Text(
                                                        format.format(
                                                          getController
                                                              .selectedDateWithPrice[index]
                                                              .originalPrice,
                                                        ),
                                                        style: Palette
                                                            .paymentBlack13
                                                            .copyWith(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              color: kDarkGrey,
                                                            ),
                                                      ),
                                                      Text(
                                                        " / ${format.format((double.parse((getController.selectedDateWithPrice[index].price.toString().replaceAll("₹", '').replaceAll(" ", '').replaceAll(",", '').toString()).trim())).customRound())}",
                                                        style:
                                                            Palette
                                                                .paymentBlack13,
                                                      ),
                                                    } else ...{
                                                      Text(
                                                        format.format(
                                                          (double.parse(
                                                            (getController
                                                                    .selectedDateWithPrice[index]
                                                                    .price
                                                                    .toString()
                                                                    .replaceAll(
                                                                      "₹",
                                                                      '',
                                                                    )
                                                                    .replaceAll(
                                                                      " ",
                                                                      '',
                                                                    )
                                                                    .replaceAll(
                                                                      ",",
                                                                      '',
                                                                    )
                                                                    .toString())
                                                                .trim(),
                                                          )).customRound(),
                                                        ),
                                                        style:
                                                            Palette
                                                                .paymentBlack13,
                                                      ),
                                                    },
                                                  ],
                                                );
                                              },
                                              separatorBuilder: (
                                                context,
                                                index,
                                              ) {
                                                return const SizedBox(
                                                  height: 8,
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Subtotal",
                                          style: Palette.paymentBlack13
                                              .copyWith(fontSize: 15),
                                        ),
                                        Text(
                                          format.format(
                                            getController.totalPrice ?? 0,
                                          ),
                                          style: Palette.paymentBlack13
                                              .copyWith(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    if (getController
                                        .isCoupenApplied
                                        .value) ...{
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Offer ( ${(getController.offerPercentage.value)}%)",
                                            style: Palette.paymentBlack13
                                                .copyWith(fontSize: 15),
                                          ),
                                          Text(
                                            "- ${format.format(getController.totalDiscount?.customRound() ?? 0)}",
                                            style: Palette.paymentBlack13
                                                .copyWith(
                                                  fontSize: 15,
                                                  color: kRed,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'This offer is applicable only for full payments.',
                                        style: Palette.detailText2.copyWith(
                                          color: kRed,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Subtotal",
                                            style: Palette.paymentBlack13
                                                .copyWith(fontSize: 15),
                                          ),
                                          Text(
                                            format.format(
                                              getController
                                                      .totalPriceAfterDiscount
                                                      ?.customRound() ??
                                                  0,
                                            ),
                                            // "₹${getController.totalPriceAfterDiscount}",
                                            style: Palette.paymentBlack13
                                                .copyWith(
                                                  fontSize: 15,
                                                  color: kBlack,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                    } else if (getController
                                        .isOfferApplied
                                        .value /*(getController.PropertyData!.result!
                                            .noOfDiscountBooking !=
                                        null) &&
                                    (getController.PropertyData?.result
                                                ?.totalBooking -
                                            500) <
                                        int.parse(getController.PropertyData
                                            ?.result!.noOfDiscountBooking)*/ ) ...{
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Offer ( ${(getController.PropertyData!.result!.noOfDiscountBooking != null) && (getController.PropertyData?.result?.totalBooking - 500) < int.parse(getController.PropertyData?.result!.noOfDiscountBooking) ? getController.PropertyData!.result!.isFirstBooking : getController.offerPercentage}%)",
                                            style: Palette.paymentBlack13
                                                .copyWith(fontSize: 15),
                                          ),
                                          Text(
                                            "- ${format.format(getController.totalDiscount?.customRound() ?? 0)}",
                                            style: Palette.paymentBlack13
                                                .copyWith(
                                                  fontSize: 15,
                                                  color: kRed,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'This offer is applicable only for full payments.',
                                        style: Palette.detailText2.copyWith(
                                          color: kRed,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Subtotal",
                                            style: Palette.paymentBlack13
                                                .copyWith(fontSize: 15),
                                          ),
                                          Text(
                                            format.format(
                                              getController
                                                      .totalPriceAfterDiscount
                                                      ?.customRound() ??
                                                  0,
                                            ),
                                            style: Palette.paymentBlack13
                                                .copyWith(
                                                  fontSize: 15,
                                                  color: kBlack,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                    } else if (getController
                                        .isCoupenApplied
                                        .value) ...{
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (getController.dateprice != null &&
                                              getController
                                                  .dateprice!
                                                  .isNotEmpty)
                                            Text(
                                              "Offer (${getController.dateprice![0].discountPercentage}%)",
                                              style: Palette.paymentBlack13
                                                  .copyWith(fontSize: 15),
                                            ),
                                          Text(
                                            "- ${format.format(getController.totalDiscount?.customRound() ?? 0)}",
                                            style: Palette.paymentBlack13
                                                .copyWith(
                                                  fontSize: 15,
                                                  color: kRed,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'This offer is applicable only for full payments.',
                                        style: Palette.detailText2.copyWith(
                                          color: kRed,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Subtotal",
                                            style: Palette.paymentBlack13
                                                .copyWith(fontSize: 15),
                                          ),
                                          Text(
                                            format.format(
                                              getController
                                                      .totalPriceAfterDiscount
                                                      ?.customRound() ??
                                                  0,
                                            ),
                                            // "₹${getController.totalPriceAfterDiscount}",
                                            style: Palette.paymentBlack13
                                                .copyWith(
                                                  fontSize: 15,
                                                  color: kBlack,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                    },
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Goods and Service Tax",
                                          style: Palette.paymentBlack13
                                              .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                        Text(
                                          "+${format.format(getController.totalGST?.customRound() ?? 0)}",
                                          style: Palette.paymentBlack13
                                              .copyWith(
                                                fontSize: 14,
                                                color: Colors.green,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total",
                                          style: Palette.paymentBlack13
                                              .copyWith(fontSize: 15),
                                        ),
                                        //TODO
                                        Text(
                                          format.format(
                                            (getController
                                                        .totalPriceAfterDiscount
                                                        ?.customRound() ??
                                                    0) +
                                                (getController.totalGST
                                                        ?.customRound() ??
                                                    0),
                                          ),
                                          style: Palette.paymentBlack13
                                              .copyWith(fontSize: 15),
                                        ),
                                        // if ((getController.PropertyData!.result!
                                        //             .noOfDiscountBooking !=
                                        //         null) &&
                                        //     (getController.PropertyData?.result
                                        //                 ?.totalBooking -
                                        //             500) <
                                        //         int.parse(getController
                                        //             .PropertyData
                                        //             ?.result!
                                        //             .noOfDiscountBooking)) ...{
                                        //   Text(
                                        //     "₹ ${double.parse(getController.totalGST?.toStringAsFixed(1) ?? '0') + (getController.totalPriceAfterDiscount ?? 0)}",
                                        //     style: Palette.btnText
                                        //         .copyWith(fontSize: 15),
                                        //   ),
                                        // } else ...{
                                        //   Text(
                                        //     "₹ ${double.parse(getController.totalGST?.toStringAsFixed(1) ?? '0') + (getController.totalPrice ?? 0)}",
                                        //     style: Palette.paymentBlack13
                                        //         .copyWith(fontSize: 15),
                                        //   ),
                                        // }
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              },
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: kDarkGrey),
                        const SizedBox(height: 8),
                      },
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12),
                            top: Radius.circular(12),
                          ),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.black.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Location', style: Palette.headerText),
                            const SizedBox(height: 18),
                            SizedBox(
                              height: 200,
                              child: Card(
                                color: kBtnGrey,
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  circles: circles,
                                  initialCameraPosition: kGooglePlex,
                                  onMapCreated: (
                                    GoogleMapController controller,
                                  ) {
                                    try {
                                      _controller.complete(controller);
                                    } catch (e) {}
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /*const SizedBox(height: 12),
                      const Divider(color: kDarkGrey),
                      const SizedBox(height: 4),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12),
                            top: Radius.circular(12),
                          ),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.black.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Review', style: Palette.headerText),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star, color: kOrange, size: 24),
                                SizedBox(width: 5),
                                Text(
                                  "${getController.PropertyData!.result!.avgRating!} ($totalReviews)",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            if (getController
                                    .PropertyData!
                                    .reviewsFromGuests
                                    .length !=
                                0)
                              Column(
                                children:
                                    ratings.entries.map((entry) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(child: Text(entry.key)),
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child:
                                                      LinearProgressIndicator(
                                                        value: entry.value / 5,
                                                        backgroundColor:
                                                            Colors.grey[300],
                                                        color: kOrange,
                                                        minHeight: 6,
                                                      ),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  entry.value.toStringAsFixed(
                                                    1,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                              ),

                            GuestReviewsWidget(
                              reviews:
                                  getController.PropertyData!.reviewsFromGuests,
                            ),
                          ],
                        ),
                      ),*/
                      const SizedBox(height: 8),
                      const Divider(color: kGreyone),
                      const SizedBox(height: 8),
                      Text('House Rules', style: Palette.headerText),
                      const SizedBox(height: 12),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12),
                            top: Radius.circular(12),
                          ),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.black.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: GetBuilder<PropertyAllDetailsController>(
                          builder: (a) {
                            final rules = buildHouseRules(getController);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🔹 GridView instead of multiple Rows
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2, // 2 per row
                                        mainAxisExtent:
                                            40, // height of each item
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                  itemCount:
                                      a.isRulesExpanded
                                          ? rules.length
                                          : (rules.length > 4
                                              ? 4
                                              : rules
                                                  .length), // show only 4 initially
                                  itemBuilder: (context, index) {
                                    return _buildHouseRuleItem(
                                      rules[index]["prefix"]!,
                                      rules[index]["suffix"]!,
                                    );
                                  },
                                ),

                                // 🔹 Custom rules section
                                if (a.isRulesExpanded &&
                                    getController
                                            .PropertyData
                                            ?.customHouseRules !=
                                        null)
                                  Column(
                                    children: List.generate(
                                      getController
                                          .PropertyData!
                                          .customHouseRules!
                                          .length,
                                      (index) {
                                        final rule =
                                            getController
                                                .PropertyData!
                                                .customHouseRules![index];
                                        if (rule.title == null)
                                          return const SizedBox();
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 6.0,
                                                ),
                                                child: Image.asset(
                                                  "assets/images/orangeDot.png",
                                                  height: 8,
                                                  width: 8,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  "${rule.title}",
                                                  style: Palette.bestText2
                                                      .copyWith(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                const SizedBox(height: 8),

                                // 🔹 Show More / Show Less Button
                                Bounce(
                                  onPressed: () {
                                    a.isRulesExpanded = !a.isRulesExpanded;
                                    a.update();
                                  },
                                  duration: const Duration(milliseconds: 150),
                                  child: Text(
                                    a.isRulesExpanded
                                        ? "Show Less"
                                        : "Show More",
                                    style: const TextStyle(color: kOrange),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        // child: Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     GetBuilder<PropertyAllDetailsController>(
                        //       initState: (a) {},
                        //       builder: (a) {
                        //         return Wrap(
                        //           alignment: WrapAlignment.start,
                        //           crossAxisAlignment:
                        //               WrapCrossAlignment.start,
                        //           direction: Axis.horizontal,
                        //           runAlignment: WrapAlignment.start,
                        //           spacing: 20,
                        //           children: List<Widget>.generate(
                        //             a.isRulesExpanded
                        //                 ? housePrefix.length
                        //                 : 4,
                        //             (index) {
                        //               return SizedBox(
                        //                 width:
                        //                     index == housePrefix.length - 1
                        //                         ? null
                        //                         : (Get.width / 2.5),
                        //                 child: Padding(
                        //                   padding:
                        //                       const EdgeInsets.symmetric(
                        //                           vertical: 10),
                        //                   child: Column(
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.center,
                        //                     children: [
                        //                       Row(
                        //                         mainAxisSize:
                        //                             MainAxisSize.min,
                        //                         mainAxisAlignment:
                        //                             MainAxisAlignment.start,
                        //                         children: [
                        //                           Image.asset(
                        //                             "assets/images/orangeDot.png",
                        //                             height: 8,
                        //                             width: 8,
                        //                           ),
                        //                           const SizedBox(width: 10),
                        //                           Text(
                        //                             "${housePrefix[index]} : ",
                        //                             style: Palette.bestText2
                        //                                 .copyWith(
                        //                               color: Colors.black,
                        //                               fontWeight:
                        //                                   FontWeight.bold,
                        //                             ),
                        //                           ),
                        //                           if (index ==
                        //                               housePrefix.length -
                        //                                   1) ...{
                        //                             Expanded(
                        //                                 flex: 0,
                        //                                 child: Text(
                        //                                   "${houseSuffix[index]}",
                        //                                   textAlign: TextAlign
                        //                                       .center, // Center the description text
                        //                                   style: Palette
                        //                                       .bestText2
                        //                                       .copyWith(
                        //                                     fontWeight:
                        //                                         FontWeight
                        //                                             .bold,
                        //                                   ),
                        //                                 ))
                        //                           }
                        //                         ],
                        //                       ),
                        //                       if (index !=
                        //                           houseSuffix.length -
                        //                               1) ...{
                        //                         const SizedBox(
                        //                             height:
                        //                                 5), // Add some space between the title and description
                        //                         Text(
                        //                           "${houseSuffix[index]}",
                        //                           textAlign: TextAlign
                        //                               .center, // Center the description text
                        //                           style: Palette.bestText2
                        //                               .copyWith(
                        //                             fontWeight:
                        //                                 FontWeight.bold,
                        //                           ),
                        //                         ),
                        //                       }
                        //                     ],
                        //                   ),
                        //                 ),
                        //               );
                        //             },
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //     GetBuilder<PropertyAllDetailsController>(
                        //       initState: (a) {},
                        //       builder: (a) {
                        //         return a.isRulesExpanded
                        //             ? Column(
                        //                 children: List<Widget>.generate(
                        //                   getController.PropertyData!
                        //                               .customHouseRules !=
                        //                           null
                        //                       ? getController.PropertyData!
                        //                           .customHouseRules!.length
                        //                       : 0,
                        //                   ((index) {
                        //                     return Padding(
                        //                       padding: const EdgeInsets
                        //                           .symmetric(vertical: 10),
                        //                       child: Row(
                        //                         children: [
                        //                           Image.asset(
                        //                             "assets/images/orangeDot.png",
                        //                             height: 8,
                        //                             width: 8,
                        //                           ),
                        //                           const SizedBox(
                        //                             width: 10,
                        //                           ),
                        //                           Flexible(
                        //                             child: Text(
                        //                               "${getController.PropertyData!.customHouseRules?[index].title}",
                        //                               style: Palette
                        //                                   .bestText2
                        //                                   .copyWith(
                        //                                 color: Colors.black,
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     );
                        //                   }),
                        //                 ),
                        //               )
                        //             : const SizedBox();
                        //       },
                        //     ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        // GetBuilder<PropertyAllDetailsController>(
                        //   initState: (a) {},
                        //   builder: (a) {
                        //     return Bounce(
                        //       onPressed: () {
                        //         a.isRulesExpanded = !a.isRulesExpanded;
                        //         a.update();
                        //       },
                        //       duration:
                        //           const Duration(milliseconds: 150),
                        //       child: Row(
                        //         children: [
                        //           Text(
                        //             a.isRulesExpanded
                        //                 ? "Show Less"
                        //                 : "Show More",
                        //             textAlign: TextAlign.start,
                        //             style: const TextStyle(
                        //               color: kOrange,
                        //               // decoration: TextDecoration.underline
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        // ),
                        //   ],
                        // ),
                      ),

                      const SizedBox(height: 12),
                      const Divider(color: kDarkGrey),
                      const SizedBox(height: 8),

                      if (getController
                          .PropertyData!
                          .safetyAmenities
                          .isNotEmpty) ...{
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(12),
                              top: Radius.circular(12),
                            ),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.black.withOpacity(0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 0),
                                spreadRadius: 0,
                                blurRadius: 1,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Safety & Property',
                                style: Palette.headerText,
                              ),
                              const SizedBox(height: 8),
                              Column(
                                children: List<Widget>.generate(
                                  getController
                                      .PropertyData!
                                      .safetyAmenities
                                      .length,
                                  ((index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/orangeDot.png",
                                            height: 8,
                                            width: 8,
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                            child: Text(
                                              getController
                                                  .PropertyData!
                                                  .safetyAmenities[index][getController
                                                          .PropertyData!
                                                          .safetyAmenities[index]
                                                          .length -
                                                      1]
                                                  .toString(),
                                              style: Palette.bestText2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: kDarkGrey),
                        const SizedBox(height: 8),
                      },

                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12),
                            top: Radius.circular(12),
                          ),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.black.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 0),
                              spreadRadius: 0,
                              blurRadius: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cancellation Policy',
                              style: Palette.headerText,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "**Please note: Cancellation fee is primarily applicable to cover platform charges, convenience fee and processing charges. Taxes as applicable.",
                              style: Palette.bestText2,
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: List<Widget>.generate(6, ((index) {
                                List CancellationPollicy = [
                                  "If you wish to cancel 45 to 30 days before the arrival date, you will be charged 5% cancellation charges** of the total property rent in the original payment mode.",
                                  "Cancellations that are made between 29 to 15 days prior to the arrival date, 15% cancellation charges** of the total property rent.",
                                  "Cancellations that are made between 14 to 7 days prior to the arrival date, 50% cancellation charges** of the total property rent.",
                                  "For any cancellations requested within 6 days of the check-in date, the booking will be non-refundable.",
                                  "A processing fee of 5% will be deducted from the refund amount as a convenience fee for cancellation.",
                                  "Refund will be process within 6 to 7 working days.",
                                ];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/orangeDot.png",
                                        height: 8,
                                        width: 8,
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          CancellationPollicy[index],
                                          style: Palette.bestText2,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHouseRuleItem(String prefix, String suffix) {
    return Container(
      // Changed from Expanded to Container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Image.asset(
                  "assets/images/orangeDot.png",
                  height: 8,
                  width: 8,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                // This Expanded is fine because it's inside a Row
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "$prefix :",
                      style: Palette.bestText2.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        suffix == "null" || suffix == "" ? "No" : suffix,
                        style: Palette.bestText2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget progressBar({
    required String title,
    required String rating,
    double? value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              commonText(text: title, color: Colors.black, fontSize: 12),
              commonText(text: rating, color: Colors.black, fontSize: 12),
            ],
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ProgressBar(
              value: value,
              backgroundColor: kOrange.withOpacity(0.3),
              color: kOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget aminities() {
    PropertyAllDetailsController getController = Get.put(
      PropertyAllDetailsController(),
    );

    if (getController.PropertyData!.amenities == null) {
      return const SizedBox();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 2,
            children: List.generate(
              getController.PropertyData!.amenities!.length > 5
                  ? 5
                  : getController.PropertyData!.amenities!.length,
              (i) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  // color: kBlack.withOpacity(0.05),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      getController
                                  .PropertyData!
                                  .amenities![i]['amenitie_icon'] !=
                              null
                          ? cNetworkImage(
                            getController
                                .PropertyData!
                                .amenities![i]['amenitie_icon']!,
                            //
                            // color: kOrange,
                            width: 24,
                            height: 24,
                          )
                          : Image.asset(
                            "assets/images/defaultAmenities.png",
                            //
                            // color: kOrange,
                            width: 24,
                            height: 24,
                          ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: AutoSizeText(
                          "${getController.PropertyData!.amenities![i]['title']} x  ${getController.PropertyData!.amenities![i]['quantity']}",
                          style: Palette.bestText2.copyWith(
                            color: AppColors.color828282,
                          ),
                          minFontSize: 11,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: MaterialButton(
              color: kOrange,
              shape: Palette.subCardShape,
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
              child: Text('See all', style: Palette.bestText4),
              onPressed: () {
                Get.dialog(Scaffold(body: Allaminities()));
              },
            ),
          ),
        ],
      );
    }
  }

  Widget theSpaceWidet() {
    PropertyAllDetailsController getController = Get.put(
      PropertyAllDetailsController(),
    );

    if (getController.PropertyData!.amenities == null) {
      return const SizedBox();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          if (getController.PropertyData!.result!.propertyTypeName != null &&
              getController.PropertyData!.result!.propertyTypeName != '') ...{
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.colorFE6927,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Property type: ${getController.PropertyData!.result!.propertyTypeName}',
                        style: color828282s15w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          },
          if (getController.PropertyData!.result!.constructedSquareFeet !=
                  null &&
              getController.PropertyData!.result!.constructedSquareFeet !=
                  '') ...{
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.colorFE6927,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Constructed Area: ${getController.PropertyData!.result!.constructedSquareFeet} sqft',
                        style: color828282s15w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          },
          if (getController.PropertyData!.result!.accommodates != null &&
              getController.PropertyData!.result!.accommodates != '') ...{
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.colorFE6927,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Accomodates: ${getController.PropertyData!.result!.accommodates}',
                        style: color828282s15w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          },
          if (getController.PropertyData!.result!.extraMattress != null &&
              getController.PropertyData!.result!.extraMattress != '') ...{
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.colorFE6927,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Sleeping capacity with extra mattress : ${getController.PropertyData!.result!.extraMattress}',
                        style: color828282s15w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          },
          if (getController.PropertyData!.result!.bedrooms != null &&
              getController.PropertyData!.result!.bedrooms != '') ...{
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.colorFE6927,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Bedrooms: ${getController.PropertyData!.result!.bedrooms}',
                        style: color828282s15w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          },
          if (getController.PropertyData!.result!.bathrooms != null &&
              getController.PropertyData!.result!.bathrooms != '') ...{
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.colorFE6927,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Bathrooms: ${getController.PropertyData!.result!.bathrooms}',
                        style: color828282s15w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          },
        ],
      );
    }
  }

  Widget reserve() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: dwidth.toDouble(),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: kBlack.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
          color: kWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GetBuilder<PropertyAllDetailsController>(
                    initState: (a) {},
                    builder: (a) {
                      if (!widget.isPropertyActive) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "This property is currently not available for booking",
                                style: Palette.bestText3,
                              ),
                            ),
                            Center(
                              child: Bounce(
                                duration: const Duration(milliseconds: 200),
                                onPressed: () {
                                  Get.to(() => const HomePage());
                                },
                                child: Text(
                                  "View Other Listing",
                                  style: Palette.bestText3.copyWith(
                                    color: AppColors.colorFE6927,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return a.isDateAvailable.value
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${format.format((getController.totalPriceAfterDiscount?.customRound() ?? 0) + (getController.totalGST?.customRound() ?? 0))} /${a.selectedDateWithPrice.isNotEmpty ? a.selectedDateWithPrice.length : 1} Night',
                                // '₹ ${a.PropertyData!.result!.propertyPrice!.price * (C.totalNight ?? 1)} /${C.totalNight ?? ""} Night',
                                style: Palette.headerText,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 11,
                                    color: kBlack.withOpacity(0.5),
                                  ),

                                  /// TODO change
                                  commonText(
                                    color: kBlack.withAlpha(125),
                                    text:
                                        ' GST ${format.format(a.totalGST?.customRound() ?? 0)} Included',
                                    fontSize: 10,
                                  ),
                                  // commonText(
                                  //   color: kBlack.withAlpha(125),
                                  //   text:
                                  //       ' GST ₹${((a.totalPrice ?? a.dateprice![0]['original_price']) * 12) / 100} Excluded',
                                  //   fontSize: 10,
                                  // )
                                ],
                              ),
                            ],
                          )
                          : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "Dates Not Available",
                                  style: Palette.bestText3,
                                ),
                              ),
                              Center(
                                child: Bounce(
                                  duration: const Duration(milliseconds: 200),
                                  onPressed: () {
                                    Get.to(() => const HomePage());
                                  },
                                  child: Text(
                                    "View Other Listing",
                                    style: Palette.bestText3.copyWith(
                                      color: AppColors.colorFE6927,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                    },
                  ),
                  if (getController.isDateAvailable.value &&
                      widget.isPropertyActive)
                    SizedBox(
                      height: 45,
                      child: MaterialButton(
                        color:
                            getController.PropertyData!.result!.isInquirySend ==
                                    0
                                ? kOrange
                                : kDarkGrey,
                        shape: Palette.subCardShape,

                        padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                        child: Text(
                          getController
                                      .PropertyData!
                                      .result!
                                      .propertyCategory ==
                                  "normal"
                              ? 'Book Now'
                              : getController
                                      .PropertyData!
                                      .result!
                                      .isInquirySend ==
                                  1
                              ? "Already Applied"
                              : "Request to book",
                          style: Palette.bestText4,
                        ),
                        onPressed: () async {
                          if (currUser?.data?.email == null) {
                            Get.to(() => const Login());
                          } else {
                            if (getController
                                    .PropertyData!
                                    .result!
                                    .isInquirySend ==
                                1) {
                            } else {
                              if (getController
                                      .PropertyData!
                                      .result!
                                      .propertyCategory ==
                                  "normal") {
                                print({
                                  "property_id":
                                      (getController.PropertyData!.result!.id ??
                                              '')
                                          .toString(),
                                  "host_id":
                                      (getController
                                                  .PropertyData!
                                                  .result!
                                                  .hostId ??
                                              '')
                                          .toString(),
                                  "user_id":
                                      (currUser!.data!.id! ?? '').toString(),
                                  "check_in":
                                      (getController.startDate ?? '')
                                          .toString(),
                                  "check_out":
                                      (getController.endDate ?? '').toString(),
                                  "adult":
                                      (as.totalAdults.text ?? '').toString(),
                                  "child":
                                      (as.totalChildren.text ?? '').toString(),
                                  "infant":
                                      (as.totalInphant.text ?? '').toString(),
                                  "total_guest":
                                      (getController
                                                  .PropertyData!
                                                  .result!
                                                  .guest ??
                                              '')
                                          .toString(),
                                  "coupon_code":
                                      getController.coupenCode.value ?? "",
                                  "propertyType":
                                      getController.coupenCode.value ?? "",

                                  "coverImg":
                                      getController
                                          .PropertyData!
                                          .result!
                                          .coverPhoto,
                                  "totalPrice":
                                      getController.totalPrice ??
                                      (getController
                                              .dateprice![0]
                                              .originalPrice ??
                                          0),
                                  "selectedDates":
                                      jsonEncode(
                                        getController.selectedDateWithPrice,
                                      ) ??
                                      "",
                                });

                                print(
                                  getController.totalPrice! -
                                      int.parse(
                                        getController
                                            .selectedDateWithPrice[0]
                                            .discount
                                            .toString(),
                                      ),
                                );

                                getController.startDate == null
                                    ? showSnackBar(
                                      message: 'Please Select Valid Date',
                                      title: 'Select Date',
                                    )
                                    : Get.to(
                                      () => ConfirmNpay(
                                        propertyType:
                                            getController
                                                .PropertyData!
                                                .result!
                                                .propertyTypeName ??
                                            '',
                                        propertyID:
                                            (getController
                                                        .PropertyData!
                                                        .result!
                                                        .id ??
                                                    '')
                                                .toString(),
                                        coverImg:
                                            getController
                                                .PropertyData!
                                                .result!
                                                .coverPhoto,
                                        totalPrice:
                                            (getController.totalPrice! -
                                                int.parse(
                                                  getController
                                                      .selectedDateWithPrice[0]
                                                      .discount
                                                      .toString(),
                                                )) ??
                                            (getController
                                                    .dateprice![0]
                                                    .originalPrice ??
                                                0),
                                        selectedDates:
                                            getController.selectedDateWithPrice,
                                      ),
                                    );
                              } else {
                                print({
                                  "property_id":
                                      (getController.PropertyData!.result!.id ??
                                              '')
                                          .toString(),
                                  "host_id":
                                      (getController
                                                  .PropertyData!
                                                  .result!
                                                  .hostId ??
                                              '')
                                          .toString(),
                                  "user_id":
                                      (currUser!.data!.id! ?? '').toString(),
                                  "check_in":
                                      (getController.startDate ?? '')
                                          .toString(),
                                  "check_out":
                                      (getController.endDate ?? '').toString(),
                                  "adult":
                                      (as.totalAdults.text ?? '').toString(),
                                  "child":
                                      (as.totalChildren.text ?? '').toString(),
                                  "infant":
                                      (as.totalInphant.text ?? '').toString(),
                                  "total_guest":
                                      (getController
                                                  .PropertyData!
                                                  .result!
                                                  .guest ??
                                              '')
                                          .toString(),
                                  "coupon_code":
                                      getController.coupenCode.value ?? "",
                                  "discount_amt":
                                      getController
                                          .selectedDateWithPrice[0]
                                          .discount
                                          .toString() ??
                                      "",
                                  "discount_per":
                                      getController.offerPercentage
                                          .toString() ??
                                      "",
                                  "host_offer_discount_status":
                                      getController.isHostOfferApplied.value
                                          ? "1"
                                          : "0",
                                  "offer_dis":
                                      getController
                                          .selectedDateWithPrice[0]
                                          .discountPercentage
                                          .toString() ??
                                      "",
                                });

                                getController.startDate == null
                                    ? showSnackBar(
                                      message: 'Please Select Valid Date',
                                      title: 'Select Date',
                                    )
                                    : await getController
                                        .getInquryApi({
                                          "property_id":
                                              (getController
                                                          .PropertyData!
                                                          .result!
                                                          .id ??
                                                      '')
                                                  .toString(),
                                          "host_id":
                                              (getController
                                                          .PropertyData!
                                                          .result!
                                                          .hostId ??
                                                      '')
                                                  .toString(),
                                          "user_id":
                                              (currUser!.data!.id! ?? '')
                                                  .toString(),
                                          "check_in":
                                              (getController.startDate ?? '')
                                                  .toString(),
                                          "check_out":
                                              (getController.endDate ?? '')
                                                  .toString(),
                                          "adult":
                                              (as.totalAdults.text ?? '')
                                                  .toString(),
                                          "child":
                                              (as.totalChildren.text ?? '')
                                                  .toString(),
                                          "total_guest":
                                              (getController
                                                          .PropertyData!
                                                          .result!
                                                          .guest ??
                                                      '')
                                                  .toString(),
                                          "infant":
                                              (as.totalInphant.text ?? '')
                                                  .toString(),
                                          "coupon_code":
                                              getController.coupenCode.value ??
                                              "",
                                          "discount_amt":
                                              getController
                                                  .selectedDateWithPrice[0]
                                                  .discount
                                                  .toString() ??
                                              "",
                                          "discount_per":
                                              getController.offerPercentage
                                                  .toString() ??
                                              "",
                                          "host_offer_discount_status":
                                              getController
                                                      .isHostOfferApplied
                                                      .value
                                                  ? "1"
                                                  : "0",
                                          "offer_dis":
                                              getController
                                                  .selectedDateWithPrice[0]
                                                  .discountPercentage
                                                  .toString() ??
                                              "",
                                        }, context)
                                        .then((value) async {
                                          await getController.getApi(
                                            widget.slug,
                                            widget.id,
                                          );
                                        });
                              }
                            }
                          }
                        },
                      ),
                    ),
                ],
              ),
              const Divider(color: kDarkGrey),
              const SizedBox(height: 5),
              commonText(
                text: "Please Note:",
                color: kBlack,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
              ),
              commonText(
                text:
                    "This Property Can Acoomodates ${getController.PropertyData!.result!.guest.toString()} Person, "
                    "However Sleeping Capacity With Extra Matress is of ${getController.PropertyData!.result!.extraMattress} Person."
                    "Per Person Per Night Extra Charges Are – Rs. ${getController.PropertyData!.result!.nightExtraMattress}/- Which Should Be Paid at Property Before Check in.",
                color: kBlack,
                fontSize: 14,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Allaminities() {
    PropertyAllDetailsController getController = Get.put(
      PropertyAllDetailsController(),
    );
    ScrollController c = ScrollController();
    if (getController.PropertyData!.amenities == null) {
      return const SizedBox();
    } else {
      return Scaffold(
        backgroundColor: kWhite,
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_ios_new, color: kBlack),
                  ),
                  const Spacer(),
                  Text("All Amenities", style: Palette.headerText),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "What amenities this place offers",
                style: Palette.bottomTextDark.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: c,
                    itemCount: getController.PropertyData!.amenities!.length,
                    itemBuilder: ((context, i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (getController
                                        .PropertyData
                                        ?.amenities?[i]['title'] !=
                                    null &&
                                getController
                                    .PropertyData
                                    ?.amenities?[i]['title']
                                    .isNotEmpty) ...{
                              getController
                                          .PropertyData!
                                          .amenities![i]['amenitie_icon'] !=
                                      null
                                  ? cNetworkImage(
                                    getController
                                            .PropertyData!
                                            .amenities![i]['amenitie_icon'] ??
                                        '',
                                    //
                                    // color: kOrange,
                                    width: 24,
                                    height: 24,
                                  )
                                  : Image.asset(
                                    "assets/images/defaultAmenities.png",
                                    //
                                    // color: kOrange,
                                    width: 24,
                                    height: 24,
                                  ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: AutoSizeText(
                                  "${getController.PropertyData?.amenities?[i]['title']} x ${getController.PropertyData?.amenities?[i]['quantity']}",
                                  style: Palette.bestText2,
                                  minFontSize: 10,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            },
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
              // Wrap(
              //   spacing: 2,
              //   children: List.generate(
              //     getController.PropertyData!.amenities!.length,
              //     (i) {
              //       return Container(
              //         padding: const EdgeInsets.all(10),
              //         margin: const EdgeInsets.all(5),
              //         // color: kBlack.withOpacity(0.05),
              //         child: InkWell(
              //             onTap: () {},
              //             child: Row(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 getController.PropertyData!.amenities![i]
              //                             .amenitieIcon !=
              //                         null
              //                     ? cNetworkImage(
              //                         BaseConstant.BASE_IMG_URL +
              //                             EndPoint.amenities +
              //                             getController.PropertyData!
              //                                 .amenities![i].amenitieIcon!,
              //                         //
              //                         // color: kOrange,
              //                         width: 24,
              //                         height: 24,
              //                       )
              //                     : Image.asset(
              //                         "assets/images/defaultAmenities.png",
              //                         //
              //                         // color: kOrange,
              //                         width: 24,
              //                         height: 24,
              //                       ),
              //                 const SizedBox(
              //                   width: 10,
              //                 ),
              //                 Flexible(
              //                   child: AutoSizeText(
              //                     getController
              //                         .PropertyData!.amenities![i].title,
              //                     style: Palette.bestText2,
              //                     minFontSize: 10,
              //                     maxLines: 3,
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                 )
              //               ],
              //             )),
              //       );
              //     },
              //   ),
              // ),
              // Container(
              //   margin: const EdgeInsets.only(left: 10),
              //   child: MaterialButton(
              //       color: kOrange,
              //       shape: Palette.subCardShape,
              //       padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
              //       child: Text(
              //         'See all',
              //         style: Palette.bestText4,
              //       ),
              //       onPressed: () {
              //         Get.dialog(Scaffold(body: aminities()));
              //       }),
              // )
            ],
          ),
        ),
      );
    }
  }

  Widget PromoCodeDialog(
    BuildContext context,
    PropertyAllDetailsController controller,
  ) {
    return PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: const EdgeInsets.all(8),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(6),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                // height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        top: 12,
                        bottom: 5,
                      ),
                      child: Text(
                        "Promo Code",
                        style: Palette.splashscreenskip,
                      ),
                    ),
                    const Divider().paddingZero,
                    Obx(
                      () => SizedBox(
                        height: 350,
                        child:
                            getController.promocodeList.isEmpty
                                ? const Center(
                                  child: Text(
                                    'No promo codes available',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                                : ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: getController.promocodeList.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                        horizontal: 8,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/promo.png',
                                                cacheHeight: 500,
                                                cacheWidth: 500,
                                                color:
                                                    getController
                                                                .promocodeList[index]
                                                                .availability ==
                                                            '1'
                                                        ? null
                                                        : Colors.grey,
                                                height: 140,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 6,
                                                ),
                                                child: RotatedBox(
                                                  quarterTurns: 1,
                                                  child: Text(
                                                    '${getController.promocodeList[index].discountSymbol == '₹' ? '₹' : ''}${getController.promocodeList[index].codeAmount}${getController.promocodeList[index].discountSymbol == '%' ? '%' : ''} OFF',
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 140,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    getController
                                                                .promocodeList[index]
                                                                .availability ==
                                                            '1'
                                                        ? AppColors.colorFE6927
                                                            .withOpacity(0.1)
                                                        : Colors.grey.shade100,
                                                borderRadius:
                                                    const BorderRadius.horizontal(
                                                      right: Radius.circular(6),
                                                    ),
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color:
                                                        getController
                                                                    .promocodeList[index]
                                                                    .availability ==
                                                                '1'
                                                            ? AppColors
                                                                .colorFE6927
                                                            : Colors.grey,
                                                  ),
                                                  top: BorderSide(
                                                    color:
                                                        getController
                                                                    .promocodeList[index]
                                                                    .availability ==
                                                                '1'
                                                            ? AppColors
                                                                .colorFE6927
                                                            : Colors.grey,
                                                  ),
                                                  right: BorderSide(
                                                    color:
                                                        getController
                                                                    .promocodeList[index]
                                                                    .availability ==
                                                                '1'
                                                            ? AppColors
                                                                .colorFE6927
                                                            : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            (getController
                                                                        .promocodeList[index]
                                                                        .title ??
                                                                    '')
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  getController
                                                                              .promocodeList[index]
                                                                              .availability ==
                                                                          '1'
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .grey
                                                                          .shade600,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 7,
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: ('Code : '),
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    getController.promocodeList[index].availability ==
                                                                            '1'
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .grey
                                                                            .shade600,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      getController
                                                                          .promocodeList[index]
                                                                          .code ??
                                                                      '',
                                                                  style: TextStyle(
                                                                    color:
                                                                        getController.promocodeList[index].availability ==
                                                                                '1'
                                                                            ? Colors.green
                                                                            : Colors.grey.shade600,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      GestureDetector(
                                                        onTap:
                                                            getController
                                                                        .promocodeList[index]
                                                                        .availability ==
                                                                    '1'
                                                                ? () async {
                                                                  Get.back();
                                                                  loaderShow(
                                                                    context,
                                                                  );
                                                                  await getController.getPrice(
                                                                    isCoupenCode:
                                                                        true,
                                                                    params: {
                                                                      "property_id":
                                                                          getController
                                                                              .PropertyData
                                                                              ?.propertyId,

                                                                      // "from_date":
                                                                      //     "01-05-2024",

                                                                      // "to_date":
                                                                      //     "02-05-2024",
                                                                      "from_date":
                                                                          getController
                                                                              .startDate,
                                                                      "to_date":
                                                                          DateFormat(
                                                                                'dd-MM-yyyy',
                                                                              )
                                                                              .format(
                                                                                DateTime.now().add(
                                                                                  const Duration(
                                                                                    days:
                                                                                        45,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                              .toString(),
                                                                      "coupon_code":
                                                                          getController
                                                                              .promocodeList[index]
                                                                              .code,
                                                                    },
                                                                    success: () async {
                                                                      print(
                                                                        "Successs123",
                                                                      );

                                                                      getController
                                                                          .isCoupenApplied
                                                                          .value = true;
                                                                      getController
                                                                          .coupenCode
                                                                          .value = getController
                                                                              .promocodeList[index]
                                                                              .code ??
                                                                          '';
                                                                      getController
                                                                          .offerPercentage
                                                                          .value = (getController.promocodeList[index].codeAmount ??
                                                                                  0)
                                                                              .toString();
                                                                      getController
                                                                          .update();
                                                                      await getController
                                                                          .priceUpdate();
                                                                    },
                                                                  );

                                                                  loaderHide();
                                                                }
                                                                : null,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                                vertical: 4,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  4,
                                                                ),
                                                            border: Border.all(
                                                              color:
                                                                  getController
                                                                              .promocodeList[index]
                                                                              .availability ==
                                                                          '1'
                                                                      ? AppColors
                                                                          .colorFE6927
                                                                      : Colors
                                                                          .grey
                                                                          .shade600,
                                                            ),
                                                          ),
                                                          child: Text(
                                                            "Apply",
                                                            style: TextStyle(
                                                              color:
                                                                  getController
                                                                              .promocodeList[index]
                                                                              .availability ==
                                                                          '1'
                                                                      ? AppColors
                                                                          .colorFE6927
                                                                      : Colors
                                                                          .grey
                                                                          .shade600,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 14),
                                                  CustomPaint(
                                                    painter:
                                                        DottedBorderPainter(),
                                                    size: Size(
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width,
                                                      2,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Text(
                                                    "Valid From : ${(DateFormat('yyyy-MM-dd').format(DateTime.parse(getController.promocodeList[index].validFrom ?? '')))}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          getController
                                                                      .promocodeList[index]
                                                                      .availability ==
                                                                  '1'
                                                              ? Colors.black
                                                              : Colors
                                                                  .grey
                                                                  .shade600,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    "To Valid : ${(DateFormat('yyyy-MM-dd').format(DateTime.parse(getController.promocodeList[index].validTill ?? '')))}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          getController
                                                                      .promocodeList[index]
                                                                      .availability ==
                                                                  '1'
                                                              ? Colors.black
                                                              : Colors
                                                                  .grey
                                                                  .shade600,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(width: 10),
                        CommonButton(
                          onPressed: () {
                            getController.messageCode.value = '';
                            getController.coupenSuccess.value = false;
                            Navigator.pop(context);
                          },
                          color: Colors.grey.shade600,
                          name: 'Close',
                        ),
                        const SizedBox(width: 5),
                        Obx(
                          () =>
                              getController.coupenSuccess.value
                                  ? CommonButton(
                                    onPressed: () async {
                                      // Get.back();
                                      // loaderShow(context);
                                      // await getController.getPrice(
                                      //     isCoupenCode: true,
                                      //     params: {
                                      //       "property_id": getController
                                      //           .PropertyData?.propertyId
                                      //           .toString(),
                                      //       "from_date":
                                      //           DateFormat('dd-MM-yyyy')
                                      //               .format(DateTime.now())
                                      //               .toString(),
                                      //       "to_date": DateFormat('dd-MM-yyyy')
                                      //           .format(DateTime.now().add(
                                      //               const Duration(days: 45)))
                                      //           .toString(),
                                      //       "coupon_code":
                                      //           getController.promocodeList[index].code,
                                      //     },
                                      //     success: () async {
                                      //       print("Successs123");
                                      //       getController
                                      //           .isCoupenApplied.value = true;
                                      //       getController.update();
                                      //       await getController.priceUpdate();
                                      //     });

                                      // loaderHide();
                                    },
                                    name: 'Apply',
                                  )
                                  : const SizedBox.shrink(),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 120.0, left: 280),
                child: GestureDetector(
                  onTap: () {
                    getController.messageCode.value = '';
                    getController.coupenSuccess.value = false;
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.color9a0400,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/appbar_icons/close.svg',
                      ),
                    ),
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

String generateRandomOrderId({int length = 8}) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(
    List.generate(
      length,
      (index) => chars.codeUnitAt(random.nextInt(chars.length)),
    ),
  );
}

// class _AppointmentDataSource extends CalendarDataSource {
//   _AppointmentDataSource(List<Appointment> source) {
//     /* source.forEach((element) {
//       if (source.contains(element)) {
//         log(element.subject, name: 'CONTAINS');
//         source.remove(element);
//       }
//     });*/

//     appointments = source.toSet().toList();

//     myIdBookingList.value = source.toSet().toList();
//     log(myIdBookingList.toString(), name: 'Calender mybookingList');
//   }
// }

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color =
              Colors
                  .grey
                  .shade600 // Color of the dotted line
          ..strokeWidth =
              1 // Width of the dotted line
          ..style = PaintingStyle.fill;

    // Define the gap between each dot and the diameter of each dot
    const gap = 5.0;
    const dotDiameter = 2.0;

    double startX = 0.0;
    while (startX < size.width) {
      canvas.drawCircle(
        Offset(startX + dotDiameter / 2, size.height / 2),
        dotDiameter / 2,
        paint,
      );
      startX += dotDiameter + gap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class GuestReviewsWidget extends StatelessWidget {
  final List<dynamic> reviews;

  const GuestReviewsWidget({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    // final displayedReviews = reviews.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*     Text("See what guests loved the most",
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.w600
        ),),
      SizedBox(height: 20,),
        ...displayedReviews.map((review) => ReviewCard(review)).toList(),
    */
        SizedBox(height: 20),

        // Show "See More" button if more than 3 reviews
        if (reviews.isNotEmpty)
          Center(
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (_) => Dialog(
                        insetPadding: const EdgeInsets.all(16),
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 16,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "All Reviews",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ...reviews.map((r) => ReviewCard(r)).toList(),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: TextButton.styleFrom(
                                      backgroundColor: kOrange,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    child: const Text(
                                      "Close",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: kOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                "See All Review",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final dynamic review;

  const ReviewCard(this.review, {super.key});

  @override
  Widget build(BuildContext context) {
    final user = review['users'];
    final name = "${user['first_name']} ${user['last_name']}";
    final utcTime = DateTime.parse(review['updated_at']).toUtc();
    final localTime =
        utcTime
            .toLocal(); // Converts to local device time zone (should be IST if device is in India)
    final formatted = DateFormat("dd-MM-yyyy hh:mm a").format(localTime);
    final rating = review['rating'] ?? 0;
    final message = review['description'] ?? "";
    final isAproved = review['is_aproved'] ?? "0";

    print(review);
    print(review['created_at']);
    print(review['created_at']);
    print(review['created_at']);
    print(review['created_at']);
    print(review['created_at']);

    return message == ""
        ? Offstage()
        : Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(user['profile_src']),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${formatted}",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    /*const SizedBox(height: 5),
                Row(
                  children: List.generate(
                    5,
                        (index) => Icon(
                      index < rating
                          ? Icons.star
                          : Icons.star_border_outlined,
                      color:kOrange,
                      size: 18,
                    ),
                  ),
                ),*/
                    const SizedBox(height: 5),
                    Text(message),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        );
  }
}
