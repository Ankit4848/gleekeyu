// ignore_for_file: depend_on_referenced_packages

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/SubPages/appBarWithTitleAndBack.dart';
import 'package:gleekeyu/src/Auth/profile/profile_controller.dart';
import 'package:gleekeyu/utils/baseconstant.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/widgets/commonText.dart';
// import 'package:gleeky_flutter/src/Auth/controller/userLogin_controller.dart';
// import 'package:gleeky_flutter/src/host/setting/edit_personal_info_screen.dart';
// import 'package:gleeky_flutter/utills/app_colors.dart';
// import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'edit_personal_info_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstName = TextEditingController();

  final TextEditingController _lastName = TextEditingController();

  final TextEditingController _birthdate = TextEditingController();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _pincode = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final RxString _country = 'Select Your Country'.obs;
  final RxString _countryID = ''.obs;
  final RxString _state = 'Select Your State'.obs;
  final RxString _stateID = ''.obs;
  final RxString _city = 'Select Your City'.obs;
  final RxString _cityID = ''.obs;
  // final TextEditingController _governmentID = TextEditingController();

  // Initial Selected Value
  RxString dropdownvalue = 'Gender'.obs;

  // List of items in our dropdown menu
  var items = [
    'Gender',
    'Male',
    'Female',
  ];

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ProfileController.to.getCountryApi();
    });
    // log(currUser?.userDetails?.gender ?? 'Gender');
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

    // dropdownvalue.value = currUser?.userDetails?.gender ?? 'Gender';
    // _governmentID.text = 'Adhar Card';

    // _emergencyContect.text = currUser?.userDetails?.about ?? "";
    super.initState();
  }

  ProfileController userController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWithTitleAndBack(title: "Profile"),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Opacity(
                              opacity: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20),
                                child: commonText(
                                  text: 'EDIT',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
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
                                            backgroundColor: klightgrey,
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
                            InkWell(
                              onTap: () {
                                Get.to(() => const EditPersonalInfoScreen());
                              },
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20),
                                child: commonText(
                                  text: 'EDIT',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        commonText(
                          text:
                              'Hi, ${currUser?.data?.firstName ?? ''} ${currUser?.data?.lastName ?? ''}',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        commonText(
                          text:
                              'Member Since, ${DateFormat('dd/MM/yyyy').format(DateTime.parse((currUser?.data?.createdAt ?? '0000-00-00').toString()))}',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    IgnorePointer(
                      ignoring: true,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commonText(
                                    text: 'First Name',
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commonText(
                                    text: 'Last Name',
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
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
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                            ProfileController.to
                                                .getStateApi(params: {
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
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
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                                  : ProfileController
                                                      .to
                                                      .getStateRes['data']
                                                      .length,
                                              (j) => ProfileController
                                                  .to
                                                  .getStateRes['data'][j]
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
                                                .to.getStateRes['data'];
                                            int tmpId = tmpList.indexWhere(
                                                (element) =>
                                                    element['name'] == value);
                                            _state.value = ProfileController
                                                    .to.getStateRes['data']
                                                [tmpId]['name'];
                                            _stateID.value = ProfileController
                                                .to
                                                .getStateRes['data'][tmpId]
                                                    ['id']
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
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
                                                : ProfileController.to
                                                    .getCityRes['data'].length,
                                            (j) => ProfileController.to
                                                .getCityRes['data'][j]['name']
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
                                          _city.value = ProfileController
                                                  .to.getCityRes['data'][tmpId]
                                              ['name'];
                                          _cityID.value = ProfileController.to
                                              .getCityRes['data'][tmpId]['id']
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
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
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  setState(() {
                                    _birthdate.text =
                                        formattedDate; //set output date to TextField value.
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
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000, 01, 01),
                                          //DateTime.now() - not to allow to choose before today.
                                          lastDate: DateTime.now(),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme:
                                                    const ColorScheme.light(
                                                  primary: kOrange,
                                                ),
                                                textButtonTheme:
                                                    TextButtonThemeData(
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        kOrange, // button text color
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
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

                          const SizedBox(height: 10),

                          // Column(
                          //   children: [
                          //     Row(
                          //       children: [
                          //         Expanded(
                          //           child: Column(
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             children: [
                          //               commonText(
                          //                 text: 'Describe Yourself',
                          //                 fontSize: 14,
                          //                 fontWeight: FontWeight.w500,
                          //                 color: Colors.black,
                          //               ),
                          //               TextFormField(
                          //                 cursorColor: kOrange,
                          //                 style: TextStyle(
                          //                   fontSize: 13,
                          //                   fontWeight: FontWeight.w400,
                          //                   color:
                          //                       Colors.black.withOpacity(0.5),
                          //                 ),
                          //                 controller: _emergencyContect,
                          //                 readOnly: true,
                          //                 decoration: const InputDecoration(
                          //                     border: InputBorder.none,
                          //                     isDense: true),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //     Divider(
                          //       color: Colors.black.withOpacity(0.2),
                          //     ),
                          //     const SizedBox(
                          //       height: 8,
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
