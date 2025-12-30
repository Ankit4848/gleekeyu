// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Auth/login_and_security/login_and_security_screen.dart';
import 'package:gleekeyu/src/HomePage/homePage_controller.dart';
import 'package:gleekeyu/src/Menu/DashBoard/dashboard_controller.dart';
import 'package:gleekeyu/src/Menu/MyCoupons/my_coupons_view.dart';
import 'package:gleekeyu/src/SubPages/Payment%20Methods/paymentMethod_view.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_controller.dart';
import 'package:gleekeyu/src/Auth/profile/profile.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/utils/style/palette.dart';
import 'package:gleekeyu/widgets/commonText.dart';
import 'package:gleekeyu/widgets/drawer_tile.dart';
import 'package:gleekeyu/widgets/exitPoopUp.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/firebase_pushNotification_service.dart';
// import 'HomePage_controller.dart';

GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    super.dispose();
  }

  double zoneHeight = 122;
  double zoneWidth = 112;
  double topY = 100;
  double leftX = Get.width - 130;
  late double initX;
  late double initY;
  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      PositionModel positionModel = await getStoredPosition();
      topY = positionModel.topX ?? 100;
      leftX = positionModel.leftY ?? Get.width - 130;
    });
    tileFunction = [
      // becomeAproMember,
      becomeAhost,
   //   becomeAagent,
      wishlist,
      // notification,
      myBookings,
      myCoupons,
      changePassword,
      // paymentMethod,
      // support,
      tAndC,
      cancellationPolicy,
      privacyPolicy,
      termOfUse,
      help,
    ];
    super.initState();

    Future.delayed(Duration(seconds: 1), () async {
      PushNotificationService.setUpInterractedMassage();
    });

  }

  HomePageController getController = Get.find();
  DashBoardController dashBoardController = Get.find();


  // Get.put(DashBoardController());
  var tileName = [
    // "become a pro member",
    "become a host",
    "wishlist",
    // "notification",
    "my bookings",
    "My Coupons",
    "Login & security",
    "Terms & Conditions",
    "Cancellation Policy",
    "Privacy Policy",
    "Terms Of Use",

    "Help Center"
  ];
  var tileImage = [
    'become a host',
    'wishlist',
    'my bookings',
    'my bookings',
    'login_and_security',
    'term_and_condition',
    'cancellation_policy',
    'privacy_policy',
    'term_of_use',
    'help'
  ];

  // becomeAproMember() {}

  becomeAhost() {
    Get.back();
    launchUrl(
      Uri.parse(
          'https://play.google.com/store/apps/details?id=com.softieons.gleekeyh'),
      mode: LaunchMode.externalApplication,
    );
    // Get.to(() => const BecomeAHost());
  }

  termOfUse() {
    Get.back();
    launchUrl(
      Uri.parse('https://www.gleekey.in/glee-terms'),
      mode: LaunchMode.externalApplication,
    );
    // Get.to(() => const BecomeAHost());
  }



  wishlist() {
    Get.back();
    getController.goto(1);
  }

  changePassword() {
    Get.back();
    Get.to(() => const LoginAndSecurityScreen());
  }

  // notification() {
  //   Get.back();
  //   getController.goto(3);
  // }

  myBookings() {
    Get.back();
    getController.goto(2);
  }

  myCoupons() {
    Get.back();
    Get.to(() => const MyCouponsScreen());
  }

  paymentMethod() {
    Get.back();
    Get.to(() => const PaymentMethod());
  }

  tAndC() async {
    Get.back();
    Uri url = Uri.parse("https://gleekey.in/glee-partner-terms");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
    // Get.to(() => const TermAndCondition());
  }

  cancellationPolicy() async {
    Get.back();
    Uri url = Uri.parse("https://gleekey.in/cancellation-policy");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  privacyPolicy() async {
    Get.back();
    Uri url = Uri.parse("https://gleekey.in/privacy-policy");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
    // Get.to(() => const PrivacyPolicy());
  }

  helpCenter() async {
    Get.back();
    Uri url = Uri.parse("https://gleekey.in/privacy-policy");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
    // Get.to(() => const PrivacyPolicy());
  }

  // support() {
  //   Get.back();
  //   Get.to(() => SupportScreen());
  // }

  help() async {
    Get.back();
    Uri url = Uri.parse("https://www.gleekey.in/contact-us");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  var tileFunction = [];

  int? lastIndex;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (getController.currentIndex != 0 &&
            getController.currentIndex != 4) {
          getController.goto(0);
          return false;
        } else if (getController.currentIndex == 4) {
          Get.back();
          getController.currentIndex = lastIndex;
          getController.update();
          return false;
        } else {
          return showExitPopup(context);
        }
      },
      child: Stack(
        children: [
          Scaffold(
              key: drawerKey,
              backgroundColor: const Color(0xFF1C2534),
              onDrawerChanged: (isOpened) {
                if (isOpened) {
                  lastIndex = getController.currentIndex;
                  getController.currentIndex = 4;
                  getController.update();
                } else {
                  getController.currentIndex = lastIndex;
                  getController.update();
                }
              },
              body: GetBuilder<HomePageController>(
                initState: (a) {},
                builder: (a) {
                  return PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: a.mainPages.length,
                    controller: a.pageController,
                    itemBuilder: ((context, index) {
                      return a.mainPages[index];
                    }),
                  );
                },
              ),
              drawerEnableOpenDragGesture: true,
              drawer: GetBuilder<UserLoginController>(
                  initState: (a) {},
                  builder: (a) {
                    return Drawer(
                      backgroundColor: kDrawer,
                      child: Stack(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Image.asset(
                                "assets/images/appbar_icons/appbar_blob.png",
                                height: dheight.toDouble(),
                              )),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Image.asset(
                                "assets/images/appbar_icons/appbar_hotel.png",
                                height: dheight * 0.2,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 25,
                              top: 40,
                            ),
                            child: Column(
                              children: [
                                Bounce(
                                  duration: const Duration(milliseconds: 150),
                                  onPressed: () {
                                    Get.to(() => ProfileScreen());
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 52 / 2,
                                        backgroundImage: NetworkImage(
                                            currUser!.data!.profileSrc ?? ''),
                                      ),
                                      const SizedBox(
                                        width: 14,
                                      ),
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            commonText(
                                              text: currUser!.data!.firstName ??
                                                  '' " " +
                                                      (currUser!
                                                              .data!.lastName ??
                                                          ''),
                                              color: kWhite,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            commonText(
                                              text: currUser!.data!.email ?? '',
                                              color: kWhite,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 19,
                                ),
                                SizedBox(
                                  // height: dheight * 0.7,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: ListView.separated(
                                              separatorBuilder:
                                                  (context, index) {
                                                return const SizedBox(
                                                  height: 0,
                                                );
                                              },
                                              shrinkWrap: true,
                                              itemCount: tileName.length,
                                              itemBuilder: ((context, index) {
                                                return DrawerTile(
                                                    tileIcon: tileImage[index],
                                                    tileName: tileName[index],
                                                    tileFunction:
                                                        tileFunction[index]);
                                              })),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          child: Bounce(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            onPressed: (() {
                                              BtmLogout(context);
                                            }),
                                            child: Container(
                                              height: 45,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                  color: kWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/images/logout_icon.png",
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  commonText(
                                                    text: "Logout",
                                                    color: kBlack,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                // Spacer(),
                                // TextButton(
                                //   onPressed: (){},
                                //   child: Text("Terms % Conditions",style:Palette.topTextWhite),
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              bottomNavigationBar: GetBuilder<HomePageController>(
                initState: (a) {},
                builder: (a) {
                  return Container(
                    color: kWhite,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                                color: kDarkGrey.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0.0, 5.0))
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (() {
                              a.goto(0);
                            }),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      child: a.currentIndex == 0
                                          ? Image.asset(
                                              "assets/images/home_icon_color.png",

                                              color: kOrange,
                                              width: 23,
                                              height: 23,
                                            )
                                          : Image.asset(
                                              "assets/images/home_icon.png",
                                              
                                              color: kBlack.withOpacity(0.3),
                                              width: 23,
                                              height: 23,
                                            )),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Home',
                                    style: a.currentIndex == 0
                                        ? Palette.bottomTextDark
                                        : Palette.bottomTextLight,
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (() {
                              a.goto(1);
                            }),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      child: a.currentIndex == 1
                                          ? Image.asset(
                                              "assets/images/wishlist_icon_color.png",
                                              
                                              color: kOrange,
                                              width: 23,
                                              height: 23,
                                            )
                                          : Image.asset(
                                              "assets/images/wishlist_icon.png",
                                              
                                              color: kBlack.withOpacity(0.3),
                                              width: 23,
                                              height: 23,
                                            )),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Wishlist',
                                    style: a.currentIndex == 1
                                        ? Palette.bottomTextDark
                                        : Palette.bottomTextLight,
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              a.goto(2);
                            },
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      child: a.currentIndex == 2
                                          ? Image.asset(
                                              "assets/images/booking_icon_color.png",
                                              
                                              color: kOrange,
                                              width: 23,
                                              height: 23,
                                            )
                                          : Image.asset(
                                              "assets/images/booking_icon.png",
                                              
                                              color: kBlack.withOpacity(0.3),
                                              width: 23,
                                              height: 23,
                                            )),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Trips',
                                    style: a.currentIndex == 2
                                        ? Palette.bottomTextDark
                                        : Palette.bottomTextLight,
                                  )
                                ],
                              ),
                            ),
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     a.goto(3);
                          //   },
                          //   child: Column(
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: [
                          //       AnimatedContainer(
                          //           duration: const Duration(milliseconds: 1500),
                          //           curve: Curves.fastLinearToSlowEaseIn,
                          //           child: a.currentIndex == 3
                          //               ? Image.asset(
                          //                   "assets/images/bell_icon_color.png",
                          //                   
                          //                   color: kOrange,
                          //                   width: 23,
                          //                   height: 23,
                          //                 )
                          //               : Image.asset(
                          //                   "assets/images/bell_icon.png",
                          //                   
                          //                   color: kBlack.withOpacity(0.3),
                          //                   width: 23,
                          //                   height: 23,
                          //                 )),
                          //       const SizedBox(
                          //         height: 5,
                          //       ),
                          //       Text(
                          //         'Notification',
                          //         style: a.currentIndex == 3
                          //             ? Palette.bottomTextDark
                          //             : Palette.bottomTextLight,
                          //       )
                          //     ],
                          //   ),
                          // ),

                          InkWell(
                              onTap: () {
                                a.goto(4);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      child: a.currentIndex == 4
                                          ? Image.asset(
                                              "assets/images/menu_selected.png",
                                              
                                              color: kOrange,
                                              width: 23,
                                              height: 23,
                                            )
                                          : Image.asset(
                                              "assets/images/menu_unselected.png",
                                              
                                              color: kBlack.withOpacity(0.3),
                                              width: 23,
                                              height: 23,
                                            )),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'Menu',
                                    style: a.currentIndex == 4
                                        ? Palette.bottomTextDark
                                        : Palette.bottomTextLight,
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}

Future<dynamic> BtmLogout(BuildContext context) {
  return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      context: context,
      builder: ((context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20)),
                    height: 4,
                    width: 40,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  commonText(
                    color: kBlack,
                    fontSize: 20,
                    text: "Log Out?",
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Center(
                    child: commonText(
                      textAlign: TextAlign.center,
                      color: kBlack.withAlpha(125),
                      fontSize: 15,
                      text: "Are You Sure, You Wants To Logout?",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: Bounce(
                            duration: const Duration(milliseconds: 300),
                            onPressed: (() {
                              Get.back();
                            }),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: kBtnGrey,
                                  borderRadius: BorderRadius.circular(6)),
                              height: 45,
                              child: Center(
                                child: commonText(
                                  textAlign: TextAlign.center,
                                  color: kBlack,
                                  fontSize: 14,
                                  text: "Cancel",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Bounce(
                            duration: const Duration(milliseconds: 300),
                            onPressed: () {
                              UserLoginController a = Get.find();
                              a.logOut();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: kOrange),
                                  color: kOrange,
                                  borderRadius: BorderRadius.circular(6)),
                              height: 45,
                              child: Center(
                                child: commonText(
                                  textAlign: TextAlign.center,
                                  color: kWhite,
                                  fontSize: 14,
                                  text: "Logout",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }));
}
