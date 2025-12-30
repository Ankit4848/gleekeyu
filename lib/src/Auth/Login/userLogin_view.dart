// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Auth/Ragistration/register.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_controller.dart';
import 'package:gleekeyu/src/Auth/Ragistration/userRegister_controller.dart';
import 'package:gleekeyu/src/Auth/forgot_password.dart';

import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/utils/style/palette.dart';
import 'package:gleekeyu/widgets/fade_slide_transition.dart';
import 'package:gleekeyu/widgets/loder.dart';
import 'package:gleekeyu/widgets/text_fields_widgets/custom_textfield_common.dart';
import 'package:gleekeyu/widgets/text_fields_widgets/custom_textfield_password.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../extras/text_styles.dart';
import '../../../widgets/exitPoopUp.dart';
import '../../HomePage/homePage_view.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  AnimationController? _animationController;
  Animation<double>? _formElementAnimation;

  var space;

  @override
  void initState() {
    super.initState();
    getControler.getDeviceIDUsingPlugin();
    _animationController = AnimationController(
      vsync: this,
      duration: kLoginAnimationDuration,
    );

    var fadeSlideTween = Tween<double>(begin: 0.0, end: 1.0);
    _formElementAnimation = fadeSlideTween.animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.45, 0.8, curve: Curves.easeInOut),
      ),
    );
    _animationController!.forward();
  }

  @override
  void dispose() {
    if (getControler.timer != null) {
      getControler.timer!.cancel();
    }
    super.dispose();
  }

  UserLoginController getControler = Get.find();

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    space = height > 650 ? kSpaceM : kSpaceS;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          final canPop = Get.key.currentState?.canPop() ?? false;
          if (canPop) {
            Get.back();
          } else {
            Get.offAll(() => const HomePage());
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Stack(
            children: [
              backGroudImage(),
              FadeSlideTransition(
                animation: _formElementAnimation!,
                additionalOffset: space,
                child: Obx(
                  () => Stack(
                    children: [
                      if (getControler.isOTPScreen.value) ...{
                        OTPView(),
                      } else ...{
                        mainView(),
                      },
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 30,
                top: 60,
                child: GestureDetector(
                  onTap: () {
                    final canPop = Get.key.currentState?.canPop() ?? false;
                    getControler.isOTPScreen.value = false;
                    getControler.emailController.text = "";
                    if (canPop) {
                      Get.back();
                    }
                    else {
                      Get.offAll(() => const HomePage());
                    }

                  },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
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
              bottomRight: Radius.circular(50),
            ),
            image: DecorationImage(
              image: AssetImage('assets/images/login_background_image.webp'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 1.6,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            color: kBlack.withOpacity(0.4),
          ),
        ),
      ],
    );
  }

  Widget mainView() {
    return Card(
      margin: EdgeInsets.only(
        right: 27,
        left: 27,
        top: MediaQuery.of(context).size.height / 4.0,
      ),
      shape: Palette.businessCardShape,
      elevation: 6,
      child: Container(
        //height: 465,
        padding: const EdgeInsets.all(20),
        child: GetBuilder<UserLoginController>(
          builder: ((a) {
            return Column(
              children: [
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: space,
                  child: Text('Welcome To', style: Palette.loginText),
                ),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: space,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 16,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/app_logo.png'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: space,
                  child: CustomTextfieldCommon(
                    controller: a.emailController,
                    label: 'email / phone number',
                    hint: 'enter your email / phone number',
                    textInputType: TextInputType.emailAddress,
                    validate: a.validate,
                    errorText: a.emailError,
                    btnValidate: a.isValidate,
                    onChange: (value) {
                      a.isPhoneValidate(value ?? '');
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: a.isEmail.value && !a.isPhone.value,
                  child: FadeSlideTransition(
                    animation: _formElementAnimation!,
                    additionalOffset: space,
                    child: CustomTextfieldPass(
                      controller: a.passwordController,
                      label: 'Password',
                      hint: 'Password',
                      validate: a.validate,
                      errorText: a.passwordError,
                      btnValidate: a.isValidate,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: space,
                  child: forgetPassword(),
                ),
                const SizedBox(height: 14),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: space,
                  child: loginBtn(),
                ),
                const SizedBox(height: 14),
                FadeSlideTransition(
                  animation: _formElementAnimation!,
                  additionalOffset: space,
                  child: registerBtn(),
                ),
                // const SizedBox(height: 20),
                // FadeSlideTransition(
                //   animation: _formElementAnimation!,
                //   additionalOffset: space,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       const Expanded(
                //         child: SizedBox(
                //           child: Divider(color: kDarkGrey, thickness: 0.7),
                //         ),
                //       ),
                //       const SizedBox(width: 7),
                //       Text('or login with', style: Palette.commonText1),
                //       const SizedBox(width: 7),
                //       const Expanded(
                //         child: SizedBox(
                //           child: Divider(color: kDarkGrey, thickness: 0.7),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 20),
                // FadeSlideTransition(
                //   animation: _formElementAnimation!,
                //   additionalOffset: space,
                //   child: socialMediaBtn(),
                // ),
              ],
            );
          }),
        ),
      ),
    );
  }

  OtpFieldController otpFieldController = OtpFieldController();

  Widget OTPView() {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.only(
            right: 27,
            left: 27,
            top: MediaQuery.of(context).size.height / 4.0,
          ),
          shape: Palette.businessCardShape,
          elevation: 6,
          child: Stack(
            children: [
              Container(
                //height: 465,
                padding: const EdgeInsets.all(0),
                child: GetBuilder<UserLoginController>(
                  builder: ((a) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeSlideTransition(
                            animation: _formElementAnimation!,
                            additionalOffset: space,
                            child: Text('OTP LOGIN', style: Palette.loginText),
                          ),
                          FadeSlideTransition(
                            animation: _formElementAnimation!,
                            additionalOffset: space,
                            child: Text(
                              getControler.isOTPSentAgain.value
                                  ? 'OTP Sent Again Successfully.!'
                                  : 'OTP Sent Successfully.! You can check your Mobile or Email',
                              style: Palette.loginText.copyWith(
                                color: kLightBlue,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeSlideTransition(
                            animation: _formElementAnimation!,
                            additionalOffset: space,
                            child: CustomTextfieldCommon(
                              controller: a.emailController,
                              label: 'Mobile Number',
                              hint: 'phone number',
                              textInputType: TextInputType.emailAddress,
                              validate: a.validate,
                              errorText: a.emailError,
                              btnValidate: a.isValidate,
                              onChange: (value) {
                                a.isPhoneValidate(value ?? '');
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeSlideTransition(
                            animation: _formElementAnimation!,
                            additionalOffset: space,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text('OTP', style: Palette.labelStyle),
                            ),
                          ),
                          const SizedBox(height: 10),
                          OTPTextField(
                            length: 4,
                            fieldWidth: 50,
                            controller: otpFieldController,
                            width: MediaQuery.of(context).size.width / 1.2,
                            style: const TextStyle(fontSize: 17),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.box,
                            onCompleted: (pin) {
                              getControler.otp.value = pin;
                              getControler.update();
                            },
                          ),
                          const SizedBox(height: 7),
                          Visibility(
                            visible: getControler.start.value != 0,
                            child: FadeSlideTransition(
                              animation: _formElementAnimation!,
                              additionalOffset: space,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "Resend OTP in ${getControler.start} seconds",
                                  style: Palette.labelStyle,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  loaderShow(context);
                                  getControler.otpVerify();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: kOrange),
                                    color: kOrange.withOpacity(0.1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Verify OTP",
                                      style: Palette.viewALLText,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Visibility(
                                visible: getControler.start.value == 0,
                                child: InkWell(
                                  onTap: () async {
                                    bool? isSuccess = await getControler.getApi(
                                      onError: (error) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return RegisterNowDialog(
                                              response: error,
                                              onResend: context,
                                              controller: getControler,
                                            );
                                          },
                                        );
                                      },
                                    );
                                    if (isSuccess ?? false) {
                                      getControler.isOTPSentAgain.value = true;
                                      getControler.update();
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: kOrange),
                                      color: kOrange.withOpacity(0.1),
                                    ),
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
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 4 - 10,
          right: 20,
          child: GestureDetector(
            onTap: () {
              getControler.isOTPScreen.value = false;
              getControler.start.value = 30;
              if (getControler.timer != null) {
                getControler.timer!.cancel();
              }
              getControler.update();
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: kRed,
              ),
              child: Center(
                child: SvgPicture.asset(
                  "assets/images/appbar_icons/close.svg",
                  semanticsLabel: 'A red up arrow',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget loginBtn() {
    return GetBuilder<UserLoginController>(
      initState: (a) {},
      builder: (a) {
        return MaterialButton(
          shape: Palette.subCardShape,
          color: kOrange,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: Center(child: Text('Login', style: Palette.btnText)),
          ),
          onPressed: () {
            a.isValidate = true;
            a.update();
            a.validate();

            if (a.emailError == null &&
                (!a.isEmail.value || a.passwordError == null)) {
              loaderShow(context);
              a.email = a.emailController.text;
              a.password = a.passwordController.text;
              a.getApi(
                onError: (error) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return RegisterNowDialog(
                        response: error,
                        onResend: context,
                        controller: a,
                      );
                    },
                  );
                },
              );
            } else {
              print("Error");
            }
          },
        );
      },
    );
  }

  Widget registerBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Register()),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Not A Member?', style: Palette.registerText1),
          const SizedBox(width: 3),
          Text('Register Here', style: Palette.registerText2),
        ],
      ),
    );
  }

  Widget forgetPassword() {
    return GestureDetector(
      onTap: () {
        Get.to(() => const ForgotPassword());
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Text(
          'Forgot password?',
          style: Palette.forgetPassText,
          textAlign: TextAlign.end,
        ),
      ),
    );
  }

  Widget socialMediaBtn() {
    UserLoginController getController = Get.find();
    UserResistorController a = Get.put(UserResistorController());
    Future<void> _handleSignIn() async {
      try {
        loaderShow(context);
        final GoogleSignInAccount? googleSignInAccount =
            await getController.googleSignIn.signIn();
        if (googleSignInAccount != null) {
          getControler.socialApi(
            params: {
              'device_token': getControler.deviceId.value,
              'fcm_token': getControler.fcmToken.value,
              "oauth_provider": "google",
              "oauth_uid": googleSignInAccount.id,
              "first_name": googleSignInAccount.displayName!.split(" ")[0],
              "last_name": googleSignInAccount.displayName!.split(" ").length >= 2 ? googleSignInAccount.displayName!.split(" ")[1] : '',
              "email": googleSignInAccount.email,
              "image": googleSignInAccount.photoUrl.toString(),
              'user_host': '0',
            },
          );
        }
      } catch (error) {
        print("Error : $error");
        loaderHide();
      } finally {
        loaderHide();
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Bounce(
          onPressed: (() {
            _handleSignIn();
          }),
          duration: const Duration(milliseconds: 100),
          child: Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/google_icon.png'),
              ),
            ),
          ),
        ),
        if (Platform.isIOS) const SizedBox(width: 30),
        if (Platform.isIOS)
          Bounce(
            duration: const Duration(milliseconds: 100),
            onPressed: () async {
              SignInWithAppleButton(
                onPressed: () async {
                  final credential = await SignInWithApple.getAppleIDCredential(
                    scopes: [
                      AppleIDAuthorizationScopes.email,
                      AppleIDAuthorizationScopes.fullName,
                    ],
                  );
                  print(credential);
                  // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                  // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                },
              );
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/apple_icon.png'),
                ),
              ),
            ),
          ),

        const SizedBox(width: 30),
        InkWell(
          onTap: () async {
            try {
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
            } catch (e) {
            } finally {
              loaderHide();
            }
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/facebook_icon.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterNowDialog extends StatelessWidget {
  RegisterNowDialog({
    super.key,
    required this.response,
    required this.onResend,
    required this.controller,
  });

  final Map<String, dynamic> response;
  final BuildContext onResend;
  UserLoginController controller;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          children: [
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                // height: 280,
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        response['message'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              Get.back();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: kOrange),
                                color: kOrange.withOpacity(0.2),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              child: Text(
                                "Close",
                                style: colorfffffffs13w600.copyWith(
                                  fontSize: 12,
                                  color: kOrange,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (!(response['message']
                            .toString()
                            .toLowerCase()
                            .contains('Invalid Password.!'.toLowerCase()))) ...{
                          const SizedBox(width: 20),
                          response['message'].toString().toLowerCase().contains("email is not verified",) ?
                          Center(child: GestureDetector(
                                  onTap: () {
                                    Get.back();
                                    loaderShow(context);
                                    controller.getApi(
                                      onError: (error) {
                                        print(error);
                                        Get.dialog(
                                          RegisterNowDialog(
                                            response: error,
                                            onResend: Get.context!,
                                            controller: controller,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: kOrange),
                                      color: kOrange.withOpacity(0.2),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      "Resend",
                                      style: colorfffffffs13w600.copyWith(
                                        fontSize: 12,
                                        color: kOrange,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),)
                              : Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    Get.back();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Register(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: kOrange),
                                      color: kOrange.withOpacity(0.2),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      "Register",
                                      style: colorfffffffs13w600.copyWith(
                                        fontSize: 12,
                                        color: kOrange,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        },
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
