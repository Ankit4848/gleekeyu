// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_controller.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_model.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_view.dart';
import 'package:intl/intl.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
import 'package:gleekeyu/widgets/loder.dart';
import 'package:gleekeyu/widgets/showSnackBar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:otp_text_field/otp_text_field.dart';

class UserResistorController extends GetxController {
  @override
  void onInit() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    birthDateController = TextEditingController();
    super.onInit();
  }

  User_model? user_model;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  RxBool isOTPScreen = false.obs;
  String? emailError;
  String? firstNameError;
  String? lastNameError;
  String? phoneError;
  String? passwordError;
  String? cnfmPasswordError;
  String? birthDateError;
  Timer? timer;
  RxInt start = 30.obs;
  RxBool isOTPSentAgain = false.obs;
  RxString otp = ''.obs;
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

  bool isValidate = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String? email;
  String? password;

  DateTime? birthDate;
  OtpFieldController otpFieldController = OtpFieldController();
  final box = Hive.box('gleekey');

  getApi({required bool isOTP}) async {
    Map<String, dynamic> params = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'password': passwordController.text,
      'confirm_password': confirmPasswordController.text,
      'date_of_birth': DateFormat('yyyy-MM-dd').format(birthDate!),
      'user_host': '0'
    };

    print(params);
    if (isOTP) {
      params.addAll({"otp": otp.value});
    }
    print(BaseConstant.BASE_URL + EndPoint.ragister);
    http.Response response = await http.post(
        Uri.parse(BaseConstant.BASE_URL + EndPoint.ragister),
        body: params);

    print(json.decode(response.body));

    if (response.statusCode == 200) {
      if (json.decode(response.body)['status'].toString() == 'true') {
        if (!isOTP) {
          isOTPScreen.value = true;
          update();
          start.value = 30;
          startTimer();
          showSnackBar(
              title: "Successfull",
              message: json.decode(response.body)['message'],
              color: Colors.green,
              isSuccess: true);
        } else {
          var result = json.decode(response.body);
          user_model = User_model.fromJson(result);
          // After successful registration (OTP verified), automatically
          // log the user in using the existing login flow so that
          // post-login navigation (including coupon deep link handling)
          // works the same as a normal login.
          UserLoginController loginController = Get.find();
          loginController.email = emailController.text;
          loginController.password = passwordController.text;
          await loginController.getApi(
            onError: (error) {
              showSnackBar(
                title: "Login Failed",
                message: error['message']?.toString() ?? '',
              );
            },
          );
        }
        UserLoginController a = Get.find();
        // box.put("email", email);dHAVAK
        // box.put('password', password);
        // box.put('isEverLogedin', "true");
        log("UserResistorController -- > User Successfully Registreted");
        loaderHide();
        // a.defaultLogin();
        update();
        a.emailController.text = emailController.text;
        a.passwordController.text = '';
      } else {
        loaderHide();
        showSnackBar(
          title: "Failed",
          message: json.decode(response.body)['message'].toString(),
          color: Colors.red,
          isSuccess: false,
        );
      }
    } else {
      printError(info: "Something Went Wrong! Please Try Again!");
    }
    update();
  }

  validate() {
    log("Velidating");
    emailError = emailValidator();
    firstNameError = firstNameValidator();
    lastNameError = lastNameValidator();
    phoneError = phoneValidator();
    passwordError = passwordValidator();
    cnfmPasswordError = cnfmpasswordValidator();
    birthDateError = birthDateValidator();
    update();
  }

  String? emailValidator() {
    if (emailController.text.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(emailController.text)) {
      return "Enter Correct Email Address";
    } else {
      return null;
    }
  }

  String? firstNameValidator() {
    if (firstNameController.text.isEmpty ||
        !RegExp(r'^[a-z A-Z]+$').hasMatch(firstNameController.text)) {
      return "Enter Correct First Name";
    } else {
      return null;
    }
  }

  String? lastNameValidator() {
    if (lastNameController.text.isEmpty ||
        !RegExp(r'^[a-z A-Z]+$').hasMatch(lastNameController.text)) {
      return "Enter Correct Last Name";
    } else {
      return null;
    }
  }

  String? phoneValidator() {
    if (phoneController.text.isEmpty ||
        !RegExp(r'^([+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]).{8,}$')
            .hasMatch(phoneController.text)) {
      return "Enter Correct Phone Number";
    } else {
      return null;
    }
  }

  String? passwordValidator() {
    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      return "Enter Correct Password";
    } else {
      return null;
    }
  }

  String? cnfmpasswordValidator() {
    if (confirmPasswordController.text.isEmpty ||
        passwordController.text.length < 6) {
      return "Enter Correct Password";
    } else {
      return null;
    }
  }

  String? birthDateValidator() {
    try {
      String datePattern = "yyyy-MM-dd";

      DateTime birthDate =
          DateFormat(datePattern).parse(birthDateController.text);
      DateTime today = DateTime.now();

      int yearDiff = today.year - birthDate.year;
      int monthDiff = today.month - birthDate.month;
      int dayDiff = today.day - birthDate.day;

      DateTime? dateTime = DateTime.tryParse(birthDateController.text);
      if (birthDateController.text.isEmpty ||
          !(birthDateController.text == dateTime.toString().substring(0, 10))) {
        return "Enter Correct BirthDate";
      } else if (birthDateController.text.isNotEmpty) {
        if (!(yearDiff > 18 ||
            yearDiff == 18 && monthDiff > 0 ||
            yearDiff == 18 && monthDiff == 0 && dayDiff >= 0)) {
          return "You are not old enough";
        }
      } else {
        return null;
      }
    } catch (e) {
      return "Enter Correct BirthDate";
    }
  }
}
