// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Menu/DashBoard/dashBoard_model.dart';
import 'package:gleekeyu/src/SubPages/SearchPlaces/searchPlaces_controller.dart';

import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/widgets/commonText.dart';
import 'package:gleekeyu/widgets/property_widget.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'SearchPlaces/searchBar.dart';




class PropertyList extends StatelessWidget {
  List<Properties> properties;
  String lat;
  String long;
  String startDate;
  String endDate;
  PropertyList(
      {super.key,
      required this.properties,
      required this.lat,
      required this.long,required this.startDate,required this.endDate});

  @override
  Widget build(BuildContext context) {
    BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
    return Scaffold(
      backgroundColor: kWhite,
      body: StatefulBuilder(builder: (context, StateSetter setState) {
        return Stack(
          children: [
            topMenu(properties: properties),

            bottomMenu(context, properties,startDate,endDate),
          ],
        );
      }),
    );
  }
}

class topMenu extends StatefulWidget {
  List<Properties> properties;
  topMenu({
    super.key,
    required this.properties,
  });

  @override
  State<topMenu> createState() => _topMenuState();
}

class _topMenuState extends State<topMenu> {
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(12, 12)),
            "assets/images/location.png")
        .then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> hotelMarkers = {};
    widget.properties.asMap().forEach((index, element) {
      hotelMarkers.add(
        Marker(
            markerId: MarkerId(index.toString()),
            position: LatLng(double.parse(element.propertyAddress?.latitude),
                double.parse(element.propertyAddress?.longitude)),
            draggable: true,
            infoWindow: InfoWindow(title: "${element.propertyName}"),
            icon: markerIcon),
      );
    });
    if (widget.properties.isEmpty) {
      return  SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back_ios_new,color: Colors.black,size: 25,),
              ),
              const SizedBox(
                width: 12,
              ),
            ],
          ),),
        ),
      );
    } else {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 10, right: 24, bottom: 12),
              child: SearchBarWidget(
                isShowFilter: true,
                uniqueId: 'listview',
              ),
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.height - 90) * 0.5,
              child: GoogleMap(
                mapType: MapType.normal,
                markers: hotelMarkers,

                //  {
                //   Marker(
                //     markerId: const MarkerId("marker2"),
                //     position: LatLng(double.parse(lat), double.parse(long)),
                //   ),
                // },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    double.parse(
                        widget.properties[0].propertyAddress?.latitude),
                    double.parse(
                      widget.properties[0].propertyAddress?.longitude,
                    ),
                  ),
                  zoom: 13.4746,
                ),
                //
              ),
            ),
          ],
        ),
      );
    }
  }
}

Widget bottomMenu(BuildContext context, List<Properties>? properties,String startDate,String endDate) {
  return DraggableScrollableSheet(
      initialChildSize: 0.52,
      minChildSize: 0.52,
      builder: ((context, scrollController) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return SafeArea(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                    color: kWhite,
                    boxShadow: [
                      BoxShadow(
                          color: kDarkGrey.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0.0, 5.0))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 12, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20)),
                        height: 4,
                        width: 40,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      (properties != null && properties.isNotEmpty)
                          ? GetBuilder<SearchPlacesController>(
                              initState: (a) {

                              },
                              builder: (a) {
                                return Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: ListView.builder(
                                            controller: scrollController,
                                            itemCount: properties != null
                                                ? properties.length
                                                : 0,
                                            itemBuilder: ((context, index) {
                                              return properties != null
                                                  ? PropertyVertical(
                                                fromSearch: true,
                                                      startDate: startDate,
                                                      endDate: endDate,
                                                      properties:
                                                          properties[index])
                                                  : null;
                                            })),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                commonText(
                                  text: "Not Found",
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                                Image.asset(
                                  "assets/images/coming-soon-bg.webp",
                                  height: 220,
                                  cacheHeight: 500,
                                  cacheWidth: 500,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                commonText(
                                  text: "No Results Found",
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            )),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      }));
}
