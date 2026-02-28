import 'package:flutter/material.dart';
import 'package:myportfolio/constants/colors.dart';

class CustomTextfield extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final int? maxLine;
  const CustomTextfield({
    super.key,
    this.hintText,
    this.controller,
    this.maxLine = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLine,
      style: TextStyle(color: CustomColor.scaffoldBg),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: CustomColor.hintDark),
        contentPadding: EdgeInsets.all(16),
        filled: true,
        fillColor: CustomColor.whiteSecondary,
        focusedBorder: getInputBorder,
        enabledBorder: getInputBorder,
        border: getInputBorder,
      ),
    );
  }

  OutlineInputBorder get getInputBorder {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    );
  }
}
