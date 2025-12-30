import 'dart:io';

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_controller.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_view.dart';
import 'package:gleekeyu/src/HomePage/homePage_view.dart';
import 'package:gleekeyu/src/Intro_pages/onBoard_screen.dart';
import 'package:gleekeyu/src/Menu/MyCoupons/my_coupons_view.dart';
import 'package:gleekeyu/src/Menu/MyCoupons/my_coupons_controller.dart';
import 'package:gleekeyu/utils/style/constants.dart';

const MethodChannel _splashDeepLinkChannel = MethodChannel('deep_link_channel');

class SplashPage extends StatelessWidget {
  SplashPage({Key? key}) : super(key: key);

  Future<Widget> _decideNext(UserLoginController controller) async {
    // Keep splash visible for ~3 seconds
    final waitFuture = Future.delayed(const Duration(seconds: 3));

    String? initialUrl;
    if (Platform.isAndroid) {
      try {
        initialUrl = await _splashDeepLinkChannel.invokeMethod<String>(
          'getInitialLink',
        );
      } catch (_) {}
    }

    await waitFuture;

    print(
      'Splash _decideNext: initialUrl=$initialUrl, isUserLoggedIn=${controller.isUserLoggedIn()}, isUserLogedInFlag=${controller.isUserLogedIn}, isEverLogedin=${controller.isEverLogedin}',
    );

    if (initialUrl != null && initialUrl.isNotEmpty) {
      if (initialUrl.contains('/coupon/')) {
        // Match main.dart deep-link behavior for coupons
        controller.navigateToCouponsAfterLogin = true;

        if (controller.isUserLoggedIn()) {
          // Already logged in: go directly to My Coupons
          // and clear post-login flag, same as main.dart.
          controller.navigateToCouponsAfterLogin = false;

          if (Get.isRegistered<MyCouponsController>()) {
            final c = Get.find<MyCouponsController>();
            c.initialPopupShown = false;
          }
          controller.openAddCouponPopup = true;
          controller.backToHomeFromCoupons = true;
          // From splash we return the target widget instead of calling Get.to.
          return const MyCouponsScreen();
        } else {
          // Not logged in: show Login; after login,
          // UserLoginController._handlePostLoginNavigation will
          // read navigateToCouponsAfterLogin and redirect.
          return const Login();
        }
      }
    }

    if (controller.isUserLogedIn || controller.isEverLogedin == "true") {
      return const HomePage();
    } else {
      return const OnBoardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    UserLoginController controller = Get.put(UserLoginController());
    return GetBuilder<UserLoginController>(
      initState: (a) {},
      builder: (a) {
        return EasySplashScreen(
          showLoader: false,
          logoWidth: MediaQuery.of(context).size.width * 0.7,
          logo: Image.asset(
            "assets/images/spalsh.png",
            width: MediaQuery.of(context).size.width * 0.7,
          ),
          backgroundColor: kmatblack,
          futureNavigator: _decideNext(controller),
        );
      },
    );
  }
}
