// ignore_for_file: file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart' show AndroidDeviceInfo, DeviceInfoPlugin;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:gleekeyu/src/Auth/Login/userLogin_model.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_view.dart';
import 'package:gleekeyu/src/HomePage/homePage_view.dart';
import 'package:gleekeyu/src/Menu/MyCoupons/my_coupons_view.dart';
import 'package:gleekeyu/src/Menu/MyCoupons/my_coupons_controller.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
import 'package:gleekeyu/widgets/loder.dart';
import 'package:gleekeyu/widgets/showSnackBar.dart';

class UserLoginController extends GetxController {
  static UserLoginController to = Get.put(UserLoginController());
  static User_model? user_model;
  RxString deviceId = ''.obs;
  RxString fcmToken = ''.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController ForgetemailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? emailError;
  String? forgetPasswordEmailError;
  String? passwordError;
  RxBool isOTPScreen = false.obs;
  bool isUserLogedIn = false;
  bool isValidate = false;
  bool isForgetPasswordValidate = false;
  RxBool isEmail = true.obs;
  RxBool isPhone = false.obs;
  RxBool isOTPSentAgain = false.obs;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String? email, password, isEverLogedin;
  String? forgetPasswordEmail;
  RxString otp = ''.obs;
  var currpage;
  final box = Hive.box('gleekey');
  Timer? timer;
  RxInt start = 30.obs;
  bool navigateToCouponsAfterLogin = false;
  bool openAddCouponPopup = false;
  bool backToHomeFromCoupons = false;


  void saveUserData(User_model userModel) {
    try {
      // Convert user model to JSON string and save
      String userDataJson = jsonEncode(userModel.toJson());
      box.put('userData', userDataJson);
      box.put('isUserLoggedIn', true);
      // Also save email and password separately for backward compatibility
      box.put("email", email);
      box.put('password', password);
      box.put('isEverLogedin', "true");
      print("User data saved successfully");
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

  // Load user data from Hive
  User_model? loadUserData() {
    try {
      String? userDataJson = box.get('userData');
      if (userDataJson != null) {
        Map<String, dynamic> userData = jsonDecode(userDataJson);
        return User_model.fromJson(userData);
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
    return null;
  }

  // Check if user is logged in
  bool isUserLoggedIn() {
    final isLoggedFlag = box.get('isUserLoggedIn', defaultValue: false) as bool;
    if (!isLoggedFlag) return false;

    final savedUser = loadUserData();
    if (savedUser != null) {
      currUser = savedUser;
      return true;
    }

    return false;
  }

  void _handlePostLoginNavigation() {
    if (navigateToCouponsAfterLogin) {
      navigateToCouponsAfterLogin = false;
      openAddCouponPopup = true;
      backToHomeFromCoupons = true;
      // User came from coupon deep link: make HomePage the base route,
      // then open MyCoupons so that back from coupons returns to Home.
      Get.offAll(() => const HomePage());
      if (Get.isRegistered<MyCouponsController>()) {
        final c = Get.find<MyCouponsController>();
        c.initialPopupShown = false;
      }
      Get.to(() => const MyCouponsScreen(),
          arguments: {'openAddPopup': true});
    } else if (Get.previousRoute.isNotEmpty && Get.previousRoute != "/HomePage") {
      Get.back();
    } else {
      Get.offAll(() => const HomePage());
    }
  }

  userLogedinUpdate() {
    // Save current user data completely
    if (currUser != null) {
      saveUserData(currUser!);
    }
  }

  defaultLogin() async {
    print("Starting default login check...");

    // First check if we have saved user data
    if (isUserLoggedIn()) {
      User_model? savedUser = loadUserData();
      if (savedUser != null && savedUser.data != null) {
        currUser = savedUser;
        isUserLogedIn = true;
        email = savedUser.data!.email;
        print("User loaded from saved data: ${email}");
        update();
        return; // User is already logged in, no need to proceed
      }
    }

    // If no saved user data, try traditional login methods
    email = box.get('email');
    password = box.get('password');
    isEverLogedin = box.get('isEverLogedin');

    print("Email from storage: $email");
    print("Password exists: ${password != null}");
    print("Ever logged in: $isEverLogedin");

    if (email != null) {
      if (password != null) {
        // Try login with saved credentials
        await getApi(
          onError: (error) {
            print("Auto-login failed: ${error['message']}");
            // If auto-login fails, clear saved data and show login screen
            clearUserData();
          },
        );
      } else {
        // Try Google sign in if no password but email exists
        try {
          final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signInSilently(); // Use silent sign in
          if (googleSignInAccount != null) {
            await socialApi(
              params: {
                'device_token': deviceId.value,
                'fcm_token': fcmToken.value,
                "oauth_provider": "google",
                "oauth_uid": googleSignInAccount.id,
                "first_name": googleSignInAccount.displayName,
                "email": googleSignInAccount.email,
                "image": googleSignInAccount.photoUrl.toString(),
                'user_host': '1',
              },
            );
          } else {
            // Google silent sign in failed, initialize empty user
            initializeEmptyUser();
          }
        } catch (e) {
          print("Google silent sign in failed: $e");
          initializeEmptyUser();
        }
      }
    } else {
      print("No email found, initializing empty user");
      initializeEmptyUser();
    }
    update();
  }

  // Initialize empty user when no login data exists
  void initializeEmptyUser() {
    currUser = User_model();
    currUser!.data = Data();
    isUserLogedIn = false;
  }

  // Clear all user data
  void clearUserData() {
    box.delete('userData');
    box.delete('isUserLoggedIn');
    box.delete('email');
    box.delete('password');
    box.put('isEverLogedin', "false");
    initializeEmptyUser();
  }

  // Modified getApi method to save user data properly
  Future<bool?> getApi({required Function(dynamic error) onError}) async {
    http.Response? response;
    if (isPhone.value) {
      response = await http.post(
        Uri.parse(BaseConstant.BASE_URL + EndPoint.sendOTP),
        body: {
          'phone_number': email,
          'fcm_token': fcmToken.value,
        },
      );
      print("Response : ${response.body}");
    } else {
      response = await http.post(
        Uri.parse(BaseConstant.BASE_URL + EndPoint.login),
        body: {
          'email': email,
          'password': password,
          'fcm_token': fcmToken.value,
          'device_token': deviceId.value,
        },
      );
    }

    if (response.statusCode == 200 || response.statusCode == 401) {
      if (isPhone.value) {
        var result = json.decode(response.body);
        if (result['status'] == true) {
          loaderHide();
          isOTPScreen.value = true;
          start.value = 30;
          startTimer();
          update();
          return true;
        } else {
          onError(result);
          loaderHide();
        }
      } else {
        var result = json.decode(response.body);
        user_model = User_model.fromJson(result);
        if (user_model!.status == true) {
          currUser = user_model!;
          print("Current User: ${currUser}");
          isUserLogedIn = true;
          userLogedinUpdate(); // This will save the complete user data
          log("UserLoginController --> Login Success : ${email!}");
          loaderHide();

          _handlePostLoginNavigation();
        } else {
          loaderHide();
          onError(result);
          initializeEmptyUser();
        }
      }
    } else {
      initializeEmptyUser();
      loaderHide();
      printError(info: "Not get data from login api");
    }

    update();
    return null;
  }

  // Modified socialApi method
  Future<bool?> socialApi({
    required Map<String, dynamic> params,
    bool isFormData = false,
  }) async {
    log(params.toString(), name: 'SOCIAL SIGN IN');
    try {
      dio.Response response = await dio.Dio().post(
        BaseConstant.BASE_URL + EndPoint.socialLogin,
        data: isFormData ? dio.FormData.fromMap(params) : params,
      );

      if (response.statusCode == 200) {
        user_model = User_model.fromJson(response.data);
        log("user model api ${response.data}");

        if (user_model!.status == true) {
          currUser = user_model!;
          isUserLogedIn = true;
          email = user_model!.data!.email;
          userLogedinUpdate(); // This will save the complete user data
          log("UserLoginController --> Login Success : ${email!}");
          loaderHide();

          _handlePostLoginNavigation();
        } else {
          loaderHide();
          showSnackBar(
              title: "Login Failed", message: user_model!.message ?? '');
          initializeEmptyUser();
        }
      } else {
        initializeEmptyUser();
        loaderHide();
        printError(info: "Not get data from login api");
      }
    } on dio.DioError catch (e) {
      loaderHide();
      log("DIO ERROR ${e.message}");
      initializeEmptyUser();
    }
    return null;
  }

  // Modified otpVerify method
  otpVerify() async {
    http.Response? response;

    response = await http.post(
      Uri.parse(BaseConstant.BASE_URL + EndPoint.sendOTP),
      body: {'phone_number': email,   'fcm_token': fcmToken.value, 'otp': otp.value},
    );
    print("Response : ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 401) {
      var result = json.decode(response.body);
      user_model = User_model.fromJson(result);
      if (user_model!.status == true) {
        currUser = user_model!;
        isUserLogedIn = true;
        userLogedinUpdate(); // This will save the complete user data
        log("UserLoginController --> Login Success : ${email!}");
        loaderHide();

        _handlePostLoginNavigation();
      } else {
        loaderHide();
        showSnackBar(title: "Login Failed", message: user_model!.message ?? "");
        initializeEmptyUser();
      }
    } else {
      initializeEmptyUser();
      loaderHide();
      printError(info: "Not get data from login api");
    }

    update();
  }

  logOut() {
    clearUserData(); // Clear all user data properly
    Get.back();
    update();
    Get.offAll(() => const Login());
    log("User Logout");
  }

  // Rest of your existing methods remain the same...
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
        } else {
          start.value--;
          update();
        }
      },
    );
  }

  Future<void> getDeviceIDUsingPlugin() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    deviceId.value = (androidInfo.id) ?? '';
    print('DEVICE ID ${deviceId.value}');

    fcmToken.value = (await FirebaseMessaging.instance.getToken()) ?? '';
    log(fcmToken.value, name: 'fcmToken');
  }

  @override
  void onInit() {
    log("trying for default login");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getDeviceIDUsingPlugin();
      defaultLogin();
    });
    super.onInit();
  }

  isPhoneValidate(String input) {
    isPhone.value =
        RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
            .hasMatch(input);
    if (isPhone.value) {
      isEmail.value = false;
    } else {
      isEmail.value = true;
    }
    update();
  }

  @override
  void onClose() {
    update();
    super.onClose();
  }

  forgetPasswordApi() async {
    http.Response response = await http.post(
      Uri.parse(BaseConstant.BASE_URL + EndPoint.forgetPassword),
      body: {
        'email': forgetPasswordEmail,
      },
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      if (result['status']) {
        loaderHide();
        showSnackBar(
            title: "Success",
            message: result['message'],
            color: Colors.green,
            isSuccess: true);
        Get.offAll(() => const Login());
        emailController.text = ForgetemailController.text;
      } else {
        showSnackBar(
          title: "Failed",
          message: result['message'],
        );
        loaderHide();
      }
    } else {
      loaderHide();
      printError(info: "Not get data from ForgetPassword api");
    }
    update();
  }

  validate() {
    emailError = emailValidator();
    passwordError = passwordValidator();
    update();
  }

  ForgetPasswordvalidate() {
    forgetPasswordEmailError = ForgetPasswordemailValidator();
    update();
  }

  String? emailValidator() {
    if (isEmail.value) {
      if (emailController.text.isEmpty ||
          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(emailController.text)) {
        return "Enter Correct Email Address";
      } else {
        return null;
      }
    }
    return null;
  }

  String? ForgetPasswordemailValidator() {
    if (ForgetemailController.text.isEmpty) {
      return "Enter Correct Email";
    } else {
      return null;
    }
  }

  String? passwordValidator() {
    if (passwordController.text.isEmpty) {
      return "Enter Correct Password";
    } else {
      return null;
    }
  }
}
