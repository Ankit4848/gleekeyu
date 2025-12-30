import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../src/SubPages/PropertyAllDetails/propertyAllDetails_controller.dart';
import '../src/SubPages/SearchPlaces/searchPlaces_controller.dart';
import '../utils/style/constants.dart';

class calander extends StatelessWidget {
  const calander({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchPlacesController getController = Get.find();
    PropertyAllDetailsController getController1 = Get.find();
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: kOrange,
            )),
        child: GetBuilder<SearchPlacesController>(
          initState: (a) {},
          builder: (a) {
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: SfDateRangePicker(
                initialSelectedRange: (a.startDate.value != "" && a.endDate.value != "")
                    ? PickerDateRange(
                        DateFormat('dd-MM-yyyy').parse(a.startDate.value),
                        DateFormat('dd-MM-yyyy').parse(a.endDate.value))
                    : null,
                navigationMode: DateRangePickerNavigationMode.scroll,
                showActionButtons: false,
                selectionShape: DateRangePickerSelectionShape.circle,
                enablePastDates: false,
                minDate: DateTime.now(),
                maxDate: DateTime.now().add(const Duration(days: 45)),
                monthViewSettings:
                    const DateRangePickerMonthViewSettings(blackoutDates: [
                  // DateTime(2022, 12, 29),
                  // DateTime(2023, 1, 2),
                  // DateTime(2023, 1, 3),
                ]),
                onSelectionChanged: ((args) {
                  if (args.value.startDate != null) {

                    getController.startDate.value = DateFormat('dd-MM-yyyy')
                        .format(DateTime.parse(args.value.startDate.toString()))
                        .toString();
                    getController1.startDate = DateFormat('dd-MM-yyyy')
                        .format(DateTime.parse(args.value.startDate.toString()))
                        .toString();

                  } else {

                    getController.startDate.value = "";

                  }
                  if (args.value.endDate != null) {
                    getController.endDate.value = DateFormat('dd-MM-yyyy')
                        .format(DateTime.parse(args.value.endDate.toString()))
                        .toString();
                    getController1.endDate = DateFormat('dd-MM-yyyy')
                        .format(DateTime.parse(args.value.endDate.toString()))
                        .toString();
                    Get.back();
                  } else {
                    getController.endDate.value = "";
                  }
                  getController1.update();
                  getController.priceUpdate();
                  getController.update();
                }),
                selectionMode: DateRangePickerSelectionMode.range,
              ),
            );
          },
        ));
  }
}
