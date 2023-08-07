import 'package:flutter/material.dart';
import 'package:projet_plum/utils/barhaut.dart';
import 'package:projet_plum/utils/navigation.dart';

class AppLayout extends StatefulWidget {
  final Widget content;
  static BuildContext? context2;

  const AppLayout({Key? key, required this.content}) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  MediaQueryData mediaQueryData(BuildContext context) {
    return MediaQuery.of(context);
  }

  Size size(BuildContext buildContext) {
    return mediaQueryData(buildContext).size;
  }

  double width(BuildContext buildContext) {
    return size(buildContext).width;
  }

  double height(BuildContext buildContext) {
    return size(buildContext).height;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context);
          } else {
            return verticalView(height(context), width(context), context);
          }
        },
      ),
    );
  }

  Widget horizontalView(double height, double width, context) {
    return Scaffold(
      body: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            /**
            !BARRE DE NAVIGATION VERTICAL 
                                      **/
            Container(
              color: Colors.white,
              height: 100,
              child: BarreHaute(),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 250,
                    child: Navigation(
                      orientation: Axis.vertical,
                    ),
                  ),
                  Expanded(child: widget.content),
                ],
              ),
            )
            /*Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                        width: 4, color: Palette.yellowColor //fourthColor,
                        ),
                  ),
                  color: Palette.primaryBackgroundColor,
                ),
                child: Column(
                  children: [
                    DrawerHeader(
                      child: Image.asset(
                        'assets/logo_vert.png',
                      ),
                    ),
                    Expanded(
                      child: Navigation(
                        orientation: Axis.vertical,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(right: 0.0, bottom: 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 60,
                      child: BarreHaute(),
                    ),
                    /**
                        !BARRE HAUTE 
                                      **/

                    Expanded(child: widget.content),
                  ],
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    return Scaffold(
      body: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            /**
                        !BARRE HAUTE 
                                      **/
            const SizedBox(
              height: 60,
              child: BarreHaute(),
            ),
            /**
            !BARRE DE NAVIGATION VERTICAL 
                                      **/
            SizedBox(
              height: 50,
              child: Navigation(
                orientation: Axis.horizontal,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: widget.content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
