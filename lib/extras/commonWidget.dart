// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app_colors.dart';
import 'text_styles.dart';

MaterialButton CommonButton(
    {String? name,
    TextStyle? style,
    double? radius,
    double? width,
    Color? color,
    Widget? child,
    required VoidCallback onPressed,
    EdgeInsetsGeometry? padding}) {
  return MaterialButton(
    color: color ?? AppColors.colorFE6927,
    minWidth: width,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 6)),
    onPressed: onPressed,
    padding: padding,
    child: child ??
        Text(
          name ?? '',
          style: style ?? colorfffffffs13w600,
        ),
  );
}

Container CommonBottomBar({required Widget child}) {
  return Container(
      height: 80,
      decoration: BoxDecoration(
          color: AppColors.colorffffff,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 5,
                spreadRadius: 3)
          ]),
      child: child);
}

StreamBuilder<bool> CommonCheckBox(RxBool rxValue) {
  return StreamBuilder(
      stream: rxValue.stream,
      builder: (context, snapshot) {
        return Checkbox(
          value: rxValue.value,
          onChanged: (val) {
            rxValue.value = !rxValue.value;
          },
          activeColor: AppColors.colorFE6927,
          side: BorderSide(
              color: AppColors.color000000.withOpacity(0.5), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        );
      });
}

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? helpText;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final bool? isObscureText;
  final String? labelText;
  final Color? lableColor;
  final EdgeInsets? padding;
  final String? initialValue;

  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final double? width;
  final int? maxLine;
  final String? Function(String? value)? validator;
  final Function(String? value)? onChange;

  const CustomTextField(
      {super.key,
      this.controller,
      this.hintText,
      this.suffixIcon,
      this.textInputType,
      this.isObscureText,
      this.labelText,
      this.padding,
      this.onTap,
      this.inputFormatters,
      this.helpText,
      this.prefixIcon,
      this.width,
      this.maxLine,
      this.validator,
      this.onChange,
      this.initialValue,
      this.lableColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null) ...{
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                labelText!,
                style: TextStyle(
                  fontSize: lableColor != null ? 13 : 16,
                  color: lableColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 9),
          },
          SizedBox(
            width: width ?? double.infinity,
            child: TextFormField(
              inputFormatters: inputFormatters,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              initialValue: initialValue,
              readOnly: onTap != null ? true : false,
              controller: controller,
              onTap: onTap,
              onChanged: onChange,
              maxLines: maxLine ?? 1,
              validator: validator,
              keyboardType: textInputType,
              obscureText: isObscureText ?? false,
              decoration: InputDecoration(
                prefixIcon: prefixIcon,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                isDense: true,
                hintText: hintText ?? '',
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
                suffixIcon: suffixIcon,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? helpText;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final bool? isObscureText;
  final String? labelText;
  final EdgeInsets? padding;
  final List<dynamic> items;
  final String? valueSuffix;
  final dynamic value;

  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final double? width;
  final int? maxLine;
  final String? Function(Object? value)? validator;
  final void Function(dynamic)? onChange;

  const CustomDropdownField({
    super.key,
    this.controller,
    this.hintText,
    this.suffixIcon,
    this.textInputType,
    this.isObscureText,
    this.labelText,
    this.padding,
    this.onTap,
    this.inputFormatters,
    this.helpText,
    this.prefixIcon,
    this.width,
    this.maxLine,
    this.validator,
    this.onChange,
    this.valueSuffix,
    required this.value,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (labelText != null) ...{
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  labelText!,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              const SizedBox(height: 9),
            },
            DropdownButtonFormField(
              items: items
                  .map((e) => DropdownMenuItem(
                      value: e, child: Text('$e $valueSuffix')))
                  .toList(),
              onChanged: onChange,
              value: value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              validator: validator,
              padding: EdgeInsets.zero,
              decoration: InputDecoration(
                prefixIcon: prefixIcon,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                isDense: true,
                hintText: hintText ?? '',
                hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                suffixIcon: suffixIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
