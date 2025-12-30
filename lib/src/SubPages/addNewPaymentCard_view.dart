// ignore_for_file: invalid_use_of_protected_member, file_names

import 'package:flutter/material.dart';
import 'package:gleekeyu/src/SubPages/Payment%20Methods/paymentMethod_controller.dart';
import 'package:gleekeyu/src/SubPages/Payment%20Methods/paymentMethod_view.dart';

import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/utils/style/palette.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/widgets/text_fields_widgets/custom_textfield_common.dart';

import 'appBarWithTitleAndBack.dart';

class AddNewPaymentCard extends StatelessWidget {
  const AddNewPaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    PaymentMethodController a = Get.find();
    return SafeArea(
        child: Scaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(24),
              child: MaterialButton(
                  shape: Palette.subCardShape,
                  color: kOrange,
                  child: SizedBox(
                    width: dwidth.toDouble(),
                    height: 45,
                    child: Center(
                      child: Text(
                        'Add',
                        style: Palette.btnText,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    a.isValidated = true;
                    a.update();
                    a.validate();
                    if (a.nameError == null &&
                        a.cvvError == null &&
                        a.dateError == null &&
                        a.numberError == null) {
                      a.allCardTile.insert(
                        0,
                        PaymentCards(
                          imgUrl: "assets/images/visa.png",
                          title: a.cardNumberController.text.toString(),
                          subtitle:
                              "Expire ${a.cardDateController.text.toString()}",
                          // radioButtonGroupValue: a.currSelectedMethod,
                        ),
                      );
                      a.totalCards++;
                      a.refresh();
                      Get.back();
                    }
                  }),
            ),
            appBar: AppBarWithTitleAndBack(title: "Add New Card"),
            body: GetBuilder<PaymentMethodController>(
              initState: (a) {},
              builder: (a) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    height: dheight.toDouble(),
                    width: dwidth.toDouble(),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 160,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: const DecorationImage(
                                    image:
                                        AssetImage("assets/images/card.png"))),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Text(
                            "Card Holder Name",
                            style: Palette.paymentBlack13,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                              child: CustomTextfieldCommon(
                                  validate: a.validate,
                                  obscureText: false,
                                  controller: a.cardNameController,
                                  btnValidate: a.isValidated,
                                  errorText: a.nameError,
                                  label: "",
                                  hint: "Card Holder Name")),
                          const SizedBox(
                            height: 18,
                          ),
                          Text(
                            "Card Number",
                            style: Palette.paymentBlack13,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                              child: CustomTextfieldCommon(
                                  validate: a.validate,
                                  textInputType: TextInputType.number,
                                  controller: a.cardNumberController,
                                  btnValidate: a.isValidated,
                                  errorText: a.numberError,
                                  label: "",
                                  hint: "16 Digit Card Number")),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Expiry Date",
                                      style: Palette.paymentBlack13,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                        child: CustomTextfieldCommon(
                                            validate: a.validate,
                                            textInputType: TextInputType.number,
                                            controller: a.cardDateController,
                                            btnValidate: a.isValidated,
                                            errorText: a.dateError,
                                            label: "",
                                            hint: "Expiry Date (MM/YY)")),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 24,
                              ),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "CVV",
                                      style: Palette.paymentBlack13,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                        child: CustomTextfieldCommon(
                                            obscureText: true,
                                            validate: a.validate,
                                            textInputType: TextInputType.number,
                                            controller: a.cardCvvController,
                                            btnValidate: a.isValidated,
                                            errorText: a.cvvError,
                                            label: "",
                                            hint: "CVV")),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )));
  }
}
