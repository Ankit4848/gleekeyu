import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:gleekeyu/extras/app_colors.dart';
import 'package:gleekeyu/extras/commonWidget.dart';
import 'package:gleekeyu/extras/text_styles.dart';
import 'package:gleekeyu/src/SubPages/PropertyAllDetails/promocode_model.dart';
import 'package:gleekeyu/src/Menu/MyCoupons/coupon_card.dart';
import 'package:gleekeyu/src/Menu/MyCoupons/coupon_terms_conditions.dart';
import 'package:gleekeyu/src/SubPages/appBarWithTitleAndBack.dart';
import 'package:gleekeyu/src/SubPages/PropertyAllDetails/propertyAllDetails_view.dart';
import 'package:gleekeyu/utils/baseconstant.dart';

import 'package:gleekeyu/src/Auth/Login/userLogin_controller.dart';
import 'package:gleekeyu/src/HomePage/homePage_view.dart';
import 'my_coupons_controller.dart';

class MyCouponsScreen extends StatelessWidget {
  const MyCouponsScreen({Key? key}) : super(key: key);

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return '-';
    }
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (_) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyCouponsController>(
      init: MyCouponsController(),
      builder: (controller) {
        final args = Get.arguments;
        final userController = UserLoginController.to;
        final fromArgs = args is Map && (args['openAddPopup'] == true);
        final fromFlag = userController.openAddCouponPopup;
        final shouldOpenPopup = (fromArgs || fromFlag);

        if (shouldOpenPopup && !controller.initialPopupShown) {
          controller.initialPopupShown = true;
          userController.openAddCouponPopup = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showAddCouponDialog();
          });
        }

        return WillPopScope(
          onWillPop: () async {
            if (userController.backToHomeFromCoupons) {
              userController.backToHomeFromCoupons = false;
              Get.offAll(() => const HomePage());
              return false;
            }
            return true;
          },
          child: Scaffold(
            backgroundColor: AppColors.colorF8F8F8,
            appBar: AppBarWithTitleAndBack(
              title: "My Coupons",
              onBack: () {
                if (userController.backToHomeFromCoupons) {
                  userController.backToHomeFromCoupons = false;
                  Get.offAll(() => const HomePage());
                } else {
                  Get.back();
                }
              },
              actions: [
                IconButton(
                  onPressed: () {
                    Get.to(() => const CouponTermsConditions());
                  },
                  icon: const Icon(Icons.info_outline, color: Colors.black),
                  tooltip: 'Terms & Conditions',
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: controller.searchController,
                          hintText: 'Search',
                          suffixIcon: const Icon(Icons.search, size: 20),
                          onChange: controller.onSearchChanged,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child:
                        controller.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : controller.filteredCoupons.isEmpty
                            ? Center(
                              child: Text(
                                'No coupons found',
                                style: color828282s15w500,
                              ),
                            )
                            : ListView.builder(
                              itemCount: controller.filteredCoupons.length,
                              itemBuilder: (context, index) {
                                final PromocodeModel coupon =
                                    controller.filteredCoupons[index];

                                final title =
                                    coupon.coupon_name ?? coupon.title ?? '';
                                final code = coupon.code ?? '';
                                final expiry = _formatDate(coupon.validTill);
                                final discount =
                                    '${coupon.codeAmount ?? ''}${(coupon.promoCodeType ?? '').toLowerCase() == "percentage" ? "%" : ""}';

                                final List<Color> cardColors = [
                                  AppColors.colorFE6927,
                                  const Color(0xFF0F9D58),
                                  const Color(0xFF4285F4),
                                  const Color(0xFF673AB7),
                                ];

                                final Color cardColor =
                                    cardColors[index % cardColors.length];

                                return Stack(
                                  children: [
                                    CouponCard(
                                      title: title,
                                      code: code,
                                      expiryDate: expiry,
                                      discount: discount,
                                      backgroundColor: cardColor,
                                    ),
                                    if (coupon.is_all != "1")
                                      Positioned(
                                        top: 20,
                                        right: 40,
                                        child: GestureDetector(
                                          onTap: () {
                                            _showCouponDetailsDialog(coupon);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0,
                                              vertical: 4.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.15,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              border: Border.all(
                                                color: Colors.white.withOpacity(
                                                  0.35,
                                                ),
                                                width: 0.8,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Text(
                                                  "View Properties",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.colorFE6927,
              onPressed: () {
                _showAddCouponDialog();
              },
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }

  void _showAddCouponDialog() {
    final TextEditingController couponController = TextEditingController();
    bool shake = false;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFFF8F8F8),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.colorFE6927.withOpacity(0.95),
                          AppColors.colorFE6927.withOpacity(0.75),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.local_offer,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Add Coupon',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: AppColors.colorFE6927,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Access your personal coupon',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Enter your code below to unlock a discount on your next booking.',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Coupon Code', style: color00000s14w500),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 80),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.symmetric(horizontal: shake ? 8 : 0),
                    child: CustomTextField(
                      controller: couponController,
                      hintText: 'Enter coupon code',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.check_circle, size: 18, color: Colors.green),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Please enter the coupon code in the following format: XXXX-0000',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF828282),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.center,
                    child: CommonButton(
                      name: 'Apply Coupon',
                      width: 200,
                      onPressed: () async {
                        final code = couponController.text.trim();
                        if (code.isEmpty) {
                          HapticFeedback.vibrate();
                          setState(() {
                            shake = true;
                          });
                          Future.delayed(const Duration(milliseconds: 120), () {
                            if (Get.isDialogOpen ?? false) {
                              setState(() {
                                shake = false;
                              });
                            }
                          });
                          Get.snackbar(
                            'Add Coupons',
                            'Please enter coupon code',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        Get.back();

                        final controller = Get.find<MyCouponsController>();
                        final success = await controller.addCoupon(code);

                        Get.snackbar(
                          'My Coupons',
                          success
                              ? 'Coupon "$code" added successfully'
                              : 'Failed to add coupon',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCouponDetailsDialog(PromocodeModel coupon) {
    final controller = Get.find<MyCouponsController>();

    Get.bottomSheet(
      SizedBox(
        height: Get.height * 0.90,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Applicable Properties',
                          style: color00000s18w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    coupon.coupon_name ?? coupon.title ?? '',
                    style: color828282s12w400,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: controller.fetchCouponProperties(
                        coupon.batch_id ?? '',
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Failed to load properties',
                              style: color828282s12w400,
                            ),
                          );
                        }

                        List<dynamic> data = snapshot.data ?? [];
                        if (data.isEmpty) {
                          data = [
                            {
                              'property_name': 'Ocean View Apartment',
                              'city': 'Surat',
                              'address': 'Near City Center',
                              'image':
                                  'https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg',
                            },
                            {
                              'property_name': 'Hilltop Villa',
                              'city': 'Mumbai',
                              'address': 'Hill Road',
                              'image':
                                  'https://images.pexels.com/photos/261187/pexels-photo-261187.jpeg',
                            },
                            {
                              'property_name': 'City Lights Studio',
                              'city': 'Delhi',
                              'address': 'Downtown',
                              'image':
                                  'https://images.pexels.com/photos/439227/pexels-photo-439227.jpeg',
                            },
                            {
                              'property_name': 'Skyline Loft',
                              'city': 'Pune',
                              'address': 'Central Avenue',
                              'image':
                                  'https://images.pexels.com/photos/323780/pexels-photo-323780.jpeg',
                            },
                          ];
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.72,
                                ),
                            physics:
                                data.length <= 4
                                    ? const NeverScrollableScrollPhysics()
                                    : const BouncingScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final item = data[index];
                              String name = 'Property ${index + 1}';
                              String subtitle = '';
                              String imageUrl = '';
                              String slug = '';
                              String id = '';
                              bool isPropertyActive = true;

                              if (item is Map<String, dynamic>) {
                                Map<String, dynamic> source = item;

                                if (item['properties']
                                    is Map<String, dynamic>) {
                                  source =
                                      item['properties']
                                          as Map<String, dynamic>;
                                }

                                name =
                                    (source['property_name'] ??
                                            source['name'] ??
                                            source['title'] ??
                                            name)
                                        .toString();
                                subtitle =
                                    (source['city'] ??
                                            source['location'] ??
                                            source['address'] ??
                                            '')
                                        .toString();

                                slug = (source['slug'] ?? '').toString();
                                id = (source['id'] ?? '').toString();
                                final statusStr =
                                    (source['property_status'] ?? '')
                                        .toString();
                                isPropertyActive = statusStr != 'Inactive';

                                final rawImage =
                                    (source['cover_photo'] ??
                                            source['image'] ??
                                            '')
                                        .toString();
                                if (rawImage.startsWith('http')) {
                                  imageUrl = rawImage;
                                } else if (rawImage.isNotEmpty) {
                                  imageUrl =
                                      BaseConstant.BASE_PROPERTY_IMG_URL +
                                      rawImage;
                                } else {
                                  imageUrl = '';
                                }
                              }

                              return GestureDetector(
                                onTap: () {
                                  if (slug.isNotEmpty && id.isNotEmpty) {
                                    Get.to(
                                      () => PropertyAllDetails(
                                        slug: slug,
                                        id: id,
                                        fromSearch: false,
                                        startDate: '',
                                        endDate: '',
                                        isPropertyActive: isPropertyActive,
                                      ),
                                    );
                                  }
                                },
                                child: Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  color: Colors.white,
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 120,
                                        width: double.infinity,
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              color: Colors.grey.shade300,
                                              child: const Icon(
                                                Icons.apartment,
                                                size: 40,
                                                color: Colors.white70,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            if (subtitle.isNotEmpty)
                                              Text(
                                                subtitle,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: const [
                                                Text(
                                                  '₹5200',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 6),
                                                Icon(
                                                  Icons.star,
                                                  size: 14,
                                                  color: Colors.amber,
                                                ),
                                                SizedBox(width: 2),
                                                Text(
                                                  '4.5',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
