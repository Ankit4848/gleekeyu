// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_view.dart';
import 'package:gleekeyu/src/Auth/Ragistration/userRegister_controller.dart';
import 'package:gleekeyu/widgets/loder.dart';

import 'package:gleekeyu/widgets/text_fields_widgets/custom_textfield_common.dart';
import 'package:gleekeyu/widgets/text_fields_widgets/custom_textfield_password.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import '../../../utils/style/constants.dart';
import '../../../utils/style/palette.dart';
import 'package:intl/intl.dart';
import '../../../widgets/fade_slide_transition.dart';
import '../Login/userLogin_controller.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _formElementAnimation;
  RxString deviceId = ''.obs;
  RxString fcmToken = ''.obs;
  Future<void> getDeviceIDUsingPlugin() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    deviceId.value = (androidInfo.id) ?? '';
   // deviceId.value = (await PlatformDeviceId.getDeviceId) ?? '';
    print('DEVICE ID ${deviceId.value}');
    fcmToken.value = (await FirebaseMessaging.instance.getToken()) ?? '';
    log(fcmToken.value, name: 'fcmToken');
  }

  bool obsecure1 = true;
  bool obsecure2 = true;
  final UserResistorController a = Get.put(UserResistorController());
  var space;

  @override
  void initState() {
    super.initState();
    getDeviceIDUsingPlugin();
    a.firstNameController = TextEditingController();
    a.lastNameController = TextEditingController();
    a.emailController = TextEditingController();
    a.phoneController = TextEditingController();
    a.passwordController = TextEditingController();
    a.confirmPasswordController = TextEditingController();
    a.birthDateController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: kLoginAnimationDuration,
    );
    var fadeSlideTween = Tween<double>(begin: 0.0, end: 1.0);
    _formElementAnimation = fadeSlideTween.animate(CurvedAnimation(
      parent: _animationController!,
      curve: const Interval(
        0.45,
        0.8,
        curve: Curves.easeInOut,
      ),
    ));
    _animationController!.forward();
  }

  @override
  void dispose() {
    if (a.timer != null) {
      a.timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    space = height > 650 ? kSpaceM : kSpaceS;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            backGroudImage(),

            Obx(
              () => FadeSlideTransition(
                animation: _formElementAnimation!,
                additionalOffset: space,
                child: a.isOTPScreen.value ? OTPView() : mainView(),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget backGroudImage() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 1.6,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
              image: DecorationImage(
                  image: AssetImage('assets/images/login_background_image.webp'),
                  fit: BoxFit.fill)),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 1.6,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50)),
            color: kBlack.withOpacity(0.4),
          ),
        )
      ],
    );
  }

  Widget mainView() {
    return Card(
        margin: EdgeInsets.only(
            right: 27, left: 27, top: MediaQuery.of(context).size.height / 15),
        shape: Palette.businessCardShape,
        elevation: 6,
        child: Container(
            // height: 380,
            padding: const EdgeInsets.all(20),
            child: GetBuilder<UserResistorController>(
              initState: (a) {},
              builder: (a) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_ios_new,color: Colors.black,size: 25,),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    FadeSlideTransition(
                      animation: _formElementAnimation!,
                      additionalOffset: space,
                      child: Text(
                        'Welcome To',
                        style: Palette.loginText,
                      ),
                    ),
                    FadeSlideTransition(
                      animation: _formElementAnimation!,
                      additionalOffset: space,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 16,
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/app_logo.png'))),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeSlideTransition(
                      animation: _formElementAnimation!,
                      additionalOffset: space,
                      child: CustomTextfieldCommon(
                        controller: a.firstNameController,
                        label: 'First Name',
                        hint: 'Enter your name',
                        errorText: a.firstNameError,
                        validate: a.validate,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeSlideTransition(
                      animation: _formElementAnimation!,
                      additionalOffset: space,
                      child: CustomTextfieldCommon(
                        controller: a.lastNameController,
                        label: 'Last Name',
                        hint: 'Enter your name',
                        validate: a.validate,
                        errorText: a.lastNameError,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeSlideTransition(
                      animation: _formElementAnimation!,
                      additionalOffset: space,
                      child: CustomTextfieldCommon(
                        controller: a.emailController,
                        label: 'Email',
                        validate: a.validate,
                        hint: 'Enter your Email',
                        errorText: a.emailError,
                        textInputType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeSlideTransition(
                      animation: _formElementAnimation!,
                      additionalOffset: space,
                      child: CustomTextfieldCommon(
                        controller: a.phoneController,
                        label: 'Phone Number',
                        validate: a.validate,
                        textInputFormatter: [
                          LengthLimitingTextInputFormatter(10)
                        ],
                        hint: 'Enter your Phone Number',
                        textInputType: TextInputType.phone,
                        errorText: a.phoneError,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeSlideTransition(
                      animation: _formElementAnimation!,
                      additionalOffset: space,
                      child: CustomTextfieldPass(
                        controller: a.passwordController,
                        label: 'Password',
                        hint: 'Password',
                        errorText: a.passwordError,
                        validate: a.validate,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeSlideTransition(
                      animation: _formElementAnimation!,
                      additionalOffset: space,
                      child: CustomTextfieldPass(
                        controller: a.confirmPasswordController,
                        label: 'Confirm Password',
                        hint: 'Confirm Password',
                        errorText: a.cnfmPasswordError,
                        validate: a.validate,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GetBuilder<UserResistorController>(
                      initState: (a) {},
                      builder: (a) {
                        return FadeSlideTransition(
                            animation: _formElementAnimation!,
                            additionalOffset: space,
                            child: CustomTextfieldCommon(
                              onTap: () async {
                                a.birthDate = await showDatePickerDialog(
                                  context: context,
                                  initialDate: DateTime(2000, 1, 1),
                                  minDate: DateTime(1950, 1, 1),
                                  maxDate: DateTime(2024, 10, 30),
                                  width: 350,
                                  height: 400,
                                  currentDate: DateTime(2000, 1, 1),
                                  selectedDate: DateTime(2000, 1, 1),
                                  currentDateDecoration: const BoxDecoration(),
                                  currentDateTextStyle: const TextStyle(),
                                  daysOfTheWeekTextStyle: const TextStyle(),
                                  disabledCellsTextStyle: const TextStyle(),
                                  enabledCellsDecoration: const BoxDecoration(),
                                  enabledCellsTextStyle: const TextStyle(),
                                  initialPickerType: PickerType.days,
                                  selectedCellDecoration: const BoxDecoration(),
                                  selectedCellTextStyle: const TextStyle(),
                                  leadingDateTextStyle: const TextStyle(),
                                  slidersColor: Colors.lightBlue,
                                  highlightColor: Colors.redAccent,
                                  slidersSize: 20,
                                  splashColor: Colors.lightBlueAccent,
                                  splashRadius: 40,
                                  centerLeadingDate: true,
                                );
                                if (a.birthDate != null) {
                                  print(a.birthDate);
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(a.birthDate!);
                                  print(formattedDate);
                                  a.birthDateController.text = formattedDate;
                                  a.update();
                                }
                              },
                              btnValidate: true,
                              readOnly: true,
                              label: 'Birth Date',
                              validate: a.validate,
                              hint: 'Enter your Birthdate',
                              textInputType: TextInputType.phone,
                              errorText: a.birthDateError,
                              controller: a.birthDateController,
                            ));
                      },
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    FadeSlideTransition(
                      animation: _formElementAnimation!,
                      additionalOffset: space,
                      child: registerBtn(),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    FadeSlideTransition(
                      animation: _formElementAnimation!,
                      additionalOffset: space,
                      child: loginBtn(),
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // FadeSlideTransition(
                    //   animation: _formElementAnimation!,
                    //   additionalOffset: space,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       const Expanded(
                    //         child: SizedBox(
                    //           child: Divider(
                    //             color: kDarkGrey,
                    //             thickness: 0.7,
                    //           ),
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         width: 7,
                    //       ),
                    //       Text(
                    //         'or register with',
                    //         style: Palette.commonText1,
                    //       ),
                    //       const SizedBox(
                    //         width: 7,
                    //       ),
                    //       const Expanded(
                    //         child: SizedBox(
                    //           child: Divider(
                    //             color: kDarkGrey,
                    //             thickness: 0.7,
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // FadeSlideTransition(
                    //     animation: _formElementAnimation!,
                    //     additionalOffset: space,
                    //     child: socialMediaBtn()),
                  ],
                );
              },
            )));
  }

  UserLoginController getControler = Get.find();
  Widget registerBtn() {
    return GetBuilder<UserResistorController>(
      initState: (a) {},
      builder: (a) {
        return MaterialButton(
            shape: Palette.subCardShape,
            color: kOrange,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 45,
              child: Center(
                child: Text(
                  'Sign Up',
                  style: Palette.btnText,
                ),
              ),
            ),
            onPressed: () async {
              a.isValidate = true;
              a.validate();
              if (a.emailError == null &&
                  a.firstNameError == null &&
                  a.lastNameError == null &&
                  a.phoneError == null &&
                  a.passwordError == null &&
                  a.cnfmPasswordError == null &&
                  a.birthDateError == null) {
               // loaderShow(context);
                await a.getApi(isOTP: false);
              }
            });
      },
    );
  }

  Widget loginBtn() {
    return GestureDetector(
      onTap: () {
        Get.to(() => const Login());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account?',
            style: Palette.registerText1,
          ),
          const SizedBox(
            width: 3,
          ),
          Text(
            'Login',
            style: Palette.registerText2,
          )
        ],
      ),
    );
  }

  Widget socialMediaBtn() {
    Future<void> handleSignIn() async {
      try {
        loaderShow(context);
        await UserLoginController.to.googleSignIn.signOut();
        final GoogleSignInAccount? googleSignInAccount =
            await UserLoginController.to.googleSignIn.signIn();

        if (googleSignInAccount != null) {
          UserLoginController.to.socialApi(
            params: {
              'device_token': deviceId.value,
              'fcm_token': fcmToken.value,
              "oauth_provider": "google",
              "oauth_uid": googleSignInAccount.id,
              "first_name": googleSignInAccount.displayName!.split(" ")[0],
              "last_name": googleSignInAccount.displayName!.split(" ")[1],
              "email": googleSignInAccount.email,
              "image": googleSignInAccount.photoUrl.toString(),
              'user_host': '0',
            },
          );
          loaderHide();
        }
      } catch (error) {
        print("Error : $error");
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Bounce(
          duration: const Duration(milliseconds: 300),
          onPressed: () {
            handleSignIn();
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/google_icon.png'))),
          ),
        ),
        /*const SizedBox(
          width: 60,
        ),*/
       /* Bounce(
          duration: const Duration(microseconds: 100),
          onPressed: () async {
            final LoginResult result = await FacebookAuth.instance.login();

            if (result.status == LoginStatus.success) {
              final userData = await FacebookAuth.instance.getUserData();
              loaderShow(context);
              getControler.socialApi(
                params: {
                  'device_token': getControler.deviceId.value,
                  'fcm_token': getControler.fcmToken.value,
                  "oauth_provider": "facebook",
                  "oauth_uid": userData['id'],
                  "first_name": userData['name'].split(" ")[0],
                  "last_name": userData['name'].split(" ")[1],
                  "email": userData['email'],
                  "image": userData['picture']['data']['url'],
                  'user_host': '0',
                },
              );
              log(userData.toString());
            } else {
              print("result.status ${result.status}");
              print("result.message ${result.message}");
            }
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/facebook_icon.png'))),
          ),
        ),*/
        // const SizedBox(
        //   width: 30,
        // ),
        // Container(
        //   height: 30,
        //   width: 30,
        //   decoration: const BoxDecoration(
        //       image: DecorationImage(
        //           image: AssetImage('assets/images/phone_icon.png'))),
        // ),
      ],
    );
  }

  Widget OTPView() {
    return Stack(
      children: [
        Card(
            margin: EdgeInsets.only(
                right: 27,
                left: 27,
                top: MediaQuery.of(context).size.height / 4.0),
            shape: Palette.businessCardShape,
            elevation: 6,
            child: Stack(
              children: [
                Container(
                    //height: 465,
                    padding: const EdgeInsets.all(0),
                    child: GetBuilder<UserResistorController>(builder: ((a) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeSlideTransition(
                              animation: _formElementAnimation!,
                              additionalOffset: space,
                              child: Text(
                                'OTP LOGIN',
                                style: Palette.loginText,
                              ),
                            ),
                            // FadeSlideTransition(
                            //   animation: _formElementAnimation!,
                            //   additionalOffset: space,
                            //   child: Container(
                            //     height: MediaQuery.of(context).size.height / 16,
                            //     width: MediaQuery.of(context).size.width / 3,
                            //     decoration: const BoxDecoration(
                            //         image: DecorationImage(
                            //             image: AssetImage('assets/images/app_logo.png'))),
                            //   ),
                            // ),
                            FadeSlideTransition(
                              animation: _formElementAnimation!,
                              additionalOffset: space,
                              child: Text(
                                a.isOTPSentAgain.value
                                    ? 'OTP Sent Again Successfully.!'
                                    : 'OTP Sent Successfully.! You can check your Mobile or Email',
                                style: Palette.loginText
                                    .copyWith(color: kLightBlue, fontSize: 14),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FadeSlideTransition(
                              animation: _formElementAnimation!,
                              additionalOffset: space,
                              child: CustomTextfieldCommon(
                                controller: a.phoneController,
                                label: 'Mobile Number',
                                hint: 'phone number',
                                textInputType: TextInputType.emailAddress,
                                validate: a.validate,
                                errorText: a.emailError,
                                btnValidate: a.isValidate,
                                readOnly: true,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FadeSlideTransition(
                              animation: _formElementAnimation!,
                              additionalOffset: space,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'OTP',
                                  style: Palette.labelStyle,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            OTPTextField(
                              length: 4,
                              fieldWidth: 50,
                              controller: a.otpFieldController,
                              width: MediaQuery.of(context).size.width / 1.2,
                              style: const TextStyle(fontSize: 17),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.box,
                              onCompleted: (pin) {
                                a.otp.value = pin;
                                a.update();
                              },
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Visibility(
                              visible: a.start.value != 0,
                              child: FadeSlideTransition(
                                animation: _formElementAnimation!,
                                additionalOffset: space,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "Resend OTP in ${a.start} seconds",
                                    style: Palette.labelStyle,
                                  ),
                                ),
                              ),
                            ),
                            // FadeSlideTransition(
                            //   animation: _formElementAnimation!,
                            //   additionalOffset: space,
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(left: 10.0),
                            //     child: Text(
                            //       'Resend OTP in ',
                            //       style: Palette.labelStyle,
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    loaderShow(context);
                                    await a.getApi(isOTP: true);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: kOrange,
                                        ),
                                        color: kOrange.withOpacity(0.1)),
                                    child: Center(
                                      child: Text(
                                        "Verify OTP",
                                        style: Palette.viewALLText,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Visibility(
                                  visible: a.start.value == 0,
                                  child: InkWell(
                                    onTap: () async {
                                      bool? isSuccess =
                                          await a.getApi(isOTP: false);
                                      if (isSuccess ?? false) {
                                        a.isOTPSentAgain.value = true;
                                        a.update();
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: kOrange,
                                          ),
                                          color: kOrange.withOpacity(0.1)),
                                      child: Center(
                                        child: Text(
                                          "Resend OTP",
                                          style: Palette.viewALLText,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }))),
              ],
            )),
        Positioned(
          top: MediaQuery.of(context).size.height / 4 - 10,
          right: 20,
          child: GestureDetector(
            onTap: () {
              a.isOTPScreen.value = false;
              a.start.value = 30;
              if (a.timer != null) {
                a.timer!.cancel();
              }
              a.update();
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: kRed,
              ),
              child: Center(
                child: SvgPicture.asset("assets/images/appbar_icons/close.svg",
                    semanticsLabel: 'A red up arrow'),
              ),
            ),
          ),
        )
      ],
    );
  }
}
