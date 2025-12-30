import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/extras/commonWidget.dart';
import 'package:gleekeyu/src/Auth/login_and_security/login_and_security_controller.dart';
import 'package:gleekeyu/utils/style/palette.dart';
import 'package:gleekeyu/widgets/text_fields_widgets/custom_textfield_common.dart';

import '../../../utils/baseconstant.dart';
import '../../../utils/style/constants.dart';
import '../../../widgets/loder.dart';
import '../../../widgets/showSnackBar.dart';

class LoginAndSecurityScreen extends StatefulWidget {
  const LoginAndSecurityScreen({super.key});

  @override
  State<LoginAndSecurityScreen> createState() => _LoginAndSecurityScreenState();
}

class _LoginAndSecurityScreenState extends State<LoginAndSecurityScreen> {
  LoginAndSecurityController controller = Get.put(LoginAndSecurityController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.isPasswordEdit.value = false;
      controller.update();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login & Security",
          style: Palette.appbarTitle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("assets/images/login.svg"),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Login",
                        style: Palette.headerText,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset("assets/images/password.svg"),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Password",
                        style: Palette.bestText,
                      ),
                      const Spacer(),
                      Obx(
                        () => CommonButton(
                            onPressed: () {
                              controller.togglePasswordButton();
                            },
                            name: controller.isPasswordEdit.value
                                ? "Close"
                                : 'Edit'),
                      )
                    ],
                  ),
                  const Divider(),
                  Obx(() {
                    if (!controller.isPasswordEdit.value) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        CustomTextfieldCommon(
                            label: 'Old password *',
                            hint: "Enter a old password",
                            controller: controller.oldPasswordController,
                            validate: (value) {}),
                        const SizedBox(
                          height: 12,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        CustomTextfieldCommon(
                            label: 'New password *',
                            hint: "Enter a New password",
                            obscureText: controller.isPasswordObscure,
                            controller: controller.passwordController,
                            validate: (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Password can't be empty";
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 12,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        CustomTextfieldCommon(
                            label: 'Confirm password *',
                            hint: "Re-Write Password",
                            obscureText: controller.isConfirmPasswordObscure,
                            controller: controller.confirmPasswordController,
                            validate: (String? value) {
                              if (value == null ||
                                  value.trim() !=
                                      controller.passwordController.text
                                          .trim()) {
                                return "Password and Confirm Password does not match";
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 12,
                        ),
                        CommonButton(
                            onPressed: () {
                              if (controller.passwordController.text.isEmpty ||
                                  controller
                                      .confirmPasswordController.text.isEmpty ||
                                  controller
                                      .oldPasswordController.text.isEmpty) {
                                showSnackBar(
                                    title: "Error",
                                    message: 'Please Fill Form First.');
                              } else if (controller.passwordController.text.characters.length < 6 ||
                                  controller.confirmPasswordController.text
                                          .characters.length <
                                      6 ||
                                  controller.oldPasswordController.text
                                          .characters.length <
                                      6) {
                                showSnackBar(
                                    title: "Error",
                                    message:
                                        'Password Must be Greater Then 6 Characters');
                              } else if (controller.passwordController.text ==
                                  controller.confirmPasswordController.text) {
                                loaderShow(context);
                                controller.changeSecurityPassApi(
                                  params: {
                                    "old_password":
                                        controller.oldPasswordController.text,
                                    "new_password":
                                        controller.passwordController.text,
                                    "password_confirmation": controller
                                        .confirmPasswordController.text,
                                  },
                                  success: () {
                                    loaderHide();
                                    Get.back();
                                    showSnackBar(
                                      title: "Success",
                                      color: kGreen,
                                      message: controller
                                          .changePassRes['message']
                                          .toString(),
                                    );
                                  },
                                  error: (e) {
                                    loaderHide();
                                    showSnackBar(
                                      title: "Error",
                                      message: e.toString(),
                                    );
                                  },
                                );
                              } else {
                                showSnackBar(
                                    title: "Error",
                                    message:
                                        'New password And Confirm Password Not Match.',
                                    color: kGreen);
                              }
                            },
                            name: "Update"),
                        const Divider(),
                      ],
                    );
                  }),
                 /* Row(
                    children: [
                      SvgPicture.asset('assets/images/world.svg'),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Social accounts",
                        style: Palette.bestText,
                      ),
                    ],
                  ),*/
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/images/email.svg'),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Email ",
                                  style: Palette.bestText,
                                ),
                                Text(
                                  "(Connected)",
                                  style: Palette.bestText3,
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                "You have confirmed your email: ${currUser!.data!.email}. A confirmed email is important to allow us to securely communicate with you.",
                                style: Palette.bestText3,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  /*const SizedBox(
                    height: 12,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/images/facebook.svg'),
                                const SizedBox(
                                  width: 0,
                                ),
                                Text(
                                  "Facebook ",
                                  style: Palette.bestText,
                                ),
                                Text(
                                  "(Not Connected)",
                                  style: Palette.bestText3,
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                "Sign in with Facebook and discover your trusted connections to hosts and guests all over the world.",
                                style: Palette.bestText3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CommonButton(onPressed: () {}, name: "Connect")
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/images/google.svg'),
                                const SizedBox(
                                  width: 0,
                                ),
                                Text(
                                  "Google ",
                                  style: Palette.bestText,
                                ),
                                Text(
                                  "(Not Connected)",
                                  style: Palette.bestText3,
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                "Connect your GLEEKEY account to your Google account for simplicity and ease.",
                                style: Palette.bestText3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CommonButton(onPressed: () {}, name: "Connect")
                    ],
                  ),*/
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kWhite,
                  boxShadow: [
                    BoxShadow(
                        color: kBlack.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/lock.png',
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Let's strengthen your account security.",
                    style: Palette.bestText,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "We are constantly looking for ways to make our community safer.",
                    style: Palette.bestText3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
