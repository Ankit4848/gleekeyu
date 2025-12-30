// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/extras/commonWidget.dart';
import 'package:gleekeyu/src/HomePage/homePage_controller.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/widgets/loder.dart';

import '../../../utils/style/palette.dart';
import '../../HomePage/homePage_view.dart';
import 'receipt_controller.dart';

class ViewReceipt extends StatefulWidget {
  String code;
  bool isNavigatToHome;
  bool isMainPayment;
  ViewReceipt(
      {super.key,
      required this.code,
      this.isNavigatToHome = false,
      this.isMainPayment = false});

  @override
  State<ViewReceipt> createState() => _ViewReceiptState();
}

ReceiptController receiptController = Get.put(ReceiptController());

class _ViewReceiptState extends State<ViewReceipt> {
  // final HomePageController a = Get.put(HomePageController());
  @override
  Widget build(BuildContext context) {
    // getController.getApi(code);
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        elevation: 0,
        leading: Bounce(
          duration: const Duration(milliseconds: 150),
          onPressed: () {
            if (!widget.isNavigatToHome) {
              Get.back();
            } else if (widget.isMainPayment) {
              HomePageController a = Get.find();
              a.currentIndex = 0;
              a.goto(a.currentIndex ?? 0);
              a.update();
              Get.off(() => const HomePage());
            } else {
              Get.back();
              Get.back(result: true);
            }
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: kBlack,
          ),
        ),
        backgroundColor: kWhite,
        title: Text(
          "View Receipt",
          style: Palette.headerText,
        ),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (!widget.isNavigatToHome) {
            Get.back();
          } else if (widget.isMainPayment) {
            HomePageController a = Get.find();
            a.currentIndex = 0;
            a.goto(a.currentIndex ?? 0);
            a.update();
            Get.off(() => const HomePage());
          } else {
            Get.back();
            Get.back(result: true);
          }
          return false;
        },
        child: Stack(
          children: [
            PDF(
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: false,
              pageFling: false,
              onError: (error) {
                print(error.toString());
              },
              onPageError: (page, error) {
                print('$page: ${error.toString()}');
              },
              onPageChanged: (int? page, int? total) {
                print('page change: $page/$total');
              },
            ).fromUrl(widget.code),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CommonButton(
                    onPressed: () async {
                      loaderShow(context);
                      await receiptController.createFileOfPdfUrl(widget.code);
                    },
                    width: double.infinity,
                    name: 'Download Receipt'),
              ),
            )
          ],
        ),
      ),
      /* Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.code,
            enableSwipe: true,
            swipeHorizontal: false,
            fitEachPage: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: 0,

            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter
            onRender: (pages) {
              setState(() {
                pages = pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print("Error : ${error}");
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric( horizontal: 16),
              child: CommonButton(onPressed: () {},
                  width: double.infinity,
                  name: 'Download Receipt'),
            ),
          )
        ],
      ),*/
    );
  }
}
