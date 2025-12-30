import 'dart:convert';

import 'package:get/get.dart';

import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';
import '../../../utils/baseconstant.dart';
import '../Login/userLogin_view.dart';

class ProfileController extends GetxController {
  static ProfileController to = Get.put(ProfileController());
  Object? params;
  Future<bool?> editPersonalInfoAPI({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(
          BaseConstant.BASE_URL + EndPoint.updateProfile,
          data: isFormData ? dio.FormData.fromMap(params) : params,
          options: dio.Options(
              headers: {'Authorization': 'Bearer ${currUser!=null?currUser?.accessToken:""}'}));

      if (response.statusCode == 200) {
        print("Updated Response ${response.data}");

        if (response.data != null) {
          if (response.data['status'] == true) {
            if (success != null) {
              success();
            }
          } else {
            if (error != null) {
              error(response.data['message']);
            }
          }
          return true;
        } else {
          if (error != null) {
            error(response.data['message']);
          }
          return false;
        }
      } else {
        if (error != null) {
          error(jsonDecode(response.data)['message']);
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        error(e.response?.data['message'] ?? "Something went wrong");
        if (e.response?.data['message'] == "Token has expired") {
          Get.offAll(const Login());
        }
      }
    }
    return null;
  }

  String? birthDateValidator(String value) {
    try {
      String datePattern = "dd-MM-yyyy";

      DateTime birthDate = DateFormat(datePattern).parse(value);
      DateTime today = DateTime.now();

      int yearDiff = today.year - birthDate.year;
      int monthDiff = today.month - birthDate.month;
      int dayDiff = today.day - birthDate.day;

      DateTime? dateTime = DateTime.tryParse(value);
      print(
          "Year Diff::: $yearDiff, Month DIFF:; ${monthDiff}, Day DIff: $dayDiff   ${value.isNotEmpty}");
      if (value.isNotEmpty) {
        if (!(yearDiff > 18 ||
            yearDiff == 18 && monthDiff > 0 ||
            yearDiff == 18 && monthDiff == 0 && dayDiff >= 0)) {
          return "You are not old enough";
        }
      } else {
        return null;
      }
    } catch (e) {
      return "Enter Correct BirthDate";
    }
  }

  RxMap<String, dynamic> getCountryRes = <String, dynamic>{}.obs;
  Future<bool?> getCountryApi({
    Function? success,
    Function? error,
  }) async {
    try {
      dio.Response response = await dio.Dio().get(
        BaseConstant.BASE_URL + EndPoint.getCountry,
      );

      if (response.statusCode == 200) {
        if (response.data != null) {
          if (response.data['status'] == true) {
            getCountryRes.value = response.data;
            if (success != null) {
              success();
            }
          } else {
            if (error != null) {
              error(response.data['message']);
            }
          }
          return true;
        } else {
          if (error != null) {
            error(response.data['message']);
          }
          return false;
        }
      } else {
        if (error != null) {
          error(jsonDecode(response.data)['message']);
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        error(e.response?.statusMessage ?? "Something went wrong");
      }
    }
    return null;
  }

  RxMap<String, dynamic> getStateRes = <String, dynamic>{}.obs;
  Future<bool?> getStateApi({
    required Map params,
    Function? success,
    Function? error,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(
        BaseConstant.BASE_URL + EndPoint.getState,
        data: params,
      );

      if (response.statusCode == 200) {
        if (response.data != null) {
          if (response.data['status'] == true) {
            getStateRes.value = response.data;
            if (success != null) {
              success();
            }
          } else {
            if (error != null) {
              error(response.data['message']);
            }
          }
          return true;
        } else {
          if (error != null) {
            error(response.data['message']);
          }
          return false;
        }
      } else {
        if (error != null) {
          error(jsonDecode(response.data)['message']);
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        error(e.response?.statusMessage ?? "Something went wrong");
      }
    }
    return null;
  }

  RxMap<String, dynamic> getCityRes = <String, dynamic>{}.obs;
  Future<bool?> getCityApi({
    required Map params,
    Function? success,
    Function? error,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(
        BaseConstant.BASE_URL + EndPoint.getCity,
        data: params,
      );

      if (response.statusCode == 200) {
        print('GET CITY API DATA ${response.data}');
        if (response.data != null) {
          if (response.data['status'] == true) {
            getCityRes.value = response.data;
            if (success != null) {
              success();
            }
          } else {
            if (error != null) {
              error(response.data['message']);
            }
          }
          return true;
        } else {
          if (error != null) {
            error(response.data['message']);
          }
          return false;
        }
      } else {
        if (error != null) {
          error(jsonDecode(response.data)['message']);
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        error(e.response?.statusMessage ?? "Something went wrong");
      }
    }
    return null;
  }
  // getApi() async {
  //   http.Response response = await http.post(
  //     Uri.parse(BaseConstant.BASE_URL + EndPoint.searchResult),
  //     headers: {
  //       'Authorization': 'Bearer ${currUser!=null?currUser?.accessToken:""}',
  //     },
  //     body: {
  //       'location': selectedPlace.toString(),
  //       'min_price': a.currMinPrice.toString(),
  //       'max_price': a.currMaxPrice.toString(),
  //       'amenities': '',
  //       'property_type': '',
  //       'guest': totalAdults.toString(),
  //       'page': '1',
  //       'limit': '1000',
  //       'currency_code': 'INR'
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     var result = json.decode(response.body);
  //     // print(result);
  //     isDataLoaded = true;
  //     properties = [];

  //     for (var x in result['data']) {
  //       properties.add(Properties.fromJson(x));
  //     }
  //     print("pr:${properties.length}");
  //     isSucsess = true;
  //     update();
  //     if (isSucsess) {
  //       print("object");
  //       Get.back();
  //       Get.to(() => PropertyList(
  //           properties: properties, lat: result['lat'], long: result['long']));
  //       loaderHide();
  //     }
  //     log("SearchPlacesController -- > got the data from API");
  //   } else {
  //     var result = json.decode(response.body);
  //     print(result);
  //     showSnackBar(title: "Try Again!", message: "Something Went Wrong");
  //     printError(info: "SearchPlacesController -- > Not get data from api");
  //     loaderHide();
  //   }
  //   update();
  // }
}
