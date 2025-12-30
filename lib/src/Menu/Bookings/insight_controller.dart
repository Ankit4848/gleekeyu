import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../../extras/prefController.dart';
import '../../../utils/baseconstant.dart';
import '../../Auth/Login/userLogin_view.dart';

class InsightController extends GetxController {
  static InsightController get to => Get.put(InsightController());

  RxList reviewsToWrite = [].obs;
  RxList reviewsByYou = [].obs;
  RxList expiredReviews = [].obs;

  RxMap<String, dynamic> insightApiResponse = <String, dynamic>{}.obs;
  RxMap<String, dynamic> insightApiResponseEarnings = <String, dynamic>{}.obs;
  RxMap<String, dynamic> insightApiResponseReviewsAboutYou = <String, dynamic>{}.obs;
  RxMap<String, dynamic> insightApiResponseReviewsbyYou = <String, dynamic>{}.obs;



  Future<bool?> submitReview({
    required Map<String, dynamic> params,
    Map<String, dynamic>? query,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async
  {
    //try {
      print('Bearer111111111111111111111 ${currUser!=null?currUser?.accessToken:""}');
      print('Bearer111111111111111111111  ${BaseConstant.BASE_URL+ EndPoint.reviewsAdd}');
      print("Params : ${params}");
      dio.Response response = await dio.Dio().post(
        BaseConstant.BASE_URL+ EndPoint.reviewsAdd,
        data: isFormData ? dio.FormData.fromMap(params) : params,
        options: dio.Options(
          headers: {'Authorization': 'Bearer ${currUser!=null?currUser?.accessToken:""}'},
        ),
      );
      print("Params : ${params}, Query : $response");
      print("Params : ${params}, Query : ${response.data['id']}");
      print("Params : ${params}, Query : ${response.data['data']['id']}");
      print("Params : ${BaseConstant.BASE_URL+ EndPoint.reviewsAdd}, Query : ${response.data}");
      if (response.statusCode == 200) {


        if (response.data != null) {

            if (success != null) {
              success(response.data['data']['id']);
            }
          return true;
        } else {
          if (error != null) {
            error(response.data['message'].toString());
          }
          return false;
        }
      } else {
        if (error != null) {
          error(jsonDecode(response.data)['message'].toString());
        }
      }
  /*  } on dio.DioError catch (e) {
      if (error != null) {
        // error(e.response?.data['message'].toString() ?? "Something went wrong");
        if (e.response?.data['message'] == "Token has expired") {
          Get.offAll(const Login());
        }
      }
    }*/
    return null;
  }












  Future<bool?> insightApiReviewsByYou({
    required Map<String, dynamic> params,
    Map<String, dynamic>? query,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async
  {
    try {
      print('Bearer111111111111111111111 ${currUser!=null?currUser?.accessToken:""}');
      print("Params : ${params}, Query : $query");
      dio.Response response = await dio.Dio().post(
        BaseConstant.BASE_URL+ EndPoint.reviews,
        data: isFormData ? dio.FormData.fromMap(params) : params,
        queryParameters: query,
        options: dio.Options(
          headers: {'Authorization': 'Bearer ${currUser!=null?currUser?.accessToken:""}'},
        ),
      );
      print("Params : ${params}, Query : $response");
      print("Params : ${BaseConstant.BASE_URL+ EndPoint.reviews}, Query : $response");
      if (response.statusCode == 200) {
        insightApiResponseReviewsbyYou.value = response.data ?? {};

        if (response.data != null) {
          if (response.data['status'] == true) {
            if (success != null) {
              log('insightApiResponseReviewsbyYou API ${insightApiResponseReviewsbyYou['data']}');
              success();
            }
          } else {
            if (error != null) {
              error(response.data['message'].toString());
            }
          }
          return true;
        } else {
          if (error != null) {
            error(response.data['message'].toString());
          }
          return false;
        }
      } else {
        if (error != null) {
          error(jsonDecode(response.data)['message'].toString());
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        // error(e.response?.data['message'].toString() ?? "Something went wrong");
        if (e.response?.data['message'] == "Token has expired") {
          Get.offAll(const Login());
        }
      }
    }
    return null;
  }


  Future<bool?> insightApiReviewsAboutYou({
    required Map<String, dynamic> params,
    Map<String, dynamic>? query,
    Function? success,
    Function? error,
    bool isFormData = false,
  }) async
  {
    try {
      print('Bearer111111111111111111111 ${currUser!=null?currUser?.accessToken:""}');
      print("Params : ${params}, Query : $query");
      dio.Response response = await dio.Dio().post(
        BaseConstant.BASE_URL+ EndPoint.reviews,
        data: isFormData ? dio.FormData.fromMap(params) : params,
        queryParameters: query,
        options: dio.Options(
          headers: {'Authorization': 'Bearer ${currUser!=null?currUser?.accessToken:""}'},
        ),
      );
      print("Params : ${params}, Query : $response");
      print("Params : ${BaseConstant.BASE_URL+ EndPoint.reviews}, Query : $response");
      if (response.statusCode == 200) {
        insightApiResponseReviewsAboutYou.value = response.data ?? {};

        if (response.data != null) {
          if (response.data['status'] == true) {
            if (success != null) {
              log('insightApiResponse API ${insightApiResponseReviewsAboutYou['data']}');
              success();
            }
          } else {
            if (error != null) {
              error(response.data['message'].toString());
            }
          }
          return true;
        } else {
          if (error != null) {
            error(response.data['message'].toString());
          }
          return false;
        }
      } else {
        if (error != null) {
          error(jsonDecode(response.data)['message'].toString());
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        // error(e.response?.data['message'].toString() ?? "Something went wrong");
        if (e.response?.data['message'] == "Token has expired") {
          Get.offAll(const Login());
        }
      }
    }
    return null;
  }






}


