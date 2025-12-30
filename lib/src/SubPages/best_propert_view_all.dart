import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/Menu/DashBoard/dashboard_controller.dart';
import 'package:gleekeyu/widgets/property_widget.dart';
import '../../utils/style/constants.dart';
import '../../utils/style/palette.dart';
import 'SearchPlaces/searchBar.dart';

class BestPropertyViewAll extends StatelessWidget {
  const BestPropertyViewAll({super.key});

  @override
  Widget build(BuildContext context) {
    DashBoardController getc = Get.find();
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: kWhite,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: kBlack,
              ),
            ),
            const Spacer(),
            Text(
              "Best Properties",
              style: Palette.headerText,
            ),
            const Spacer()
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(26, 0, 26, 8),
        child: Column(
          children: [
            SearchBarWidget(   uniqueId: 'property_view',),


            const SizedBox(
              height: 15,
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: getc.properties.length,
                itemBuilder: ((context, index) {
                  return PropertyVertical(
                    properties: getc.properties[index],
                    startDate: "",
                    endDate: "",
                    fromSearch: false,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
