import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:gleekeyu/utils/baseconstant.dart';

class LoginAndSecurityController extends GetxController {
  RxBool isPasswordEdit = false.obs;
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isPasswordObscure = false;
  bool isConfirmPasswordObscure = false;
  void togglePasswordButton() {
    isPasswordEdit.value = !isPasswordEdit.value;
    update();
  }

  RxMap<String, dynamic> changePassRes = <String, dynamic>{}.obs;

  Future<bool?> changeSecurityPassApi({
    required Map<String, dynamic> params,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async {
    try {
      dio.Response response = await dio.Dio().post(
          BaseConstant.BASE_URL + EndPoint.userChangePassword,
          data: isFormData ? dio.FormData.fromMap(params) : params,
          options: dio.Options(
              headers: {'Authorization': 'Bearer ${currUser!=null?currUser?.accessToken:""}'}));
      changePassRes.value = response.data ?? {};
      if (response.statusCode == 200) {
        if (response.data != null) {
          if (response.data['status'] == true) {
            if (success != null) {
              success();
            }
          } else {
            if (error != null) {
              error(response.data['message']);
            }
          }
          return true;
        } else {
          if (error != null) {
            error(response.data['message']);
          }
          return false;
        }
      } else {
        if (error != null) {
          error(jsonDecode(response.data)['message']);
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        error(e.response?.statusMessage ?? "Something went wrong");
      }
    }
    return null;
  }
}
