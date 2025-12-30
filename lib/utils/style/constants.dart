import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Colors
const Color cThemeBlue = Color(0xFF0E0E0E);
const Color cThemePink = Color(0xFF0E0E0E);
const Color kBlack = Colors.black;

const Color kGolden = Color(0xFFC8A86B);
const Color kmatblack = Color(0xFF202427);
const Color klightgrey = Color(0xFFD3D3D3);
const Color kTextgrey = Color(0xFF939393);

const Color kOrange = Color(0xFFFE6927);
const Color kGreen = Color(0xFF3e8d27);
const Color kYellow = Color.fromARGB(255, 226, 207, 38);
const Color kLightBlue = Color(0xFF17a2b8);
const Color kDarkBlue = Color(0xFF1C2534);
const Color kLightGrey = Color(0xFFD1D1D1);
const Color kRed = Color(0xFFdb375e);

const Color kBtnGrey = Color(0xFFEDEDED);
const Color kBlackTheme = Color(0xFF262626);
const Color kDarkGrey = Color(0xFF828282);
const Color kOrange30 = Color(0xFFFE6927);
const Color kOrangeLite = Color(0xFFFFECE3);
const Color kLightOrange = Color(0xFFF8CBB8);
const Color kLightGrey1 = Color(0xFF494949);
const Color kLightGrey2 = Color(0xFFE9E9E9);

const Color kBround = Color(0xFF645555);
const Color kDrawer = Color(0xFFFF8047);

const Color kWhite30 = Colors.white30;
const Color kWhite = Colors.white;
const Color kWhite60 = Colors.white60;
const Color kWhite12 = Colors.white12;
const Color kWhite70 = Colors.white70;
const Color kGreyone = Colors.grey;
const Color klightcolor = Color(0xFF31363b);
const Color kDarkThemecolor = Color(0xFF4d4a4a);
const Color kbase = Color.fromARGB(255, 168, 69, 69);
const Color kHighL = Color.fromRGBO(245, 245, 245, 1);

const String kCurrency = '\$';
const String kRupeeCurrency = '\₹';

// Padding
const double kPaddingS = 8.0;
const double kPaddingM = 16.0;
const double kPaddingL = 32.0;

const double pagePadding = 24;

// Spacing
const double kSpaceS = 8.0;
const double kSpaceM = 16.0;
const double kSpaceLoginFormM = 180.0;
const double kSpaceLoginFormS = 120.0;

// Animation
const Duration kButtonAnimationDuration = Duration(milliseconds: 600);
const Duration kCardAnimationDuration = Duration(milliseconds: 400);
const Duration kRippleAnimationDuration = Duration(milliseconds: 200);
const Duration kLoginAnimationDuration = Duration(milliseconds: 1500);

// font name
const String kThemeFont = 'HankenGrotesk';

//margin padding
const EdgeInsets kStandardMargin = EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0);

const EdgeInsets kcardmargin = EdgeInsets.only(right: 20.0, left: 20.0);

int dheight = Get.height.toInt();
int dwidth = Get.width.toInt();
var format = NumberFormat.currency(
  name: "INR",
  locale: 'en_IN',
  decimalDigits: 0, // change it to get decimal places
  symbol: '₹',
);

storeLogoLastPosition(PositionModel positionModel) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("Position", jsonEncode(positionModel));
}

Future<PositionModel> getStoredPosition() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? value = sharedPreferences.getString("Position");
  if (value != null) {
    return PositionModel.fromJson(jsonDecode(value));
  }
  return PositionModel(leftY: Get.width - 130, topX: 100);
}

class PositionModel {
  double? topX;
  double? leftY;

  PositionModel({this.topX, this.leftY});

  PositionModel.fromJson(Map<String, dynamic> json) {
    topX = json['topX'];
    leftY = json['leftY'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topX'] = this.topX;
    data['leftY'] = this.leftY;
    return data;
  }
}

void logLong(String text) {
  const int chunkSize = 800;
  for (var i = 0; i < text.length; i += chunkSize) {
    debugPrint(
      text.substring(
        i,
        i + chunkSize > text.length ? text.length : i + chunkSize,
      ),
    );
  }
}

extension CustomRounding on double {
  int customRound() {
    // Extract the integer part and the decimal part
    int integerPart = this.floor();
    double decimalPart = this - integerPart;

    // Round based on the decimal part
    if (decimalPart >= 0.1 && decimalPart <= 0.5) {
      return integerPart;
    } else if (decimalPart >= 0.6 && decimalPart <= 0.9) {
      return (integerPart + 1);
    } else {
      // For values where the decimal part is exactly 0.0, 1.0 or other unexpected cases
      return integerPart;
    }
  }
}
