import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/extras/app_colors.dart';
import 'package:gleekeyu/src/SubPages/SearchPlaces/searchBar.dart';
import 'package:gleekeyu/src/SubPages/SearchPlaces/searchPlaces_controller.dart';
import 'package:gleekeyu/src/SubPages/best_propert_view_all.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/src/SubPages/PropertyTypeByID/property_type.dart';
import 'package:gleekeyu/widgets/Shimmer/shimmer_box.dart';
import 'package:gleekeyu/widgets/loder.dart';
import 'package:gleekeyu/widgets/property_widget.dart';
import '../../../utils/style/palette.dart';

import '../../SubPages/PropertyAllDetails/propertyAllDetails_controller.dart';
import '../../SubPages/confirm_n_pay/confirm_n_pay.dart';
import 'CountdownTimerWidget.dart';
import 'dashBoard_model.dart';
import 'dashboard_controller.dart';
import 'package:intl/intl.dart';
class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with TickerProviderStateMixin {
  AnimationController? controller;
  int count = 0;
  bool isSearchVisible = false;
  // late final TickerTextController _tickerTextController;
  String dragDirection = '';
  double startDXPoint = 20;
  double startDYPoint = 0;
  double? dXPoint;
  double? dYPoint;
  String? velocity;
  DashBoardController dashBoardController=Get.find();
  PropertyAllDetailsController getController =
  Get.find();

  @override
  initState() {
    super.initState();
    controller = BottomSheet.createAnimationController(this);
    controller?.duration = const Duration(seconds: 1);
    controller?.reverseDuration = const Duration(seconds: 1);
    controller?.drive(CurveTween(curve: Curves.easeIn));
    dashBoardController.getApi();
    dashBoardController.getInqApi();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  double zoneHeight = 122;
  double zoneWidth = 112;
  double topY = 21;
  double leftX = 16;
  late double initX;
  late double initY;
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: GetBuilder<DashBoardController>(
        initState: (a) {},
        builder: (a) {
          return a.isDataLoaded
              ? Scaffold(
                  resizeToAvoidBottomInset: true,
                  appBar: AppBar(
                    elevation: 0,
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    flexibleSpace: Stack(
                      children: [
                        SizedBox(
                          width: Get.width,
                          child: const Image(
                            image: AssetImage(
                              'assets/images/appbar_back.png',
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          margin: const EdgeInsets.only(
                            bottom: 30,
                            right: 10,
                          ),
                          height: 70,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.transparent),
                          child: Image.asset(
                            'assets/images/app_logo.png',
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 30,
                          child: dashBoardController.inquiryModel!=null && dashBoardController.inquiryModel!.inquiryModelData!=null ?GestureDetector(
                            onTap: () async {




                              /* Get.to(() =>
                                  ConfirmNpay(
                                    propertyType: getController.PropertyData!.result!.propertyTypeName ?? '',
                                    propertyID: (dashBoardController.inquiryModel!.inquiryModelData!.propertyId).toString(),
                                    coverImg: getController.PropertyData!.result!.coverPhoto,
                                    totalPrice: getController.totalPrice ?? (getController.dateprice![0].originalPrice ?? 0),
                                    selectedDates: getController.selectedDateWithPrice,
                                  ));
                             */


                              await getController.getBasketApi(dashBoardController.inquiryModel!.inquiryModelData!.slug!,
                                  dashBoardController.inquiryModel!.inquiryModelData!.propertyId!.toString(),
                                DateFormat('dd-MM-yyyy').format( DateTime.parse(dashBoardController.inquiryModel!.inquiryModelData!.data!.checkIn!)),
                                DateFormat('dd-MM-yyyy').format( DateTime.parse(dashBoardController.inquiryModel!.inquiryModelData!.data!.checkOut!)),).then((value) async {


                                  getController.startDate= DateFormat('dd-MM-yyyy').format( DateTime.parse(dashBoardController.inquiryModel!.inquiryModelData!.data!.checkIn!));
                                  getController.endDate= DateFormat('dd-MM-yyyy').format( DateTime.parse(dashBoardController.inquiryModel!.inquiryModelData!.data!.checkOut!));

                                  print("asdasdasdasd");
                                  print(dashBoardController
                                      .inquiryModel!.inquiryModelData!
                                      .data!.couponCode);

                               if(dashBoardController.inquiryModel!.inquiryModelData!.data!.couponCode!=null) {
                                   await getController
                                       .getPrice(
                                       isCoupenCode:
                                       true,
                                       params: {
                                         "property_id": getController
                                             .PropertyData
                                             ?.propertyId,
                                         "from_date":
                                         getController
                                             .startDate,
                                         "to_date": DateFormat('dd-MM-yyyy')
                                             .format(DateTime.now().add(
                                             const Duration(days: 45)))
                                             .toString(),
                                         "coupon_code": dashBoardController
                                             .inquiryModel!.inquiryModelData!
                                             .data!.couponCode,
                                       },
                                       success: () async {
                                         print("Successs123");
                                         getController
                                             .isCoupenApplied
                                             .value = true;
                                         getController
                                             .coupenCode
                                             .value =
                                             dashBoardController.inquiryModel!
                                                 .inquiryModelData!.data!
                                                 .couponCode ??
                                                 '';
                                         getController
                                             .offerPercentage
                                             .value =
                                             (dashBoardController.inquiryModel!
                                                 .inquiryModelData!.data!
                                                 .discountPer ??
                                                 0)
                                                 .toString();
                                         getController
                                             .update();
                                         await getController.priceUpdate().then((value) {

                                           print( "getController.totalPrice");
                                           print( getController.totalPrice);
                                           print(getController
                                               .offerPercentage
                                               .value );

                                           Get.to(() =>   ConfirmNpay(
                                             propertyType: getController.PropertyData!.result!.propertyTypeName ?? '',
                                             propertyID: (getController.PropertyData!.result!.id ?? '').toString(),
                                             coverImg: getController
                                                 .PropertyData!.result!.coverPhoto,
                                             totalPrice:getController
                                                 .offerPercentage
                                                 .value !=null?
                                             getController.totalPrice! - int.parse(getController
                                                 .offerPercentage
                                                 .value)

                                                 : getController.totalPrice ??
                                                 (getController
                                                     .dateprice![0].originalPrice ??
                                                     0),
                                             selectedDates:
                                             getController.selectedDateWithPrice,
                                           ));
                                         },);
                                       });
                                 }else
                                   {

                                     await getController.priceUpdate().then((value) {
                                       Get.to(() =>   ConfirmNpay(
                                         propertyType: getController.PropertyData!.result!.propertyTypeName ?? '',
                                         propertyID: (getController.PropertyData!.result!.id ?? '').toString(),
                                         coverImg: getController
                                             .PropertyData!.result!.coverPhoto,
                                         totalPrice: getController.totalPrice ??
                                             (getController
                                                 .dateprice![0].originalPrice ??
                                                 0),
                                         selectedDates:
                                         getController.selectedDateWithPrice,
                                       ));
                                     },);
                                   }
                              },);




                            },
                            child: CountdownTimerWidget(
                              dateTimeStr: dashBoardController.inquiryModel!.inquiryModelData!.dateTime!, // from API
                              type: dashBoardController.inquiryModel!.inquiryModelData!.type!,
                            ),
                          ):SizedBox(),
                        )
                      ],
                    ),
                    toolbarHeight: 130,
                  ),
                  body: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 0),
                            child: RichText(
                              text: TextSpan(
                                  text: 'Find Your Ideal Staycation with ',
                                  style: TextStyle(
                                      color: AppColors.color000000,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                  children: [
                                    TextSpan(
                                      text: 'Gleekey',
                                      style: TextStyle(
                                          color: AppColors.colorFE6927,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900),
                                    )
                                  ]),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 0),
                            child: SearchBarWidget(
                              isShowFilter: false,
                              uniqueId: 'dashboard_view',
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 95,
                                          child: PropertyById(),
                                        ),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        Text(
                                          'Top Destinations',
                                          style: Palette.headerText,
                                        ),
                                      ],
                                    ),
                                  ),
                                  topDestination(),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Best Properties Near You',
                                                  style: Palette.headerText,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(() =>
                                                      const BestPropertyViewAll());
                                                },
                                                child: Text(
                                                  'View All  ',
                                                  style: Palette.viewALLText,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 15,
                                        ),

                                        GetBuilder<DashBoardController>(
                                          builder: (c) {
                                            if (c.properties.isNotEmpty) {
                                              return CarouselSlider.builder(
                                                itemCount: c.properties.length,
                                                itemBuilder: (context, index, realIndex) {
                                                  return Property(
                                                    properties: c.properties[index],
                                                    fromSearch: false,
                                                  );
                                                },
                                                options: CarouselOptions(
                                                  height: 310,               // Fixed height to avoid vertical overflow
                                                  autoPlay: true,               // Enables auto-scroll
                                                  autoPlayInterval: Duration(seconds: 3), // Duration between scrolls
                                                  autoPlayAnimationDuration: Duration(milliseconds: 800), // Smooth scrolling
                                                  autoPlayCurve: Curves.linear,  // Natural feel
                                                  enlargeCenterPage: false,      // Highlight center item
                                                  viewportFraction: 0.7,        // Control item width visibility
                                                ),
                                              );
                                             /* return SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: List.generate(
                                                        c.properties.length,
                                                        (index) {
                                                      return Property(
                                                        properties:
                                                            c.properties[index],
                                                      );
                                                    })),
                                              );*/
                                            } else {
                                              return Center(
                                                child: Image.asset(
                                                  'assets/images/no_data_found.png',
                                                  height: 200,
                                                  cacheHeight: 200,
                                                  cacheWidth: 200,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Divider(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            thickness: 0.4,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Gleekey's Choice",
                                                  style: Palette.headerText,
                                                ),
                                              ),
                                              GetBuilder<DashBoardController>(
                                                  builder: (a) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Bounce(
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      onPressed: () {
                                                        if (a.pageController
                                                            .hasClients) {
                                                          a.pageController.animateToPage(
                                                              a.currentGleekeyChoiceIndex.value == 0
                                                                  ? a.gleekeyChoiceProperty
                                                                          .length -
                                                                      1
                                                                  : a.currentGleekeyChoiceIndex
                                                                          .value -
                                                                      1,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          200),
                                                              curve: Curves
                                                                  .easeInOut);
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: kOrange,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: const Center(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 6.0),
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_back_ios,
                                                              color: kWhite,
                                                              size: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Bounce(
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      onPressed: () {
                                                        if (a.pageController
                                                            .hasClients) {
                                                          a.pageController.animateToPage(
                                                              a.currentGleekeyChoiceIndex
                                                                          .value ==
                                                                      a.gleekeyChoiceProperty
                                                                              .length -
                                                                          1
                                                                  ? 0
                                                                  : a.currentGleekeyChoiceIndex
                                                                          .value +
                                                                      1,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          200),
                                                              curve: Curves
                                                                  .bounceIn);
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: kOrange,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: const Center(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 6.0),
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              color: kWhite,
                                                              size: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 14,
                                        ),
                                        GetBuilder<DashBoardController>(
                                            builder: (c) {
                                          if (c.gleekeyChoiceProperty.isEmpty) {
                                            return Center(
                                              child: Image.asset(
                                                'assets/images/no_data_found.png',
                                                height: 200,
                                                cacheHeight: 200,
                                                cacheWidth: 200,
                                              ),
                                            );
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: ExpandablePageView(
                                              // pageController: c.pageController,
                                              onPageChanged: (value) {
                                                c.currentGleekeyChoiceIndex
                                                    .value = value;
                                                c.currentGleekeyChoiceIndex
                                                    .refresh();
                                              },
                                              children: List.generate(
                                                c.gleekeyChoiceProperty.length,
                                                (index) =>
                                                    GleekeyChoicePropertyWidget(
                                                  properties:
                                                      c.gleekeyChoiceProperty[
                                                          index],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        GetBuilder<DashBoardController>(
                                            builder: (a) {
                                          return StreamBuilder(
                                              stream: a
                                                  .currentGleekeyChoiceIndex
                                                  .stream,
                                              builder: (context, stream) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: List.generate(
                                                    a.gleekeyChoiceProperty
                                                        .length,
                                                    (index) {
                                                      return Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                            left: 2, right: 2),
                                                        height: 6,
                                                        width: 6,
                                                        decoration: BoxDecoration(
                                                            color: a.currentGleekeyChoiceIndex
                                                                        .value ==
                                                                    index
                                                                ? AppColors
                                                                    .colorFE6927
                                                                : const Color(
                                                                    0xFFEEEAFB),
                                                            shape: BoxShape
                                                                .circle),
                                                      );
                                                    },
                                                  ),
                                                );
                                              });
                                        }),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Divider(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            thickness: 0.4,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Best Seller Properties',
                                                  style: Palette.headerText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        GetBuilder<DashBoardController>(
                                          builder: (c) {
                                            if (c
                                                .bestSellerProperties.isEmpty) {
                                              return Center(
                                                child: Image.asset(
                                                  'assets/images/no_data_found.png',
                                                  height: 200,
                                                  cacheHeight: 200,
                                                  cacheWidth: 200,
                                                ),
                                              );
                                            } else {
                                              return SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: List.generate(
                                                        c.bestSellerProperties
                                                            .length, (index) {
                                                      return Property(
                                                        fromSearch: false,
                                                        properties:
                                                            c.bestSellerProperties[
                                                                index],
                                                      );
                                                    })),
                                              );
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Divider(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            thickness: 0.4,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Popular Properties',
                                                  style: Palette.headerText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 15,
                                        ),
                                        GetBuilder<DashBoardController>(
                                          builder: (c) {
                                            if (c.popularProperties.isEmpty) {
                                              return Center(
                                                child: Image.asset(
                                                  'assets/images/no_data_found.png',
                                                  height: 200,
                                                  cacheHeight: 200,
                                                  cacheWidth: 200,
                                                ),
                                              );
                                            } else {
                                              return SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: List.generate(
                                                        c.popularProperties
                                                            .length, (index) {
                                                      return Property(
                                                        properties:
                                                            c.popularProperties[
                                                                index],
                                                        fromSearch: false,
                                                      );
                                                    })),
                                              );
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        // whyUShoulChooseUsWidget(),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Divider(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            thickness: 0.4,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        customerReviewWidget(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Scaffold(
                  body: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Expanded(child: ShimmerBox(60, dwidth)),
                          const SizedBox(
                            width: 12,
                          ),
                          ShimmerBox(60, 60),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FlexiShimmerBox(150, (dwidth / 2 - 24).toInt()),
                          const SizedBox(
                            width: 24,
                          ),
                          FlexiShimmerBox(150, (dwidth / 2 - 24).toInt())
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FlexiShimmerBox(150, (dwidth / 2 - 24).toInt()),
                          const SizedBox(
                            width: 24,
                          ),
                          FlexiShimmerBox(150, (dwidth / 2 - 24).toInt())
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Expanded(
                        child: ShimmerBox(180, dwidth),
                      )
                    ],
                  ),
                ));
        },
      ),
    );
  }

  Widget whyUShoulChooseUsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Why You Should Choose Us ?',
            style: Palette.headerText,
          ),
        ),
        Center(
          child: Text(
            'It would be best if you chose us because we provide the best accommodation and we have sorted all the villas here based on their quality.',
            style: Palette.bestText2,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: kOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '01',
                    style: Palette.onboardingText1.copyWith(fontSize: 12),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'We provide the best choice of farmhouses for you to stay.',
                  style: Palette.bookingTabunSelected
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "We always prioritize customer comfort and satisfaction. That's why we only accept the best villas and farmhouses.",
                  style: Palette.bestText2.copyWith(fontSize: 11),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            )),
            Expanded(
              child: Image.asset(
                'assets/images/why-choose-us.png',
              ),
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: kOrange,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '02',
            style: Palette.onboardingText1.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Low price with the best quality',
          style: Palette.bookingTabunSelected
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "Although the price tends to be low but it will not affect the quality of service, so don't worry.",
          style: Palette.bestText2.copyWith(fontSize: 11),
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: kOrange,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '03',
            style: Palette.onboardingText1.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'Best Refund Policy',
          style: Palette.bookingTabunSelected
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "Don't worry if suddenly you have a problem and want to do a refund, with gleekey you can get a best refund prices.",
          style: Palette.bestText2.copyWith(fontSize: 11),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget customerReviewWidget() {
    DashBoardController controller = Get.find();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Text(
                'Customer Testimonials',
                style: Palette.headerText,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Bounce(
                      duration: const Duration(milliseconds: 300),
                      onPressed: () {controller.carouselController.previousPage();},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          color: kOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: Icon(
                              Icons.arrow_back_ios, color: kWhite, size: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Bounce(
                      duration: const Duration(milliseconds: 300),
                      onPressed: () {
                        controller.carouselController.nextPage();
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          color: kOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: kWhite,
                              size: 15,
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
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CarouselSlider.builder(
            carouselController: controller.carouselController,
            itemCount: controller.testimonials.length,
            itemBuilder: (context, index, realIndex) {
              return Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                margin: const EdgeInsets.only(
                    bottom: 10, top: 10, left: 8, right: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: const Color(0xFFFFF7F4).withOpacity(0.9),
                    border: Border.all(
                        color: AppColors.colorFE6927.withOpacity(0.1))
                    // boxShadow: [
                    //   BoxShadow(
                    //     blurRadius: 4,
                    //     spreadRadius: 0,
                    //     offset: const Offset(0, 0),
                    //     color: const Color(0xFF000000).withOpacity(0.1),
                    //   ),
                    // ],
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // Makes it a perfect circle
                            border: Border.all(),
                          ),
                          child: ClipOval( // Ensures the image inside is also circular
                            child: CachedNetworkImage(
                              imageUrl: "https://gleekey.in/public/front/images/testimonial/${controller.testimonials[index].image}",
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => const Center(
                                child: Icon(Icons.error),
                              ),
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          // Wrap with Expanded
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                controller.testimonials[index].name,
                                style: TextStyle(
                                  color: AppColors.colorFE6927,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                controller.testimonials[index].description,
                                style: TextStyle(
                                  color: AppColors.color000000,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                // Handle overflow
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            options: CarouselOptions(
              autoPlay: true,
              onPageChanged: (index, reason) {
                controller.currentTestimonialsIndex.value = index;
              },
              aspectRatio: 2.4,
              enlargeCenterPage: true, // Optional: Make the center item larger
              enableInfiniteScroll:
                  false, // Optional: Disable infinite scrolling
              viewportFraction: 1.0,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        GetBuilder<DashBoardController>(builder: (a) {
          return StreamBuilder(
              stream: a.currentTestimonialsIndex.stream,
              builder: (context, stream) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    a.testimonials.length,
                    (index) {
                      return Container(
                        margin: const EdgeInsets.only(left: 2, right: 2),
                        height: 6,
                        width: 6,
                        decoration: BoxDecoration(
                            color: a.currentTestimonialsIndex.value == index
                                ? AppColors.colorFE6927
                                : const Color(0xFFEEEAFB),
                            shape: BoxShape.circle),
                      );
                    },
                  ),
                );
              });
        }),
      ],
    );
  }

  PageController pageController = PageController(
    initialPage: 0,
  );
  Widget topDestination() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),


    child: GetBuilder<DashBoardController>(
        builder: (controller) => Container(
      height: 210,
      alignment: Alignment.topCenter,
      width: Get.width,
      child: Column(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
              height: 150,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1.1, // Ensures full width
              onPageChanged: (index, reason) {
                controller.setPageIndex(index);
              },
            ),
            itemCount: (controller.startingCities.length / 3).ceil(),
            itemBuilder: (context, pageIndex, realIndex) {
              int startIndex = pageIndex * 3;
              int endIndex = (pageIndex + 1) * 3;

              endIndex = endIndex > controller.startingCities.length
                  ? controller.startingCities.length
                  : endIndex;

              List<StartingCities> pageItems =
              controller.startingCities.sublist(startIndex, endIndex);

              return MyPageWidget(
                startingCities: pageItems,
              );
            },
          ),
          const SizedBox(height: 18),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                (controller.startingCities.length / 3).ceil(),
                    (index) {
                  return Container(
                    margin: const EdgeInsets.only(left: 2, right: 2),
                    height: 6,
                    width: 6,
                    decoration: BoxDecoration(
                      color: controller.currentIndex.value == index
                          ? AppColors.colorFE6927
                          : const Color(0xFFEEEAFB),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
    ),

    );
  }



  Widget best_property() {
    return GetBuilder<DashBoardController>(
      builder: (c) {
        return ListView.builder(
          itemCount: c.properties.length,
          primary: false,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Property(
              properties: c.properties[index],
              fromSearch: false,
            );
          },
        );
      },
    );
  }
}

class MyPageWidget extends StatelessWidget {
  List<StartingCities> startingCities = [];

  MyPageWidget({super.key, required this.startingCities});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: startingCities.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Bounce(
            duration: const Duration(milliseconds: 150),
            onPressed: () {
              loaderShow(context);
              SearchPlacesController a = Get.find();
              a.selectedPlace = item.name ?? 'Farm';
              a.getApi();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.colorFE6927,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          spreadRadius: 0,
                          offset: const Offset(0, 3),
                          color: const Color(0xFF000000).withOpacity(0.2),
                        )
                      ]),
                  child: Center(
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        placeholder: (context, url) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return const Center(
                            child: Icon(Icons.error),
                          );
                        },
                        height: 110,
                        width: 110,
                        memCacheHeight: 110,
                        memCacheWidth: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ExpandablePageView extends StatefulWidget {
  final List<Widget> children;
  // PageController pageController;
  Function(int value) onPageChanged;
  ExpandablePageView(
      {Key? key,
      required this.children,
      // required this.pageController,
      required this.onPageChanged})
      : super(key: key);

  @override
  State<ExpandablePageView> createState() => _ExpandablePageViewState();
}

class _ExpandablePageViewState extends State<ExpandablePageView>
    with TickerProviderStateMixin {
  late List<double> _heights;
  int _currentPage = 0;

  double get _currentHeight => _heights.isEmpty ? 0 : _heights[_currentPage];
  late PageController pageController;
  DashBoardController dashBoardController = Get.find();
  @override
  void initState() {
    _heights = widget.children.map((e) => 0.0).toList();
    super.initState();
    pageController = PageController()
      ..addListener(() {
        final newPage = pageController.page?.round() ?? 0;
        if (_currentPage != newPage) {
          setState(() => _currentPage = newPage);
        }
      });
    dashBoardController.pageController = pageController;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: Curves.easeInOutCubic,
      duration: const Duration(milliseconds: 100),
      tween: Tween<double>(
          begin: _heights.isEmpty ? 0 : _heights[0], end: _currentHeight),
      builder: (context, value, child) => SizedBox(height: value, child: child),
      child: PageView(
        controller: pageController,
        onPageChanged: widget.onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: _sizeReportingChildren
            .asMap() //
            .map(
              (index, child) => MapEntry(
                index,
                child,
              ),
            )
            .values
            .toList(),
      ),
    );
  }

  List<Widget> get _sizeReportingChildren => widget.children
      .asMap() //
      .map(
        (index, child) => MapEntry(
          index,
          OverflowBox(
            //needed, so that parent won't impose its constraints on the children, thus skewing the measurement results.
            minHeight: 0,
            maxHeight: double.infinity,
            alignment: Alignment.topCenter,
            child: SizeReportingWidget(
              onSizeChange: (size) =>
                  setState(() => _heights[index] = size.height),
              child: Align(child: child),
            ),
          ),
        ),
      )
      .values
      .toList();
}

class SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  const SizeReportingWidget({
    Key? key,
    required this.child,
    required this.onSizeChange,
  }) : super(key: key);

  @override
  State<SizeReportingWidget> createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((a) => _notifySize());
    return widget.child;
  }

  void _notifySize() {
    if (!mounted) {
      return;
    }
    final size = context.size;
    if (_oldSize != size && size != null) {
      _oldSize = size;
      widget.onSizeChange(size);
    }
  }
}
