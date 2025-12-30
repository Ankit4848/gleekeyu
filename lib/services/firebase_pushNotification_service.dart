import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/HomePage/homePage_view.dart';
import 'package:gleekeyu/src/Intro_pages/splashScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../extras/prefController.dart';
import '../src/Auth/Login/userLogin_controller.dart';
import '../src/HomePage/homePage_controller.dart';
import 'package:intl/intl.dart';

import '../src/Menu/DashBoard/dashboard_controller.dart';
import '../src/SubPages/PropertyAllDetails/propertyAllDetails_controller.dart';
import '../src/SubPages/confirm_n_pay/confirm_n_pay.dart';

@pragma('vm:entry-point')
void backgroundHandler(NotificationResponse details) {
  log('Background Notification Tap: ${details.payload}', name: 'BG_HANDLER');

  print("Detailssss123: ${details.payload}");
  log('${details.payload}', name: 'NOTIFICATION TAP');
  log(PrefController.to.token.value, name: 'NOTIFICATION TAP');
    if (details.payload == "Transaction") {
     // Get.to(() => const TransactionHistoryScreen());
    } else if (details.payload == "New Booking" ||
        details.payload == "Cancel Booking") {
     // Get.to(() => const ReserVationScreen());
    } else {
     // Get.to(() => const NotificationScreen());
    }


}

class PushNotificationService {
// It is assumed that all messages contain a data field with the key 'type'
  setupInteractedMessage() async {
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   // Get.to(() => TransactionHistoryScreen());
    // });
    enableIOSNotifications();
    await registerNotificationListeners();
  }

  registerNotificationListeners() async {
    try {
      final AndroidNotificationChannel channel = androidNotificationChannel();
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@drawable/app_logo');
      const DarwinInitializationSettings iOSSettings =
      DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );
      InitializationSettings initSettings = const InitializationSettings(
        android: androidSettings,
        iOS: iOSSettings,
      );

      flutterLocalNotificationsPlugin.initialize(initSettings,
          onDidReceiveNotificationResponse: (NotificationResponse details) async {
            print("Detailssss12dddddddddddd3: ${details.payload}");
            print('${details.payload} NOTIFICATION TAP');
            print('PrefController.to.token.value NOTIFICATION TAP');


              if (details.payload.toString().contains("Trip")||details.payload.toString().contains("Inquiry")) {

                HomePageController homePageController=Get.find();
                homePageController.currentIndex=2;
                homePageController.goto(homePageController.currentIndex ?? 0);
                homePageController.update();
                Get.to(() =>  HomePage());

             //   Get.to(() =>  MenuScreen());
              }

              else if (details.payload.toString().contains("Inq Approved")) {
              DashBoardController dashBoardController=Get.find();
              PropertyAllDetailsController getController =
              Get.find();

              await getController.getBasketApi(dashBoardController.inquiryModel!.inquiryModelData!.slug!,
                dashBoardController.inquiryModel!.inquiryModelData!.propertyId!.toString(),
                DateFormat('dd-MM-yyyy').format( DateTime.parse(dashBoardController.inquiryModel!.inquiryModelData!.data!.checkIn!)),
                DateFormat('dd-MM-yyyy').format( DateTime.parse(dashBoardController.inquiryModel!.inquiryModelData!.data!.checkOut!)),).then((value) async {


                getController.startDate= DateFormat('dd-MM-yyyy').format( DateTime.parse(dashBoardController.inquiryModel!.inquiryModelData!.data!.checkIn!));
                getController.endDate= DateFormat('dd-MM-yyyy').format( DateTime.parse(dashBoardController.inquiryModel!.inquiryModelData!.data!.checkOut!));

                print("asdasdasdasd");
                print(dashBoardController
                    .inquiryModel!.inquiryModelData!
                    .data!.couponCode);

                if(dashBoardController.inquiryModel!.inquiryModelData!.data!.couponCode!=null) {
                  await getController
                      .getPrice(
                      isCoupenCode:
                      true,
                      params: {
                        "property_id": getController
                            .PropertyData
                            ?.propertyId,
                        // "from_date":
                        //     "01-05-2024",

                        // "to_date":
                        //     "02-05-2024",

                        "from_date":
                        getController
                            .startDate,
                        "to_date": DateFormat('dd-MM-yyyy')
                            .format(DateTime.now().add(
                            const Duration(days: 45)))
                            .toString(),
                        "coupon_code": dashBoardController
                            .inquiryModel!.inquiryModelData!
                            .data!.couponCode,
                      },
                      success:
                          () async {
                        print("Successs123");


                        getController
                            .isCoupenApplied
                            .value = true;
                        getController
                            .coupenCode
                            .value =
                            dashBoardController.inquiryModel!
                                .inquiryModelData!.data!
                                .couponCode ??
                                '';
                        getController
                            .offerPercentage
                            .value =
                            (dashBoardController.inquiryModel!
                                .inquiryModelData!.data!
                                .discountPer ??
                                0)
                                .toString();
                        getController
                            .update();
                        await getController.priceUpdate().then((value) {

                          print( "getController.totalPrice");
                          print( getController.totalPrice);
                          print(getController
                              .offerPercentage
                              .value );

                          Get.to(() =>   ConfirmNpay(
                            propertyType: getController.PropertyData!.result!.propertyTypeName ?? '',
                            propertyID: (getController.PropertyData!.result!.id ?? '').toString(),
                            coverImg: getController
                                .PropertyData!.result!.coverPhoto,
                            totalPrice:getController
                                .offerPercentage
                                .value !=null?
                            getController.totalPrice! - int.parse(getController
                                .offerPercentage
                                .value)

                                : getController.totalPrice ??
                                (getController
                                    .dateprice![0].originalPrice ??
                                    0),
                            selectedDates:
                            getController.selectedDateWithPrice,
                          ));
                        },);
                      });
                }else
                {

                  await getController.priceUpdate().then((value) {
                    Get.to(() =>   ConfirmNpay(
                      propertyType: getController.PropertyData!.result!.propertyTypeName ?? '',
                      propertyID: (getController.PropertyData!.result!.id ?? '').toString(),
                      coverImg: getController
                          .PropertyData!.result!.coverPhoto,
                      totalPrice: getController.totalPrice ??
                          (getController
                              .dateprice![0].originalPrice ??
                              0),
                      selectedDates:
                      getController.selectedDateWithPrice,
                    ));
                  },);
                }
              },);




              //Get.to(() =>  MenuScreen());
              }


              else if (details.payload.toString().contains("Booking")) {
              //  Get.to(() => const ReserVationScreen());
              }else if (details.payload.toString().contains("Transaction")) {
              //  Get.to(() => const TransactionHistoryScreen());
              }else if (details.payload.toString().contains("Property")) {
                // Get.to(() => AllListingScreen(type: 'Listed',));
              } else {

              }


          },
          onDidReceiveBackgroundNotificationResponse:
          backgroundHandler);

      FirebaseMessaging.onMessage.listen(
            (RemoteMessage? message) {
          // homeController.getHomeData(
          //   withLoading: false,
          // );
          print("DetailssssS: ${message?.notification?.android}");
          log(message.toString(), name: 'onMessage');
          final RemoteNotification? notification = message!.notification;
          final AndroidNotification? android = message.notification?.android;
          // If `onMessage` is triggered with a notification, construct our own
          // local notification to show to users using the created channel.
          if (notification != null && android != null) {
            print("Condition Truw");
            flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              payload: notification.title ?? '',
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: '@drawable/app_logo',
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      print("Error:::::: ${e}");
    }
  }
  static Future<void> setUpInterractedMassage() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();



    if (initialMessage != null) {
      print("222222222222222222222222222222222222222");
      print(initialMessage.data['text']);
      print(initialMessage.data.containsKey('text') &&
          initialMessage.data['text'].toString().contains('Property Approved'));

      log('initial message ${initialMessage.data}',
          name: 'onMessageOpenedApp MSG');

        if (initialMessage.data.containsKey('text') &&
            initialMessage.data['text'].toString().contains('Inq Approved')) {
          DashBoardController dashBoardController=Get.find();
          PropertyAllDetailsController getController =
          Get.find();

          await dashBoardController.getInqApi().then((value) async {
            await getController.getBasketApi(dashBoardController.inquiryModel!.inquiryModelData!.slug!,
              dashBoardController.inquiryModel!.inquiryModelData!.propertyId!.toString(),
              DateFormat('dd-MM-yyyy').format( DateTime.parse(dashBoardController.inquiryModel!.inquiryModelData!.data!.checkIn!)),
              DateFormat('dd-MM-yyyy').format( DateTime.parse(dashBoardController.inquiryModel!.inquiryModelData!.data!.checkOut!)),).then((value) async {


              getController.startDate= DateFormat('dd-MM-yyyy').format( DateTime.parse(dashBoardController.inquiryModel!.inquiryModelData!.data!.checkIn!));
              getController.endDate= DateFormat('dd-MM-yyyy').format( DateTime.parse(dashBoardController.inquiryModel!.inquiryModelData!.data!.checkOut!));

              print("asdasdasdasd");
              print(dashBoardController
                  .inquiryModel!.inquiryModelData!
                  .data!.couponCode);

              if(dashBoardController.inquiryModel!.inquiryModelData!.data!.couponCode!=null) {
                await getController
                    .getPrice(
                    isCoupenCode:
                    true,
                    params: {
                      "property_id": getController
                          .PropertyData
                          ?.propertyId,
                      // "from_date":
                      //     "01-05-2024",

                      // "to_date":
                      //     "02-05-2024",

                      "from_date":
                      getController
                          .startDate,
                      "to_date": DateFormat('dd-MM-yyyy')
                          .format(DateTime.now().add(
                          const Duration(days: 45)))
                          .toString(),
                      "coupon_code": dashBoardController
                          .inquiryModel!.inquiryModelData!
                          .data!.couponCode,
                    },
                    success:
                        () async {
                      print("Successs123");


                      getController
                          .isCoupenApplied
                          .value = true;
                      getController
                          .coupenCode
                          .value =
                          dashBoardController.inquiryModel!
                              .inquiryModelData!.data!
                              .couponCode ??
                              '';
                      getController
                          .offerPercentage
                          .value =
                          (dashBoardController.inquiryModel!
                              .inquiryModelData!.data!
                              .discountPer ??
                              0)
                              .toString();
                      getController
                          .update();
                      await getController.priceUpdate().then((value) {

                        print( "getController.totalPrice");
                        print( getController.totalPrice);
                        print(getController
                            .offerPercentage
                            .value );

                        Get.to(() =>   ConfirmNpay(
                          propertyType: getController.PropertyData!.result!.propertyTypeName ?? '',
                          propertyID: (getController.PropertyData!.result!.id ?? '').toString(),
                          coverImg: getController
                              .PropertyData!.result!.coverPhoto,
                          totalPrice:getController
                              .offerPercentage
                              .value !=null?
                          getController.totalPrice! - int.parse(getController
                              .offerPercentage
                              .value)

                              : getController.totalPrice ??
                              (getController
                                  .dateprice![0].originalPrice ??
                                  0),
                          selectedDates:
                          getController.selectedDateWithPrice,
                        ));
                      },);
                    });
              }else
              {

                await getController.priceUpdate().then((value) {
                  Get.to(() =>   ConfirmNpay(
                    propertyType: getController.PropertyData!.result!.propertyTypeName ?? '',
                    propertyID: (getController.PropertyData!.result!.id ?? '').toString(),
                    coverImg: getController
                        .PropertyData!.result!.coverPhoto,
                    totalPrice: getController.totalPrice ??
                        (getController
                            .dateprice![0].originalPrice ??
                            0),
                    selectedDates:
                    getController.selectedDateWithPrice,
                  ));
                },);
              }
            },);

          },);

        } else  if (initialMessage.data.containsKey('text') &&
            initialMessage.data['text'].toString().contains('Inquiry')) {
          HomePageController homePageController=Get.find();

          Get.to(() =>  HomePage());
          homePageController.currentIndex=2;
          homePageController.goto(homePageController.currentIndex ?? 0);
          homePageController.update();

          //   Get.to(() => MenuScreen());
        } else  if (initialMessage.data.containsKey('text') &&
            initialMessage.data['text'].toString().contains('Trip')) {
          HomePageController homePageController=Get.find();

          Get.to(() =>  HomePage());
          homePageController.currentIndex=2;
          homePageController.goto(homePageController.currentIndex ?? 0);
          homePageController.update();

          //   Get.to(() => MenuScreen());
        }



        else  if (initialMessage.data.containsKey('text') &&
            initialMessage.data['text'].toString().contains('Trip')) {
          HomePageController homePageController=Get.find();

          Get.to(() =>  HomePage());
          homePageController.currentIndex=2;
          homePageController.goto(homePageController.currentIndex ?? 0);
          homePageController.update();

          //   Get.to(() => MenuScreen());
        } else if (initialMessage.data.containsKey('text') &&
            initialMessage.data['text'].toString().contains('Transaction')) {
        //  Get.to(() => const TransactionHistoryScreen());
        } else if (initialMessage.data.containsKey('text') &&
            initialMessage.data['text'].toString().contains('Property')) {
          log('condition true');

        }
        else if (initialMessage.data.containsKey('text') &&
            initialMessage.data['text'].toString().contains('Booking')) {
          print('conditioasdsadasdsadsadn true');

        }

    }

    FirebaseMessaging.onMessageOpenedApp.listen(
          (event) async {
        print("Event data:: ${event.data}");
        log('initial message ${event.data})}', name: 'onMessageOpenedApp MSG');

          if (event.data['text'].toString().contains("Inquiry") || event.data['text'].toString().contains("Trip")) {
            HomePageController homePageController=Get.find();
            homePageController.currentIndex=2;
            homePageController.goto(homePageController.currentIndex ?? 0);
            homePageController.update();
            Get.to(() =>  SplashPage());

            //  Get.to(() =>  MenuScreen());
          } else if (event.data['text'].toString().contains('Inq Approved')) {
          DashBoardController dashBoardController=Get.find();
          PropertyAllDetailsController getController = Get.find();

          await getController.getBasketApi(dashBoardController.inquiryModel!.inquiryModelData!.slug!,
            dashBoardController.inquiryModel!.inquiryModelData!.propertyId!.toString(),
            DateFormat('dd-MM-yyyy').format( DateTime.parse(dashBoardController.inquiryModel!.inquiryModelData!.data!.checkIn!)),
            DateFormat('dd-MM-yyyy').format( DateTime.parse(dashBoardController.inquiryModel!.inquiryModelData!.data!.checkOut!)),).then((value) async {


            getController.startDate= DateFormat('dd-MM-yyyy').format( DateTime.parse(dashBoardController.inquiryModel!.inquiryModelData!.data!.checkIn!));
            getController.endDate= DateFormat('dd-MM-yyyy').format( DateTime.parse(dashBoardController.inquiryModel!.inquiryModelData!.data!.checkOut!));

            print("asdasdasdasd");
            print(dashBoardController
                .inquiryModel!.inquiryModelData!
                .data!.couponCode);

            if(dashBoardController.inquiryModel!.inquiryModelData!.data!.couponCode!=null) {
              await getController
                  .getPrice(
                  isCoupenCode:
                  true,
                  params: {
                    "property_id": getController
                        .PropertyData
                        ?.propertyId,
                    // "from_date":
                    //     "01-05-2024",

                    // "to_date":
                    //     "02-05-2024",

                    "from_date":
                    getController
                        .startDate,
                    "to_date": DateFormat('dd-MM-yyyy')
                        .format(DateTime.now().add(
                        const Duration(days: 45)))
                        .toString(),
                    "coupon_code": dashBoardController
                        .inquiryModel!.inquiryModelData!
                        .data!.couponCode,
                  },
                  success:
                      () async {
                    print("Successs123");


                    getController
                        .isCoupenApplied
                        .value = true;
                    getController
                        .coupenCode
                        .value =
                        dashBoardController.inquiryModel!
                            .inquiryModelData!.data!
                            .couponCode ??
                            '';
                    getController
                        .offerPercentage
                        .value =
                        (dashBoardController.inquiryModel!
                            .inquiryModelData!.data!
                            .discountPer ??
                            0)
                            .toString();
                    getController
                        .update();
                    await getController.priceUpdate().then((value) {

                      print( "getController.totalPrice");
                      print( getController.totalPrice);
                      print(getController
                          .offerPercentage
                          .value );

                      Get.to(() =>   ConfirmNpay(
                        propertyType: getController.PropertyData!.result!.propertyTypeName ?? '',
                        propertyID: (getController.PropertyData!.result!.id ?? '').toString(),
                        coverImg: getController
                            .PropertyData!.result!.coverPhoto,
                        totalPrice:getController
                            .offerPercentage
                            .value !=null?
                        getController.totalPrice! - int.parse(getController
                            .offerPercentage
                            .value)

                            : getController.totalPrice ??
                            (getController
                                .dateprice![0].originalPrice ??
                                0),
                        selectedDates:
                        getController.selectedDateWithPrice,
                      ));
                    },);
                  });
            }else
            {

              await getController.priceUpdate().then((value) {
                Get.to(() =>   ConfirmNpay(
                  propertyType: getController.PropertyData!.result!.propertyTypeName ?? '',
                  propertyID: (getController.PropertyData!.result!.id ?? '').toString(),
                  coverImg: getController
                      .PropertyData!.result!.coverPhoto,
                  totalPrice: getController.totalPrice ??
                      (getController
                          .dateprice![0].originalPrice ??
                          0),
                  selectedDates:
                  getController.selectedDateWithPrice,
                ));
              },);
            }
          },);

        } else if (event.data['text'].toString().contains("Booking")) {
           // Get.to(() => const ReserVationScreen());
          }else if (event.data['text'].toString().contains("Transaction")) {
          //  Get.to(() => const TransactionHistoryScreen());
          }else if (event.data['text'].toString().contains("Property")) {
           // Get.to(() => AllListingScreen(type: 'Listed',));
          } else {
          }
      },
    );
  }
  static Future<void> setUpInterractedMassage2(RemoteMessage initialMessage) async {

    print("11111111111111111111111111111");
    print(initialMessage.data.containsKey('text') &&
        initialMessage.data['text'].toString().contains('Property Approved'));

    if (initialMessage != null) {
      log('initial message ${initialMessage.data}',
          name: 'onMessageOpenedApp MSG');

        if (initialMessage.data.containsKey('text') &&
            initialMessage.data['text'].toString().contains('Inquiry')) {

          await Hive.initFlutter();
          await Hive.openBox('gleekey');
          HomePageController homePageController= Get.put(HomePageController());
          UserLoginController userLoginController= Get.put(UserLoginController());

          //  Get.to(() => InquiryScreen());

        }else if (initialMessage.data.containsKey('text') &&
            initialMessage.data['text'].toString().contains('Trip')) {

          await Hive.initFlutter();
          await Hive.openBox('gleekey');
          HomePageController homePageController= Get.put(HomePageController());
          UserLoginController userLoginController= Get.put(UserLoginController());

          //  Get.to(() => InquiryScreen());

        }
        else if (initialMessage.data.containsKey('text') &&
            initialMessage.data['text'].toString().contains('Transaction')) {

        } else if (initialMessage.data.containsKey('text') &&
            initialMessage.data['text'].toString().contains('Property')) {
          log('condition true');

        } else if (initialMessage.data.containsKey('text') &&
            initialMessage.data['text'].toString().contains('Booking')) {
          print('conditioasdsadasdsadsadn true');

        } else if (initialMessage.data.containsKey('text') &&
            initialMessage.data['text'].toString().contains('Property Approved')) {
          print('conditioasdsadasdsadsadn true');
      }
    }

  }

  static enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  static AndroidNotificationChannel androidNotificationChannel() =>
      const AndroidNotificationChannel(
        '1203', // id
        'High Importance Notifications', // title
        description:
        'This channel is used for important notifications.', // description
        importance: Importance.max,
      );
}


