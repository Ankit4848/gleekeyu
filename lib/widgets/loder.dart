import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import '../utils/style/constants.dart';



void loaderShow(context) {
  return Loader.show(
    context,
    isSafeAreaOverlay: true,
    isBottomBarOverlay: true,
    overlayColor: Colors.black26,
    progressIndicator: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        height: 50,
        width: 50,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitCircle(
              color: kOrange,
              size: 30,
            ),
          ],
        )),
  );
}

void loaderHide() {
  return Loader.hide();
}
