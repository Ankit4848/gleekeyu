import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../../../extras/app_colors.dart';
import '../../../../extras/text_styles.dart';

class ReviewScreenPast extends StatelessWidget {
  final Map<String, dynamic> data;
  const ReviewScreenPast({super.key, required this.data});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "${data['properties']['name']}",
                        style: color00000s18w600,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0,
                    child: IgnorePointer(
                      ignoring: true,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  endIndent: 10,
                  indent: 10,
                  color: AppColors.color000000.withOpacity(0.1),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                Text('Communication with Host/Caretaker',style: color00000s15w600),
                                SizedBox(height: 5,),
                                RatingBar.builder(
                                  initialRating: double.parse((data['communication_host'] ?? '0').toString()),
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
                            SizedBox(height: 5,),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Over all ratings to Host/caretaker', style: color00000s15w600),
                            SizedBox(height: 5,),
                            RatingBar.builder(
                              initialRating: double.parse(
                                  (data['rating'] ?? 0).toString()),
                              minRating: 1,
                              ignoreGestures: true,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              unratedColor: AppColors.colorD9D9D9,
                              itemPadding: const EdgeInsets.symmetric(
                                  horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: AppColors.colorFE6927,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                            SizedBox(height: 5,),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Host/Caretaker’s support and behaviour', style: color00000s15w600),
                            SizedBox(height: 5,),
                            RatingBar.builder(
                              initialRating: double.parse((data['host_support'] ?? 0).toString()),
                              minRating: 1,
                              ignoreGestures: true,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              unratedColor: AppColors.colorD9D9D9,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: AppColors.colorFE6927,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                            SizedBox(height: 5,),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Hygiene standards',
                                style: color00000s15w600),
                            SizedBox(height: 5,),
                            RatingBar.builder(
                              initialRating: double.parse(
                                  (data['property_cleanliness'] ?? 0).toString()),
                              minRating: 1,
                              ignoreGestures: true,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              unratedColor: AppColors.colorD9D9D9,
                              itemPadding: const EdgeInsets.symmetric(
                                  horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: AppColors.colorFE6927,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                            SizedBox(height: 5,),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Responsiveness of Host',
                                style: color00000s15w600),
                            SizedBox(height: 5,),
                            RatingBar.builder(
                              initialRating: double.parse(
                                  (data['property_communication'] ?? 0).toString()),
                              minRating: 1,
                              ignoreGestures: true,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              unratedColor: AppColors.colorD9D9D9,
                              itemPadding: const EdgeInsets.symmetric(
                                  horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: AppColors.colorFE6927,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                            SizedBox(height: 5,),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Photos to Reality',
                                style: color00000s15w600),
                            SizedBox(height: 5,),
                            RatingBar.builder(
                              initialRating: double.parse(
                                  (data['accuracy'] ?? 0).toString()),
                              minRating: 1,
                              ignoreGestures: true,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              unratedColor: AppColors.colorD9D9D9,
                              itemPadding: const EdgeInsets.symmetric(
                                  horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: AppColors.colorFE6927,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                            SizedBox(height: 5,),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Neighbourhood and Surroundings',
                                style: color00000s15w600),
                            SizedBox(height: 5,),
                            RatingBar.builder(
                              initialRating: double.parse(
                                  (data['property_experienc'] ?? 0).toString()),
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
                            SizedBox(height: 5,),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Value for Money',
                                style: color00000s15w600),
                            SizedBox(height: 5,),
                            RatingBar.builder(
                              initialRating: double.parse(
                                  (data['value'] ?? 0).toString()),
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
                            SizedBox(height: 5,),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Overall Experience',
                                style: color00000s15w600),
                            SizedBox(height: 5,),
                            RatingBar.builder(
                              initialRating: double.parse((data['communication_host'] ?? 0).toString()),
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
                            SizedBox(height: 5,),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description',
                                style: color00000s15w600),
                            SizedBox(height: 5,),
                            Text(
                              data['description'] ?? '',
                              style: color50perBlacks13w400,
                            ),
                            SizedBox(height: 5,),
                            Divider(
                              endIndent: 10,
                              indent: 10,
                              color: AppColors.color000000.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
