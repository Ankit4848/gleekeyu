import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/SubPages/PropertyAllDetails/promocode_model.dart';
import 'package:gleekeyu/src/SubPages/PropertyAllDetails/propertyAllDetails_model.dart';
import 'package:gleekeyu/src/SubPages/confirm_n_pay/confirm_n_pay_controller.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;

import '../../../widgets/loder.dart';
import '../../../widgets/showSnackBar.dart';

class PropertyAllDetailsController extends GetxController {
  @override
  void onClose() {
    isDataLoaded = false;
    super.onClose();
  }

  List<SelectedDateWithPrice>? dateprice;
  List<DateTime> availableDates = [];
  String? startDate;
  String? endDate;
  RxBool isDateAvailable = false.obs;
  int? totalPrice;
  double? totalPriceAfterDiscount;
  double? totalGST;
  double? totalGSTWithoutOffer;
  double? totalDiscount;
  double? discountPercentage;
  PropertyAllDetails_model? propertyAllDetails_model;
  Data? PropertyData;
  bool isRulesExpanded = false;
  CarouselSliderController carouselController = CarouselSliderController();
  var isDataLoaded = false;
  List<SelectedDateWithPrice> selectedDateWithPrice = [];
  RxInt selectedOfferValue = (-1).obs;
  SelectedDateWithPrice? getPriceFromDate(String date)
  {
    SelectedDateWithPrice? price;
    for (SelectedDateWithPrice element in dateprice ?? []) {
      element.date.toString() == date
          ? price = SelectedDateWithPrice(
              date: date,
              discount: element.discount,
              discountPercentage: element.discountPercentage,
              ivataxGstPer: element.ivataxGstPer,
              originalPrice: element.originalPrice,
              perDayTax: element.perDayTax,
              price: element.price,
              availability: element.availability,
            )
          : null;
    }

    return price;
  }

  void clearOldData() {
    // Clear old property data
    dateprice = null;
    availableDates.clear();
    startDate = null;
    endDate = null;
    isDateAvailable.value = false;
    totalPrice = null;
    totalPriceAfterDiscount = null;
    totalGST = null;
    totalGSTWithoutOffer = null;
    totalDiscount = null;
    discountPercentage = null;
    propertyAllDetails_model = null;
    PropertyData = null;
    isRulesExpanded = false;
    isDataLoaded = false;
    selectedDateWithPrice.clear();
    selectedOfferValue.value = -1;
    isCoupenApplied.value = false;
    messageCode.value = '';
    coupenSuccess.value = false;
    isCalenderShow.value = false;
    coupenCode.value = '';
    promocodeList.clear();
    isOfferApplied.value = false;
    isHostOfferApplied.value = false;
    offerPercentage.value = '0';

    print("Cleared old controller data");
    update();
  }
  RxBool isCoupenApplied = false.obs;

  List<String> getDatesBetween(
      {required String startDate, required String? endDate})
  {
    List<String> dateList = [];

    if (endDate != null) {
      DateFormat formatter = DateFormat('dd-MM-yyyy');
      DateTime start = formatter.parse(startDate);
      DateTime end = formatter.parse(endDate);

      // Add the start date to the list
      dateList.add(formatter.format(start));

      // Generate the dates between the start and end dates (excluding the end date)
      while (start.isBefore(end)) {
        start = start.add(
          const Duration(days: 1),
        );
        if (start.isBefore(end)) {
          dateList.add(formatter.format(start));
        }
      }
    } else {
      dateList.add(startDate);
    }

    return dateList;
  }

  Future<void> priceUpdate({PaymentOption? paymentOption}) async
  {
    totalPrice = null;
    totalPriceAfterDiscount = null;
    totalGST = null;
    totalGSTWithoutOffer = null;
    totalDiscount = null;
    selectedDateWithPrice = [];
    isDateAvailable.value = true;
    discountPercentage = 0;
    print("Start date : $startDate");
    print("End date : $endDate");

    if(startDate==null)
  {

    startDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    endDate = DateFormat('dd-MM-yyyy',).format(DateTime.now().add(const Duration(days: 1)));

  }

    for (var element
        in getDatesBetween(startDate: startDate!, endDate: endDate)) {

      SelectedDateWithPrice? price = getPriceFromDate(element);
      print("Start date : $element");
      print("Start date : $price");
      if (price != null) {
        discountPercentage =
            double.parse((price.discountPercentage ?? '0').toString());
        print("Price availability : ${price.date} ${price.availability}");
        if (price.availability != 'Available') {
          isDateAvailable.value = false;
          return;
        }

        String taxPrice = '';
        String taxPriceWithoutDiscount = '';

        int tempPrice = int.parse(price.originalPrice.toString());

        double discountPrice = double.parse((price.discount ?? 0.0).toString());
        // ((int.parse(PropertyData!.result!.isFirstBooking.toString()) *
        //         tempPrice) /
        //     100);

        if ((paymentOption != null &&
                paymentOption == PaymentOption.Full &&
                tempPrice != discountPrice) ||
            (paymentOption == null && tempPrice != discountPrice)) {
          if ((tempPrice - discountPrice) >= 7500) {
            taxPrice = (((tempPrice - discountPrice) * 18) / 100).toString();
            taxPriceWithoutDiscount = (((tempPrice) * 18) / 100).toString();
          } else {
            taxPrice = (((tempPrice - discountPrice) * 12) / 100).toString();
            taxPriceWithoutDiscount = (((tempPrice) * 12) / 100).toString();
          }
        } else {
          if ((tempPrice) >= 7500) {
            taxPrice = (((tempPrice) * 18) / 100).toString();
            taxPriceWithoutDiscount = (((tempPrice) * 18) / 100).toString();
          } else {
            taxPrice = (((tempPrice) * 12) / 100).toString();
            taxPriceWithoutDiscount = (((tempPrice) * 12) / 100).toString();
          }
        }

        selectedDateWithPrice.add(price);

        if (discountPrice != tempPrice) {
          totalPriceAfterDiscount =
              double.parse((tempPrice - discountPrice).toString()) +
                  double.parse((totalPriceAfterDiscount ?? '0').toString())
                      .customRound();
        }
        totalPrice = (price.originalPrice ?? 0) +
            int.parse((totalPrice ?? '0').toString());
        totalDiscount = double.parse(discountPrice.toString()) +
            double.parse((totalDiscount ?? '0').toString());
        totalGST = double.parse(taxPrice) +
            double.parse((totalGST ?? '0.0').toString());
        totalGSTWithoutOffer = double.parse(taxPriceWithoutDiscount) +
            double.parse((totalGSTWithoutOffer ?? '0.0').toString());
      }
    }
    update();
  }

  getApi(String slug, String id) async
  {
    clearOldData();
    print("API :${BaseConstant.BASE_URL + EndPoint.propertyAllDetails + slug}");
    print("API :${currUser!=null?currUser?.accessToken:""}");
    http.Response response = await http.post(
      Uri.parse(BaseConstant.BASE_URL + EndPoint.propertyAllDetails + slug),
      headers: {
        'Authorization': 'Bearer ${currUser!=null?currUser!.accessToken:""}',
      }
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      propertyAllDetails_model = PropertyAllDetails_model.fromJson(result);
      PropertyData = propertyAllDetails_model!.data;
      await getPrice(
        params: {
          "property_id": id.toString(),
          "from_date":
              DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
          "to_date": DateFormat('dd-MM-yyyy')
              .format(DateTime.now().add(const Duration(days: 45)))
              .toString(),
        },
      );
      isDataLoaded = true;
      log("got the data -- > slug: ${result}");
    } else {
      printError(
        info: "PropertyAllDetailsController --> Not get data from api",
      );
    }
    update();
  }


  Future<void> getBasketApi(String slug, String id,String date,String endDate) async
  {
    print("API :${BaseConstant.BASE_URL + EndPoint.propertyAllDetails + slug}");
    print("API :${currUser!=null?currUser?.accessToken:""}");
    http.Response response = await http.post(
        Uri.parse(BaseConstant.BASE_URL + EndPoint.propertyAllDetails + slug),
        headers: {
          'Authorization': 'Bearer ${currUser!=null?currUser!.accessToken:""}',
        }
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      propertyAllDetails_model = PropertyAllDetails_model.fromJson(result);
      PropertyData = propertyAllDetails_model!.data;

      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(endDate);
      DateTime newDate = parsedDate.add(Duration(days: 5));
      String formattedDate = DateFormat('dd-MM-yyyy').format(newDate);
      await getPrice(
        params: {
          "property_id": id.toString(),
          "from_date":date,
          "to_date": formattedDate,
        },
      );
      isDataLoaded = true;
      log("got the data -- > slug: ${result}");
    } else {
      printError(
        info: "PropertyAllDetailsController --> Not get data from api",
      );
    }
    update();
  }



  Future<void> getInquryApi(Map<String, dynamic> params,BuildContext context) async
  {
    print("API :${BaseConstant.BASE_URL + EndPoint.sendInquiry}");
    //loaderShow(context);
    http.Response response = await http.post(
      Uri.parse(BaseConstant.BASE_URL + EndPoint.sendInquiry ),
      body: params,
      headers: {'Authorization': 'Bearer ${currUser!=null?currUser?.accessToken:""}',},
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      loaderHide();
      Get.defaultDialog(
        title: "Request sent successfully.",
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.all(10),
        titlePadding: EdgeInsets.only(top: 20),
        barrierDismissible: false,
        titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        content: Text(
          result['message'],
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        confirm: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent),
          onPressed: () => Get.back(),
          child: const Text("Ok",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),),
        ),
        radius: 10,
      );
      log("got the data -- > slug: ${result}");
    } else {
      printError(info: "PropertyAllDetailsController --> Not get data from api",);
    }
      update();
  }

  RxString messageCode = ''.obs;
  RxBool coupenSuccess = false.obs;
  RxBool isCalenderShow = false.obs;
  RxString coupenCode = ''.obs;

  RxList<PromocodeModel> promocodeList = <PromocodeModel>[].obs;
  getPromocodeList({String? propertyId}) async
  {
    try {
      final requestBody = {"check_in_date": startDate, "check_out_date": endDate, "property_id": propertyId ?? ""};
      print("Request URL: ${BaseConstant.BASE_URL + EndPoint.promoCodeList}");
      print("Request Params: $requestBody");
      http.Response response = await http.post(
      Uri.parse(BaseConstant.BASE_URL + EndPoint.promoCodeList),
      body: requestBody,
      headers: {'Authorization': 'Bearer ${currUser!=null?currUser?.accessToken:""}',});
      print("Responseeeeee: ${response.body}");
      if (response.statusCode == 200) {
        var decoded = json.decode(response.body);
        List result;
        if (decoded is List) {
          result = decoded;
        } else if (decoded is Map && decoded['data'] != null) {
          result = decoded['data'] as List;
        } else {
          result = [];
        }
        promocodeList.value = result.map((e) => PromocodeModel.fromJson(e)).toList();
        print("Promocode List Length:: ${promocodeList.length}");
        update();
      } else {
        printError(info: "PropertyAllDetailsController --> Not get data from api");
      }
      update();
    } catch (e) {
      printError(info: "Error:: $e");
    }
  }

  RxBool isOfferApplied = false.obs;
  RxBool isHostOfferApplied = false.obs;
  RxString offerPercentage = '0'.obs;
  Future<bool> getPrice(
      {required Map<String, dynamic> params,
      Function? success,
      Function? error,
      bool isHostOffer = false,
      bool isCoupenCode = false}) async
  {
    try {
      print("TOKEN : ${'Bearer ${currUser!=null?currUser?.accessToken:""}'}");
      print("Params  : $params");
      print(
          "Url  : ${BaseConstant.BASE_URL}get_property_calender_price_user_side");

      dio.Dio d = dio.Dio();

      dio.Response response = await d
          .post(
        '${BaseConstant.BASE_URL}get_property_calender_price_user_side',
        // data: params,
        data: dio.FormData.fromMap(params),
        queryParameters: params,
        options: dio.Options(
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
          // headers: {
          //   'Authorization': 'Bearer ${currUser!=null?currUser?.accessToken:""}',
          // },
        ),
      )
          .catchError((e) {
        print('Apply Coupon Error $e');
      });
      print("Responseeee : ${response.data}");

      if (response.statusCode == 200) {
        var result = response.data;
        if (result != null) {
          log("Result:::::: ${result.toString()}");
          if (result['status'] == true) {
            print("Disoucndsadsafafaf: ${result['discount_status']}");
            isOfferApplied.value =
                result['discount_status'] == "true" ? true : false;
            print(
                "IS Offer Applied ${result['discount_status'] == "true" ? true : false}");
            if (isHostOffer) {
              print(
                  "IS Offer Host Applied ${result['discount_status'] == "true" ? true : false}");
              isHostOfferApplied.value =
                  result['discount_status'] == "true" ? true : false;
            }
            if ((!isOfferApplied.value && !isHostOffer)) {
              print("Condition True");
              params.addAll({"host_offer": "1"});
              await getPrice(
                  params: params,
                  isHostOffer: true,
                  success: () {
                    if (success != null) {
                      success();
                    }
                  });
            } else {
              print("Condition False");
              final List body = result['date'];
              dateprice =
                  body.map((e) => SelectedDateWithPrice.fromJson(e)).toList();

              for (SelectedDateWithPrice element in dateprice ?? []) {
                if (element.availability != "Available") {
                  availableDates
                      .add(DateFormat('dd-MM-yyyy').parse(element.date));
                }
                print("Available Date ::: ${availableDates.length}");
              }
              for (SelectedDateWithPrice element in dateprice ?? []) {
                if (element.availability != "Available") {
                  availableDates
                      .add(DateFormat('dd-MM-yyyy').parse(element.date));
                }
                print("Available Date ::: ${availableDates.length}");
                if (element.discountPercentage != '00') {
                  offerPercentage.value = element.discountPercentage.toString();
                  break;
                }
              }
              print("Called After Break");
              totalPrice = int.parse(double.parse(dateprice?[0]
                          .price
                          .toString()
                          .replaceAll('₹', '')
                          .replaceAll(',', '')
                          .trim() ??
                      '0')
                  .customRound()
                  .toString());
              update();
              if (success != null) {
                success();
              }
            }
            // final List body = result['date'];
            //
            // dateprice =
            //     body.map((e) => SelectedDateWithPrice.fromJson(e)).toList();
            //
            // totalPrice = int.parse(dateprice?[0]
            //         .price
            //         .toString()
            //         .replaceAll('₹', '')
            //         .replaceAll(',', '') ??
            //     '0');
            // update();
            // if (success != null) {
            //   success();
            // }
            return true;
          } else {
            if (error != null) {
              error(result['message']);
            }
            return false;
          }
        } else {
          if (error != null) {
            error(result['message']);
          }
        }
        return false;
      } else {
        return false;
        // if (error != null) {
        //   error(json.decode(response.body)['message']);
        // }
        // printError(
        //     info: "PropertyAllDetailsController --> Not get data from api");
      }
    } catch (e) {

      print('Something Went Wrong : $e');

      return false;
    }
    update();
  }
}

class SelectedDateWithPrice {
  var ivataxGstPer;
  var perDayTax;
  var price;
  var originalPrice;
  var originalPriceDisplay;
  var discount;
  var discountPercentage;
  var date;
  var availability;

  SelectedDateWithPrice(
      {this.ivataxGstPer,
      this.perDayTax,
      this.price,
      this.originalPrice,
      this.originalPriceDisplay,
      this.discount,
      this.discountPercentage,
      this.date,
      this.availability});

  SelectedDateWithPrice.fromJson(Map<String, dynamic> json) {
    ivataxGstPer = json['ivatax_gst_per'];
    perDayTax = json['per_day_tax'];
    price = json['price'];
    originalPrice = json['original_price'];
    originalPriceDisplay = json['original_price_display'];
    discount = json['discount'];
    discountPercentage = json['discount_percentage'];
    date = json['date'];
    availability = json['availability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ivatax_gst_per'] = this.ivataxGstPer;
    data['per_day_tax'] = this.perDayTax;
    data['price'] = this.price;
    data['original_price'] = this.originalPrice;
    data['original_price_display'] = this.originalPriceDisplay;
    data['discount'] = this.discount;
    data['discount_percentage'] = this.discountPercentage;
    data['date'] = this.date;
    data['availability'] = this.availability;
    return data;
  }
}
