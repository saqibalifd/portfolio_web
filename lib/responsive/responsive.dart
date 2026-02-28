import 'package:flutter/material.dart';
import 'package:myportfolio/constants/size.dart';

class Responsive {
  // Check if the device is mobile
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < kMobileWidth;

  // Check if the device is desktop
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= kMobileWidth;

  // Helper widget to switch between mobile and desktop widgets
  static Widget widget({
    required BuildContext context,
    required Widget mobile,
    required Widget desktop,
  }) {
    return isMobile(context) ? mobile : desktop;
  }
}
