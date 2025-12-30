// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
import 'package:gleekeyu/widgets/showSnackBar.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:http/http.dart' as http;

class FilterController extends GetxController {
  double currMinPrice = 0;
  double currMaxPrice = 100000;
  bool isDataLoaded = false;
  int totalAmenities = 6;
  int totalBedrooms = 0;
  int totalBathrooms = 0;
  int totalAllowGuest = 0;
  int totalSleepingCapacity = 0;
  int totalBeds = 0;
  String sortBy = "";
  var result;
  SfRangeValues values = const SfRangeValues(0, 100000);

  @override
  void onInit() {
    // DashBoardController a = Get.find();
    // for (var type in a.propertyType) {
    //   PropertyTypeIcon.add(type.icon);
    //   PropertyTypeName.add(type.name);
    //   PropertyTypeID.add(type.id);
    // }
    // PropertyTypeID = a.propertyType;
    getApi();
    print(PropertyTypeName);
    super.onInit();
  }

  List<String> amenitiesTitle = [];
  List<int> amenitiesID = [];
  var PropertyTypeIcon = [];
  var PropertyTypeName = [];
  var PropertyTypeID = [];
  var filteredPropertyType = [];
  String? propertyType;
  getApi() async {
    http.Response response = await http.post(
      Uri.tryParse("${BaseConstant.BASE_URL}${EndPoint.filter}")!,
    );
    if (response.statusCode == 200) {
      result = json.decode(response.body);
      print("Amentionidsfdsf : ${result['data']['amenities']}");
      isDataLoaded = true;
      for (var x in result['data']['property_type_imgs']) {
        PropertyTypeName.add(x['name']);
        PropertyTypeIcon.add(x['icon']);
        PropertyTypeID.add(x['id']);
      }
      log("Filter Controller --> got data from api");
    } else {
      var result = json.decode(response.body);

      showSnackBar(title: "Try Again !", message: "Something Went Wrong");
      print(result);
      printError(info: "Filter Controller --> Not get data from api");
    }
    update();
  }
}
