// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
// import 'package:dio/dio.dart' as dio;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/extras/commonWidget.dart';
import 'package:gleekeyu/src/Auth/Login/userLogin_controller.dart';
import 'package:gleekeyu/src/Auth/profile/profile_controller.dart';
import 'package:gleekeyu/src/SubPages/appBarWithTitleAndBack.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/utils/style/palette.dart';
import 'package:gleekeyu/widgets/commonText.dart';
import 'package:gleekeyu/widgets/loder.dart';
import 'package:dio/dio.dart' as dio;
// import 'package:gleeky_flutter/API/api_config.dart';
// import 'package:gleeky_flutter/src/Auth/controller/userLogin_controller.dart';
// import 'package:gleeky_flutter/src/host/dash_board/controller/getUserController.dart';
// import 'package:gleeky_flutter/src/host/setting/controller/edit_personal_info_Controller.dart';
// import 'package:gleeky_flutter/utills/app_colors.dart';
// import 'package:gleeky_flutter/utills/commonWidget.dart';
// import 'package:gleeky_flutter/utills/loder.dart';
// import 'package:gleeky_flutter/utills/snackBar.dart';
// import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../widgets/showSnackBar.dart';

class EditPersonalInfoScreen extends StatefulWidget {
  const EditPersonalInfoScreen({Key? key}) : super(key: key);

  @override
  State<EditPersonalInfoScreen> createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _describeController = TextEditingController();

  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _birthdate = TextEditingController();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _pincode = TextEditingController();

  final TextEditingController _phoneNumber = TextEditingController();

  // final TextEditingController _governmentID = TextEditingController();

  // Initial Selected Value
  RxString dropdownvalue = 'Gender'.obs;

  // List of items in our dropdown menu
  var items = [
    'Gender',
    'Male',
    'Female',
  ];
  final RxString _country = 'Select Your Country'.obs;
  final RxString _countryID = ''.obs;
  final RxString _state = 'Select Your State'.obs;
  final RxString _stateID = ''.obs;
  final RxString _city = 'Select Your City'.obs;
  final RxString _cityID = ''.obs;

  @override
  initState() {
    _firstName.text = currUser?.data?.firstName ?? "";
    _lastName.text = currUser?.data?.lastName ?? "";
    _email.text = currUser?.data?.email ?? "";
    dropdownvalue.value = currUser?.userDetails?.gender ?? "Male";
    _phoneNumber.text =
        currUser?.data?.formattedPhone ?? currUser?.data?.phone ?? '';
    _birthdate.text = currUser?.userDetails?.dateOfBirth ?? '';
    _countryID.value = (currUser?.data?.countryId ?? 0).toString();
    _stateID.value = (currUser?.data?.stateId ?? 0).toString();
    _cityID.value = (currUser?.data?.countryId ?? 0).toString();
    _address.text = (currUser?.data?.address ?? '').toString();
    _pincode.text = (currUser?.data?.pincode ?? '').toString();
    _country.value = currUser?.data?.countyName ?? "";
    _state.value = currUser?.data?.stateName ?? '';
    _city.value = currUser?.data?.cityName ?? '';
    // // _governmentID.text = 'Adhar Card';
    _describeController.text = currUser?.userDetails?.about ?? "";
    super.initState();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxString imgPath = ''.obs;
  Future pickImg() async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        imgPath.value = pickedFile.path;
      }
    } catch (e) {
      // showSnackBar(title: ApiConfig.error, message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBarWithTitleAndBack(title: "Edit Personal Info"),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Obx(() {
              return Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: imgPath.value != ''
                              ? kIsWeb
                                  ? Image.memory(
                                      File(imgPath.value).readAsBytesSync(),
                                      fit: BoxFit.scaleDown,
                                    )
                                  : Image.file(
                                      File(imgPath.value),
                                      fit: BoxFit.cover,
                                    )
                              : Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            currUser?.data?.profileSrc ?? '',
                                        placeholder: (context, url) =>
                                            const CupertinoActivityIndicator(
                                              color: kOrange,
                                            ),
                                        errorWidget: (context, url, error) =>
                                            const CircleAvatar(
                                              backgroundColor: kLightGrey,
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.black,
                                              ),
                                            ),
                                        height: 100,
                                        width: 100,
                                        memCacheHeight: 110,
                                        memCacheWidth: 110,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                        ),
                      ),

                      // CircleAvatar(
                      //   minRadius: 50,
                      //   backgroundImage: AssetImage(AppImages.homeImg),
                      // ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            pickImg();
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.camera_alt_outlined,
                                color: Colors.black, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Center(
                child: Text(
                  "Please upload a clear photo to help hosts and guests to learn about each other.",
                  textAlign: TextAlign.center,
                  style: Palette.bestText2,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonText(
                                  text: 'First Name *',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                TextFormField(
                                  controller: _firstName,
                                  cursorColor: kOrange,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonText(
                                  text: 'Last Name *',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                TextFormField(
                                  controller: _lastName,
                                  cursorColor: kOrange,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonText(
                                  text: 'Email Address *',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                TextFormField(
                                  controller: _email,
                                  readOnly: true,
                                  cursorColor: kOrange,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonText(
                                  text: 'Mobile *',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                TextFormField(
                                  controller: _phoneNumber,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    MaskTextInputFormatter(
                                        mask: '##########',
                                        filter: {"#": RegExp(r'[0-9]')},
                                        type: MaskAutoCompletionType.lazy)
                                  ],
                                  readOnly: true,
                                  cursorColor: kOrange,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonText(
                                  text: 'I Am *',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                Obx(() {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 5),
                                    child: DropdownButton(
                                      isDense: true,
                                      value: dropdownvalue.value,
                                      underline: const SizedBox(),
                                      isExpanded: true,
                                      borderRadius: BorderRadius.circular(6),
                                      icon: const Icon(Icons.arrow_drop_down),
                                      items: items.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: commonText(
                                            text: items,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        dropdownvalue.value = newValue!;
                                      },
                                    ),
                                  );
                                }),
                                const SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonText(
                                  text: 'Country *',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                Obx(() {
                                  return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: DropdownSearch<String>(
                                        popupProps: const PopupProps.menu(
                                          showSelectedItems: true,
                                          showSearchBox: true,
                                        ),
                                        items: List.generate(
                                            ProfileController
                                                    .to.getCountryRes.isEmpty
                                                ? 0
                                                : ProfileController
                                                    .to
                                                    .getCountryRes['data']
                                                    .length,
                                            (j) => ProfileController
                                                .to
                                                .getCountryRes['data'][j]
                                                    ['name']
                                                .toString()),
                                        dropdownDecoratorProps:
                                            const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  border: InputBorder.none),
                                        ),
                                        onChanged: (value) {
                                          List tmpList = ProfileController
                                              .to.getCountryRes['data'];
                                          _country.value = value ?? '';
                                          int tmpId = tmpList.indexWhere(
                                              (element) =>
                                                  element['name'] == value);
                                          _countryID.value =
                                              tmpList[tmpId]['id'].toString();
                                          ProfileController.to.getStateApi(
                                              params: {
                                                'country_id':
                                                    _countryID.value.toString()
                                              });
                                          _state.value = 'Select Your State';
                                          _city.value = 'Select Your City';
                                        },
                                        selectedItem: _country.value,
                                      ));
                                }),
                                const SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonText(
                                  text: 'State *',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                Obx(() {
                                  return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: DropdownSearch<String>(
                                        popupProps: const PopupProps.menu(
                                          showSelectedItems: true,
                                          showSearchBox: true,
                                        ),
                                        items: List.generate(
                                            ProfileController
                                                    .to.getStateRes.isEmpty
                                                ? 0
                                                : ProfileController.to
                                                    .getStateRes['data'].length,
                                            (j) => ProfileController.to
                                                .getStateRes['data'][j]['name']
                                                .toString()),
                                        dropdownDecoratorProps:
                                            const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                                  border: InputBorder.none),
                                        ),
                                        onChanged: (value) {
                                          List tmpList = ProfileController
                                              .to.getStateRes['data'];
                                          int tmpId = tmpList.indexWhere(
                                              (element) =>
                                                  element['name'] == value);
                                          _state.value = ProfileController
                                                  .to.getStateRes['data'][tmpId]
                                              ['name'];
                                          _stateID.value = ProfileController.to
                                              .getStateRes['data'][tmpId]['id']
                                              .toString();
                                          ProfileController.to.getCityApi(
                                              params: {
                                                'state_id':
                                                    _stateID.value.toString()
                                              });
                                          _city.value = 'Select Your City';
                                        },
                                        selectedItem: _state.value,
                                      ));
                                }),
                                const SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonText(
                                  text: 'City *',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                Obx(() {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: DropdownSearch<String>(
                                      popupProps: const PopupProps.menu(
                                        showSelectedItems: true,
                                        showSearchBox: true,
                                      ),
                                      items: List.generate(
                                          ProfileController
                                                  .to.getCityRes.isEmpty
                                              ? 0
                                              : ProfileController
                                                  .to.getCityRes['data'].length,
                                          (j) => ProfileController
                                              .to.getCityRes['data'][j]['name']
                                              .toString()),
                                      dropdownDecoratorProps:
                                          const DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                                border: InputBorder.none),
                                      ),
                                      onChanged: (value) {
                                        List tmpList = ProfileController
                                            .to.getCityRes['data'];
                                        int tmpId = tmpList.indexWhere(
                                            (element) =>
                                                element['name'] == value);
                                        _city.value = ProfileController.to
                                            .getCityRes['data'][tmpId]['name'];
                                        _cityID.value = ProfileController
                                            .to.getCityRes['data'][tmpId]['id']
                                            .toString();
                                      },
                                      selectedItem: _city.value,
                                    ),
                                  );
                                }),
                                const SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonText(
                                  text: 'Address *',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                TextFormField(
                                  controller: _address,
                                  maxLines: 3,
                                  cursorColor: kOrange,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonText(
                                  text: 'Pincode *',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                TextFormField(
                                  controller: _pincode,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    MaskTextInputFormatter(
                                        mask: '######',
                                        filter: {"#": RegExp(r'[0-9]')},
                                        type: MaskAutoCompletionType.lazy)
                                  ],
                                  cursorColor: kOrange,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: InkWell(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: _birthdate.text.trim().isNotEmpty
                                    ? DateTime.parse(_birthdate.text)
                                    : DateTime.now(),
                                firstDate: DateTime(1950),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: kOrange,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              Colors.red, // button text color
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (pickedDate != null) {
                                print(pickedDate);
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(formattedDate);
                                setState(() {
                                  _birthdate.text = formattedDate;
                                });
                              } else {}
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commonText(
                                    text: 'Birthdate',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  TextFormField(
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                      await showDatePickerDialog(
                                        context: context,
                                        initialDate: DateTime(2000, 1, 1),
                                        minDate: DateTime(1950, 1, 1),
                                        maxDate: DateTime(2024, 10, 30),
                                        width: 350,
                                        height: 400,
                                        currentDate: DateTime(2000, 1, 1),
                                        selectedDate: DateTime(2000, 1, 1),
                                        currentDateDecoration: const BoxDecoration(),
                                        currentDateTextStyle: const TextStyle(),
                                        daysOfTheWeekTextStyle: const TextStyle(),
                                        disabledCellsTextStyle: const TextStyle(),
                                        enabledCellsDecoration: const BoxDecoration(),
                                        enabledCellsTextStyle: const TextStyle(),
                                        initialPickerType: PickerType.days,
                                        selectedCellDecoration: const BoxDecoration(),
                                        selectedCellTextStyle: const TextStyle(),
                                        leadingDateTextStyle: const TextStyle(),
                                        slidersColor: Colors.lightBlue,
                                        highlightColor: Colors.redAccent,
                                        slidersSize: 20,
                                        splashColor: Colors.lightBlueAccent,
                                        splashRadius: 40,
                                        centerLeadingDate: true,
                                      );

                                      if (pickedDate != null) {
                                        print(
                                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                        String formattedDate =
                                            DateFormat('dd-MM-yyyy')
                                                .format(pickedDate);
                                        print(
                                            formattedDate); //formatted date output using intl package =>  2021-03-16
                                        setState(() {
                                          _birthdate.text =
                                              formattedDate; //set output date to TextField value.
                                        });
                                      } else {}
                                    },
                                    controller: _birthdate,
                                    validator: (value) {
                                      return ProfileController.to
                                          .birthDateValidator(value ?? '');
                                    },
                                    cursorColor: kOrange,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 8),
                        //   child: Divider(
                        //     color: Colors.black.withOpacity(0.2),
                        //   ),
                        // ),
                        // const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonText(
                                  text: 'Describe Yourself',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                TextFormField(
                                  controller: _describeController,
                                  cursorColor: kOrange,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Tell us about Yourself..!',
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Column(children: [
                        //   Row(
                        //     children: [
                        //       Expanded(
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Text('Describe Yourself',
                        //                 style: color00000s14w500),
                        //             TextFormField(
                        //               cursorColor: kOrange,
                        //               style: color50perBlacks13w400,
                        //               controller: _emergencyContect,
                        //               decoration: const InputDecoration(
                        //                   border: InputBorder.none,
                        //                   isDense: true),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       // isEditable.value
                        //       //     ? IconButton(
                        //       //         onPressed: () {
                        //       //           isEditable.value = false;
                        //       //         },
                        //       //         splashColor: Colors.transparent,
                        //       //         icon: const Icon(
                        //       //           Icons.close,
                        //       //           size: 20,
                        //       //         ))
                        //       //     : InkWell(
                        //       //         onTap: () {
                        //       //           isEditable.value = true;
                        //       //         },
                        //       //         splashColor: Colors.transparent,
                        //       //         highlightColor: Colors.transparent,
                        //       //         child: Container(
                        //       //           decoration: BoxDecoration(
                        //       //               border: Border.all(
                        //       //                   color: Colors.black),
                        //       //               borderRadius:
                        //       //                   BorderRadius.circular(6)),
                        //       //           padding: const EdgeInsets.symmetric(
                        //       //               vertical: 5, horizontal: 12),
                        //       //           child: const Text('Edit'),
                        //       //         ),
                        //       //       )
                        //     ],
                        //   ),
                        //   Divider(
                        //     color: Colors.black.withOpacity(0.2),
                        //   ),
                        //   const SizedBox(
                        //     height: 8,
                        //   ),
                        // ]),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kWhite,
                              boxShadow: [
                                BoxShadow(
                                    color: kBlack.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 1)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/lock.png',
                                height: 30,
                                width: 30,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                "Which information can be changed?",
                                style: Palette.bestText,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                "Details that Gleekey uses to verify your identity can’t be changed. Contact information and a few other personal details are editable, but the next time you make a reservation or create a listing, we might ask you to prove your identity.",
                                style: Palette.bestText3,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kWhite,
                              boxShadow: [
                                BoxShadow(
                                    color: kBlack.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 1)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/lock.png',
                                height: 30,
                                width: 30,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                "What details are disclosed to others?",
                                style: Palette.bestText,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                "After a reservation is confirmed, Gleekey only makes hosts' and visitors' contact information available.",
                                style: Palette.bestText3,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        CommonButton(
                            onPressed: () async {
                              // isEditable.value = false;

                              if (dropdownvalue.value == 'Gender') {
                                showSnackBar(
                                    title: '',
                                    message: 'Please Select the gender.');
                              } else {
                                if (formKey.currentState!.validate()) {
                                  loaderShow(context);
                                  ProfileController.to.editPersonalInfoAPI(
                                    params: imgPath.value == ''
                                        ? {
                                            'first_name':
                                                _firstName.text.trim(),
                                            'last_name': _lastName.text.trim(),
                                            'email': _email.text.trim(),
                                            'phone': _phoneNumber.text
                                                .substring(
                                                    _phoneNumber.text.length -
                                                        10)
                                                .trim(),
                                            'formatted_phone':
                                                _phoneNumber.text.trim(),
                                            "date_of_birth":
                                                _birthdate.text.trim(),
                                            "details[about]":
                                                _describeController.text.trim(),
                                            'gender': dropdownvalue.value,
                                            'default_country': 'in',
                                            'carrier_code': _phoneNumber.text
                                                .trim()
                                                .substring(
                                                    0,
                                                    _phoneNumber.text.length -
                                                        10)
                                                .replaceAll('+', ''),
                                            "country_id": _countryID,
                                            "state_id": _stateID,
                                            "city_id": _cityID,
                                            "pincode": _pincode.text.trim(),
                                            "address": _address.text.trim()
                                          }
                                        : {
                                            'first_name':
                                                _firstName.text.trim(),
                                            'last_name': _lastName.text.trim(),
                                            'email': _email.text.trim(),
                                            'phone': _phoneNumber.text.trim(),
                                            "photos[]": [
                                              await dio.MultipartFile.fromFile(
                                                  imgPath.value,
                                                  filename: imgPath.value),
                                            ],
                                            "date_of_birth":
                                                _birthdate.text.trim(),
                                            "details[about]":
                                                _describeController.text.trim(),
                                            'gender': dropdownvalue.value,
                                            'default_country': 'in',
                                            'carrier_code': _phoneNumber.text
                                                .trim()
                                                .substring(
                                                    0,
                                                    _phoneNumber.text.length -
                                                        10)
                                                .replaceAll('+', ''),
                                            "country_id": _countryID,
                                            "state_id": _stateID,
                                            "city_id": _cityID,
                                            "pincode": _pincode.text.trim(),
                                            "address": _address.text.trim()
                                          },
                                    isFormData: true,
                                    error: (e) {
                                      loaderHide();
                                      showSnackBar(
                                        title: 'Error',
                                        message: e.toString(),
                                      );
                                    },
                                    success: () {
                                      loaderHide();
                                      Get.back();
                                      Get.back();
                                      UserLoginController.to.defaultLogin();
                                      showSnackBar(
                                          title: 'Succes',
                                          color: kGreen,
                                          message:
                                              'Profile Updated Successfully..');
                                    },
                                  );
                                }
                              }
                              // EditPersonalInfoController.to.editPersonalInfoAPI(
                              //   params: imgPath.value == ''
                              //       ? {
                              //           'first_name': _firstName.text,
                              //           'last_name': _lastName.text,
                              //           'email': _email.text,
                              //           'phone': _phoneNumber.text,
                              //           "date_of_birth": _birthdate.text,
                              //           "details[about]": _emergencyContect.text,
                              //         }
                              //       : {
                              //           'first_name': _firstName.text,
                              //           'last_name': _lastName.text,
                              //           'email': _email.text,
                              //           'phone': _phoneNumber.text,
                              //           "photos[]": [
                              //             await http.MultipartFile.fromPath(
                              //                 "", imgPath.value,
                              //                 filename: imgPath.value),
                              //           ],
                              //           "date_of_birth": _birthdate.text,
                              //           "details[about]": _emergencyContect.text,
                              //         },
                              //   isFormData: true,
                              //   error: (e) {
                              //     loaderHide();
                              //     // showSnackBar(
                              //     //   title: ApiConfig.error,
                              //     //   message: e.toString(),
                              //     // );
                              //   },
                              //   success: () {
                              //     loaderHide();
                              //     Get.back();
                              //     Get.back();
                              //     // showSnackBar(
                              //     //     title: ApiConfig.success,
                              //     //     message: 'Profile Updated Successfully..');
                              //     // GetUserController.to.getUserApi();
                              //   },
                              // );
                            },
                            name: 'Save'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
