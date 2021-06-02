import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  static const MOBILE_BREAKPOINT = 540;
  static const TABLET_BREAKPOINT = 1200;

  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

// This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < MOBILE_BREAKPOINT;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < TABLET_BREAKPOINT &&
      MediaQuery.of(context).size.width >= MOBILE_BREAKPOINT;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= TABLET_BREAKPOINT;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // If our width is more than TABLET_BREAKPOINT then we consider it a desktop
      builder: (context, constraints) {
        if (constraints.maxWidth >= TABLET_BREAKPOINT) {
          return desktop;
        }
        // If width it less then TABLET_BREAKPOINT and more then MOBILE_BREAKPOINT we consider it as tablet
        else if (constraints.maxWidth >= MOBILE_BREAKPOINT) {
          return tablet;
        }
        // Or less then that we called it mobile
        else {
          return mobile;
        }
      },
    );
  }
}
