import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_controller.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_view.dart';
import 'package:gleekeyu/src/HomePage/homePage_controller.dart';
import 'package:gleekeyu/src/Menu/DashBoard/dashboard_controller.dart';
import 'package:gleekeyu/src/Menu/MyCoupons/my_coupons_view.dart';
import 'package:gleekeyu/src/Menu/MyCoupons/my_coupons_controller.dart';
import 'package:gleekeyu/src/Menu/WishList/AddWishList_Widget/addWishlist_controller.dart';
import 'package:gleekeyu/src/SubPages/Filter/filter.dart';
import 'package:gleekeyu/src/SubPages/Filter/filter_controller.dart';
import 'package:gleekeyu/src/SubPages/PropertyAllDetails/propertyAllDetails_controller.dart';
import 'package:gleekeyu/src/SubPages/SearchPlaces/searchPlaces_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'services/firebase_pushNotification_service.dart'
    show PushNotificationService;
import 'src/Intro_pages/splashScreen.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/style/constants.dart';
import 'widgets/snow_fall_widget.dart';

const MethodChannel _deepLinkChannel = MethodChannel('deep_link_channel');

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  PushNotificationService.setUpInterractedMassage2(message);
}

void initDeepLinks() {
  _deepLinkChannel.setMethodCallHandler((call) async {
    if (call.method == 'onDeepLink') {
      final url = call.arguments as String?;
      if (url != null && url.isNotEmpty) {
        _handleDeepLink(url);
      }
    }
  });
}

Future<void> _checkInitialDeepLink() async {
  try {
    final initialUrl = await _deepLinkChannel.invokeMethod<String>(
      'getInitialLink',
    );
    if (initialUrl != null && initialUrl.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleDeepLink(initialUrl);
      });
    }
  } catch (e) {}
}

void _handleDeepLink(String url) {
  print('Received deep link: $url');

  if (url.contains('/filter')) {
    Get.to(() => const Filter());
  } else if (url.contains('/coupon/')) {
    final userController = UserLoginController.to;
    userController.navigateToCouponsAfterLogin = true;
    if (userController.isUserLoggedIn()) {
      // Already logged in: go directly to My Coupons and open popup,
      // and clear the post-login flag so future logins behave normally.
      userController.navigateToCouponsAfterLogin = false;
      userController.openAddCouponPopup = true;
      if (Get.isRegistered<MyCouponsController>()) {
        final c = Get.find<MyCouponsController>();
        c.initialPopupShown = false;
      }
      Get.to(() => const MyCouponsScreen(), arguments: {'openAddPopup': true});
    } else {
      // Not logged in: go to Login; on successful login,
      // UserLoginController._handlePostLoginNavigation will
      // read navigateToCouponsAfterLogin and redirect.
      Get.offAll(() => const Login());
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    print("Valueeeee: $value");
    if (value) {
      Permission.notification.request();
    }
  });

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  try {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await Firebase.initializeApp();
    print("FCM TOKEN:::: ${await FirebaseMessaging.instance.getToken()}");
    await PushNotificationService().setupInteractedMessage();
  } catch (e) {}

  await FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      // 🔥 App close hoy tyare aavi notification thi su open karvu te decide karo
      PushNotificationService.setUpInterractedMassage2(message);
    }
  });

  await Hive.initFlutter();
  await Hive.openBox('gleekey');

  Get.put(UserLoginController());
  Get.put(FilterController());
  Get.put(SearchPlacesController());
  Get.put(HomePageController());
  Get.put(WishlistController());
  Get.put(DashBoardController());
  Get.put(PropertyAllDetailsController());

  initDeepLinks();

  runApp(const MyApp());
}

Future<String?> _getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id; // unique ID on Android
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gleekey',
      theme: ThemeData(
        primaryColor: kOrange,
        primarySwatch: Colors.deepOrange,
        unselectedWidgetColor: kOrange,
        fontFamily: 'HankenGrotesk',
      ),
      // builder: (context, child) {
      //   return SnowFallWidget(child: SafeArea(child: child!));
      // },
      builder: (context, child) {
        return SafeArea(child: child!);
      },
      supportedLocales: const [Locale('en', 'US')],
      home: SplashPage(),
    );
  }
}
