// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:gleekeyu/extras/app_colors.dart';
import 'package:gleekeyu/widgets/loder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/showSnackBar.dart';
import 'receipt_model.dart';

class ReceiptController extends GetxController {
  Receipt_model? receipt_model;
  Booking? booking;
  var isDataLoaded = false;
  int tabCurrIndex = 0;
  getApi(String code) async {
    print("Receipt API : ${BaseConstant.BASE_URL + EndPoint.receipt + code}");
    http.Response response = await http.get(
      Uri.parse(BaseConstant.BASE_URL + EndPoint.receipt + code),
      headers: {
        'Authorization': 'Bearer ${currUser!=null?currUser?.accessToken:""}',
      },
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      receipt_model = Receipt_model.fromJson(result);
      print("Date Price : ${receipt_model!.data!.datePrice!}");
      isDataLoaded = true;
      booking = receipt_model!.data!.booking;
      log("Receipt Controller -- > got the data from API");
    } else {
      printError(info: "Receipt Controller -- > Not get data from api");
    }
    update();
  }

  Future<File> createFileOfPdfUrl(String pdfPath) async {
    try {
      final url = pdfPath;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      Directory dir = Directory('/storage/emulated/0/Download');
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      print("Download files Success : ${file.path}");
      showSnackBar(
          title: "Success",
          color: AppColors.color32BD01,
          message:
              'Receipt successfully downloded..You can check in your device download folder');
      loaderHide();
      return file;
    } catch (e) {
      loaderHide();
      throw Exception('Error parsing asset file!');
    }
  }
}
