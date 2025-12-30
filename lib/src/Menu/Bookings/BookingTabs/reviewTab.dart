import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Menu/Bookings/BookingTabs/review_screen_past.dart';
import 'package:gleekeyu/src/Menu/Bookings/bookings_controller.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/src/Menu/Bookings/Booking%20Card/bookingCancelledCard.dart';
import 'package:gleekeyu/widgets/Shimmer/property_shimmer.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:intl/intl.dart';
import '../../../../extras/app_colors.dart';
import '../../../../extras/commonWidget.dart';
import '../../../../extras/text_styles.dart';
import '../../../../utils/style/palette.dart';
import '../../../../widgets/loder.dart';
import '../Booking Card/inquiryStatusBookingsCard.dart';
import '../insight_controller.dart';

class ReviewTab extends StatefulWidget {
   ReviewTab({super.key});

  @override
  State<ReviewTab> createState() => _ReviewTabState();
}

class _ReviewTabState extends State<ReviewTab> {
   List reviewsbyYouTab = ['Reviews About You','Write Review', 'Past Review'];

   RxBool isShimmer = true.obs;

   RxInt selectedTab = 1.obs;

   RxInt selectedReviewTab = 1.obs;

   @override
  void initState() {
    // TODO: implement initState
     callapi();
    super.initState();
  }
   Future<void> callapi() async {

     await InsightController.to.insightApiReviewsAboutYou(
       params: {'offset': 0, 'limit': 10},
       query: {'type': 'reviewsAboutYou'},
       success: () {
         loaderHide();
         setState(() {
           selectedReviewTab.value = 0;
         });
         isShimmer.value = false;
       },
       error: (e) {
         loaderHide();
         isShimmer.value = false;
       },
     );
     await InsightController.to.insightApiReviewsByYou(
       params: {'offset': 0, 'limit': 10},
       query: {'type': 'reviewsByYou'},
       success: () {
         InsightController.to.reviewsToWrite.value =
             InsightController
                 .to
                 .insightApiResponseReviewsbyYou['data']['reviewsToWrite'] ??
                 [];
         InsightController.to.reviewsByYou.value =
             InsightController
                 .to
                 .insightApiResponseReviewsbyYou['data']['reviewsByYou'] ??
                 [];
         InsightController.to.expiredReviews.value =
             InsightController
                 .to
                 .insightApiResponseReviewsbyYou['data']['expiredReviews'] ??
                 [];


         print(InsightController.to.reviewsToWrite.value.length);
         print(InsightController.to.reviewsToWrite.value.length);
         print(InsightController.to.reviewsToWrite.value.length);
         print(InsightController.to.reviewsToWrite.value.length);
         print(InsightController.to.reviewsToWrite.value.length);
         print(((selectedReviewTab.value == 0 ? InsightController.to.reviewsToWrite.length :
         selectedReviewTab.value == 1 ? InsightController.to.reviewsByYou.length :
         0) == 0));

         setState(() {
           selectedReviewTab.value = 1;
         });
         loaderHide();
         isShimmer.value = false;
       },
       error: (e) {
         loaderHide();
         isShimmer.value = false;
       },
     );
   }


   Widget reviewsAboutYouView() {
     return SingleChildScrollView(
       child:
       isShimmer.value
           ? Column(
         children: List.generate(
           5,
               (index) => Padding(
             padding: const EdgeInsets.symmetric(
               horizontal: 5,
               vertical: 8,
             ),
             child: Container(
               width: double.maxFinite,
               decoration: BoxDecoration(
                 color: AppColors.colorffffff,
                 borderRadius: BorderRadius.circular(10),
                 boxShadow: const [
                   BoxShadow(
                     blurRadius: 5,
                     spreadRadius: 5,
                     color: Color.fromRGBO(0, 0, 0, 0.05),
                   ),
                 ],
               ),
               padding: const EdgeInsets.symmetric(
                 vertical: 15,
                 horizontal: 12,
               ),
               child: Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Expanded(
                     flex: 2,
                     child: Column(
                       children: [

                       ],
                     ),
                   ),
                   const SizedBox(width: 10),
                   Expanded(
                     flex: 5,
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           children: [
                             Expanded(
                               child: Row(
                                 children: [
                                   CircleAvatar(
                                     maxRadius: 20,
                                     backgroundColor:
                                     AppColors.colorE6E6E6,
                                     backgroundImage: const AssetImage(
                                       'assets/images/profile.png',
                                     ),
                                   ),
                                   const SizedBox(width: 10),
                                   Flexible(
                                     child: Text(
                                       'Lorem Ipsum',
                                       style: color000000s12w400,
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                             Text(
                               '2 years ago',
                               style: color000000s12w400,
                             ),
                           ],
                         ),
                         const SizedBox(height: 4),
                         Text(
                           'Lorem Ipsum is simply dummy text of the printing and typesetting Lorem Ipsum has been the industry\'s standard dummy text ever since the ',
                           style: color50perBlacks13w400,
                         ),
                         const SizedBox(height: 5),
                         InkWell(
                           onTap: () {

                           },
                           highlightColor: Colors.transparent,
                           splashColor: Colors.transparent,
                           child: Text(
                             'View Details',
                             style: colorFE6927s12w600,
                           ),
                         ),
                       ],
                     ),
                   ),
                 ],
               ),
             ),
           ),
         ),
       )
           : InsightController
           .to
           .insightApiResponseReviewsAboutYou['data'] ==
           null ||
           InsightController
               .to
               .insightApiResponseReviewsAboutYou['data']['reviewsAboutYou'] ==
               null ||
           InsightController
               .to
               .insightApiResponseReviewsAboutYou['status'] ==
               false
           ? Padding(
         padding: const EdgeInsets.all(20),
         child: Container(
           width: double.maxFinite,
           decoration: BoxDecoration(
             color: AppColors.colorD9D9D9,
             borderRadius: BorderRadius.circular(15),
           ),
           padding: const EdgeInsets.symmetric(
             vertical: 40,
             horizontal: 50,
           ),
           child: Column(
             children: [
               Text(
                 InsightController
                     .to
                     .insightApiResponseReviewsAboutYou['message']
                     .toString(),
                 style: color00000s14w500,
                 textAlign: TextAlign.center,
               ),
             ],
           ),
         ),
       )
           : Column(
         children: List.generate(
           InsightController
               .to
               .insightApiResponseReviewsAboutYou['data']['reviewsAboutYou']
               .length,
               (index) => Padding(
             padding: const EdgeInsets.symmetric(
               horizontal: 15,
               vertical: 8,
             ),
             child: Container(
               width: double.maxFinite,
               decoration: BoxDecoration(
                 color: AppColors.colorffffff,
                 borderRadius: BorderRadius.circular(10),
                 boxShadow: const [
                   BoxShadow(
                     blurRadius: 5,
                     spreadRadius: 5,
                     color: Color.fromRGBO(0, 0, 0, 0.05),
                   ),
                 ],
               ),
               padding: const EdgeInsets.symmetric(
                 vertical: 15,
                 horizontal: 12,
               ),
               child: Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Expanded(
                     flex: 2,
                     child: Column(
                       children: [
                         ClipRRect(
                           borderRadius: BorderRadius.circular(10),
                           child: CachedNetworkImage(
                             imageUrl:
                             InsightController
                                 .to
                                 .insightApiResponseReviewsAboutYou['data']['reviewsAboutYou'][index]?['cover_photo_photos'] ??
                                 '',
                             placeholder:
                                 (context, url) =>
                                 CupertinoActivityIndicator(
                                   color: AppColors.colorFE6927,
                                 ),
                             errorWidget:
                                 (context, url, error) =>
                             const Icon(Icons.error),
                             fit: BoxFit.cover,
                             height: 100,
                             width: 100,
                             memCacheHeight: 110,
                             memCacheWidth: 110,

                           ),
                         ),
                         const SizedBox(height: 10),
                         Text(
                           InsightController
                               .to
                               .insightApiResponseReviewsAboutYou['data']['reviewsAboutYou'][index]?['property_name'] ??
                               '',
                           style: color00000s13w600,
                         ),
                       ],
                     ),
                   ),
                   const SizedBox(width: 10),
                   Expanded(
                     flex: 5,
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           children: [
                             Expanded(
                               child: Row(
                                 children: [
                                   ClipRRect(
                                     borderRadius:
                                     BorderRadius.circular(100),
                                     child: CachedNetworkImage(
                                       imageUrl:
                                       InsightController
                                           .to
                                           .insightApiResponseReviewsAboutYou['data']['reviewsAboutYou'][index]?['user_profile_image'] ??
                                           '',
                                       placeholder:
                                           (context, url) =>
                                           CupertinoActivityIndicator(
                                             color:
                                             AppColors
                                                 .colorFE6927,
                                           ),
                                       errorWidget:
                                           (context, url, error) =>
                                       const Icon(Icons.error),
                                       fit: BoxFit.cover,
                                       height: 40,
                                       width: 40,
                                     ),
                                   ),
                                   const SizedBox(width: 10),



                                   Flexible(
                                     child: Text(
                                       InsightController
                                           .to
                                           .insightApiResponseReviewsAboutYou['data']['reviewsAboutYou'][index]?['sender_name'] ??
                                           '',
                                       style: color000000s12w400,
                                     ),
                                   ),
                                 ],
                               ),
                             ),

                           ],
                         ),






                         const SizedBox(height: 5),

                         Text('Overall Experience',
                             style: TextStyle(
                               fontSize: 14,
                               color: Colors.black
                             )),
                         RatingBar.builder(
                           initialRating: double.parse(
                               (InsightController
                                   .to
                                   .insightApiResponseReviewsAboutYou['data']['reviewsAboutYou'][index]?['rating'] ?? '0').toString()),
                           minRating: 1,
                           ignoreGestures: true,
                           direction: Axis.horizontal,
                           allowHalfRating: true,
                           itemCount: 5,
                           itemSize: 20,
                           unratedColor: AppColors.colorD9D9D9,
                           itemPadding: const EdgeInsets.symmetric(
                             horizontal: 4.0,
                           ),
                           itemBuilder: (context, _) => Icon(
                             Icons.star,
                             color: AppColors.colorFE6927,
                           ),
                           onRatingUpdate: (rating) {
                             print(rating);
                           },
                         ),


                         const SizedBox(height: 5),
                         if(InsightController
                             .to
                             .insightApiResponseReviewsAboutYou['data']['reviewsAboutYou'][index]?['message']!=null)
                         Text(
                           InsightController
                               .to
                               .insightApiResponseReviewsAboutYou['data']['reviewsAboutYou'][index]?['message'] ??
                               '',
                           style: color50perBlacks13w400,
                         ),
                         const SizedBox(height: 5),
                         Text(
                           InsightController
                               .to
                               .insightApiResponseReviewsAboutYou['data']['reviewsAboutYou'][index]?['post_date'] ??
                               '',
                           style: color000000s12w400,
                         ),
                         const SizedBox(height: 5),
                         InkWell(
                           onTap: () {


                             showDialog(
                               context: context,
                               barrierDismissible: false,
                               builder: (
                                   context,) {
                                 return  showDialogForShowingABoutReviewReview(InsightController
                                     .to
                                     .insightApiResponseReviewsAboutYou['data']?['reviewsAboutYou'][index] ??
                                     {});
                               },
                             );

                           },
                           highlightColor: Colors.transparent,
                           splashColor: Colors.transparent,
                           child: Text(
                             'View Details',
                             style: colorFE6927s12w600,
                           ),
                         )
                    /*     Row(
                           mainAxisAlignment:
                           MainAxisAlignment.spaceBetween,
                           children: [
                             InkWell(
                               onTap: () {
                                 log(
                                   (InsightController
                                       .to
                                       .insightApiResponseReviewsAboutYou['data']?['reviewsAboutYou'][index] ??
                                       {})
                                       .toString(),
                                 );
                                 Get.to(
                                       () => ReviewScreen(
                                     data:
                                     InsightController
                                         .to
                                         .insightApiResponseReviewsAboutYou['data']?['reviewsAboutYou'][index] ??
                                         {},
                                   ),
                                 );
                               },
                               highlightColor: Colors.transparent,
                               splashColor: Colors.transparent,
                               child: Text(
                                 'View Details',
                                 style: colorFE6927s12w600,
                               ),
                             ),
                             CommonButton(
                               padding: const EdgeInsets.symmetric(
                                 vertical: 5,
                                 horizontal: 5,
                               ),
                               onPressed: () {
                                 showDialog(
                                   context: context,
                                   barrierDismissible: false,
                                   //context: _scaffoldKey.currentContext,
                                   builder: (context) {
                                     return AlertDialog(
                                       contentPadding:
                                       const EdgeInsets.symmetric(
                                         horizontal: 12,
                                         vertical: 12,
                                       ),
                                       scrollable: true,
                                       title: Row(
                                         mainAxisAlignment:
                                         MainAxisAlignment
                                             .spaceBetween,
                                         children: [
                                           Text(
                                             'Reply To ${InsightController.to.insightApiResponseReviewsAboutYou['data']['reviewsAboutYou'][index]?['user_name'] ?? ''}',
                                             style: color00000s18w600,
                                           ),
                                           InkWell(
                                             onTap: () {
                                               Get.back();
                                             },
                                             child: const Icon(
                                               Icons.close,
                                             ),
                                           ),
                                         ],
                                       ),
                                       shape:
                                       const RoundedRectangleBorder(
                                         borderRadius:
                                         BorderRadius.all(
                                           Radius.circular(
                                             20.0,
                                           ),
                                         ),
                                       ),
                                       content: SizedBox(
                                         width: Get.width,
                                         child: Column(
                                           children: [
                                             Padding(
                                               padding:
                                               const EdgeInsets.all(
                                                 8.0,
                                               ),
                                               child: Column(
                                                 crossAxisAlignment:
                                                 CrossAxisAlignment
                                                     .start,
                                                 children: [
                                                   Text(
                                                     'Your Message',
                                                     style:
                                                     color00000s15w600,
                                                   ),
                                                   TextFormField(
                                                     controller: _hostSendMessage,
                                                     cursorColor:
                                                     AppColors
                                                         .colorFE6927,
                                                     maxLines: 3,
                                                     decoration: InputDecoration(
                                                       hintText:
                                                       'Type Here...',
                                                       floatingLabelBehavior:
                                                       FloatingLabelBehavior
                                                           .always,
                                                       border: OutlineInputBorder(
                                                         borderRadius:
                                                         BorderRadius.circular(
                                                           6.0,
                                                         ),
                                                         borderSide: BorderSide(
                                                           width: 1,
                                                           color: AppColors
                                                               .color000000
                                                               .withOpacity(
                                                             0.5,
                                                           ),
                                                         ),
                                                       ),
                                                       focusedBorder: OutlineInputBorder(
                                                         borderRadius:
                                                         BorderRadius.circular(
                                                           6.0,
                                                         ),
                                                         borderSide: BorderSide(
                                                           width: 1,
                                                           color: AppColors
                                                               .color000000
                                                               .withOpacity(
                                                             0.5,
                                                           ),
                                                         ),
                                                       ),
                                                       contentPadding:
                                                       const EdgeInsets.all(
                                                         13.0,
                                                       ),
                                                     ),
                                                   ),
                                                   Divider(
                                                     endIndent: 10,
                                                     indent: 10,
                                                     color: AppColors
                                                         .color000000
                                                         .withOpacity(
                                                       0.1,
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                             ),
                                             CommonButton(
                                               onPressed: () {
                                                 if (_hostSendMessage
                                                     .text
                                                     .isEmpty) {
                                                   showSnackBar(
                                                     title:
                                                     ApiConfig
                                                         .error,
                                                     message:
                                                     'Message should not be Empty!',
                                                   );
                                                 }
                                               },
                                               name: 'Send',
                                             ),
                                           ],
                                         ),
                                       ),
                                     );
                                   },
                                 );
                               },
                               child: Row(
                                 children: [
                                   Icon(
                                     Icons.reply_rounded,
                                     size: 25,
                                     color: AppColors.colorffffff,
                                   ),
                                   const SizedBox(width: 2),
                                   Text(
                                     'Reply',
                                     style: colorfffffffs13w600,
                                   ),
                                 ],
                               ),
                             ),
                           ],
                         ),*/
                       ],
                     ),
                   ),
                 ],
               ),
             ),
           ),
         ),
       ),
     );
   }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingsController>(
      initState: (a) {},
      builder: (a) {
        return  Obx((){
          return SingleChildScrollView(
            child:
            isShimmer.value
                ? Column(
                children: List.generate(
                  5,
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 8,
                    ),
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: AppColors.colorffffff,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 5,
                            spreadRadius: 5,
                            color: Color.fromRGBO(0, 0, 0, 0.05),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        ],
                      ),
                    ),
                  ),
                ),
              )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(() {
                    return Row(
                      children: List.generate(
                        reviewsbyYouTab.length,
                            (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              selectedReviewTab.value = index;
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border:
                                selectedReviewTab.value == index
                                    ? Border.all(
                                  color: AppColors.colorFE6927,
                                )
                                    : null,
                                color:
                                selectedReviewTab.value == index
                                    ? AppColors.colorFE6927.withOpacity(
                                  0.2,
                                )
                                    : Colors.white,
                                boxShadow:
                                selectedReviewTab.value != index
                                    ? const [
                                  BoxShadow(
                                    blurRadius: 5,
                                    spreadRadius: 3,
                                    offset: Offset(0, 1),
                                    color: Color.fromRGBO(
                                      0,
                                      0,
                                      0,
                                      0.05,
                                    ),
                                  ),
                                ]
                                    : null,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 7,
                                horizontal: 13,
                              ),
                              child: Text(
                                reviewsbyYouTab[index],
                                style:
                                selectedReviewTab.value == index
                                    ? colorfffffffs13w600.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorFE6927,
                                )
                                    : colorfffffffs13w600.copyWith(
                                  color: AppColors.color000000
                                      .withOpacity(0.5),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 15),
                 Column(
                  children: selectedReviewTab.value == 0?[reviewsAboutYouView()]:
                  selectedReviewTab.value == 1?
                  InsightController.to.reviewsToWrite.isEmpty?[
                    Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: AppColors.colorD9D9D9,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 40,
                        horizontal: 50,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'You don’t have any Reviews yet.',
                            style: color00000s14w500,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )]:
                  List.generate( InsightController.to.reviewsToWrite.length,
                        (index) {
                      List data = InsightController.to.reviewsToWrite;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 12,
                        ),
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: AppColors.colorffffff,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 5,
                                color: Color.fromRGBO(0, 0, 0, 0.05),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 12,
                          ),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                        data[index]['properties']?['cover_photo'] ??
                                            '',
                                        placeholder:
                                            (context, url) =>
                                            CupertinoActivityIndicator(
                                              color:
                                              AppColors
                                                  .colorFE6927,
                                            ),
                                        errorWidget:
                                            (context, url, error) =>
                                        const Icon(Icons.error),
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 100,
                                        memCacheHeight: 110,
                                        memCacheWidth: 110,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      data[index]?['properties']?['name'] ??
                                          '',
                                      style: color000000s12w400
                                          .copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(
                                                  100,
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                  data[index]['user_profile_image'] ??
                                                      '',
                                                  placeholder:
                                                      (
                                                      context,
                                                      url,
                                                      ) => CupertinoActivityIndicator(
                                                    color:
                                                    AppColors
                                                        .colorFE6927,
                                                  ),
                                                  errorWidget:
                                                      (
                                                      context,
                                                      url,
                                                      error,
                                                      ) => Image.asset(
                                                    "assets/images/profile_image.png",
                                                  ),
                                                  fit: BoxFit.cover,
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  selectedReviewTab.value==1
                                                      ? "${data[index]['host']['first_name']} ${data[index]['host']['last_name']}"
                                                      : "${data[index]['user_name']}",
                                                  style:
                                                  color000000s12w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    if (selectedReviewTab.value ==
                                        3) ...{
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/sad_smiley.svg',
                                            height: 30,
                                            width: 30,
                                          ),
                                          const SizedBox(width: 8),
                                          const Flexible(
                                            child: Text(
                                              'Unfortunately, the deadline to submit a public review for this user has passed.',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    },
                                    if (selectedReviewTab.value !=
                                        2) ...{
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/calendarIcon.png",
                                            height: 17,
                                            width: 17,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            data[index]['date_range'] ??
                                                '',
                                            style: color000000s12w400,
                                          ),
                                        ],
                                      ),
                                    },
                                    if (selectedReviewTab.value == 1)
                                      RichText(
                                        text: TextSpan(
                                          text: 'You have ',
                                          style: color50perBlacks13w400,
                                          children: [
                                            TextSpan(
                                              text:
                                              '${DateFormat('yyyy-MM-dd').parse(data[index]['end_date'] ?? DateFormat('dd-MM-yyy').format(DateTime.now())).difference(DateTime.now()).inDays + 15} days ',
                                              style: color50perBlacks13w400
                                                  .copyWith(
                                                color:
                                                AppColors
                                                    .color000000,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                              'to submit a public review for ${data[index]['host']['first_name']} ${data[index]['host']['last_name']}',
                                              style: color50perBlacks13w400
                                                  .copyWith(
                                                color:
                                                AppColors
                                                    .color828282,
                                                fontWeight:
                                                FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    const SizedBox(height: 5),
                                    if (selectedReviewTab.value ==
                                        2) ...{

                                      Text(
                                        data[index]['bookings']['date_range'] ??
                                            '',
                                        style: color000000s12w400,
                                      ),

                                      Text(
                                        data[index]['description'] ?? '',
                                        style: color000000s12w400,
                                      ),
                                      Bounce(
                                        onPressed: () {
                                          /*  showDialog(
                                            context: context,
                                            builder: (context) {
                                              return showDialogForShowingReview(
                                                data[index],
                                              );
                                            },
                                          );*/



                                          Get.to(
                                                () =>
                                                ReviewScreenPast(
                                                  data:
                                                  data[index] ??
                                                      {},
                                                ),
                                          );

                                        },
                                        duration: const Duration(
                                          milliseconds: 150,
                                        ),
                                        child: Text(
                                          'View More',
                                          style: color000000s12w400
                                              .copyWith(
                                            color:
                                            AppColors
                                                .colorFE6927,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.watch_later_outlined,
                                            color:
                                            AppColors.color828282,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            data[index]['post_date'] ??
                                                '',
                                            style: color000000s12w400
                                                .copyWith(
                                              color:
                                              AppColors
                                                  .color828282,
                                            ),
                                          ),
                                        ],
                                      ),
                                    },
                                    if (selectedReviewTab.value == 1)
                                      CommonButton(
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          showDialog(
                                            context: context,

                                            builder: (context) {
                                              return Dialog(
                                                backgroundColor:
                                                AppColors
                                                    .colorD9D9D9,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal:
                                                    12.0,
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                    MainAxisSize
                                                        .min,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Center(
                                                        child: Text(
                                                          "Write Review",
                                                          style:
                                                          color00000s18w600,
                                                        ),
                                                      ),
                                                      Divider(
                                                        color:
                                                        AppColors
                                                            .color000000,
                                                      ),
                                                      Text(
                                                        "Write a review for ${data[index]?['booking_first_name']} ${data[index]?['booking_last_name']} ",
                                                        style:
                                                        color00000s14w500,
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Text(
                                                        "You and your guest will only see your feedback from this trip once you have both completed a review. Be honest so that you help your guest plan for future trips on GLEEKEY. Your review will also help other hosts know what to expect when they receive a reservation request from them.",
                                                        style: color828282s12w400
                                                            .copyWith(
                                                          height:
                                                          1.2,
                                                          color:
                                                          AppColors
                                                              .color645555,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Text(
                                                        "You have ${DateFormat('yyyy-MM-dd').parse(data[index]['start_date']).difference(DateTime.now()).inDays + 16} days to complete your reviews, and if only one of you has completed a review in that time, we’ll make it public after the review period ends.",
                                                        style: color828282s12w400
                                                            .copyWith(
                                                          height:
                                                          1.2,
                                                          color:
                                                          AppColors
                                                              .color645555,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Center(
                                                        child: CommonButton(
                                                          onPressed: () {
                                                            FocusScope.of(context).unfocus();
                                                            print(data[index]);

                                                            Get.back();
                                                            if(selectedReviewTab.value == 1 ){

                                                              if(data[index]['host_id']!=currUser!.data!.id) {
                                                                showDialog(
                                                                  context:
                                                                  context,
                                                                  barrierDismissible:
                                                                  false,
                                                                  //context: _scaffoldKey.currentContext,
                                                                  builder: (
                                                                      context,) {
                                                                    return showDialogForNextWritingReview(
                                                                        (data[index]['booking_id'])
                                                                            .toString());
                                                                  },
                                                                );
                                                              }else
                                                              {
                                                                showDialog(
                                                                  context:
                                                                  context,
                                                                  barrierDismissible:
                                                                  false,
                                                                  //context: _scaffoldKey.currentContext,
                                                                  builder: (context,) {
                                                                    return showDialogForWritingReview((data[index]['booking_id']).toString());
                                                                  },
                                                                );
                                                              }

                                                            }
                                                            else {
                                                              Get.defaultDialog(
                                                                title:
                                                                data[index]?['properties']?['name'] ??
                                                                    '',
                                                                barrierDismissible:
                                                                true,
                                                                content: SizedBox(
                                                                  width:
                                                                  Get.width,
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                          8.0,
                                                                        ),
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment:
                                                                              MainAxisAlignment
                                                                                  .spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  'Describe Your Experience',
                                                                                  style:
                                                                                  color00000s15w600,
                                                                                ),
                                                                                /*   RatingBar
                                                                          .builder(
                                                                        initialRating:
                                                                            double.parse(
                                                                                ('0').toString()),
                                                                        minRating:
                                                                            1,
                                                                        ignoreGestures:
                                                                            true,
                                                                        direction:
                                                                            Axis.horizontal,
                                                                        allowHalfRating:
                                                                            true,
                                                                        itemCount:
                                                                            5,
                                                                        itemSize:
                                                                            20,
                                                                        unratedColor:
                                                                            AppColors
                                                                                .colorD9D9D9,
                                                                        itemPadding:
                                                                            const EdgeInsets
                                                                                .symmetric(
                                                                          horizontal:
                                                                              4.0,
                                                                        ),
                                                                        itemBuilder:
                                                                            (context, _) =>
                                                                                Icon(
                                                                          Icons
                                                                              .star,
                                                                          color: AppColors
                                                                              .colorFE6927,
                                                                        ),
                                                                        onRatingUpdate:
                                                                            (rating) {
                                                                          print(
                                                                              rating);
                                                                        },
                                                                      ),*/
                                                                              ],
                                                                            ),
                                                                            Text(
                                                                              data[index]['message'] ??
                                                                                  '',
                                                                              style:
                                                                              color50perBlacks13w400,
                                                                            ),
                                                                            const SizedBox(
                                                                              height:
                                                                              8,
                                                                            ),
                                                                            Divider(
                                                                              endIndent:
                                                                              10,
                                                                              indent:
                                                                              10,
                                                                              color: AppColors
                                                                                  .color000000
                                                                                  .withOpacity(
                                                                                0.1,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                          8.0,
                                                                        ),
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment:
                                                                              MainAxisAlignment
                                                                                  .spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  'Private Guest Feedback',
                                                                                  style:
                                                                                  color00000s15w600,
                                                                                ),
                                                                                /*   RatingBar
                                                                          .builder(
                                                                        initialRating:
                                                                            double.parse(
                                                                                ('0').toString()),
                                                                        minRating:
                                                                            1,
                                                                        ignoreGestures:
                                                                            true,
                                                                        direction:
                                                                            Axis.horizontal,
                                                                        allowHalfRating:
                                                                            true,
                                                                        itemCount:
                                                                            5,
                                                                        itemSize:
                                                                            20,
                                                                        unratedColor:
                                                                            AppColors
                                                                                .colorD9D9D9,
                                                                        itemPadding:
                                                                            const EdgeInsets
                                                                                .symmetric(
                                                                          horizontal:
                                                                              4.0,
                                                                        ),
                                                                        itemBuilder:
                                                                            (context, _) =>
                                                                                Icon(
                                                                          Icons
                                                                              .star,
                                                                          color: AppColors
                                                                              .colorFE6927,
                                                                        ),
                                                                        onRatingUpdate:
                                                                            (rating) {
                                                                          print(
                                                                              rating);
                                                                        },
                                                                      ),*/
                                                                              ],
                                                                            ),
                                                                            Text(
                                                                              data[index]['secret_feedback'] ??
                                                                                  'No secret feedback',
                                                                              style:
                                                                              color50perBlacks13w400,
                                                                            ),
                                                                            const SizedBox(
                                                                              height:
                                                                              8,
                                                                            ),
                                                                            Divider(
                                                                              endIndent:
                                                                              10,
                                                                              indent:
                                                                              10,
                                                                              color: AppColors
                                                                                  .color000000
                                                                                  .withOpacity(
                                                                                0.1,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                          8.0,
                                                                        ),
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Text(
                                                                              'Did the guest leave your space clean?',
                                                                              style:
                                                                              color00000s15w600,
                                                                            ),
                                                                            RatingBar
                                                                                .builder(
                                                                              initialRating: double
                                                                                  .parse(
                                                                                (data[index]['cleanliness'] ??
                                                                                    '0')
                                                                                    .toString(),
                                                                              ),
                                                                              minRating:
                                                                              1,
                                                                              ignoreGestures:
                                                                              true,
                                                                              direction:
                                                                              Axis
                                                                                  .horizontal,
                                                                              allowHalfRating:
                                                                              true,
                                                                              itemCount:
                                                                              5,
                                                                              itemSize:
                                                                              20,
                                                                              unratedColor:
                                                                              AppColors
                                                                                  .colorD9D9D9,
                                                                              itemPadding: const EdgeInsets
                                                                                  .symmetric(
                                                                                horizontal:
                                                                                4.0,
                                                                              ),
                                                                              itemBuilder:
                                                                                  (
                                                                                  context,
                                                                                  _,) =>
                                                                                  Icon(
                                                                                    Icons
                                                                                        .star,
                                                                                    color:
                                                                                    AppColors
                                                                                        .colorFE6927,
                                                                                  ),
                                                                              onRatingUpdate: (
                                                                                  rating,) {
                                                                                print(
                                                                                  rating,
                                                                                );
                                                                              },
                                                                            ),
                                                                            (data[index]['cleanliness_message'] ==
                                                                                null ||
                                                                                data[index]['cleanliness_message'] ==
                                                                                    '')
                                                                                ? const SizedBox()
                                                                                : const SizedBox(
                                                                              height:
                                                                              5,
                                                                            ),
                                                                            (data[index]['cleanliness_message'] ==
                                                                                null ||
                                                                                data[index]['cleanliness_message'] ==
                                                                                    '')
                                                                                ? const SizedBox()
                                                                                : Text(
                                                                              data[index]['cleanliness_message'] ??
                                                                                  '',
                                                                              style:
                                                                              color50perBlacks13w400,
                                                                            ),
                                                                            const SizedBox(
                                                                              height:
                                                                              5,
                                                                            ),
                                                                            Divider(
                                                                              endIndent:
                                                                              10,
                                                                              indent:
                                                                              10,
                                                                              color: AppColors
                                                                                  .color000000
                                                                                  .withOpacity(
                                                                                0.1,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                          8.0,
                                                                        ),
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Text(
                                                                              'How clearly did the guest communicate their plans, questions, and concerns?',
                                                                              style:
                                                                              color00000s15w600,
                                                                            ),
                                                                            RatingBar
                                                                                .builder(
                                                                              initialRating: double
                                                                                  .parse(
                                                                                (data[index]['communication'] ??
                                                                                    '0')
                                                                                    .toString(),
                                                                              ),
                                                                              minRating:
                                                                              1,
                                                                              ignoreGestures:
                                                                              true,
                                                                              direction:
                                                                              Axis
                                                                                  .horizontal,
                                                                              allowHalfRating:
                                                                              true,
                                                                              itemCount:
                                                                              5,
                                                                              itemSize:
                                                                              20,
                                                                              unratedColor:
                                                                              AppColors
                                                                                  .colorD9D9D9,
                                                                              itemPadding: const EdgeInsets
                                                                                  .symmetric(
                                                                                horizontal:
                                                                                4.0,
                                                                              ),
                                                                              itemBuilder:
                                                                                  (
                                                                                  context,
                                                                                  _,) =>
                                                                                  Icon(
                                                                                    Icons
                                                                                        .star,
                                                                                    color:
                                                                                    AppColors
                                                                                        .colorFE6927,
                                                                                  ),
                                                                              onRatingUpdate: (
                                                                                  rating,) {
                                                                                print(
                                                                                  rating,
                                                                                );
                                                                              },
                                                                            ),
                                                                            (data[index]['communication_message'] ==
                                                                                null ||
                                                                                data[index]['communication_message'] ==
                                                                                    '')
                                                                                ? const SizedBox()
                                                                                : const SizedBox(
                                                                              height:
                                                                              5,
                                                                            ),
                                                                            (data[index]['communication_message'] ==
                                                                                null ||
                                                                                data[index]['communication_message'] ==
                                                                                    '')
                                                                                ? const SizedBox()
                                                                                : Text(
                                                                              data[index]['communication_message'] ??
                                                                                  '',
                                                                              style:
                                                                              color50perBlacks13w400,
                                                                            ),
                                                                            const SizedBox(
                                                                              height:
                                                                              5,
                                                                            ),
                                                                            Divider(
                                                                              endIndent:
                                                                              10,
                                                                              indent:
                                                                              10,
                                                                              color: AppColors
                                                                                  .color000000
                                                                                  .withOpacity(
                                                                                0.1,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                          8.0,
                                                                        ),
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Text(
                                                                              'Did the guest observe the house rules you provided?',
                                                                              style:
                                                                              color00000s15w600,
                                                                            ),
                                                                            RatingBar
                                                                                .builder(
                                                                              initialRating: double
                                                                                  .parse(
                                                                                (data[index]['house_rules'] ??
                                                                                    '0')
                                                                                    .toString(),
                                                                              ),
                                                                              minRating:
                                                                              1,
                                                                              ignoreGestures:
                                                                              true,
                                                                              direction:
                                                                              Axis
                                                                                  .horizontal,
                                                                              allowHalfRating:
                                                                              true,
                                                                              itemCount:
                                                                              5,
                                                                              itemSize:
                                                                              20,
                                                                              unratedColor:
                                                                              AppColors
                                                                                  .colorD9D9D9,
                                                                              itemPadding: const EdgeInsets
                                                                                  .symmetric(
                                                                                horizontal:
                                                                                4.0,
                                                                              ),
                                                                              itemBuilder:
                                                                                  (
                                                                                  context,
                                                                                  _,) =>
                                                                                  Icon(
                                                                                    Icons
                                                                                        .star,
                                                                                    color:
                                                                                    AppColors
                                                                                        .colorFE6927,
                                                                                  ),
                                                                              onRatingUpdate: (
                                                                                  rating,) {
                                                                                print(
                                                                                  rating,
                                                                                );
                                                                              },
                                                                            ),
                                                                            Divider(
                                                                              endIndent:
                                                                              10,
                                                                              indent:
                                                                              10,
                                                                              color: AppColors
                                                                                  .color000000
                                                                                  .withOpacity(
                                                                                0.1,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          name:
                                                          "Write Review",
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },

                                        name: 'Write Review',
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ) :

                  InsightController.to.reviewsByYou.isEmpty?[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: AppColors.colorD9D9D9,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 40,
                          horizontal: 50,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'You don’t have any Reviews yet.',
                              style: color00000s14w500,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )]:
                  List.generate(InsightController.to.reviewsByYou.length,
                        (index) {
                      List data =InsightController.to.reviewsByYou;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 12,
                        ),
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: AppColors.colorffffff,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 5,
                                color: Color.fromRGBO(0, 0, 0, 0.05),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 12,
                          ),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                        data[index]['properties']?['cover_photo'] ??
                                            '',
                                        placeholder:
                                            (context, url) =>
                                            CupertinoActivityIndicator(
                                              color:
                                              AppColors
                                                  .colorFE6927,
                                            ),
                                        errorWidget:
                                            (context, url, error) =>
                                        const Icon(Icons.error),
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 100,
                                        memCacheHeight: 110,
                                        memCacheWidth: 110,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      data[index]?['properties']?['name'] ??
                                          '',
                                      style: color000000s12w400
                                          .copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(
                                                  100,
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                  data[index]['user_profile_image'] ??
                                                      '',
                                                  placeholder:
                                                      (
                                                      context,
                                                      url,
                                                      ) => CupertinoActivityIndicator(
                                                    color:
                                                    AppColors
                                                        .colorFE6927,
                                                  ),
                                                  errorWidget:
                                                      (
                                                      context,
                                                      url,
                                                      error,
                                                      ) => Image.asset(
                                                    "assets/images/profile_image.png",
                                                  ),
                                                  fit: BoxFit.cover,
                                                  height: 40,
                                                  width: 40,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  selectedReviewTab.value==1
                                                      ? "${data[index]['host']['first_name']} ${data[index]['host']['last_name']}"
                                                      : "${data[index]['user_name']}",
                                                  style:
                                                  color000000s12w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    if (selectedReviewTab.value ==
                                        3) ...{
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/sad_smiley.svg',
                                            height: 30,
                                            width: 30,
                                          ),
                                          const SizedBox(width: 8),
                                          const Flexible(
                                            child: Text(
                                              'Unfortunately, the deadline to submit a public review for this user has passed.',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    },
                                    if (selectedReviewTab.value !=
                                        2) ...{
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/calendarIcon.png",
                                            height: 17,
                                            width: 17,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            data[index]['date_range'] ??
                                                '',
                                            style: color000000s12w400,
                                          ),
                                        ],
                                      ),
                                    },
                                    if (selectedReviewTab.value == 1)
                                      RichText(
                                        text: TextSpan(
                                          text: 'You have ',
                                          style: color50perBlacks13w400,
                                          children: [
                                            TextSpan(
                                              text:
                                              '${DateFormat('yyyy-MM-dd').parse(data[index]['end_date'] ?? DateFormat('dd-MM-yyy').format(DateTime.now())).difference(DateTime.now()).inDays + 15} days ',
                                              style: color50perBlacks13w400
                                                  .copyWith(
                                                color:
                                                AppColors
                                                    .color000000,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                              'to submit a public review for ${data[index]['host']['first_name']} ${data[index]['host']['last_name']}',
                                              style: color50perBlacks13w400
                                                  .copyWith(
                                                color:
                                                AppColors
                                                    .color828282,
                                                fontWeight:
                                                FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    const SizedBox(height: 5),
                                    if (selectedReviewTab.value ==
                                        2) ...{

                                      Text(
                                        data[index]['bookings']['date_range'] ??
                                            '',
                                        style: color000000s12w400,
                                      ),

                                      Text(
                                        data[index]['description'] ?? '',
                                        style: color000000s12w400,
                                      ),
                                      Bounce(
                                        onPressed: () {
                                        /*  showDialog(
                                            context: context,
                                            builder: (context) {
                                              return showDialogForShowingReview(
                                                data[index],
                                              );
                                            },
                                          );*/



                                          Get.to(
                                                () =>
                                                ReviewScreenPast(
                                                  data:
                                                  data[index] ??
                                                      {},
                                                ),
                                          );

                                        },
                                        duration: const Duration(
                                          milliseconds: 150,
                                        ),
                                        child: Text(
                                          'View More',
                                          style: color000000s12w400
                                              .copyWith(
                                            color:
                                            AppColors
                                                .colorFE6927,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.watch_later_outlined,
                                            color:
                                            AppColors.color828282,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            data[index]['post_date'] ??
                                                '',
                                            style: color000000s12w400
                                                .copyWith(
                                              color:
                                              AppColors
                                                  .color828282,
                                            ),
                                          ),
                                        ],
                                      ),
                                    },
                                    if (selectedReviewTab.value == 1)
                                      CommonButton(
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          showDialog(
                                            context: context,

                                            builder: (context) {
                                              return Dialog(
                                                backgroundColor:
                                                AppColors
                                                    .colorD9D9D9,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal:
                                                    12.0,
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                    MainAxisSize
                                                        .min,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Center(
                                                        child: Text(
                                                          "Write Review",
                                                          style:
                                                          color00000s18w600,
                                                        ),
                                                      ),
                                                      Divider(
                                                        color:
                                                        AppColors
                                                            .color000000,
                                                      ),
                                                      Text(
                                                        "Write a review for ${data[index]?['booking_first_name']} ${data[index]?['booking_last_name']} ",
                                                        style:
                                                        color00000s14w500,
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Text(
                                                        "You and your guest will only see your feedback from this trip once you have both completed a review. Be honest so that you help your guest plan for future trips on GLEEKEY. Your review will also help other hosts know what to expect when they receive a reservation request from them.",
                                                        style: color828282s12w400
                                                            .copyWith(
                                                          height:
                                                          1.2,
                                                          color:
                                                          AppColors
                                                              .color645555,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Text(
                                                        "You have ${DateFormat('yyyy-MM-dd').parse(data[index]['start_date']).difference(DateTime.now()).inDays + 16} days to complete your reviews, and if only one of you has completed a review in that time, we’ll make it public after the review period ends.",
                                                        style: color828282s12w400
                                                            .copyWith(
                                                          height:
                                                          1.2,
                                                          color:
                                                          AppColors
                                                              .color645555,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Center(
                                                        child: CommonButton(
                                                          onPressed: () {
                                                            FocusScope.of(context).unfocus();
                                                            print(data[index]);

                                                            Get.back();
                                                            if(selectedReviewTab.value == 1 ){

                                                              if(data[index]['host_id']!=currUser!.data!.id) {
                                                                showDialog(
                                                                  context:
                                                                  context,
                                                                  barrierDismissible:
                                                                  false,
                                                                  //context: _scaffoldKey.currentContext,
                                                                  builder: (
                                                                      context,) {
                                                                    return showDialogForNextWritingReview(
                                                                        (data[index]['booking_id'])
                                                                            .toString());
                                                                  },
                                                                );
                                                              }else
                                                                {

                                                                  showDialog(
                                                                    context:
                                                                    context,
                                                                    barrierDismissible:
                                                                    false,
                                                                    //context: _scaffoldKey.currentContext,
                                                                    builder: (
                                                                        context,) {
                                                                      return showDialogForWritingReview(
                                                                          (data[index]['booking_id'])
                                                                              .toString());
                                                                    },
                                                                  );
                                                                }

                                                            }
                                                            else {
                                                              Get.defaultDialog(
                                                                title:
                                                                data[index]?['properties']?['name'] ??
                                                                    '',
                                                                barrierDismissible:
                                                                true,
                                                                content: SizedBox(
                                                                  width:
                                                                  Get.width,
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                          8.0,
                                                                        ),
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment:
                                                                              MainAxisAlignment
                                                                                  .spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  'Describe Your Experience',
                                                                                  style:
                                                                                  color00000s15w600,
                                                                                ),
                                                                                /*   RatingBar
                                                                          .builder(
                                                                        initialRating:
                                                                            double.parse(
                                                                                ('0').toString()),
                                                                        minRating:
                                                                            1,
                                                                        ignoreGestures:
                                                                            true,
                                                                        direction:
                                                                            Axis.horizontal,
                                                                        allowHalfRating:
                                                                            true,
                                                                        itemCount:
                                                                            5,
                                                                        itemSize:
                                                                            20,
                                                                        unratedColor:
                                                                            AppColors
                                                                                .colorD9D9D9,
                                                                        itemPadding:
                                                                            const EdgeInsets
                                                                                .symmetric(
                                                                          horizontal:
                                                                              4.0,
                                                                        ),
                                                                        itemBuilder:
                                                                            (context, _) =>
                                                                                Icon(
                                                                          Icons
                                                                              .star,
                                                                          color: AppColors
                                                                              .colorFE6927,
                                                                        ),
                                                                        onRatingUpdate:
                                                                            (rating) {
                                                                          print(
                                                                              rating);
                                                                        },
                                                                      ),*/
                                                                              ],
                                                                            ),
                                                                            Text(
                                                                              data[index]['message'] ??
                                                                                  '',
                                                                              style:
                                                                              color50perBlacks13w400,
                                                                            ),
                                                                            const SizedBox(
                                                                              height:
                                                                              8,
                                                                            ),
                                                                            Divider(
                                                                              endIndent:
                                                                              10,
                                                                              indent:
                                                                              10,
                                                                              color: AppColors
                                                                                  .color000000
                                                                                  .withOpacity(
                                                                                0.1,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                          8.0,
                                                                        ),
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment:
                                                                              MainAxisAlignment
                                                                                  .spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  'Private Guest Feedback',
                                                                                  style:
                                                                                  color00000s15w600,
                                                                                ),
                                                                                /*   RatingBar
                                                                          .builder(
                                                                        initialRating:
                                                                            double.parse(
                                                                                ('0').toString()),
                                                                        minRating:
                                                                            1,
                                                                        ignoreGestures:
                                                                            true,
                                                                        direction:
                                                                            Axis.horizontal,
                                                                        allowHalfRating:
                                                                            true,
                                                                        itemCount:
                                                                            5,
                                                                        itemSize:
                                                                            20,
                                                                        unratedColor:
                                                                            AppColors
                                                                                .colorD9D9D9,
                                                                        itemPadding:
                                                                            const EdgeInsets
                                                                                .symmetric(
                                                                          horizontal:
                                                                              4.0,
                                                                        ),
                                                                        itemBuilder:
                                                                            (context, _) =>
                                                                                Icon(
                                                                          Icons
                                                                              .star,
                                                                          color: AppColors
                                                                              .colorFE6927,
                                                                        ),
                                                                        onRatingUpdate:
                                                                            (rating) {
                                                                          print(
                                                                              rating);
                                                                        },
                                                                      ),*/
                                                                              ],
                                                                            ),
                                                                            Text(
                                                                              data[index]['secret_feedback'] ??
                                                                                  'No secret feedback',
                                                                              style:
                                                                              color50perBlacks13w400,
                                                                            ),
                                                                            const SizedBox(
                                                                              height:
                                                                              8,
                                                                            ),
                                                                            Divider(
                                                                              endIndent:
                                                                              10,
                                                                              indent:
                                                                              10,
                                                                              color: AppColors
                                                                                  .color000000
                                                                                  .withOpacity(
                                                                                0.1,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                          8.0,
                                                                        ),
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Text(
                                                                              'Did the guest leave your space clean?',
                                                                              style:
                                                                              color00000s15w600,
                                                                            ),
                                                                            RatingBar
                                                                                .builder(
                                                                              initialRating: double
                                                                                  .parse(
                                                                                (data[index]['cleanliness'] ??
                                                                                    '0')
                                                                                    .toString(),
                                                                              ),
                                                                              minRating:
                                                                              1,
                                                                              ignoreGestures:
                                                                              true,
                                                                              direction:
                                                                              Axis
                                                                                  .horizontal,
                                                                              allowHalfRating:
                                                                              true,
                                                                              itemCount:
                                                                              5,
                                                                              itemSize:
                                                                              20,
                                                                              unratedColor:
                                                                              AppColors
                                                                                  .colorD9D9D9,
                                                                              itemPadding: const EdgeInsets
                                                                                  .symmetric(
                                                                                horizontal:
                                                                                4.0,
                                                                              ),
                                                                              itemBuilder:
                                                                                  (
                                                                                  context,
                                                                                  _,) =>
                                                                                  Icon(
                                                                                    Icons
                                                                                        .star,
                                                                                    color:
                                                                                    AppColors
                                                                                        .colorFE6927,
                                                                                  ),
                                                                              onRatingUpdate: (
                                                                                  rating,) {
                                                                                print(
                                                                                  rating,
                                                                                );
                                                                              },
                                                                            ),
                                                                            (data[index]['cleanliness_message'] ==
                                                                                null ||
                                                                                data[index]['cleanliness_message'] ==
                                                                                    '')
                                                                                ? const SizedBox()
                                                                                : const SizedBox(
                                                                              height:
                                                                              5,
                                                                            ),
                                                                            (data[index]['cleanliness_message'] ==
                                                                                null ||
                                                                                data[index]['cleanliness_message'] ==
                                                                                    '')
                                                                                ? const SizedBox()
                                                                                : Text(
                                                                              data[index]['cleanliness_message'] ??
                                                                                  '',
                                                                              style:
                                                                              color50perBlacks13w400,
                                                                            ),
                                                                            const SizedBox(
                                                                              height:
                                                                              5,
                                                                            ),
                                                                            Divider(
                                                                              endIndent:
                                                                              10,
                                                                              indent:
                                                                              10,
                                                                              color: AppColors
                                                                                  .color000000
                                                                                  .withOpacity(
                                                                                0.1,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                          8.0,
                                                                        ),
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Text(
                                                                              'How clearly did the guest communicate their plans, questions, and concerns?',
                                                                              style:
                                                                              color00000s15w600,
                                                                            ),
                                                                            RatingBar
                                                                                .builder(
                                                                              initialRating: double
                                                                                  .parse(
                                                                                (data[index]['communication'] ??
                                                                                    '0')
                                                                                    .toString(),
                                                                              ),
                                                                              minRating:
                                                                              1,
                                                                              ignoreGestures:
                                                                              true,
                                                                              direction:
                                                                              Axis
                                                                                  .horizontal,
                                                                              allowHalfRating:
                                                                              true,
                                                                              itemCount:
                                                                              5,
                                                                              itemSize:
                                                                              20,
                                                                              unratedColor:
                                                                              AppColors
                                                                                  .colorD9D9D9,
                                                                              itemPadding: const EdgeInsets
                                                                                  .symmetric(
                                                                                horizontal:
                                                                                4.0,
                                                                              ),
                                                                              itemBuilder:
                                                                                  (
                                                                                  context,
                                                                                  _,) =>
                                                                                  Icon(
                                                                                    Icons
                                                                                        .star,
                                                                                    color:
                                                                                    AppColors
                                                                                        .colorFE6927,
                                                                                  ),
                                                                              onRatingUpdate: (
                                                                                  rating,) {
                                                                                print(
                                                                                  rating,
                                                                                );
                                                                              },
                                                                            ),
                                                                            (data[index]['communication_message'] ==
                                                                                null ||
                                                                                data[index]['communication_message'] ==
                                                                                    '')
                                                                                ? const SizedBox()
                                                                                : const SizedBox(
                                                                              height:
                                                                              5,
                                                                            ),
                                                                            (data[index]['communication_message'] ==
                                                                                null ||
                                                                                data[index]['communication_message'] ==
                                                                                    '')
                                                                                ? const SizedBox()
                                                                                : Text(
                                                                              data[index]['communication_message'] ??
                                                                                  '',
                                                                              style:
                                                                              color50perBlacks13w400,
                                                                            ),
                                                                            const SizedBox(
                                                                              height:
                                                                              5,
                                                                            ),
                                                                            Divider(
                                                                              endIndent:
                                                                              10,
                                                                              indent:
                                                                              10,
                                                                              color: AppColors
                                                                                  .color000000
                                                                                  .withOpacity(
                                                                                0.1,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                          8.0,
                                                                        ),
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            Text(
                                                                              'Did the guest observe the house rules you provided?',
                                                                              style:
                                                                              color00000s15w600,
                                                                            ),
                                                                            RatingBar
                                                                                .builder(
                                                                              initialRating: double
                                                                                  .parse(
                                                                                (data[index]['house_rules'] ??
                                                                                    '0')
                                                                                    .toString(),
                                                                              ),
                                                                              minRating:
                                                                              1,
                                                                              ignoreGestures:
                                                                              true,
                                                                              direction:
                                                                              Axis
                                                                                  .horizontal,
                                                                              allowHalfRating:
                                                                              true,
                                                                              itemCount:
                                                                              5,
                                                                              itemSize:
                                                                              20,
                                                                              unratedColor:
                                                                              AppColors
                                                                                  .colorD9D9D9,
                                                                              itemPadding: const EdgeInsets
                                                                                  .symmetric(
                                                                                horizontal:
                                                                                4.0,
                                                                              ),
                                                                              itemBuilder:
                                                                                  (
                                                                                  context,
                                                                                  _,) =>
                                                                                  Icon(
                                                                                    Icons
                                                                                        .star,
                                                                                    color:
                                                                                    AppColors
                                                                                        .colorFE6927,
                                                                                  ),
                                                                              onRatingUpdate: (
                                                                                  rating,) {
                                                                                print(
                                                                                  rating,
                                                                                );
                                                                              },
                                                                            ),
                                                                            Divider(
                                                                              endIndent:
                                                                              10,
                                                                              indent:
                                                                              10,
                                                                              color: AppColors
                                                                                  .color000000
                                                                                  .withOpacity(
                                                                                0.1,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          name:
                                                          "Write Review",
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },

                                        name: 'Write Review',
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        );
      },
    );
  }
   RxInt cleanlinessRating = 0.obs;
   RxInt overallExperience = 0.obs;
   RxInt communicationHostRating = 0.obs;
   RxInt hostSupportRating = 0.obs;



   RxInt accuracyRating = 0.obs;
   RxInt arrivalRating = 0.obs;
   RxInt amenitiesRating = 0.obs;



   RxInt accuracyRating2 = 0.obs;
   RxInt amenitiesRating2 = 0.obs;
   RxInt cleanlinessRating2 = 0.obs;
   RxInt arrivalRating2 = 0.obs;
   RxInt communicationlRating2 = 0.obs;
   RxInt locationRating2 = 0.obs;
   RxInt valueRating2 = 0.obs;
   final TextEditingController _describeExperience = TextEditingController();
   final TextEditingController _aboutStaying = TextEditingController();
   final TextEditingController _improveStaying = TextEditingController();


   showDialogForWritingReview(String id) {
     return AlertDialog(
       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
       scrollable: true,
       title: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Text('Write a Review', style: color00000s18w600),
           InkWell(
             onTap: () {
               Get.back();
             },
             child: const Icon(Icons.close),
           ),
         ],
       ),
       shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.all(Radius.circular(20.0)),
       ),
       content: SizedBox(
         width: Get.width,
         child: Column(
           children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('1. Describe Your Experience', style: color00000s15w600),
                   Text('Your review will be public on mayur’s profile.',
                     style: color50perBlacks13w400,
                   ),
                   TextFormField(
                     controller: _describeExperience,
                     cursorColor: AppColors.colorFE6927,
                     maxLines: 3,
                     onEditingComplete: () {
                       FocusScope.of(context).unfocus(); // Hide keyboard when done is pressed
                     },
                     decoration: InputDecoration(
                       hintText: 'What was it like to host this guest?',
                       hintStyle: color828282s12w400,
                       floatingLabelBehavior: FloatingLabelBehavior.always,
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(6.0),
                         borderSide: BorderSide(
                           width: 1,
                           color: AppColors.color000000.withOpacity(0.5),
                         ),
                       ),
                       focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(6.0),
                         borderSide: BorderSide(
                           width: 1,
                           color: AppColors.color000000.withOpacity(0.5),
                         ),
                       ),
                       contentPadding: const EdgeInsets.all(13.0),
                     ),
                   ),
                   const SizedBox(height: 5),
                   Text(
                     'Make sure your review doesn’t include personal information (last name, address, contact information, etc.).',
                     style: color50perBlacks13w400.copyWith(height: 1.2),
                   ),
                 ],
               ),
             ),
             const SizedBox(height: 8),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 8.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('2. Private Host Feedback', style: color00000s15w600),
                   Text(
                     'This feedback is just for your guest. We won’t make it public.',
                     style: color50perBlacks13w400,
                   ),
                   TextFormField(
                     controller: _aboutStaying,
                     cursorColor: AppColors.colorFE6927,
                     maxLines: 3,
                     onEditingComplete: () {
                       FocusScope.of(context).unfocus(); // Hide keyboard when done is pressed
                     },
                     decoration: InputDecoration(
                       hintText:
                       'Thank you guest for visiting or offer some tips to help them improve for their next trip.',
                       hintStyle: color828282s12w400,
                       floatingLabelBehavior: FloatingLabelBehavior.always,
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(6.0),
                         borderSide: BorderSide(
                           width: 1,
                           color: AppColors.color000000.withOpacity(0.5),
                         ),
                       ),
                       focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(6.0),
                         borderSide: BorderSide(
                           width: 1,
                           color: AppColors.color000000.withOpacity(0.5),
                         ),
                       ),
                       contentPadding: const EdgeInsets.all(13.0),
                     ),
                   ),

                   const SizedBox(height: 10),
                   Text('3. Overall Experience', style: color00000s15w600),
                   const SizedBox(height: 5),
                   RatingBar.builder(
                     initialRating: overallExperience.value.toDouble(),
                     minRating: 0,
                     direction: Axis.horizontal,
                     itemCount: 5,
                     itemSize: 20,
                     unratedColor: AppColors.color828282.withOpacity(0.8),
                     itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                     itemBuilder:
                         (context, _) =>
                         Icon(Icons.star, color: AppColors.colorFE6927),
                     onRatingUpdate: (rating) {
                       overallExperience.value = rating.toInt();
                       print(overallExperience.value);
                     },
                   ),
                   const SizedBox(height: 12),
                   Text(
                     '4. Did the guest leave your space clean?',
                     style: color00000s15w600,
                   ),
                   const SizedBox(height: 5),
                   // Text(
                   //   'How accurately did the photos & description represent the actual space?',
                   //   style: color50perBlacks13w400,
                   // ),
                   Padding(
                     padding: const EdgeInsets.symmetric(vertical: 5),
                     child: RatingBar.builder(
                       initialRating: accuracyRating.value.toDouble(),
                       minRating: 0,
                       direction: Axis.horizontal,
                       itemCount: 5,
                       itemSize: 20,
                       unratedColor: AppColors.color828282.withOpacity(0.8),
                       itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                       itemBuilder:
                           (context, _) =>
                           Icon(Icons.star, color: AppColors.colorFE6927),
                       onRatingUpdate: (rating) {
                         accuracyRating.value = rating.toInt();
                         print(accuracyRating.value);
                       },
                     ),
                   ),

                   const SizedBox(height: 10),
                   Text(
                     '5. How clearly did the guest communicate their plans, questions, and concerns?',
                     style: color00000s15w600,
                   ),
                   const SizedBox(height: 5),
                   Padding(
                     padding: const EdgeInsets.symmetric(vertical: 5),
                     child: RatingBar.builder(
                       initialRating: cleanlinessRating.value.toDouble(),
                       minRating: 0,
                       direction: Axis.horizontal,
                       itemCount: 5,
                       itemSize: 20,
                       unratedColor: AppColors.color828282.withOpacity(0.8),
                       itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                       itemBuilder:
                           (context, _) =>
                           Icon(Icons.star, color: AppColors.colorFE6927),
                       onRatingUpdate: (rating) {
                         cleanlinessRating.value = rating.toInt();
                         print(cleanlinessRating.value);
                       },
                     ),
                   ),
                   const SizedBox(height: 12),
                   Text(
                     '6. Did the guest observe the house rules you provided?',
                     style: color00000s15w600,
                   ),
                   const SizedBox(height: 5),
                   Padding(
                     padding: const EdgeInsets.symmetric(vertical: 5),
                     child: RatingBar.builder(
                       initialRating: arrivalRating.value.toDouble(),
                       minRating: 0,
                       direction: Axis.horizontal,
                       itemCount: 5,
                       itemSize: 20,
                       unratedColor: AppColors.color828282.withOpacity(0.8),
                       itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                       itemBuilder:
                           (context, _) =>
                           Icon(Icons.star, color: AppColors.colorFE6927),
                       onRatingUpdate: (rating) {
                         arrivalRating.value = rating.toInt();
                         print(arrivalRating.value);
                       },
                     ),
                   ),
                   Align(
                     alignment: Alignment.center,
                     child: CommonButton(
                       onPressed: () async {


                         FocusScope.of(context).unfocus();

                         await InsightController.to.submitReview(
                           params: {
                             'id': id,
                           "message":_describeExperience.text.trim(),
                           "secret_feedback":_aboutStaying.text.trim(),
                           "cleanliness": accuracyRating.value.toString(),
                           "rating":overallExperience.value.toString(),
                           "communication":cleanlinessRating.value.toString() ,
                           "house_rules":arrivalRating.value.toString(),
                           },
                           success: (val) {

                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                 content: Text("Review Added successfully."),
                                 duration: const Duration(seconds: 2),
                               ),
                             );
                             Get.back();
                             callapi();

                           },
                           error: (e) {
                           },
                         );

                       },
                       name: 'Submit',
                     ),
                   ),
                 ],
               ),
             ),
           ],
         ),
       ),
     );
   }

   showDialogForNextWritingReview(String id) {
     return AlertDialog(
       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
       scrollable: true,
       title: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Text('Write a Review', style: color00000s18w600),
           InkWell(
             onTap: () {
               Get.back();
             },
             child: const Icon(Icons.close),
           ),
         ],
       ),
       shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.all(Radius.circular(20.0)),
       ),
       content: SizedBox(
         width: Get.width,
         child: Column(
           children: [
             const SizedBox(height: 8),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 8.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [

                   const SizedBox(height: 10),
                   Text('1. Communication with Host/Caretaker', style: color00000s15w600),
                   const SizedBox(height: 5),
                   RatingBar.builder(
                     initialRating: communicationHostRating.value.toDouble(),
                     minRating: 0,
                     direction: Axis.horizontal,
                     itemCount: 5,
                     itemSize: 20,
                     unratedColor: AppColors.color828282.withOpacity(0.8),
                     itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                     itemBuilder:
                         (context, _) =>
                         Icon(Icons.star, color: AppColors.colorFE6927),
                     onRatingUpdate: (rating) {
                       communicationHostRating.value = rating.toInt();
                       print(communicationHostRating.value);
                     },
                   ),
                   const SizedBox(height: 12),
                   const SizedBox(height: 10),
                   Text('2. Host/Caretaker’s support and behaviour', style: color00000s15w600),
                   const SizedBox(height: 5),
                   RatingBar.builder(
                     initialRating: hostSupportRating.value.toDouble(),
                     minRating: 0,
                     direction: Axis.horizontal,
                     itemCount: 5,
                     itemSize: 20,
                     unratedColor: AppColors.color828282.withOpacity(0.8),
                     itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                     itemBuilder:
                         (context, _) =>
                         Icon(Icons.star, color: AppColors.colorFE6927),
                     onRatingUpdate: (rating) {
                       hostSupportRating.value = rating.toInt();
                       print(hostSupportRating.value);
                     },
                   ),
                   const SizedBox(height: 12),

                   const SizedBox(height: 10),
                   Text('3. Over all ratings to Host/caretaker', style: color00000s15w600),
                   const SizedBox(height: 5),
                   RatingBar.builder(
                     initialRating: overallExperience.value.toDouble(),
                     minRating: 0,
                     direction: Axis.horizontal,
                     itemCount: 5,
                     itemSize: 20,
                     unratedColor: AppColors.color828282.withOpacity(0.8),
                     itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                     itemBuilder:
                         (context, _) =>
                         Icon(Icons.star, color: AppColors.colorFE6927),
                     onRatingUpdate: (rating) {
                       overallExperience.value = rating.toInt();
                       print(overallExperience.value);
                     },
                   ),
                   const SizedBox(height: 12),

                   Align(
                     alignment: Alignment.center,
                     child: CommonButton(
                       onPressed: () async {
                         FocusScope.of(context).unfocus();
                         print("--------------------------");
                         print(id);
                         print(id);
                         print(id);
                         print(id);
                         print(id);
                         print(id);
                         print(id);
                         print(id);


                       await InsightController.to.submitReview(
                           params: {
                             'booking_id': id,
                             "communication_host":communicationHostRating.value.toString(),
                             "host_support":hostSupportRating.value.toString(),
                             "rating":overallExperience.value.toString(),

                           },
                           success: (val) {

                             Get.back();
                             communicationHostRating.value=0;
                             hostSupportRating.value=0;
                             overallExperience.value=0;



                             callapi();
                             showDialog(
                               context:
                               context,
                               barrierDismissible:
                               false,
                               //context: _scaffoldKey.currentContext,
                               builder: (
                                   context,) {
                                 return  showDialogForNextWritingReviewPartTwo(id,val.toString());
                               },
                             );






                           },
                           error: (e) {
                           },
                         );








                       },
                       name: 'Next',
                     ),
                   ),
                 ],
               ),
             ),
           ],
         ),
       ),
     );
   }

   showDialogForNextWritingReviewPartTwo(String id,String review_id) {
     return AlertDialog(
       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
       scrollable: true,
       title: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Text('Write a Review', style: color00000s18w600),
           InkWell(
             onTap: () {
               Get.back();
             },
             child: const Icon(Icons.close),
           ),
         ],
       ),
       shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.all(Radius.circular(20.0)),
       ),
       content: SizedBox(
         width: Get.width,
         child: Column(
           children: [

             const SizedBox(height: 10),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 8.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [

                   Text(
                     'Your host will not know how you respond to these',
                     style: color50perBlacks13w400,
                   ),


                   Text('1. Hygiene standards', style: color00000s15w600),
                   const SizedBox(height: 5),
                   RatingBar.builder(
                     initialRating: accuracyRating2.value.toDouble(),
                     minRating: 0,
                     direction: Axis.horizontal,
                     itemCount: 5,
                     itemSize: 20,
                     unratedColor: AppColors.color828282.withOpacity(0.8),
                     itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                     itemBuilder:
                         (context, _) =>
                         Icon(Icons.star, color: AppColors.colorFE6927),
                     onRatingUpdate: (rating) {
                       accuracyRating2.value = rating.toInt();
                       print(accuracyRating2.value);
                     },
                   ),

                   const SizedBox(height: 10),
                   Text('2. Responsiveness of Host', style: color00000s15w600),
                   const SizedBox(height: 5),
                   RatingBar.builder(
                     initialRating: cleanlinessRating2.value.toDouble(),
                     minRating: 0,
                     direction: Axis.horizontal,
                     itemCount: 5,
                     itemSize: 20,
                     unratedColor: AppColors.color828282.withOpacity(0.8),
                     itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                     itemBuilder:
                         (context, _) =>
                         Icon(Icons.star, color: AppColors.colorFE6927),
                     onRatingUpdate: (rating) {
                       cleanlinessRating2.value = rating.toInt();
                       print(cleanlinessRating2.value);
                     },
                   ),
                   const SizedBox(height: 10),



                   Text('3. Photos to Reality', style: color00000s15w600),
                   const SizedBox(height: 5),
                   RatingBar.builder(
                     initialRating: arrivalRating2.value.toDouble(),
                     minRating: 0,
                     direction: Axis.horizontal,
                     itemCount: 5,
                     itemSize: 20,
                     unratedColor: AppColors.color828282.withOpacity(0.8),
                     itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                     itemBuilder:
                         (context, _) =>
                         Icon(Icons.star, color: AppColors.colorFE6927),
                     onRatingUpdate: (rating) {
                       arrivalRating2.value = rating.toInt();
                       print(arrivalRating2.value);
                     },
                   ),
                   const SizedBox(height: 10),




                   Text('4. Neighbourhood and Surrounding', style: color00000s15w600),
                   const SizedBox(height: 5),
                   RatingBar.builder(
                     initialRating: amenitiesRating2.value.toDouble(),
                     minRating: 0,
                     direction: Axis.horizontal,
                     itemCount: 5,
                     itemSize: 20,
                     unratedColor: AppColors.color828282.withOpacity(0.8),
                     itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                     itemBuilder:
                         (context, _) =>
                         Icon(Icons.star, color: AppColors.colorFE6927),
                     onRatingUpdate: (rating) {
                       amenitiesRating2.value = rating.toInt();
                       print(amenitiesRating2.value);
                     },
                   ),
                   const SizedBox(height: 10),



                   Text('5. Value for Money', style: color00000s15w600),
                   const SizedBox(height: 5),
                   RatingBar.builder(
                     initialRating: valueRating2.value.toDouble(),
                     minRating: 0,
                     direction: Axis.horizontal,
                     itemCount: 5,
                     itemSize: 20,
                     unratedColor: AppColors.color828282.withOpacity(0.8),
                     itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                     itemBuilder:
                         (context, _) =>
                         Icon(Icons.star, color: AppColors.colorFE6927),
                     onRatingUpdate: (rating) {
                       valueRating2.value = rating.toInt();
                       print(valueRating2.value);
                     },
                   ),
                   const SizedBox(height: 10),




                   Text('6. Overall Experience', style: color00000s15w600),
                   const SizedBox(height: 5),
                   RatingBar.builder(
                     initialRating: locationRating2.value.toDouble(),
                     minRating: 0,
                     direction: Axis.horizontal,
                     itemCount: 5,
                     itemSize: 20,
                     unratedColor: AppColors.color828282.withOpacity(0.8),
                     itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                     itemBuilder:
                         (context, _) =>
                         Icon(Icons.star, color: AppColors.colorFE6927),
                     onRatingUpdate: (rating) {
                       locationRating2.value = rating.toInt();
                       print(locationRating2.value);
                     },
                   ),
                   const SizedBox(height: 10),

                   const SizedBox(height: 10),

                   Text('7. Add Descrption', style: color00000s15w600),

                   TextFormField(
                     controller: _improveStaying,
                     cursorColor: AppColors.colorFE6927,
                     maxLines: 3,
                     onEditingComplete: () {
                       FocusScope.of(context).unfocus(); // Hide keyboard when done is pressed
                     },
                     decoration: InputDecoration(
                       hintText: 'Descrption',
                       hintStyle: color828282s12w400,
                       floatingLabelBehavior: FloatingLabelBehavior.always,
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(6.0),
                         borderSide: BorderSide(
                           width: 1,
                           color: AppColors.color000000.withOpacity(0.5),
                         ),
                       ),
                       focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(6.0),
                         borderSide: BorderSide(
                           width: 1,
                           color: AppColors.color000000.withOpacity(0.5),
                         ),
                       ),
                       contentPadding: const EdgeInsets.all(13.0),
                     ),
                   ),

                   Align(
                     alignment: Alignment.center,
                     child: CommonButton(
                       onPressed: () async {

                         FocusScope.of(context).unfocus();
                         await InsightController.to.submitReview(
                           params: {
                             'booking_id': id,
                             'review_id': review_id,
                             "property_cleanliness":accuracyRating2.value,
                             "property_communication":cleanlinessRating2.value,
                             "accuracy":arrivalRating2.value,
                             "location":amenitiesRating2.value,
                             "value":valueRating2.value,
                             "property_experienc":locationRating2.value,
                             "description":_improveStaying.text.trim(),

                           },
                           success: (val) {


                             accuracyRating2.value=0;
                             cleanlinessRating2.value=0;
                             arrivalRating2.value=0;
                             amenitiesRating2.value=0;
                             valueRating2.value=0;
                             locationRating2.value=0;
                             _improveStaying.text="";





                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                 content: Text("Review Added successfully."),
                                 duration: const Duration(seconds: 2),
                               ),);
                             Get.back();
                             callapi();
                           },
                           error: (e) {
                           },
                         );








                       },
                       name: 'Submit',
                     ),
                   ),
                 ],
               ),
             ),
           ],
         ),
       ),
     );
   }

   showDialogForShowingReview(var data) {
     print(data['cleanliness']);
     print("111111");
     print("222222");
     return AlertDialog(
       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
       scrollable: true,
       content: SafeArea(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             const SizedBox(height: 12),
             Text(
               data['properties']?['name'] ?? '',
               style: color000000s12w400.copyWith(
                 fontWeight: FontWeight.w600,
                 fontSize: 20,
               ),
             ),
             const SizedBox(height: 12),
             const Divider(),
             const SizedBox(height: 12),
             Text(
               'Describe Your Experience',
               style: color00000s14w500.copyWith(
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
             ),
             const SizedBox(height: 8),
             Text(
               data['message'] ?? '',
               style: color00000s14w500.copyWith(
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
                 color: AppColors.color828282,
               ),
             ),
             const SizedBox(height: 12),
             Text(
               'Private Guest Feedback',
               style: color00000s14w500.copyWith(
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
             ),
             const SizedBox(height: 8),
             Text(
               data['secret_feedback'] ?? '',
               style: color00000s14w500.copyWith(
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
                 color: AppColors.color828282,
               ),
             ),
             const SizedBox(height: 12),
             Text(
               'Overall Experience',
               style: color00000s14w500.copyWith(
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
             ),
             const SizedBox(height: 8),
             RatingBar.builder(
               initialRating:data['rating']==null?0.0: double.parse(data['rating'].toString()),
               minRating: 0,
               direction: Axis.horizontal,
               itemCount: 5,
               itemSize: 20,
               ignoreGestures: true,
               unratedColor: AppColors.color828282.withOpacity(0.8),
               itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
               itemBuilder:
                   (context, _) =>
                   Icon(Icons.star, color: AppColors.colorFE6927),
               onRatingUpdate: (rating) {},
             ),

             const SizedBox(height: 12),
             Text(
               'Did the guest leave your space clean?',
               style: color00000s14w500.copyWith(
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
             ),
             const SizedBox(height: 8),
             RatingBar.builder(
               initialRating: double.parse(data['cleanliness'].toString()),
               minRating: 0,
               direction: Axis.horizontal,
               itemCount: 5,
               itemSize: 20,
               ignoreGestures: true,
               unratedColor: AppColors.color828282.withOpacity(0.8),
               itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
               itemBuilder:
                   (context, _) =>
                   Icon(Icons.star, color: AppColors.colorFE6927),
               onRatingUpdate: (rating) {},
             ),
             const SizedBox(height: 12),
             Text(
               'How clearly did the guest communicate their plans, questions, and concerns?',
               style: color00000s14w500.copyWith(
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
             ),
             const SizedBox(height: 8),
             RatingBar.builder(
               initialRating: double.parse(data['communication'].toString()),
               minRating: 0,
               direction: Axis.horizontal,
               itemCount: 5,
               itemSize: 20,
               ignoreGestures: true,
               unratedColor: AppColors.color828282.withOpacity(0.8),
               itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
               itemBuilder:
                   (context, _) =>
                   Icon(Icons.star, color: AppColors.colorFE6927),
               onRatingUpdate: (rating) {},
             ),
             const SizedBox(height: 12),
             Text(
               'Did the guest observe the house rules you provided?}',
               style: color00000s14w500.copyWith(
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
             ),
             const SizedBox(height: 8),
             RatingBar.builder(
               initialRating: data['house_rules']==null?0.0:double.parse(data['house_rules'].toString()),
               minRating: 0,
               direction: Axis.horizontal,
               itemCount: 5,
               itemSize: 20,
               ignoreGestures: true,
               unratedColor: AppColors.color828282.withOpacity(0.8),
               itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
               itemBuilder:
                   (context, _) =>
                   Icon(Icons.star, color: AppColors.colorFE6927),
               onRatingUpdate: (rating) {},
             ),
             const SizedBox(height: 12),
             const Divider(),
           ],
         ),
       ),
     );
   }


   showDialogForShowingABoutReviewReview(var data) {
     return AlertDialog(
       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
       scrollable: true,
       content: SafeArea(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             const SizedBox(height: 12),
             Text(
               data['property_name'] ?? '',
               style: color000000s12w400.copyWith(
                 fontWeight: FontWeight.w600,
                 fontSize: 20,
               ),
             ),
             const SizedBox(height: 12),
             const Divider(),
             const SizedBox(height: 12),
             Text(
               'Cleanliness Maintained by Guest',
               style: color00000s14w500.copyWith(
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
             ),
             const SizedBox(height: 8),
             RatingBar.builder(
               initialRating:data['cleanliness']==null?0.0: double.parse(data['cleanliness'].toString()),
               minRating: 0,
               direction: Axis.horizontal,
               itemCount: 5,
               itemSize: 20,
               ignoreGestures: true,
               unratedColor: AppColors.color828282.withOpacity(0.8),
               itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
               itemBuilder:
                   (context, _) =>
                   Icon(Icons.star, color: AppColors.colorFE6927),
               onRatingUpdate: (rating) {},
             ),
             const SizedBox(height: 12),
             Text(
               'On time check-in and check-out',
               style: color00000s14w500.copyWith(
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
             ),
             const SizedBox(height: 8),
             RatingBar.builder(
               initialRating:data['on_time_checkin']==null?0.0: double.parse(data['on_time_checkin'].toString()),
               minRating: 0,
               direction: Axis.horizontal,
               itemCount: 5,
               itemSize: 20,
               ignoreGestures: true,
               unratedColor: AppColors.color828282.withOpacity(0.8),
               itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
               itemBuilder:
                   (context, _) =>
                   Icon(Icons.star, color: AppColors.colorFE6927),
               onRatingUpdate: (rating) {},
             ),
             const SizedBox(height: 12),
             Text(
               'Easy Coordination before and during the stay',
               style: color00000s14w500.copyWith(
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
             ),
             const SizedBox(height: 8),
             RatingBar.builder(
               initialRating:data['communication']==null?0.0: double.parse(data['communication'].toString()),
               minRating: 0,
               direction: Axis.horizontal,
               itemCount: 5,
               itemSize: 20,
               ignoreGestures: true,
               unratedColor: AppColors.color828282.withOpacity(0.8),
               itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
               itemBuilder:
                   (context, _) =>
                   Icon(Icons.star, color: AppColors.colorFE6927),
               onRatingUpdate: (rating) {},
             ),

             const SizedBox(height: 12),
             Text(
               'Overall Experience',
               style: color00000s14w500.copyWith(
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
             ),
             const SizedBox(height: 8),
             RatingBar.builder(
               initialRating:data['rating']==null?0.0: double.parse(data['rating'].toString()),

               minRating: 0,
               direction: Axis.horizontal,
               itemCount: 5,
               itemSize: 20,
               ignoreGestures: true,
               unratedColor: AppColors.color828282.withOpacity(0.8),
               itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
               itemBuilder:
                   (context, _) =>
                   Icon(Icons.star, color: AppColors.colorFE6927),
               onRatingUpdate: (rating) {},
             ),
             const SizedBox(height: 12),
             Text(
               'Respect for House Rules',
               style: color00000s14w500.copyWith(
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
             ),
             const SizedBox(height: 8),
             RatingBar.builder(
               initialRating:data['house_rules']==null?0.0: double.parse(data['house_rules'].toString()),


               minRating: 0,
               direction: Axis.horizontal,
               itemCount: 5,
               itemSize: 20,
               ignoreGestures: true,
               unratedColor: AppColors.color828282.withOpacity(0.8),
               itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
               itemBuilder:
                   (context, _) =>
                   Icon(Icons.star, color: AppColors.colorFE6927),
               onRatingUpdate: (rating) {},
             ),

             const SizedBox(height: 12),
             const Divider(),
           ],
         ),
       ),
     );
   }


}
