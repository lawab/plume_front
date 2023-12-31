import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    required this.smallScreen,
    this.mediumScreen,
    this.largeScreen,
    Key? key,
  }) : super(key: key);

  final Widget? largeScreen;
  final Widget? mediumScreen;
  final Widget smallScreen;

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 800 &&
        MediaQuery.of(context).size.width <= 1200;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 200) {
          return smallScreen;
        } else if (constraints.maxWidth <= 800 && constraints.maxWidth >= 200) {
          return mediumScreen ?? smallScreen;
        } else {
          return largeScreen ?? smallScreen;
        }
      },
    );
  }
}
