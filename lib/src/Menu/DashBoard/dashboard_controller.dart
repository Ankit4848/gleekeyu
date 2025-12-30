// ignore_for_file: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_controller.dart';
import 'package:gleekeyu/src/Menu/DashBoard/dashBoard_model.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
import 'inquiry_model.dart';

class DashBoardController extends GetxController {
  UserLoginController getController = Get.find();
  double currDotValue = 0;
  double? currLatitude;
  double? currLongitude;
  RxInt currentIndex = 0.obs;
  DashBoard_model? dashBoard_model;
  InquiryModel? inquiryModel;
  List<StartingCities> startingCities = [];
  List<List<StartingCities>> cityPages = []; // <== Page-wise cached list
  PageController pageController = PageController();
  List<PropertyType> propertyType = [];
  List<Properties> properties = [];
  List<Properties> bestSellerProperties = [];
  List<Testimonials> testimonials = [];
  List<Properties> popularProperties = [];
  List<Properties> gleekeyChoiceProperty = [];

  RxInt currentGleekeyChoiceIndex = 0.obs;
  RxInt currentTestimonialsIndex = 0.obs;

  var isDataLoaded = false;

  final carousel_slider.CarouselSliderController carouselController =
      carousel_slider.CarouselSliderController();

  void setPageIndex(int index) {
    currentIndex.value = index;
    update(['indicator']); // Only update dots
  }

  int get pageCount => cityPages.length;

  void prepareCityPages() {
    cityPages.clear();
    for (int i = 0; i < startingCities.length; i += 3) {
      int end = (i + 3).clamp(0, startingCities.length);
      cityPages.add(startingCities.sublist(i, end));
    }
  }

  @override
  void onInit() async {
    isDataLoaded = false;

    await getLocation();
    super.onInit();
  }

  Future<void> getLocation() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        Location location = Location();
        LocationData currLocation = await location.getLocation();
        currLatitude = currLocation.latitude;
        currLongitude = currLocation.longitude;
      } else if (status.isDenied) {
        await [Permission.location].request();
        isDataLoaded = true;
        if ((await Permission.location.status).isGranted) {
          getLocation();
          return;
        } else {
          // User denied permission, use default coordinates
          currLongitude = 72.8160;
          currLatitude = 21.1637618;
        }
      } else if (status.isPermanentlyDenied) {
        // Don't force open settings on app startup
        // Use default coordinates instead
        currLongitude = 72.8160;
        currLatitude = 21.1637618;
        print(
          "Location permission permanently denied. Using default coordinates.",
        );
      }
    } else {
      // Location service is disabled, use default coordinates
      currLongitude = 72.8160;
      currLatitude = 21.1637618;
      isDataLoaded = true;
      print("Location service is disabled. Using default coordinates.");
    }
    await getInqApi();
    await getApi();
    update();
  }

  Future<void> getApi() async {
    Map<String, dynamic> params = {
      //'curr_lat': "21.1652",
      // 'curr_lng': "72.7799"
      'curr_lat': currLatitude.toString(),
      'curr_lng': currLongitude.toString(),
    };
    d.Dio dio = d.Dio();
    d.Response response = await dio.post(
      "${BaseConstant.BASE_URL}${EndPoint.home}",
      data: d.FormData.fromMap(params),
    );

    print("${BaseConstant.BASE_URL}${EndPoint.home}");
    print(params);

    if (response.statusCode == 200) {
      log(response.data.toString());
      dashBoard_model = DashBoard_model.fromJson(response.data);

      startingCities = dashBoard_model!.data!.startingCities ?? [];

      // 🔁 Page caching
      prepareCityPages();

      propertyType = dashBoard_model!.data!.propertyType ?? [];
      properties = dashBoard_model!.data!.properties ?? [];
      gleekeyChoiceProperty =
          dashBoard_model!.data!.gleekeyChoiceProperty ?? [];
      bestSellerProperties = dashBoard_model!.data!.bestSellerProperty ?? [];
      popularProperties = dashBoard_model!.data!.populerProperties ?? [];
      testimonials = dashBoard_model!.data!.testimonials ?? [];
      isDataLoaded = true;
      update(['carousel']);
    } else {
      printError(info: "Dashboard API error");
    }
    update();
  }

  Future<void> getInqApi() async {
    if (currUser == null) return;
    http.Response response = await http.get(
      Uri.parse(BaseConstant.BASE_URL + EndPoint.getInquiry),

      headers: {
        'Authorization':
            'Bearer ${currUser != null ? currUser?.accessToken : ""}',
      },
    );
    log(
      "got the data -- > slug: ${BaseConstant.BASE_URL + EndPoint.getInquiry}",
    );
    log("got the data -- > slug: ${response.body}");
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      inquiryModel = InquiryModel.fromJson(result);
      // print("Date Price : ${inquiryModel!.inquiryModelData!.dateTime!}");
      isDataLoaded = true;

      log(
        "got the data -- > slug: ${BaseConstant.BASE_URL + EndPoint.getInquiry}",
      );
      log("got the data -- > slug: ${result}");
    } else {
      printError(
        info: "PropertyAllDetailsController --> Not get data from api",
      );
    }
    update();
  }

  @override
  void onClose() {
    log("Dashboard closed");
    super.onClose();
  }
}
