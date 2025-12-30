import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/SubPages/SearchPlaces/searchPlaces_controller.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/widgets/commonText.dart';

class SearchPlaces extends StatelessWidget {
  const SearchPlaces({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchPlacesController>(
      initState: (a) {},
      builder: (a) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: (() {
                    Navigator.pop(context);
                  }),
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
                  text: "Where To?",
                  color: kBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 55,
              width: double.maxFinite,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: TextField(
                    autofocus: true,
                    controller: a.searchTextController,
                    style: const TextStyle(),
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: kOrange))),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonText(
                  text: "Top Search",
                  color: kBlack.withAlpha(125),
                  fontSize: 11,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 2,
                  width: 55,
                  color: kOrange,
                )
              ],
            )),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 80,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      a.pridiction.length,
                      (index) => InkWell(
                            onTap: () {
                              a.selectedPlace =
                                  a.pridiction[index]['description'];
                              a.update();
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: SizedBox(
                                width: dwidth.toDouble(),
                                child: commonText(
                                  textAlign: TextAlign.start,
                                  text: a.pridiction[index]['description'],
                                  color: kBlack,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          )),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class DestinationDialog extends StatelessWidget {
  const DestinationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: GetBuilder<SearchPlacesController>(
      initState: (a) {},
      builder: (a) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (() {
                        Navigator.pop(context);
                      }),
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
                      text: "Where To?",
                      color: kBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 55,
                width: double.maxFinite,
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextField(
                      autofocus: true,
                      controller: a.searchTextController,
                      style: const TextStyle(),
                      decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: kOrange))),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonText(
                    text: "Top Search",
                    color: kBlack.withAlpha(125),
                    fontSize: 11,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 2,
                    width: 55,
                    color: kOrange,
                  )
                ],
              )),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        a.pridiction.length,
                        (index) => InkWell(
                              onTap: () {
                                a.selectedPlace =
                                    a.pridiction[index]['description'];
                                a.update();
                                Get.back();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: SizedBox(
                                  width: dwidth.toDouble(),
                                  child: commonText(
                                    textAlign: TextAlign.start,
                                    text: a.pridiction[index]['description'],
                                    color: kBlack,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            )),
                  ),
                ),
              )
            ],
          ),
        );
      },
    ));
  }
}
