// ignore_for_file: must_be_immutable, depend_on_referenced_packages, use_build_context_synchronously, equal_elements_in_set

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
import 'package:gleekeyu/widgets/showSnackBar.dart';
import 'package:intl/intl.dart';

import 'package:gleekeyu/extras/app_colors.dart';
import 'package:gleekeyu/extras/commonWidget.dart';
import 'package:gleekeyu/src/SubPages/Payment%20Methods/paymentMethod_controller.dart';
import 'package:gleekeyu/src/SubPages/PropertyAllDetails/propertyAllDetails_controller.dart';
import 'package:gleekeyu/src/SubPages/SearchPlaces/searchPlaces_controller.dart';
import 'package:gleekeyu/src/SubPages/appBarWithTitleAndBack.dart';
import 'package:gleekeyu/src/SubPages/confirm_n_pay/confirm_n_pay_controller.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/widgets/text_fields_widgets/custom_textfield_common.dart';
import 'package:gleekeyu/widgets/text_fields_widgets/custrom_textfield_paragraph.dart';

import '../../../services/razorpay_controller.dart';
import '../../../utils/style/palette.dart';
import '../PropertyAllDetails/propertyAllDetails_view.dart';

class ConfirmNpay extends StatefulWidget {
  String coverImg;
  int totalPrice;
  String propertyType;
  String propertyID;
  List<SelectedDateWithPrice> selectedDates;
  String? bookingID;
  String? gstTex;
  Map<String, dynamic>? bookingData;

  ConfirmNpay(
      {super.key,
      required this.selectedDates,
      required this.coverImg,
      required this.totalPrice,
      required this.propertyType,
      required this.propertyID,
      this.bookingID,
      this.gstTex,
      this.bookingData});

  @override
  State<ConfirmNpay> createState() => _ConfirmNpayState();
}

class _ConfirmNpayState extends State<ConfirmNpay> {
  final ConfrimNPayController a = Get.put(ConfrimNPayController());
  PropertyAllDetailsController getController =
      Get.put(PropertyAllDetailsController());
  RazorPayController getRazorpayController = Get.put(RazorPayController());
  @override
  void initState() {
    a.paymentOption = PaymentOption.Full;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Get.put(PaymentMethodController());
    a.checkDayDuration(
        startDate: widget.selectedDates[0].date ?? DateTime.now().toString());
    return Scaffold(
      appBar: AppBarWithTitleAndBack(title: "Confirm & Pay"),
      body: SingleChildScrollView(
        child: Container(
          color: kWhite,
          padding: const EdgeInsets.all(22),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: kOrange,
                    width: 1.3,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.coverImg.toString(),
                      imageBuilder: (context, imageProvider) => Container(
                        height: 145,

                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      memCacheHeight: 110,
                      memCacheWidth: 110,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Price ",
                                style: Palette.paymentBlack13,
                              ),
                              Text(
                                "(${widget.selectedDates.length} Night)",
                                style: Palette.paymentGrey13,
                              ),
                              const Spacer(),
                              Text(
                                format.format(widget.bookingData== null ? widget.totalPrice : widget.bookingData!['per_night'] * widget.selectedDates.length),
                                style: Palette.paymentBlack13,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Bounce(
                            onPressed: () {
                              a.isPriceBreakup = !a.isPriceBreakup;
                              a.update();
                            },
                            duration: const Duration(milliseconds: 150),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical:  8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "View Price Breakup",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: kOrange,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                  SizedBox()
                                ],
                              ),
                            ),
                          ),
                          Obx(() {
                            if (getController.coupenCode.isNotEmpty &&
                                a.paymentOption == PaymentOption.Full &&
                                widget.bookingID == null) {
                              return Container(
                                margin: const EdgeInsets.only(top: 12),
                                width: double.maxFinite,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.grey.shade200,
                                    border: Border.all(
                                        color: Colors.grey.shade500)),
                                child: Text(getController.coupenCode.value),
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                          if (widget.bookingID == null) ...{
                            GetBuilder<ConfrimNPayController>(
                              initState: (a) {},
                              builder: (a) {
                                return Column(
                                  children: [
                                    Visibility(
                                      visible: a.checkDayDuration(
                                              startDate: widget
                                                      .selectedDates[0].date ??
                                                  DateTime.now().toString()) >=
                                          7,
                                      child: RadioListTile<PaymentOption>(
                                        visualDensity: const VisualDensity(
                                            horizontal:
                                                VisualDensity.minimumDensity,
                                            vertical:
                                                VisualDensity.minimumDensity),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        title:
                                            const Text('50% Payment Advance'),
                                        activeColor: Colors.blue,
                                        groupValue: a.paymentOption,
                                        value: PaymentOption.Advance,
                                        onChanged:
                                            (PaymentOption? value) async {
                                          a.onChange(
                                              value ?? PaymentOption.Advance);
                                          await getController.priceUpdate(
                                              paymentOption: a.paymentOption);
                                          setState(() {});
                                          showDialog(
                                            context: context,
                                            barrierColor: Colors.transparent,
                                            builder: (context) {
                                              return dialogFor50Payment(
                                                  context, a);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    RadioListTile<PaymentOption>(
                                      visualDensity: const VisualDensity(
                                          horizontal:
                                              VisualDensity.minimumDensity,
                                          vertical:
                                              VisualDensity.minimumDensity),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      title: const Text('Full Payment'),
                                      activeColor: Colors.blue,
                                      groupValue: a.paymentOption,
                                      value: PaymentOption.Full,
                                      onChanged: (PaymentOption? value) {
                                        a.onChange(
                                          value ?? PaymentOption.Full,
                                        );
                                        getController.priceUpdate(
                                          paymentOption: a.paymentOption,
                                        );
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          },
                          GetBuilder<ConfrimNPayController>(
                            initState: (a) {},
                            builder: (a) {
                              return Visibility(
                                visible: a.isPriceBreakup,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: ListView.separated(
                                    itemCount: widget.bookingID == null
                                        ? getController
                                            .selectedDateWithPrice.length
                                        : widget.selectedDates.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      print(
                                          "dshjdscahjdsvchjdfsvhj : ${widget.selectedDates[index].originalPrice?.toString().replaceAll(' ', '').replaceAll(',', '')}");
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: a.paymentOption ==
                                                    PaymentOption.Full
                                                ? Text(
                                                    "${widget.selectedDates[index].date} (Tax ${widget.selectedDates[index].ivataxGstPer}% ${format.format((double.parse(widget.selectedDates[index].perDayTax?.toString().replaceAll(' ', '').replaceAll(',', '') ?? '0')).customRound())})",
                                                    style: Palette
                                                            .GreyText12w500
                                                        .copyWith(
                                                            color:
                                                                Colors.black54),
                                                  )
                                                : Text(
                                                    widget.bookingData == null
                                                        ? "${widget.selectedDates[index].date} (Tax ${(widget.selectedDates[index].originalPrice ?? 0) >= 7500 ? '18' : '12'}%  ${format.format(((double.parse(widget.selectedDates[index].originalPrice?.toString().replaceAll(' ', '').replaceAll(',', '') ?? '0') >= 7500 ? ((double.parse(widget.selectedDates[index].originalPrice?.toString().replaceAll(' ', '').replaceAll(',', '') ?? '0')) * 18).customRound() : (double.parse(widget.selectedDates[index].originalPrice?.toString().replaceAll(' ', '').replaceAll(',', '') ?? '0')).customRound() * 12) / 100).customRound())})"
                                                        : "${widget.selectedDates[index].date} (Tax ${(widget.selectedDates[index].price ?? 0) >= 7500 ? '18' : '12'}%  ${format.format(((double.parse(widget.selectedDates[index].price?.toString().replaceAll(' ', '').replaceAll(',', '') ?? '0') >= 7500 ? ((double.parse(widget.selectedDates[index].price?.toString().replaceAll(' ', '').replaceAll(',', '') ?? '0')) * 18).customRound() : (double.parse(widget.selectedDates[index].price?.toString().replaceAll(' ', '').replaceAll(',', '') ?? '0')).customRound() * 12) / 100).customRound())})",
                                                    style: Palette
                                                            .GreyText12w500
                                                        .copyWith(
                                                            color:
                                                                Colors.black54),
                                                  ),
                                          ),
                                          // const Spacer(),
                                          if (a.paymentOption ==
                                                      PaymentOption.Full &&
                                                  getController
                                                      .isOfferApplied.value &&
                                                  getController
                                                          .selectedDateWithPrice[
                                                              index]
                                                          .originalPrice
                                                          .toString() !=
                                                      (getController
                                                              .selectedDateWithPrice[
                                                                  index]
                                                              .price
                                                              .toString()
                                                              .replaceAll(
                                                                  "₹", '')
                                                              .replaceAll(
                                                                  " ", '')
                                                              .replaceAll(
                                                                  ",", '')
                                                              .toString())
                                                          .trim() /*(getController
                                                            .PropertyData!
                                                            .result!
                                                            .noOfDiscountBooking !=
                                                        null &&
                                                    (int.parse(getController
                                                                .PropertyData!
                                                                .result!
                                                                .totalBooking
                                                                .toString()) -
                                                            500) <
                                                        int.parse(getController
                                                            .PropertyData!
                                                            .result!
                                                            .noOfDiscountBooking
                                                            .toString()))*/
                                              ) ...{
                                            Text(
                                              format.format(widget
                                                  .selectedDates[index]
                                                  .originalPrice),
                                              style: Palette.paymentBlack13
                                                  .copyWith(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: kDarkGrey,
                                              ),
                                            ),
                                            Text(
                                              " / ${format.format((double.parse((widget.selectedDates[index].price.toString().replaceAll("₹", '').replaceAll(" ", '').replaceAll(",", '').toString()).trim())).customRound())}",
                                              style: Palette.paymentBlack13,
                                            ),
                                          } else ...{
                                            Text(
                                              widget.bookingID == null
                                                  ? format.format(widget
                                                      .selectedDates[index]
                                                      .originalPrice)
                                                  : format.format((double.parse(
                                                          (widget
                                                                  .selectedDates[
                                                                      index]
                                                                  .price
                                                                  .toString()
                                                                  .replaceAll(
                                                                      "₹", '')
                                                                  .replaceAll(
                                                                      " ", '')
                                                                  .replaceAll(
                                                                      ",", '')
                                                                  .toString())
                                                              .trim()))
                                                      .customRound()),
                                              style: Palette.paymentBlack13,
                                            ),
                                          }
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 8,
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subtotal",
                                style: Palette.paymentBlack13
                                    .copyWith(fontSize: 15),
                              ),
                              Text(
                                 format.format(widget.bookingData== null ? widget.totalPrice : widget.bookingData!['per_night'] * widget.selectedDates.length),
                                style: Palette.paymentBlack13
                                    .copyWith(fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          if (a.paymentOption == PaymentOption.Full &&
                              getController.isCoupenApplied.value &&
                              widget.bookingID == null) ...{
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Offer ( ${(getController.offerPercentage.value)}%)",
                                  style: Palette.paymentBlack13
                                      .copyWith(fontSize: 15),
                                ),
                                Text(
                                  "- ${format.format(getController.totalDiscount?.customRound() ?? 0)}",
                                  style: Palette.paymentBlack13
                                      .copyWith(fontSize: 15, color: kRed),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              'This offer is applicable only for full payments.',
                              style: Palette.detailText2.copyWith(color: kRed),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Subtotal",
                                  style: Palette.paymentBlack13
                                      .copyWith(fontSize: 15),
                                ),
                                Text(
                                  format.format(getController
                                          .totalPriceAfterDiscount
                                          ?.customRound() ??
                                      0),
                                  style: Palette.paymentBlack13
                                      .copyWith(fontSize: 15, color: kBlack),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          } else if (a.paymentOption == PaymentOption.Full &&
                                  getController.isOfferApplied.value &&
                                  widget.bookingID ==
                                      null /*(getController.PropertyData!.result!
                                            .noOfDiscountBooking !=
                                        null) &&
                                    (getController.PropertyData?.result
                                                ?.totalBooking -
                                            500) <
                                        int.parse(getController.PropertyData
                                            ?.result!.noOfDiscountBooking)*/
                              ) ...{
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Offer ( ${(getController.PropertyData!.result!.noOfDiscountBooking != null) &&
                                      (getController.PropertyData?.result?.totalBooking - 500) <
                                          int.parse(getController.PropertyData?.result!.noOfDiscountBooking) ?
                                  getController.PropertyData!.result!.isFirstBooking : getController.offerPercentage}%)",
                                  style: Palette.paymentBlack13
                                      .copyWith(fontSize: 15),
                                ),
                                Text(
                                  "- ${format.format(getController.totalDiscount?.customRound() ?? 0)}",
                                  style: Palette.paymentBlack13
                                      .copyWith(fontSize: 15, color: kRed),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              'This offer is applicable only for full payments.',
                              style: Palette.detailText2.copyWith(color: kRed),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Subtotal",
                                  style: Palette.paymentBlack13
                                      .copyWith(fontSize: 15),
                                ),
                                Text(
                                  format.format(getController
                                          .totalPriceAfterDiscount
                                          ?.customRound() ??
                                      0),
                                  style: Palette.paymentBlack13
                                      .copyWith(fontSize: 15, color: kBlack),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          } else if (a.paymentOption == PaymentOption.Full &&
                              getController.isCoupenApplied.value &&
                              widget.bookingID == null) ...{
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (getController.dateprice != null &&
                                    getController.dateprice!.isNotEmpty)
                                  Text(
                                    "Offer (${getController.dateprice![0].discountPercentage}%)",
                                    style: Palette.paymentBlack13
                                        .copyWith(fontSize: 15),
                                  ),
                                Text(
                                  "- ${format.format(getController.totalDiscount?.customRound() ?? 0)}",
                                  style: Palette.paymentBlack13
                                      .copyWith(fontSize: 15, color: kRed),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              'This offer is applicable only for full payments.',
                              style: Palette.detailText2.copyWith(color: kRed),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Subtotal",
                                  style: Palette.paymentBlack13
                                      .copyWith(fontSize: 15),
                                ),
                                Text(
                                  format.format(getController
                                          .totalPriceAfterDiscount
                                          ?.customRound() ??
                                      0),
                                  style: Palette.paymentBlack13
                                      .copyWith(fontSize: 15, color: kBlack),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          },
                          // if (a.paymentOption == PaymentOption.Full &&
                          //     ((getController.PropertyData!.result!
                          //                 .noOfDiscountBooking !=
                          //             null) &&
                          //         (getController.PropertyData?.result
                          //                     ?.totalBooking -
                          //                 500) <
                          //             int.parse(getController.PropertyData
                          //                 ?.result!.noOfDiscountBooking))) ...{
                          //   Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text(
                          //         "Offer (${getController.PropertyData!.result!.isFirstBooking}%)",
                          //         style: Palette.paymentBlack13
                          //             .copyWith(fontSize: 15),
                          //       ),
                          //       Text(
                          //         "- ₹${getController.totalDiscount}",
                          //         style: Palette.paymentBlack13
                          //             .copyWith(fontSize: 15, color: kRed),
                          //       ),
                          //     ],
                          //   ),
                          //   const SizedBox(
                          //     height: 3,
                          //   ),
                          //   Text(
                          //     'This offer is applicable only for full payments.',
                          //     style: Palette.detailText2.copyWith(color: kRed),
                          //   ),
                          //   const SizedBox(
                          //     height: 8,
                          //   ),
                          //   Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text(
                          //         "Subtotal",
                          //         style: Palette.paymentBlack13
                          //             .copyWith(fontSize: 15),
                          //       ),
                          //       Text(
                          //         "₹${getController.totalPriceAfterDiscount}",
                          //         style: Palette.paymentBlack13
                          //             .copyWith(fontSize: 15, color: kBlack),
                          //       ),
                          //     ],
                          //   ),
                          //   const SizedBox(
                          //     height: 5,
                          //   ),
                          // },

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Goods and Service Tax",
                                style: Palette.paymentBlack13.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.gstTex != null
                                    ? "+ ${format.format((double.parse(widget.gstTex ?? '0')).customRound())}"
                                    : a.paymentOption == PaymentOption.Full
                                        ? "+ ${format.format(getController.totalGST?.customRound() ?? 0)}"
                                        : "+ ${format.format(getController.totalGSTWithoutOffer?.customRound() ?? 0)}",
                                style: Palette.paymentBlack13.copyWith(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Divider(),
                          if (widget.bookingID == null) ...{
                            GetBuilder<ConfrimNPayController>(builder: (a) {
                              return Row(
                                children: [
                                  Text(
                                    "Advance Payment",
                                    style: Palette.paymentBlack13
                                        .copyWith(fontSize: 15),
                                  ),
                                  const Spacer(),
                                  if (a.paymentOption == PaymentOption.Full &&
                                          (getController
                                                  .isCoupenApplied.value ||
                                              getController
                                                  .isOfferApplied.value)
                                      // ((getController.PropertyData!.result!
                                      //             .noOfDiscountBooking !=
                                      //         null) &&
                                      //     (getController.PropertyData?.result
                                      //                 ?.totalBooking -
                                      //             500) <
                                      //         int.parse(getController
                                      //             .PropertyData
                                      //             ?.result!
                                      //             .noOfDiscountBooking))

                                      ) ...{
                                    Text(
                                      a.paymentOption == PaymentOption.Full
                                          ? format.format((getController
                                                      .totalPriceAfterDiscount ??
                                                  0) +
                                              (getController.totalGST ?? 0)
                                                  .customRound())
                                          : format.format((((getController
                                                              .totalPrice ??
                                                          0) +
                                                      (getController.totalGST ??
                                                          0)) /
                                                  2)
                                              .customRound()),
                                      style: Palette.paymentBlack13
                                          .copyWith(fontSize: 15),
                                    ),
                                  } else ...{
                                    Text(
                                      a.paymentOption == PaymentOption.Full
                                          ? format.format(widget.totalPrice +
                                              (getController.totalGST ?? 0)
                                                  .customRound())
                                          : format.format(((double.parse(getController
                                                                  .totalGST
                                                                  ?.customRound()
                                                                  .toString() ??
                                                              '0')
                                                          .customRound() +
                                                      (getController
                                                              .totalPrice ??
                                                          0)) /
                                                  2)
                                              .customRound()),
                                      style: Palette.paymentBlack13
                                          .copyWith(fontSize: 15),
                                    ),
                                  }
                                ],
                              );
                            }),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
                                  style: Palette.paymentBlack13
                                      .copyWith(fontSize: 15),
                                ),
                                if (a.paymentOption == PaymentOption.Full &&
                                        (getController.isCoupenApplied.value ||
                                            getController.isOfferApplied.value)
                                    // ((getController.PropertyData!.result!
                                    //             .noOfDiscountBooking !=
                                    //         null) &&
                                    //     (getController.PropertyData?.result
                                    //                 ?.totalBooking -
                                    //             500) <
                                    //         int.parse(getController
                                    //             .PropertyData
                                    //             ?.result!
                                    //             .noOfDiscountBooking))

                                    ) ...{
                                  Text(
                                    format.format(double.parse(getController
                                                .totalGST
                                                ?.customRound()
                                                .toString() ??
                                            '0') +
                                        (getController.totalPriceAfterDiscount
                                                ?.customRound() ??
                                            0)),
                                    style: Palette.paymentBlack13
                                        .copyWith(fontSize: 15),
                                  ),
                                } else ...{
                                  Text(
                                    format.format(
                                      double.parse(getController.totalGST
                                                      ?.customRound()
                                                      .toString() ??
                                                  '0')
                                              .customRound() +
                                          (getController.totalPrice ?? 0),
                                    ),
                                    style: Palette.paymentBlack13
                                        .copyWith(fontSize: 15),
                                  ),
                                }
                              ],
                            ),
                          } else ...{
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
                                  style: Palette.paymentBlack13.copyWith(
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  format.format(widget.totalPrice),
                                  style: Palette.paymentBlack13
                                      .copyWith(fontSize: 15),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Paid Payment",
                                  style: Palette.paymentBlack13.copyWith(
                                    fontSize: 15,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  format.format(
                                    (widget.totalPrice / 2).customRound(),
                                  ),
                                  style: Palette.paymentBlack13
                                      .copyWith(fontSize: 15),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Remain Payment",
                                  style: Palette.paymentBlack13
                                      .copyWith(fontSize: 15),
                                ),
                                const Spacer(),
                                Text(
                                  format.format(
                                      (widget.totalPrice / 2).customRound()),
                                  style: Palette.paymentBlack13
                                      .copyWith(fontSize: 15),
                                ),
                              ],
                            ),
                          }

                          // GetBuilder<ConfrimNPayController>(
                          //   initState: (a) {},
                          //   builder: (a) {
                          //     return Visibility(
                          //       visible: a.isPriceBreakup,
                          //       child: Padding(
                          //         padding: const EdgeInsets.only(top: 8),
                          //         child: ListView.separated(
                          //           itemCount: selectedDates.length,
                          //           shrinkWrap: true,
                          //           itemBuilder: (context, index) {
                          //             return Row(
                          //               children: [
                          //                 Text(
                          //                     "${selectedDates[index].date} ( Tax ${double.parse(selectedDates[index].price) >= 7500 ? "18%" : "12%"} ${selectedDates[index].tax} )",
                          //                     style: Palette.GreyText12w500
                          //                         .copyWith(
                          //                             color: Colors.black54)),
                          //                 const Spacer(),
                          //                 Text(
                          //                   "₹${selectedDates[index].price}",
                          //                   style: Palette.paymentBlack13,
                          //                 ),
                          //               ],
                          //             );
                          //           },
                          //           separatorBuilder: (context, index) {
                          //             return const SizedBox(
                          //               height: 8,
                          //             );
                          //           },
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          // const SizedBox(
                          //   height: 8,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       "Subtotal",
                          //       style: Palette.paymentBlack13
                          //           .copyWith(fontSize: 15),
                          //     ),
                          //     Text(
                          //       "₹$totalPrice",
                          //       style: Palette.paymentBlack13
                          //           .copyWith(fontSize: 15),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 8,
                          // ),
                          // Row(
                          //   children: [
                          //     Text(
                          //     Text(
                          //       "₹${propertyAllDetailsController.totalGST}",
                          //       style: Palette.paymentBlack13.copyWith(
                          //           color: Colors.green,
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.normal),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 12,
                          // ),     "Goods & Services Tax",
                          //       style: Palette.paymentBlack13.copyWith(
                          //         fontWeight: FontWeight.normal,
                          //         fontSize: 14,
                          //       ),
                          //     ),
                          //     const Spacer(),
                          //
                          // const Divider(
                          //   height: 1,
                          //   color: kBlack,
                          // ),
                          // const SizedBox(
                          //   height: 12,
                          // ),
                          // GetBuilder<ConfrimNPayController>(builder: (a) {
                          //   return Row(
                          //     children: [
                          //       Text(
                          //         "Advance Payment",
                          //         style: Palette.paymentBlack13
                          //             .copyWith(fontSize: 15),
                          //       ),
                          //       const Spacer(),
                          //       Text(
                          //         a.paymentOption == PaymentOption.Full
                          //             ? "₹${totalPrice + (getController.totalGST ?? 0)}"
                          //             : '₹${(totalPrice + (getController.totalGST ?? 0)) / 2}',
                          //         style: Palette.paymentBlack13
                          //             .copyWith(fontSize: 15),
                          //       ),
                          //     ],
                          //   );
                          // }),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Row(
                          //   children: [
                          //     Text(
                          //       "Total",
                          //       style: Palette.paymentBlack13
                          //           .copyWith(fontSize: 15),
                          //     ),
                          //     const Spacer(),
                          //     Text(
                          //       "₹${totalPrice + (propertyAllDetailsController.totalGST ?? 0)}",
                          //       style: Palette.paymentBlack13
                          //           .copyWith(fontSize: 15),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // const SizedBox(
              //   height: 28,
              // ),
              // Text(
              //   "Do You Have A Promo Code?",
              //   style: Palette.headerText,
              // ),
              // const SizedBox(
              //   height: 13,
              // ),
              // Text(
              //   "Enter Your Promo Code",
              //   style: Palette.bottomTextDark,
              // ),
              // const SizedBox(
              //   height: 15,
              // ),
              // SizedBox(
              //   height: 45,
              //   child: Row(
              //     children: [
              //       Flexible(
              //         child: CustomTextfieldCommon(
              //             validate: () {},
              //             controller: a.promoCode,
              //             label: " ",
              //             hint: " "),
              //       ),
              //       const SizedBox(
              //         width: 10,
              //       ),
              //       SizedBox(
              //         height: 45,
              //         width: 100,
              //         child: MaterialButton(
              //             color: kOrange,
              //             shape: Palette.subCardShape,
              //             padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
              //             child: Text(
              //               'Apply',
              //               style: Palette.bestText4,
              //             ),
              //             onPressed: () {}),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(
                height: 16,
              ),
              // const Divider(
              //   color: kBlack,
              // ),
              const SizedBox(
                height: 26,
              ),
              Row(
                children: [
                  Text(
                    "Your Trip",
                    style: Palette.headerText,
                  ),
                  const Spacer(),
                  // const SizedBox(height: 45, width: 85, child: searchEdit()
                  //  MaterialButton(
                  //     color: kOrange,
                  //     shape: Palette.subCardShape,
                  //     padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                  //     child: Text(
                  //       'Edit',
                  //       style: Palette.bestText4,
                  //     ),
                  //     onPressed: () {
                  //       Get.dialog(Scaffold(body: SearchBarWidget()));

                  //     }),

                  // ),
                ],
              ),
              const SizedBox(
                height: 26,
              ),
              Row(
                children: [
                  Text(
                    "Check In :",
                    style: Palette.paymentBlack13,
                  ),
                  const Spacer(),
                  Text(
                   widget.bookingData== null?     widget.selectedDates[0].date ??
                        DateFormat('dd-MM-yyyy').format(DateTime.now()): widget.bookingData!['start_date'] ,
                    style: Palette.GreyText12w500,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    "Check Out :",
                    style: Palette.paymentBlack13,
                  ),
                  const Spacer(),
                  Text(
                  widget.bookingData ==null?  getController.endDate??  DateFormat('yyyy-MM-dd').format(DateTime.now()
                                .add(const Duration(days: 1))) : widget.bookingData?['end_date'],
                    
                    style: Palette.GreyText12w500,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              GetBuilder<SearchPlacesController>(
                initState: (a) {},
                builder: (a) {
                  return Row(
                    children: [
                      Text(
                        "Total Guests :",
                        style: Palette.paymentBlack13,
                      ),
                      const Spacer(),
                      Text(
                        "${widget.bookingData== null ?(int.parse(a.totalAdults.text)+ int.parse(a.totalChildren.text)+ int.parse(a.totalInphant.text)) : widget.bookingData?['guest']} Guest",
                        style: Palette.GreyText12w500,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              GetBuilder<SearchPlacesController>(
                initState: (a) {},
                builder: (a) {
                  return Row(
                    children: [
                      Text(
                        "Total Adults :",
                        style: Palette.paymentBlack13,
                      ),
                      const Spacer(),
                      Text(
                        "${widget.bookingData== null ?a.totalAdults.text : widget.bookingData?['adults']} Adults",
                        style: Palette.GreyText12w500,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              GetBuilder<SearchPlacesController>(
                initState: (a) {},
                builder: (a) {
                  return Row(
                    children: [
                      Text(
                        "Total Childrens :",
                        style: Palette.paymentBlack13,
                      ),
                      const Spacer(),
                      Text(
                        "${widget.bookingData== null ? a.totalChildren.text : widget.bookingData?['children']} Childrens",
                        style: Palette.GreyText12w500,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              GetBuilder<SearchPlacesController>(
                initState: (a) {},
                builder: (a) {
                  return Row(
                    children: [
                      Text(
                        "Total Infant :",
                        style: Palette.paymentBlack13,
                      ),
                      const Spacer(),
                      Text(
                        "${widget.bookingData== null ? a.totalInphant.text : widget.bookingData?['infant']} Infant",
                        style: Palette.GreyText12w500,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text(
                    "Property Type :",
                    style: Palette.paymentBlack13,
                  ),
                  const Spacer(),
                  Text(
                    widget.propertyType,
                    style: Palette.GreyText12w500,
                  ),
                ],
              ),
              const SizedBox(
                height: 21,
              ),
              const Divider(
                color: kBlack,
              ),
              const SizedBox(
                height: 28,
              ),
              Text(
                "Enter Your Details",
                style: Palette.headerText,
              ),
              const SizedBox(
                height: 7,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: kRed.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Text(
                  "Note: At the time of check-in, details entered below should match as per govt. issued ID proofs for all the guests. Entry might be restricted in case of non-availability or mismacth of ID Proofs.",
                  style: Palette.recText,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                "First Name",
                style: Palette.paymentBlack13,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 45,
                  child: CustomTextfieldCommon(
                      validate: () {},
                      controller: a.firstName,
                      label: "",
                      hint: "")),
              const SizedBox(
                height: 18,
              ),
              Text(
                "Last Name",
                style: Palette.paymentBlack13,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 45,
                  child: CustomTextfieldCommon(
                      validate: () {},
                      controller: a.lastName,
                      label: "",
                      hint: "")),
              const SizedBox(
                height: 18,
              ),
              Text(
                "Email Address",
                style: Palette.paymentBlack13,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 45,
                  child: CustomTextfieldCommon(
                      validate: () {},
                      controller: a.email,
                      label: "",
                      hint: "")),
              const SizedBox(
                height: 18,
              ),
              Text(
                "Mobile Number",
                style: Palette.paymentBlack13,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 45,
                  child: CustomTextfieldCommon(
                      validate: () {},
                      controller: a.mobile,
                      textInputType: TextInputType.phone,
                      label: "",
                      hint: "")),
              const SizedBox(
                height: 24,
              ),
              const Divider(
                color: kBlack,
              ),
              // const SizedBox(
              //   height: 16,
              // ),
              // Text(
              //   "Who Are You Booking For?",
              //   style: Palette.headerText,
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   children: [
              //     Transform.scale(
              //       scale: 1.3,
              //       child: Radio(
              //         splashRadius: 50,
              //         toggleable: true,
              //         focusColor: kOrange,
              //         value: 0,
              //         autofocus: true,
              //         activeColor: kOrange,
              //         groupValue: a.selectedRadioButton,
              //         onChanged: (value) {
              //           // setState(() {
              //           //   selectedRadioButton = value!.toDouble();
              //           // });
              //         },
              //       ),
              //     ),
              //     Text("I am The Main Guest", style: Palette.GreyText12w500),
              //   ],
              // ),
              // Row(
              //   children: [
              //     Transform.scale(
              //       scale: 1.3,
              //       child: Radio(
              //         toggleable: true,
              //         focusColor: kOrange,
              //         overlayColor:
              //             MaterialStateColor.resolveWith((states) => kOrange),
              //         value: 1,
              //         autofocus: true,
              //         activeColor: kOrange,
              //         groupValue: a.selectedRadioButton,
              //         onChanged: (value) {
              //           // setState(() {
              //           //   a.selectedRadioButton = value!.toDouble();
              //           // });
              //         },
              //       ),
              //     ),
              //     Text("Booking is for Someone Else",
              //         style: Palette.GreyText12w500),
              //   ],
              // ),
              // const SizedBox(
              //   height: 22,
              // ),
              // const Divider(
              //   color: kBlack,
              // ),
              // const SizedBox(
              //   height: 18,
              // ),
              // Text(
              //   "Guests : 1 Adults",
              //   style: Palette.headerText,
              // ),
              // const SizedBox(
              //   height: 22,
              // ),
              // Text(
              //   "Full Guest Name",
              //   style: Palette.paymentBlack13,
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // SizedBox(
              //     height: 45,
              //     child: CustomTextfieldCommon(
              //         validate: () {},
              //         controller: a.lastName,
              //         label: "",
              //         hint: "")),
              // const SizedBox(
              //   height: 18,
              // ),
              // Row(
              //   children: [
              //     Text(
              //       "Guest email ",
              //       style: Palette.paymentBlack13,
              //     ),
              //     Text(
              //       "(Optional)",
              //       style: Palette.paymentGrey13,
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // SizedBox(
              //     height: 45,
              //     child: CustomTextfieldCommon(
              //         validate: () {},
              //         controller: a.lastName,
              //         label: "",
              //         hint: "")),
              // const SizedBox(
              //   height: 18,
              // ),
              // const Divider(
              //   color: kBlack,
              // ),

              Text(
                "Additional Requests",
                style: Palette.headerText,
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Text(
              //   "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
              //   style: Palette.paymentRequestText,
              // ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 92,
                  child: CustomTextfieldPara(
                      controller: a.request,
                      label: "",
                      hint: "Additional request")),
              const SizedBox(
                height: 18,
              ),
              const Divider(
                color: kBlack,
              ),
              const SizedBox(
                height: 18,
              ),
              Text(
                "Cancellation Policy",
                style: Palette.headerText,
              ),
              const SizedBox(
                height: 10,
              ),

              Column(
                children: List<Widget>.generate(
                  6,
                  ((index) {
                    List CancellationPollicy = [
                      "If you wish to cancel 45 to 30 days before the arrival date, you will be charged 5% cancellation charges** of the total property rent in the original payment mode.",
                      "Cancellations that are made between 29 to 15 days prior to the arrival date, 15% cancellation charges** of the total property rent.",
                      "Cancellations that are made between 14 to 7 days prior to the arrival date, 50% cancellation charges** of the total property rent.",
                      "For any cancellations requested within 6 days of the check-in date, the booking will be non-refundable.",
                      "A processing fee of 5% will be deducted from the refund amount as a convenience fee for cancellation.",
                      "Refund will be process within 6 to 7 working days."
                    ];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/orangeDot.png",
                            height: 8,
                            width: 8,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              CancellationPollicy[index],
                              style: Palette.bestText2,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "**Please note: Cancellation fee is primarily applicable to cover platform charges, convenience fee and processing charges. Taxes as applicable.",
                style: Palette.bestText2
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
              ),

              const SizedBox(
                height: 13,
              ),
              const Divider(
                color: kBlack,
              ),
              const SizedBox(
                height: 17,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Pay With",
              //       style: Palette.headerText,
              //     ),
              //     Bounce(
              //       duration: const Duration(milliseconds: 300),
              //       onPressed: () {
              //         Get.to(() => const PaymentMethod());
              //       },
              //       child: commonText(
              //         text: "Change Method",
              //         color: kOrange,
              //         fontSize: 12,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 15,
              // ),
              // GetBuilder<PaymentMethodController>(
              //   initState: (a) {},
              //   builder: (a) {
              //     return CardTile(
              //         cardTile: a.allCardTile[a.currSelectedMethod],
              //         value: a.currSelectedMethod);
              //   },
              // ),
              // Container(
              //   height: 45,
              //   decoration: BoxDecoration(
              //       color: kWhite,
              //       borderRadius: BorderRadius.circular(6),
              //       border: Border.all(
              //         color: kDarkGrey.withAlpha(150),
              //         width: 1,
              //       )),
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 12),
              //     child: Row(
              //       children: [
              //         Image.asset(
              //           "assets/images/credit_card.png",
              //           height: 20,
              //           width: 20,
              //         ),
              //         const Text("    Credit Card / Debit Card"),
              //         const Spacer(),
              //         Transform.scale(
              //           scale: 1.2,
              //           child: Radio(
              //             splashRadius: 50,
              //             toggleable: true,
              //             focusColor: kOrange,
              //             value: 0,
              //             autofocus: true,
              //             activeColor: kOrange,
              //             groupValue: a.selectedRadioButton1,
              //             onChanged: (value) {
              //               // setState(() {
              //               //   selectedRadioButton1 = value!.toDouble();
              //               // });
              //             },
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 12,
              // ),
              // Container(
              //   height: 45,
              //   decoration: BoxDecoration(
              //       color: kWhite,
              //       borderRadius: BorderRadius.circular(6),
              //       border: Border.all(
              //         color: kDarkGrey.withAlpha(150),
              //         width: 1,
              //       )),
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 12),
              //     child: Row(
              //       children: [
              //         Image.asset(
              //           "assets/images/google-pay.png",
              //           height: 20,
              //           width: 20,
              //         ),
              //         const Text("    Credit Card / Debit Card"),
              //         const Spacer(),
              //         Transform.scale(
              //           scale: 1.2,
              //           child: Radio(
              //             splashRadius: 50,
              //             toggleable: true,
              //             focusColor: kOrange,
              //             value: 1,
              //             autofocus: true,
              //             activeColor: kOrange,
              //             groupValue: a.selectedRadioButton1,
              //             onChanged: (value) {
              //               // setState(() {
              //               //   selectedRadioButton1 = value!.toDouble();
              //               // });
              //             },
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 12,
              // ),
              // Container(
              //   height: 45,
              //   decoration: BoxDecoration(
              //       color: kWhite,
              //       borderRadius: BorderRadius.circular(6),
              //       border: Border.all(
              //         color: kDarkGrey.withAlpha(150),
              //         width: 1,
              //       )),
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 12),
              //     child: Row(
              //       children: [
              //         Image.asset(
              //           "assets/images/paytm.png",
              //           height: 20,
              //           width: 20,
              //         ),
              //         const Text("    Credit Card / Debit Card"),
              //         const Spacer(),
              //         Transform.scale(
              //           scale: 1.2,
              //           child: Radio(
              //             splashRadius: 50,
              //             toggleable: true,
              //             focusColor: kOrange,
              //             value: 2,
              //             autofocus: true,
              //             activeColor: kOrange,
              //             groupValue: a.selectedRadioButton1,
              //             onChanged: (value) {
              //               // setState(() {
              //               //   selectedRadioButton1 = value!.toDouble();
              //               // });
              //             },
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // const SizedBox(
              //   height: 20,
              // ),

              // const Divider(
              //   color: kBlack,
              // ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                width: double.maxFinite,
                child: Opacity(
                  opacity: (widget.bookingID == null &&
                          a.paymentOption == PaymentOption.Advance)
                      ? 0.5
                      : 1,
                  child: MaterialButton(
                    color: kOrange,
                    shape: Palette.subCardShape,
                    padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                    onPressed: (widget.bookingID == null &&
                            a.paymentOption == PaymentOption.Advance)
                        ? () {}
                        : () {





                      print(widget.totalPrice + (getController.totalGST ?? 0).customRound());
                      print((getController.totalGST ?? 0));
                      print(widget.totalPrice);







                         getRazorpayController
                              ..onSuccess = (String paymentID) {
                                a.bookPropery(
                                    context: context,
                                    paymentID: paymentID,
                                    propertyID: widget.propertyID,
                                    bookingID: widget.bookingID,
                                    bookingData: widget.bookingData);
                                print("On Success: $paymentID ");
                                // Handle success if needed (e.g., navigate to success screen)
                              }
                              ..onError = () {

                              print("sadfsadsadsadsad");
                                // Handle error if needed (e.g., show an error message)
                              }
                              ..openCheckout(
                                amount: widget.bookingID != null
                                    ? ((widget.totalPrice / 2).customRound()) *
                                        100
                                    : (((a.paymentOption == PaymentOption.Full &&
                                                    ((getController
                                                                .PropertyData!
                                                                .result!
                                                                .noOfDiscountBooking !=
                                                            null) &&
                                                        (getController
                                                                    .PropertyData
                                                                    ?.result
                                                                    ?.totalBooking -
                                                                500) <
                                                            int.parse(getController
                                                                .PropertyData
                                                                ?.result!
                                                                .noOfDiscountBooking)))
                                                ? a.paymentOption ==
                                                        PaymentOption.Full
                                                    ? (getController.totalPriceAfterDiscount ?? 0) +
                                                        (getController.totalGST ?? 0)
                                                            .customRound()
                                                    : ((getController.totalPrice ?? 0) +
                                                            (getController.totalPrice ?? 0)) ~/
                                                        2
                                                : a.paymentOption == PaymentOption.Full
                                                    ? widget.totalPrice + (getController.totalGST ?? 0).customRound()
                                                    : (double.parse(getController.totalGST?.toStringAsFixed(1) ?? '0').customRound() + (getController.totalPrice ?? 0)) ~/ 2)
                                            .toInt()) *
                                        100,
                                key: 'rzp_live_DdHJFlyNk3U66p',
                                name:
                                    "${currUser?.data?.firstName ?? 'Alok'} ${currUser?.data?.lastName ?? 'Kumar'}",
                                number:
                                    //  currUser?.data?.phone ??
                                    '1234567890',
                                orderId: generateRandomOrderId(),
                              );
                          },
                    child: Text(
                      widget.bookingID != null ? "Confirm & Pay" : 'Book Now',
                      style: Palette.bestText4,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Dialog dialogFor50Payment(
      BuildContext context, ConfrimNPayController controller) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              color: Colors.transparent,
              
              padding: const EdgeInsets.all(30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 12.0, top: 12, bottom: 5),
                      child: Text(
                        "Booking Payment",
                        style: Palette.splashscreenskip,
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        "Dear Customer,",
                        style: Palette.GreyText12w500.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Text(
                        'As you have opted for partial payment, please note balance has to be paid before 7 days of checkin. Failing to pay, booking will be auto cancelled and you will not be eligible for any refund. For more details on refund please refer our cancellation policy.',
                        style: Palette.GreyText12w500.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Obx(
                      () => GestureDetector(
                        onTap: controller.toggleIsAgree,
                        child: Row(
                          children: [
                            Checkbox(
                              value: controller.isAgree.value,
                              onChanged: (value) {
                                controller.toggleIsAgree();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              activeColor: Colors.blue,
                            ),
                            Text(
                              "I agree",
                              style: Palette.bestText1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        CommonButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.grey.shade600,
                            name: 'Close'),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CommonButton(
                              onPressed: () {

                                print(((double.parse(getController.totalGST?.toStringAsFixed(1) ?? '0').customRound()
                                    + (getController.totalPrice ?? 0)) ~/ 2)
                                    .toInt());





                                if (a.isAgree.value) {
                                  getRazorpayController
                                    ..onSuccess = (String paymentID) {
                                      a.bookPropery(
                                          context: context,
                                          paymentID: paymentID,
                                          propertyID: widget.propertyID);
                                    }
                                    ..onError = () {
                                      // Handle error if needed (e.g., show an error message)
                                    }
                                    ..openCheckout(
                                      amount: (((a.paymentOption == PaymentOption.Full &&
                                                      ((getController
                                                                  .PropertyData!
                                                                  .result!
                                                                  .noOfDiscountBooking !=
                                                              null) &&
                                                          (getController
                                                                      .PropertyData
                                                                      ?.result
                                                                      ?.totalBooking -
                                                                  500) <
                                                              int.parse(getController
                                                                  .PropertyData
                                                                  ?.result!
                                                                  .noOfDiscountBooking)))
                                                  ? a.paymentOption ==
                                                          PaymentOption.Full
                                                      ? (getController.totalPriceAfterDiscount ?? 0) +
                                                          (getController.totalGST ?? 0)
                                                              .customRound()
                                                      : ((getController.totalPrice ?? 0) +
                                                              (getController.totalPrice ?? 0)) ~/
                                                          2
                                                  : a.paymentOption == PaymentOption.Full
                                                      ? widget.totalPrice + (getController.totalGST ?? 0).customRound()
                                                      : (double.parse(getController.totalGST?.toStringAsFixed(1) ?? '0').customRound()
                                          + (getController.totalPrice ?? 0)) ~/ 2)
                                              .toInt()) *
                                          100,
                                      key: 'rzp_live_DdHJFlyNk3U66p',
                                      name:
                                          "${currUser?.data?.firstName ?? 'Alok'} ${currUser?.data?.lastName ?? 'Kumar'}",
                                      number:
                                          //  currUser?.data?.phone ??
                                          '1234567890',
                                      orderId: generateRandomOrderId(),
                                    );
                                } else {
                                  showSnackBar(
                                      title: "Error",
                                      message:
                                          'Please select the checkbox to proceed.');
                                }
                              },
                              name: 'Pay Now'),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    )
                  ],
                ),
              )),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 390.0, left: 250),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.color9a0400,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                        'assets/images/appbar_icons/close.svg'),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
