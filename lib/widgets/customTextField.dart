// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:ecomerce_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final ValueChanged<String> onSubmitted;
  final FocusNode onFocusNode;
  String? hintText, validatorMsg;
  Widget? suffixIcon, prefixIcon;
  bool isVisible;

  CustomTextField({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onFocusNode,
    this.suffixIcon,
    this.prefixIcon,
    required this.textInputType,
    required this.hintText,
    required this.isVisible,
    required this.validatorMsg,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.grey,
      textAlignVertical: TextAlignVertical.center,
      autocorrect: false,
      minLines: 1,
      // onFieldSubmitted: onSubmitted,
      onChanged: onSubmitted,
      focusNode: onFocusNode,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Padding(
          padding: EdgeInsets.only(right: 17.sp),
          child: prefixIcon,
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 17.sp),
          child: suffixIcon ?? Container(),
        ),
        suffixIconConstraints:
        BoxConstraints(maxHeight: 40.sp, maxWidth: 50.sp),
        hintText: hintText,
        hintStyle:
        interRegularTextStyle.copyWith(fontSize: 16.sp, color: Colors.black26),
      ),
      style: interRegularTextStyle.copyWith(
        fontSize: 18.sp,
        color: Colors.black45,
        decoration: TextDecoration.none,
      ),
      keyboardType: textInputType,
      obscureText: !isVisible,
      maxLines: 1,
    );
  }
}
