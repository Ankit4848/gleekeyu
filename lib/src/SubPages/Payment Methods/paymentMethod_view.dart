// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/SubPages/addNewPaymentCard_view.dart';
import 'package:gleekeyu/src/SubPages/appBarWithTitleAndBack.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/utils/style/palette.dart';
import 'package:gleekeyu/widgets/commonText.dart';

import 'paymentMethod_controller.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => PaymentMethodController(), fenix: true);
    return Scaffold(
      backgroundColor: kWhite,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: MaterialButton(
            shape: Palette.subCardShape,
            color: kOrange,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 45,
              child: Center(
                child: Text(
                  'Select',
                  style: Palette.btnText,
                ),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      appBar: AppBarWithTitleAndBack(title: "Payment Method"),
      floatingActionButton: GetBuilder<PaymentMethodController>(
        initState: (a) {},
        builder: (a) {
          return FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              a.addCard();
              Get.to(() => const AddNewPaymentCard());
            },
          );
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: GetBuilder<PaymentMethodController>(
              initState: (a) {},
              builder: (a) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonText(
                      text: "Cards",
                      color: kBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    a.totalCards > 0
                        ? ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: ((context, index) {
                              return CardTile(
                                  cardTile: a.allCardTile[index], value: index);
                            }),
                            separatorBuilder: ((context, index) {
                              return const SizedBox(
                                height: 8,
                              );
                            }),
                            itemCount: a.totalCards)
                        : SizedBox(
                            height: 25,
                            child: Center(
                              child: commonText(
                                text: 'No Card Found',
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 8,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    commonText(
                      text: "UPI",
                      color: kBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          return CardTile(
                            cardTile: a.allCardTile[index + a.totalCards],
                            value: index + a.totalCards,
                          );
                        }),
                        separatorBuilder: ((context, index) {
                          return const SizedBox(
                            height: 8,
                          );
                        }),
                        itemCount: a.totalUpi),
                    const SizedBox(
                      height: 20,
                    ),
                    commonText(
                      text: "Other",
                      color: kBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          return CardTile(
                            cardTile: a
                                .allCardTile[index + a.totalCards + a.totalUpi],
                            value: index + a.totalCards + a.totalUpi,
                          );
                        }),
                        separatorBuilder: ((context, index) {
                          return const SizedBox(
                            height: 8,
                          );
                        }),
                        itemCount: a.totalOthers),
                    const SizedBox(
                      height: 40,
                    ),
                    // commonText(
                    //   text: "Current Method",
                    //   color: kBlack,
                    //   fontSize: 14,
                    //   fontWeight: FontWeight.w700,
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // CardTile(
                    //     cardTile: a.allCardTile[a.currSelectedMethod],
                    //     value: a.currSelectedMethod),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
            )),
      ),
    );
  }
}

class PaymentCards {
  String imgUrl;
  String title;
  String? subtitle;
  PaymentCards({
    required this.imgUrl,
    required this.title,
    this.subtitle,
  });
}

class CardTile extends StatelessWidget {
  PaymentCards cardTile;
  int value;
  CardTile({Key? key, required this.cardTile, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentMethodController>(
      initState: (a) {},
      builder: (a) {
        return Bounce(
          onPressed: (() {
            a.currSelectedMethod = value;
            a.update();
          }),
          duration: const Duration(milliseconds: 200),
          child: Container(
            decoration: BoxDecoration(
                border: a.currSelectedMethod == value
                    ? Border.all(color: kOrange, width: 2)
                    : Border.all(color: kWhite.withOpacity(0)),
                borderRadius: BorderRadius.circular(10)),
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                dense: true,
                leading: SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(
                      child: Image.asset(
                    cardTile.imgUrl,
                    height: 15,
                  )),
                ),
                title: commonText(
                  text: value < a.totalCards
                      ? "**** **** **** ${cardTile.title.substring(cardTile.title.length - 4)}"
                      : cardTile.title,
                  color: kBlack,
                  fontSize: 12,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w600,
                ),
                subtitle: cardTile.subtitle != null
                    ? commonText(
                        text: cardTile.subtitle!,
                        color: kBlack.withOpacity(0.5),
                        fontSize: 12,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w400,
                      )
                    : null,
                trailing: GetBuilder<PaymentMethodController>(
                  initState: (a) {},
                  builder: (a) {
                    return SizedBox(
                      height: 50,
                      child: Transform.scale(
                        scale: 1.2,
                        child: Radio(
                          splashRadius: 30,
                          toggleable: true,
                          focusColor: kOrange,
                          value: value,
                          autofocus: true,
                          activeColor: kOrange,
                          groupValue: a.currSelectedMethod,
                          onChanged: (value) {
                            a.currSelectedMethod = value!;
                            a.update();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
