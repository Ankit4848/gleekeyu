import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as d;
import 'wishlistedProperties_model.dart';

class WishlistedPropertiesController extends GetxController {
  @override
  void onClose() {
    log("Wishlisted Properties page Closed");
    super.onClose();
  }

  WishlistedProperties_model? wishlistedProperties_model;

  var isDataLoaded = false;
  var wishlistedID = [];
  @override
  void onInit() {
    getApi();
    super.onInit();
  }

  getApi() async {
    d.Dio dio = d.Dio();
    d.Response response =
        await dio.post(BaseConstant.BASE_URL + EndPoint.wishlist,
            options: d.Options(
              headers: {
                'Authorization': 'Bearer ${currUser!=null?currUser?.accessToken:""}',
              },
            ),
            data: d.FormData.fromMap(
              {
                'offset': '0',
                'limit': '100',
              },
            ));
    if (response.statusCode == 200) {
      // var result = json.decode(response.data);
      wishlistedProperties_model =
          WishlistedProperties_model.fromJson(response.data);
      isDataLoaded = true;
      log("WishlistedPropertiesController -- > got the data from API");
    } else {
      var result = json.decode(response.data);
      print(result);
      printError(
          info: "WishlistedPropertiesController -- > Not get data from api");
    }
    update();
  }
}
