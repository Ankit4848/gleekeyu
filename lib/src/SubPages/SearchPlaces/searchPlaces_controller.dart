// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:gleekeyu/src/SubPages/Filter/filter_controller.dart';

import 'package:gleekeyu/src/Menu/DashBoard/dashBoard_model.dart';
import 'package:gleekeyu/src/SubPages/list_view.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/widgets/loder.dart';

import 'package:gleekeyu/widgets/showSnackBar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Menu/DashBoard/dashboard_controller.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SearchPlacesController extends GetxController {
  TextEditingController searchTextController = TextEditingController();
  TextEditingController gleekeySearchController = TextEditingController();
  List<Properties> properties = [];
  String sessionToken = "";
  var pridiction = [];
  var selectedPlace = "Search Places";
  bool isSucsess = false;
  RxString startDate = "".obs, endDate = "".obs;
  bool isDataLoaded = false;

  TextEditingController totalAdults = TextEditingController(text: 1.toString());
  TextEditingController totalChildren = TextEditingController(
    text: 0.toString(),
  );
  TextEditingController totalInphant = TextEditingController(
    text: 0.toString(),
  );
  int? totalNight;

  @override
  void onInit() {
    sessionToken = const Uuid().v4();
    searchTextController.addListener(() {
      getSuggestion(searchTextController.text);
    });
    totalAdults.text = 1.toString();
    totalChildren.text = 0.toString();
    totalInphant.text = 0.toString();
    super.onInit();
  }

  getSuggestion(String input) async {
    DashBoardController a = Get.find();
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$googleMapsApi&components=country:in&sessiontoken=$sessionToken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      pridiction = result['predictions'];
      result['predictions'].isEmpty
          ? a.startingCities.forEach((city) {
            pridiction.add({"description": city.name});
          })
          : null;
      log("Search places Controller 1111-- > got the data from API");
    } else {
      printError(info: "Search places Controller -- > Not get data from api");
    }
    update();
  }

  getApi() async {
    try {
      isSucsess = false;
      FilterController a = Get.find();
      properties = [];
      update();
      print("Property type : ${a.amenitiesID.join(',')}");
      print(BaseConstant.BASE_URL + EndPoint.searchResult);
      Map params = {
        'location': selectedPlace.toString(),
        'min_price': a.currMinPrice.toString(),
        'max_price': a.currMaxPrice.toString(),
        'amenities': a.amenitiesID.join(','),
        'property_type': a.filteredPropertyType.join(','),
        'checkin': startDate.value ?? "",
        'checkout': endDate.value ?? '',
        "property_sort_by": a.sortBy,
        'property_name': gleekeySearchController.text,
        'guest':
            (int.parse(totalAdults.text) + int.parse(totalChildren.text))
                .toString(),
        'page': '1',
        'limit': '1000',
        'allow_guest': a.totalAllowGuest.toString(),
        'extra_mattress': a.totalSleepingCapacity.toString(),
        "bedrooms": a.totalBedrooms.toString(),
        'currency_code': 'INR',
      };
      print("Params : ${params}");
      print("Token : Bearer ${currUser != null ? currUser?.accessToken : ""}");
      http.Response response = await http.post(
        Uri.parse(BaseConstant.BASE_URL + EndPoint.searchResult),
        headers: {
          'Authorization':
              'Bearer ${currUser != null ? currUser?.accessToken : ""}',
        },
        body: params,
      );
      print(
        "Search Response Data: ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}",
      );
      print("called");
      logLong(response.body);
      if (response.statusCode == 200) {
        var result = json.decode(response.body);

        isDataLoaded = true;

        for (var x in result['data']) {
          properties.add(Properties.fromJson(x));
        }
        print("pr:${properties.length}");
        isSucsess = true;
        update();
        if (isSucsess) {
          Get.back();
          Get.back();
          pridiction = [];

          selectedPlace = "Search Places";
          // startDate = null;
          // endDate = null;
          // totalAdults = 1;
          // totalChildren = 0;
          // totalInphant = 0;
          a.currMinPrice = 0;
          a.currMaxPrice = 100000;
          a.update();
          gleekeySearchController.text = '';

          print("startDate.value");
          print(startDate.value);
          print(endDate.value);

          Get.to(
            () => PropertyList(
              properties: properties,
              startDate: startDate.value,
              endDate: endDate.value,
              lat: result['lat'],
              long: result['long'],
            ),
          );
          loaderHide();
        }
        log("SearchPlacesController -- > got the data from API");
      } else {
        print("Response : ${response.body}");
        showSnackBar(title: "Try Again!", message: "Something Went Wrong");
        printError(info: "SearchPlacesController -- > Not get data from api");
        loaderHide();
      }
    } catch (e) {
      print("Error::: $e");
    } finally {
      loaderHide();
    }
    update();
  }

  void priceUpdate({
    var startD,
    var endD,
    var adults,
    var children,
    var inphant,
  }) {
    if (startDate.value != "" && endDate.value != "") {
      DateFormat dateFormat = DateFormat('dd-MM-yyyy');
      DateTime sDate = dateFormat.parse(startDate.value);
      DateTime eDate = dateFormat.parse(endDate.value);
      Duration duration = eDate.difference(sDate);
      totalNight =
          (duration.inMilliseconds / 86400000).ceil() == 0
              ? null
              : (duration.inMilliseconds / 86400000).ceil();
    } else {
      totalNight = null;
    }
  }
}
