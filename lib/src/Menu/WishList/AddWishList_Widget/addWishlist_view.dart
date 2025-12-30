// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_controller.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_view.dart';
import 'package:gleekeyu/utils/style/constants.dart';

import 'addWishlist_controller.dart';

class addWishlistWidget extends StatelessWidget {
  const addWishlistWidget(
      {Key? key, required this.PropertyID, this.size, this.height})
      : super(key: key);

  final int PropertyID;
  final double? size;
  final double? height;

  @override
  Widget build(BuildContext context) {
    WishlistController a = Get.put(WishlistController());
    return GetBuilder<WishlistController>(
      initState: (a) {},
      builder: (a) {
        return Bounce(
          duration: const Duration(milliseconds: 150),
          onPressed: (() {
            UserLoginController isLogedin = Get.put(UserLoginController());
            if (!isLogedin.isUserLogedIn) {
              Get.off(() => const Login());
            } else {
              a.getApi(PropertyID);
              a.wishlistedID.contains(PropertyID)
                  ? a.wishlistedID.remove(PropertyID)
                  : a.wishlistedID.add(PropertyID);
              a.update();
            }
          }),
          child: CircleAvatar(
              radius: size ?? 12,
              backgroundColor: kBlack.withOpacity(0.3),
              child: Image.asset(
                "assets/images/wishlist_icon_color.png",
                color: a.wishlistedID.contains(PropertyID) ? kRed : kWhite,
                width: height ?? 10,
                height: height ?? 10,
              )),
        );
      },
    );
  }
}
