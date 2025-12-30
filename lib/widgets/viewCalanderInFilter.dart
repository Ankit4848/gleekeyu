import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/style/constants.dart';
import 'calander.dart';
import 'commonText.dart';
import 'searchEdit.dart';

class viewCalanderInFilter extends StatelessWidget {
  String date;
  viewCalanderInFilter({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4))),
        padding: const EdgeInsets.all(0),
        splashRadius: 1,
        tooltip: "",
        enableFeedback: false,
        position: PopupMenuPosition.over,
        color: Colors.white,
        offset: const Offset(-1, 0),
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - 90,
        ),
        itemBuilder: ((context) {
          return [
            PopupItem(
                child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 10, right: 10),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: kWhite, borderRadius: BorderRadius.circular(10)),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Image.asset(
                            "assets/images/cancel.png",
                            height: 21,
                            width: 21,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        commonText(
                          text: "When's Your Trip?",
                          color: kBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const calander(),
                  ],
                ),
              ),
            ))
          ];
        }),
        child: Container(
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kWhite,
              boxShadow: [
                BoxShadow(
                    color: kDarkGrey.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0.0, 5.0))
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                commonText(
                  text: date,
                  color: kBlack,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                Image.asset(
                  "assets/images/booking_icon_color.png",
                  color: kOrange,
                  height: 24,
                )
              ],
            ),
          ),
        ));
  }
}

class DialogForCheckInCheckOutDate extends StatelessWidget {
  const DialogForCheckInCheckOutDate({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: kWhite, borderRadius: BorderRadius.circular(10)),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Image.asset(
                    "assets/images/cancel.png",
                    height: 21,
                    width: 21,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                commonText(
                  text: "When's Your Trip?",
                  color: kBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const calander(),
          ],
        ),
      ),
    );
  }
}
