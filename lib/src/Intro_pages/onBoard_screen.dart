import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Intro_pages/main_start_page.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/utils/style/palette.dart';
import 'package:gleekeyu/widgets/commonText.dart';

import 'onBoard_controller.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OnBoardController a = Get.put(OnBoardController());

    List<Widget> onBoardScreens = [
      onBoard1(),
      onBoard2(),
      onBoard3(),
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: kDarkBlue,
        body: Stack(
          children: [
            PageView.builder(
                controller: a.c,
                itemCount: onBoardScreens.length,
                itemBuilder: (context, i) {
                  return onBoardScreens[i];
                }),
            Column(
              children: [
                const Spacer(),
                Container(
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            GetBuilder<OnBoardController>(
                              initState: (a) {},
                              builder: (a) {
                                return DotsIndicator(
                                  dotsCount: onBoardScreens.length,
                                  position: a.currIndex,
                                  decorator: const DotsDecorator(
                                    color: kLightGrey2,
                                    activeColor: kOrange,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 80,
                          ),
                          Center(
                            child: SizedBox(
                              height: 40,
                              width: 100,
                              child: MaterialButton(
                                  color: kOrange,
                                  shape: Palette.subCardShape,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 7, 10, 7),
                                  child: commonText(
                                    text: 'NEXT',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: kWhite,
                                  ),
                                  onPressed: () {
                                    if (a.currIndex == 2) {
                                      Get.off(const MainStartPage());
                                    } else {
                                      a.currIndex++;
                                      a.update();
                                      a.c.animateToPage(a.currIndex.toInt(),
                                          duration: const Duration(
                                              milliseconds: 1000),
                                          curve: Curves.easeInQuad);
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 80,
                            ),
                            GestureDetector(
                              onTap: (() {
                                // TODO change
                                //a.currIndex++;
                                Get.off(const MainStartPage());
                              }),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 200, top: 10),
                                child: commonText(
                                  text: "Skip >",
                                  color: kOrange,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 70,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget onBoard1() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Container(
       //  color: kDarkBlue,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  "assets/images/onBoard_bg.png",
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                  height: dheight * 0.4,

                  width: double.maxFinite,
                )),
            AnimatedPositioned(
                bottom: dheight * 0.3,
                duration: const Duration(milliseconds: 1000),
                child: Image.asset(
                  "assets/images/spash_1.webp",
                  cacheHeight: 500,
                  cacheWidth: 500,
                  alignment: Alignment.topCenter,
                  height: 200,
                )),
            Column(
              children: [
                const SizedBox(
                  height: 90,
                ),






                commonText(
                  text: "Welcome To",
                  color: Colors.white,
                  fontSize: 25,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                ),
                Image.asset(
                  "assets/images/app_logo.png",
                  alignment: Alignment.topCenter,
                  height: 60,
                ),
                const SizedBox(
                  height: 15,
                ),
                commonText(
                  text:
                      "Discover your perfect staycation retreat with ease!",
                  color: Colors.white,
                  fontSize: 18,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 15,
                ),

                // TODO change text to logo

                // SizedBox(
                //   width: 200,
                //   child: commonText(
                //     text:
                //         "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                //     color: kBlack.withOpacity(0.5),
                //     fontSize: 13,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget onBoard2() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Container(
        // color: AppColors.color1C2534,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(
              "assets/images/onBoard_bg_180.png",
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,

              height: dheight * 0.4,
              width: double.maxFinite,
            ),
            AnimatedPositioned(
                top: dheight * 0.2,
                duration: const Duration(milliseconds: 1000),
                child: Image.asset(
                  "assets/images/spalsh_2.webp",
                  alignment: Alignment.topCenter,
                  cacheHeight: 500,
                  cacheWidth: 500,
                  height: 200,
                )),
            Column(
              children: [
                SizedBox(
                  height: dheight * 0.48,
                ),
                commonText(
                  text: "Moments To Memories",
                  color: Colors.white,
                  fontSize: 25,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 15,
                ),
                commonText(
                  text:
                      "Experience perfect staycation at our handpicked properties!",
                  color: Colors.white,
                  fontSize: 16,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 15,
                ),
                // TODO change text to logo
                Image.asset(
                  "assets/images/app_logo.png",
                  alignment: Alignment.topCenter,
                  height: 60,
                )
                // SizedBox(
                //   width: 200,
                //   child: commonText(
                //     text:
                //         "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                //     color: kBlack.withOpacity(0.5),
                //     fontSize: 13,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget onBoard3() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Container(
        // color: AppColors.color1C2534,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  "assets/images/onBoard_bg.png",
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                  height: dheight * 0.4,

                  width: double.maxFinite,
                )),
            AnimatedPositioned(
                bottom: dheight * 0.3,
                duration: const Duration(milliseconds: 1000),
                child: Image.asset(
                  "assets/images/spalsh_3.webp",
                  alignment: Alignment.topCenter,
                  height: 200,
                  cacheHeight: 500,
                  cacheWidth: 500,
                )),
            Column(
              children: [
                const SizedBox(
                  height: 140,
                ),
               /* commonText(
                  text: "Discover range of affordable luxurious stay at Gleekey",
                  color: Colors.white,
                  fontSize: 25,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                ),*/
                const SizedBox(
                  height: 15,
                ),
                commonText(
                  text: "A Range Of Affordable Luxurious Accommodations Awaits!",
                  color: Colors.white,
                  fontSize: 22,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 15,
                ),
                // TODO change text to logo
                Image.asset(
                  "assets/images/app_logo.png",
                  alignment: Alignment.topCenter,
                  height: 60,
                )
                // SizedBox(
                //   width: 200,
                //   child: commonText(
                //     text:
                //         "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                //     color: kBlack.withOpacity(0.5),
                //     fontSize: 13,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
