// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';

import 'package:gleekeyu/src/SubPages/SearchPlaces/searchPlaces_controller.dart';
import 'package:gleekeyu/src/SubPages/SearchPlaces/searchPlaces_view.dart';
import '../../../utils/style/constants.dart';
import '../../../utils/style/palette.dart';
import '../../../widgets/commonText.dart';
import '../../../widgets/loder.dart';
import '../../../widgets/text_fields_widgets/custom_textfield_common.dart';
import '../../../widgets/viewCalanderInFilter.dart';
import '../Filter/filter.dart';

class SearchBarWidget extends StatefulWidget {
  final bool isShowFilter;
  final String? uniqueId;

  const SearchBarWidget({
    Key? key,
    this.isShowFilter = false,
    this.uniqueId,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late SearchPlacesController controller;
  late String instanceId;

  @override
  void initState() {
    super.initState();
    // Create unique instance ID
    instanceId = widget.uniqueId ?? DateTime.now().millisecondsSinceEpoch.toString();

    // Get controller safely
    try {
      controller = Get.find<SearchPlacesController>();
      controller.startDate.value="";
      controller.endDate.value="";
    } catch (e) {
      // If controller doesn't exist, create it
      Get.put(SearchPlacesController());
      controller = Get.find<SearchPlacesController>();
      controller.startDate.value="";
      controller.endDate.value="";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: Key('search_bar_row_$instanceId'), // Unique key for this instance
      children: [
        if (widget.isShowFilter)
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 25,
            ),
          ),
        if (widget.isShowFilter)
          const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _showSearchBottomSheet(context);
            },
            child: Container(
              key: Key('search_container_$instanceId'), // Unique key
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF000000).withOpacity(0.12),
                ),
              ),
              width: double.maxFinite,
              child: Theme(
                data: Theme.of(context).copyWith(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.search_rounded,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    GetBuilder<SearchPlacesController>(
                      builder: (a) {
                        return commonText(
                          text: a.selectedPlace,
                          color: kTextgrey,
                          fontSize: 14,
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (widget.isShowFilter) ...[
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              Get.to(() => const Filter());
            },
            child: Card(
              elevation: 4,
              color: kOrange,
              shape: Palette.smallCardShape,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/filter.png'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      //key: Key('search_bottom_sheet_$instanceId'), // Unique key for bottom sheet
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            SizedBox(
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFB1B1B1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDestinationSection(),
                    const SizedBox(height: 16),
                    _buildPropertyNameSection(),
                    const SizedBox(height: 16),
                    _buildCheckInOutSection(),
                    const SizedBox(height: 16),
                    _buildGuestsSection(),
                    const SizedBox(height: 14),
                    _buildActionButtons(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDestinationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonText(
          text: "Destination",
          color: kBlack.withAlpha(125),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return const DestinationDialog();
              },
            );
          },
          child: Container(
            key: Key('destination_container_$instanceId'),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kWhite,
              boxShadow: [
                BoxShadow(
                  color: kDarkGrey.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0.0, 5.0),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GetBuilder<SearchPlacesController>(
                  builder: (a) {
                    return Expanded(
                      child: commonText(
                        maxlines: 1,
                        text: a.selectedPlace,
                        color: kBlack,
                        textAlign: TextAlign.start,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
                Image.asset(
                  "assets/images/global-search.png",
                  color: kOrange,
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonText(
          text: "Property Name",
          color: kBlack.withAlpha(125),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 16),
        Theme(
          data: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
          ),
          child: Container(
            key: Key('property_name_container_$instanceId'),
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kWhite,
              boxShadow: [
                BoxShadow(
                  color: kDarkGrey.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0.0, 5.0),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[350],
                  ),
                  height: 45,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: commonText(
                        text: '#GLEEKEYFARMHOUSE-',
                        color: kOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CustomTextfieldCommon(
                    isBorder: false,
                    controller: controller.gleekeySearchController,
                    hint: 'Property ID',
                    validate: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  void debugPrintDateValues() {
    print("=== DEBUG DATE VALUES ===");
    print("Start Date RxString value: '${controller.startDate.value}'");
    print("End Date RxString value: '${controller.endDate.value}'");
    print("Start Date isEmpty: ${controller.startDate.value.isEmpty}");
    print("End Date isEmpty: ${controller.endDate.value.isEmpty}");
    print("========================");
  }

  Widget _buildCheckInOutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonText(
          text: "Check in - Check out",
          color: kBlack.withAlpha(125),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 16),
        GetBuilder<SearchPlacesController>(
          builder: (a) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const DialogForCheckInCheckOutDate();
                  },
                ).then((value) {
                  debugPrintDateValues();
                  a.update(); // Force rebuild to show updated values

                },);
              },
              child: Container(
                key: Key('checkin_checkout_container_$instanceId'),
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kWhite,
                  boxShadow: [
                    BoxShadow(
                      color: kDarkGrey.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0.0, 5.0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      commonText(
                        text: "${a.startDate.value==""? "Start Date":a.startDate.value} - ${a.endDate.value=="" ? "End Date":a.endDate.value}",
                        color: kBlack,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      Image.asset(
                        "assets/images/booking_icon_color.png",
                        color: kOrange,
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGuestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonText(
          text: "Adults & Child's",
          color: kBlack.withAlpha(125),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 16),
        _buildGuestRow("Adults :", "A"),
        const SizedBox(height: 14),
        _buildGuestRow("Children :", "C", subtitle: "(Above 5 Year)"),
        const SizedBox(height: 14),
        _buildGuestRow("Children :", "I", subtitle: "(0-5 Year)"),
      ],
    );
  }

  Widget _buildGuestRow(String label, String variable, {String? subtitle}) {
    return Row(
      children: [
        Container(
          width: 100,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonText(
                text: label,
                color: kBlack.withAlpha(125),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              if (subtitle != null)
                commonText(
                  text: subtitle,
                  color: kBlack.withAlpha(100),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
            ],
          ),
        ),
        const SizedBox(width: 25),
        AddRemoveButtons(
          key: Key('add_remove_${variable}_$instanceId'),
          variable: variable,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Bounce(
          duration: const Duration(milliseconds: 300),
          onPressed: () {
            controller.pridiction = [];
            controller.selectedPlace = "Search Places";
            controller.startDate.value = "";
            controller.endDate.value = "";
            controller.totalAdults.text = '1';
            controller.totalChildren.text = '0';
            controller.totalInphant.text = '0';
            controller.gleekeySearchController.text = '';
            controller.update();
          },
          child: Container(
            key: Key('clear_button_$instanceId'),
            height: 30,
            width: 60,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: kDarkGrey.withOpacity(0.5),
                  blurRadius: 2,
                ),
              ],
              color: kWhite,
              border: Border.all(
                color: kBlack.withOpacity(0.6),
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: commonText(
                text: "Clear",
                color: kBlack.withAlpha(125),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        GetBuilder<SearchPlacesController>(
          builder: (a) {
            return Bounce(
              duration: const Duration(milliseconds: 300),
              onPressed: () async {
                loaderShow(context);
                await a.getApi();
              },
              child: Container(
                key: Key('search_button_$instanceId'),
                height: 30,
                width: 60,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: kDarkGrey.withOpacity(0.5),
                      blurRadius: 2,
                    ),
                  ],
                  color: kOrange,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: commonText(
                    text: "Search",
                    color: kWhite,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Fixed AddRemoveButtons widget
class AddRemoveButtons extends StatelessWidget {
  final String variable;

  const AddRemoveButtons({
    Key? key,
    required this.variable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchPlacesController>(
      builder: (a) {
        return Row(
          children: [
            const SizedBox(width: 14),
            Bounce(
              onPressed: () {
                switch (variable) {
                  case "A":
                    int totalAdults = int.parse(a.totalAdults.text);
                    totalAdults > 1 ? totalAdults-- : null;
                    a.totalAdults.text = totalAdults.toString();
                    break;
                  case "C":
                    int totalChildred = int.parse(a.totalChildren.text);
                    totalChildred > 0 ? totalChildred-- : null;
                    a.totalChildren.text = totalChildred.toString();
                    break;
                  case "I":
                    int totalInphant = int.parse(a.totalInphant.text);
                    totalInphant > 0 ? totalInphant-- : null;
                    a.totalInphant.text = totalInphant.toString();
                    break;
                }
                a.update();
              },
              duration: const Duration(milliseconds: 100),
              child: Container(
                height: 27,
                width: 27,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kOrange),
                ),
                child: const Icon(
                  Icons.remove_rounded,
                  color: kOrange,
                  size: 25,
                ),
              ),
            ),
            const SizedBox(width: 25),
            commonText(
              text: variable == "A"
                  ? a.totalAdults.text.toString()
                  : variable == "C"
                  ? a.totalChildren.text.toString()
                  : a.totalInphant.text.toString(),
              color: kBlack,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
            const SizedBox(width: 25),
            Bounce(
              onPressed: () {
                switch (variable) {
                  case "A":
                    int totalAdults = int.parse(a.totalAdults.text);
                    totalAdults++;
                    a.totalAdults.text = totalAdults.toString();
                    break;
                  case "C":
                    int totalChildred = int.parse(a.totalChildren.text);
                    totalChildred++;
                    a.totalChildren.text = totalChildred.toString();
                    break;
                  case "I":
                    int totalInphant = int.parse(a.totalInphant.text);
                    totalInphant++;
                    a.totalInphant.text = totalInphant.toString();
                    break;
                }
                a.update();
              },
              duration: const Duration(milliseconds: 100),
              child: Container(
                height: 27,
                width: 27,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kOrange),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: kOrange,
                  size: 24,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Keep your existing PopupItem classes
class PopupItem extends PopupMenuItem {
  const PopupItem({
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  @override
  _PopupItemState createState() => _PopupItemState();
}

class _PopupItemState extends PopupMenuItemState {
  @override
  void handleTap() {}
}