// ignore_for_file: depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/SubPages/SearchPlaces/searchPlaces_controller.dart';
import 'package:gleekeyu/src/SubPages/appBarWithTitleAndBack.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/utils/style/palette.dart';
import 'package:gleekeyu/widgets/cNetworkImage.dart';
import 'package:gleekeyu/widgets/c_dropdown.dart';
import 'package:gleekeyu/widgets/commonText.dart';
import 'package:gleekeyu/widgets/loder.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:intl/intl.dart';
import 'filter_controller.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final FilterController a = Get.put(FilterController());
  @override
  void initState() {
    a.currMaxPrice =
        double.parse(a.result['data']['default_max_price'].toString());
    a.currMinPrice =
        double.parse(a.result['data']['default_min_price'].toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GetBuilder<FilterController>(
            initState: (a) {},
            builder: (a) {
              return Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: kWhite,
                appBar: AppBarWithTitleAndBack(title: "Filter"),
                body: a.isDataLoaded
                    ? SingleChildScrollView(
                        child: GetBuilder<FilterController>(
                          initState: (a) {},
                          builder: (a) {
                            return Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commonText(
                                    text: "Price Range",
                                    color: kBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const SizedBox(
                                    height: 45,
                                  ),
                                  Flexible(
                                    child: SizedBox(
                                      child: GetBuilder<FilterController>(
                                        initState: (a) {},
                                        builder: (a) {
                                          return SfRangeSlider(
                                            shouldAlwaysShowTooltip: true,
                                            tooltipShape:
                                                const SfRectangularTooltipShape(),
                                            min: double.parse(a.result['data']
                                                    ['default_min_price']
                                                .toString()),
                                            max: double.parse(a.result['data']
                                                    ['default_max_price']
                                                .toString()),
                                            values: SfRangeValues(
                                                a.currMinPrice, a.currMaxPrice),
                                            numberFormat: NumberFormat(''),
                                            // showTicks: false,
                                            // showLabels: false,
                                            enableTooltip: true,
                                            onChanged: (SfRangeValues values) {
                                              a.values = values;
                                              a.currMinPrice = double.parse(
                                                  values.start.toString());
                                              a.currMaxPrice = double.parse(
                                                  values.end.toString());
                                              a.update();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    height: 1,
                                    color: kDarkGrey,
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  commonText(
                                    text: "Sort By",
                                    color: kBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const SizedBox(
                                    height: 22,
                                  ),
                                  GetBuilder<FilterController>(
                                    initState: (a) {},
                                    builder: (a) {
                                      return cDropDown(
                                          hintText: 'Select Sort By',
                                          onChanged: (p0) {
                                            a.sortBy = p0 == 1
                                                ? "chepest"
                                                : p0 == 2
                                                    ? 'expensive'
                                                    : '';
                                          },
                                          items: [
                                            'Select Sort By',
                                            'Most Affordable',
                                            'Most Economical',
                                          ]);
                                    },
                                  ),
                                  const SizedBox(
                                    height: 22,
                                  ),
                                  const Divider(
                                    height: 1,
                                    color: kDarkGrey,
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  commonText(
                                    text: "Rooms And Beds",
                                    color: kBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const SizedBox(
                                    height: 22,
                                  ),
                                  GetBuilder<FilterController>(
                                    initState: (a) {},
                                    builder: (a) {
                                      return Wrap(
                                        runSpacing: 16,
                                        spacing: 16,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/bed.png',
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  commonText(
                                                      text: 'Bedrooms',
                                                      color: Colors.black,
                                                      fontSize: 14)
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              cDropDown(
                                                width: 150,
                                                height: 35,
                                                hintText:
                                                    a.totalBedrooms.toString(),
                                                items: [
                                                  'Bedrooms',
                                                  '1',
                                                  '2',
                                                  '3',
                                                  '4',
                                                  '5',
                                                  '6',
                                                  '7',
                                                  '8',
                                                  '9',
                                                  '10',
                                                ],
                                                onChanged: (p0) {
                                                  a.totalBedrooms = p0 ?? 0;
                                                },
                                              )
                                            ],
                                          ),
                                          // Column(
                                          //   mainAxisSize: MainAxisSize.min,
                                          //   children: [
                                          //     Row(
                                          //       mainAxisSize: MainAxisSize.min,
                                          //       children: [
                                          //         Image.asset(
                                          //             'assets/images/bathroom.png'),
                                          //         const SizedBox(
                                          //           width: 12,
                                          //         ),
                                          //         commonText(
                                          //             text: 'Bathrooms',
                                          //             color: Colors.black,
                                          //             fontSize: 14)
                                          //       ],
                                          //     ),
                                          //     const SizedBox(
                                          //       height: 12,
                                          //     ),
                                          //     cDropDown(
                                          //       width: 150,
                                          //       hintText:
                                          //           a.totalBedrooms.toString(),
                                          //       items: [
                                          //         'Bathrooms',
                                          //         '1',
                                          //         '2',
                                          //         '3',
                                          //         '4',
                                          //         '5',
                                          //         '6',
                                          //         '7',
                                          //         '8',
                                          //         '9+',
                                          //       ],
                                          //       onChanged: (p0) {
                                          //         a.totalBathrooms = p0 ?? 0;
                                          //       },
                                          //     )
                                          //   ],
                                          // ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                      'assets/images/guest.png'
                                                      ,
                                                      height: 20,
                                                      width: 20,
                                                      ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  commonText(
                                                      text: 'Allow Guest',
                                                      color: Colors.black,
                                                      fontSize: 14)
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.5,
                                                height: 40,
                                                child: TextFormField(
                                                  onChanged: (value) {
                                                    if (value
                                                        .trim()
                                                        .isNotEmpty) {
                                                      a.totalAllowGuest =
                                                          int.parse(value);
                                                    }
                                                  },
                                                  initialValue: a
                                                      .totalAllowGuest
                                                      .toString(),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    MaskTextInputFormatter(
                                                        mask:
                                                            '#############################################################',
                                                        filter: {
                                                          "#": RegExp(r'[0-9]')
                                                        },
                                                        type:
                                                            MaskAutoCompletionType
                                                                .lazy)
                                                  ],
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                      bottom: 10,
                                                      left: 12,
                                                    ),
                                                    isDense: true,
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/sleeping_capecity.png',
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  commonText(
                                                      text: 'Sleeping Capacity',
                                                      color: Colors.black,
                                                      fontSize: 14)
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.5,
                                                height: 35,
                                                child: TextFormField(
                                                  onChanged: (value) {
                                                    if (value
                                                        .trim()
                                                        .isNotEmpty) {
                                                      a.totalSleepingCapacity =
                                                          int.parse(value);
                                                    }
                                                  },
                                                  initialValue: a
                                                      .totalSleepingCapacity
                                                      .toString(),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    MaskTextInputFormatter(
                                                        mask:
                                                            '#############################################################',
                                                        filter: {
                                                          "#": RegExp(r'[0-9]')
                                                        },
                                                        type:
                                                            MaskAutoCompletionType
                                                                .lazy)
                                                  ],
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                      bottom: 10,
                                                      left: 12,
                                                    ),
                                                    isDense: true,
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),

                                  const SizedBox(
                                    height: 22,
                                  ),
                                  const Divider(
                                    height: 1,
                                    color: kDarkGrey,
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  commonText(
                                    text: "Property Type",
                                    color: kBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const SizedBox(
                                    height: 22,
                                  ),
                                  SizedBox(
                                      height: 95,
                                      child: GetBuilder<FilterController>(
                                          builder: (a) {
                                        return ListView.builder(
                                          itemCount: a.PropertyTypeName.length,
                                          primary: false,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Bounce(
                                                    duration: const Duration(
                                                        milliseconds: 150),
                                                    onPressed: () {
                                                      a.filteredPropertyType
                                                              .contains(
                                                                  a.PropertyTypeID[
                                                                      index])
                                                          ? a.filteredPropertyType
                                                              .remove(
                                                                  a.PropertyTypeID[
                                                                      index])
                                                          : a.filteredPropertyType
                                                              .add(
                                                                  a.PropertyTypeID[
                                                                      index]);
                                                      a.update();
                                                    },
                                                    child: Container(
                                                      height: 75,
                                                      width: 75,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            Colors.transparent,
                                                        border: Border.all(
                                                            color: a.filteredPropertyType
                                                                    .contains(
                                                                        a.PropertyTypeID[
                                                                            index])
                                                                ? kOrange
                                                                : kBlack
                                                                    .withOpacity(
                                                                        0.2),
                                                            width: 2.0),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          a.filteredPropertyType
                                                                  .contains(
                                                                      a.PropertyTypeID[
                                                                          index])
                                                              ? Positioned(
                                                                  top: 5,
                                                                  right: 3,
                                                                  child: Image
                                                                      .asset(
                                                                    "assets/images/checked.png",
                                                                    height: 14,
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                          Center(
                                                            child:
                                                                cNetworkImage(
                                                              "${BaseConstant.BASE_PROPERTY_TYPE_IMG_URL}${a.PropertyTypeIcon[index]}",
                                                              width: 30,
                                                              height: 30,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Flexible(
                                                    child: commonText(
                                                      text: a.PropertyTypeName[
                                                          index],
                                                      color: kBlack,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      })),

                                  const SizedBox(
                                    height: 14,
                                  ),

                                  const Divider(
                                    height: 1,
                                    color: kDarkGrey,
                                  ),
                                  // const SizedBox(
                                  //   height: 14,
                                  // ),
                                  // commonText(
                                  //   text: "Rooms and Beds",
                                  //   color: kBlack,
                                  //   fontSize: 12,
                                  //   fontWeight: FontWeight.w600,
                                  // ),
                                  // const SizedBox(
                                  //   height: 22,
                                  // ),
                                  // Row(
                                  //   mainAxisSize: MainAxisSize.min,
                                  //   children: [
                                  //     Column(
                                  //       children: [

                                  //       ],
                                  //     )
                                  //   ],
                                  // ),
                                  // const SizedBox(
                                  //   height: 14,
                                  // ),
                                  // const Divider(
                                  //   height: 1,
                                  //   color: kDarkGrey,
                                  // ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  commonText(
                                    text: "Amenities",
                                    color: kBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const SizedBox(
                                    height: 22,
                                  ),
                                  GetBuilder<FilterController>(
                                    initState: (a) {},
                                    builder: (a) {
                                      return SizedBox(
                                        child: Wrap(
                                          children: List.generate(
                                              a.totalAmenities,
                                              (index) =>
                                                  emenities(context, index)),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  GetBuilder<FilterController>(
                                    initState: (a) {},
                                    builder: (a) {
                                      return Bounce(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        onPressed: () {
                                          a.totalAmenities == 6
                                              ? a.totalAmenities = a
                                                  .result['data']['amenities']
                                                  .length
                                              : a.totalAmenities = 6;
                                          a.update();
                                        },
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: commonText(
                                            text: a.totalAmenities == 6
                                                ? "View More      "
                                                : "View Less      ",
                                            color: kOrange,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // const SizedBox(
                                  //   height: 14,
                                  // ),
                                  // const Divider(
                                  //   height: 1,
                                  //   color: kDarkGrey,
                                  // ),
                                  // const SizedBox(
                                  //   height: 14,
                                  // ),
                                  // commonText(
                                  //   text: "Ratings",
                                  //   color: kBlack,
                                  //   fontSize: 12,
                                  //   fontWeight: FontWeight.w600,
                                  // ),
                                  // const SizedBox(
                                  //   height: 22,
                                  // ),
                                  // FittedBox(
                                  //   fit: BoxFit.scaleDown,
                                  //   child: Row(
                                  //     mainAxisSize: MainAxisSize.min,
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: List.generate(
                                  //         5,
                                  //         (index) => Flexible(
                                  //             child: ratings(context, index))),
                                  //   ),
                                  // ),
                                  // const SizedBox(
                                  //   height: 14,
                                  // ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox(),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 24, left: 24, right: 24, top: 12),
                  child: SizedBox(
                    height: 60,
                    child: Bounce(
                      onPressed: () {
                        Get.back();
                        loaderShow(context);
                        SearchPlacesController getC = Get.find();
                        getC.getApi();
                        getC.update();
                        a.update();
                      },
                      duration: const Duration(milliseconds: 200),
                      child: Card(
                          elevation: 3,
                          shape: Palette.cardShape,
                          color: kOrange,
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Center(
                                child: Text(
                                  'Apply Filter',
                                  style: Palette.bestText4,
                                ),
                              ))),
                    ),
                  ),
                ),
              );
            }));
  }

  var isSelected = List.filled(5, false);

  Widget ratings(BuildContext context, index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: GestureDetector(
            onTap: (() {
              // setState(() {
              //   isSelected[index]
              //       ? isSelected[index] = false
              //       : isSelected[index] = true;
              // });
            }),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected[index] ? kOrange : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border:
                    Border.all(color: isSelected[index] ? kOrange : kLightGrey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    commonText(
                      text: (index + 1).toString(),
                      color: isSelected[index] ? kWhite : kLightGrey,
                      fontSize: 12,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Icon(
                      Icons.star_outline_rounded,
                      color: isSelected[index] ? kWhite : kLightGrey,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }

  Widget emenities(BuildContext context, index) {
    return GetBuilder<FilterController>(
      initState: (a) {},
      builder: (a) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Theme(
              data:
                  Theme.of(context).copyWith(unselectedWidgetColor: kDarkGrey),
              child: Checkbox(
                  value: a.amenitiesTitle
                      .contains(a.result['data']['amenities'][index]['title']),
                  onChanged: ((value) {
                    setState(() {
                      if (a.amenitiesTitle.contains(
                          a.result['data']['amenities'][index]['title'])) {
                        a.amenitiesID.removeWhere((element) =>
                            element ==
                            a.result['data']['amenities'][index]['id']);
                        a.amenitiesTitle.removeWhere((element) =>
                            element ==
                            a.result['data']['amenities'][index]['title']);
                      } else {
                        a.amenitiesTitle
                            .add(a.result['data']['amenities'][index]['title']);
                        a.amenitiesID
                            .add(a.result['data']['amenities'][index]['id']);
                      }
                    });
                  })),
            ),
            // Image.asset(
            //   "assets/images/wifi.png",
            //   height: 15,
            // ),
            // const SizedBox(
            //   width: 6,
            // ),
            commonText(
              text: a.result['data']['amenities'][index]['title'],
              color: kBlack,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ],
        );
      },
    );
  }
}
