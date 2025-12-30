import 'package:flutter/material.dart';
import 'package:gleekeyu/extras/app_colors.dart';
import 'package:gleekeyu/src/SubPages/appBarWithTitleAndBack.dart';

class CouponTermsConditions extends StatelessWidget {
  const CouponTermsConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> terms = [
      'Validity: This coupon is valid until the expiry date.',
      'Applicable Days: Valid on both weekdays and weekends.',
      'Booking Confirmation: Dates and booking approval are subject to the property owner\'s availability.',
      'Cancellation Policy: Guests must review the Gleekey.in cancellation policy before booking.',
      'Discount Scope: Coupon is valid only on stay charges. Any additional facilities or services (meals, activities, amenities, etc.) will be charged extra and payable directly at the property.',
      'Single Use: Coupon can be used only once per booking.',
      'Non-Transferable: Coupon is non-transferable and cannot be exchanged for cash.',
      'Not Combinable: Cannot be clubbed with any other offer, discount, or promotion.',
      'Platform Restriction: Valid only for bookings made through Gleekey.in.',
      'Misuse Clause: Gleekey.in reserves the right to cancel or withdraw the coupon in case of misuse or violation of terms.',
      'Price Variability: Final prices may vary depending on season, occupancy, and individual property policies.',
      'Website Policies: For all other terms, conditions, and policies, please refer to the official guidelines available on our website: Gleekey.in.',
    ];

    return Scaffold(
      backgroundColor: AppColors.colorF8F8F8,
      appBar: AppBarWithTitleAndBack(title: "Terms & Conditions"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Gleekey.in Promotional Coupon',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please read the following terms carefully before using your coupon.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...terms.map((term) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.colorFE6927,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              term,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
