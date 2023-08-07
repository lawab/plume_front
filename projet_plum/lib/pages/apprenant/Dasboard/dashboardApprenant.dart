import 'package:flutter/material.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

class DashboardApprenant extends StatefulWidget {
  const DashboardApprenant({Key? key}) : super(key: key);

  @override
  DashboardApprenantState createState() => DashboardApprenantState();
}

class DashboardApprenantState extends State<DashboardApprenant> {
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
          } else if (constraints.maxWidth >= 400) {
            return verticalView(height(context), width(context), context);
          } else {
            return mobile(height(context), width(context), context);
          }
        },
      ),
    );
  }

  Widget horizontalView(double height, double width, context) {
    return AppLayout(
      content: Container(
          height: height,
          width: width,
          color: Palette.backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //////////////////////////////////// Utilisateur, Note et cours non valider
                Container(
                  height: height / 2,
                  child: Row(children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        height: height / 2,
                        child: Column(
                          children: [
                            ///////////////////////////////////////////////////Utilisateurs
                            Container(
                              height: height / 4,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 2.5,
                                  ),
                                  Container(
                                    height: 15,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 20),
                                    child: const Text(
                                      "Activité de l'école",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2.5,
                                  ),
                                  Container(
                                    height: height / 4 - 20,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            color: Palette.violetColor,
                                            child: Container(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            color: Colors.white,
                                            child: Container(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ///////////////////////////////////////////////////Notes
                            Container(
                              height: height / 4,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 2.5,
                                  ),
                                  Container(
                                    height: 15,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(
                                      'Notes et scolarité',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2.5,
                                  ),
                                  Container(
                                    height: height / 4 - 20,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            color: Colors.amber,
                                            child: Container(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            color: Colors.white,
                                            child: Container(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ///////////////////////////////////////////////////Cours non valider
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 2.5,
                            ),
                            Container(
                              height: 15,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 20),
                              child: Text('Recommandations'),
                            ),
                            const SizedBox(
                              height: 2.5,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              color: Colors.white,
                              child: Container(
                                height: height / 2 - 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                ////////////////////////////////////FIN Utilisateur, Note et cours non valider
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  color: Colors.white,
                  child: Container(
                    height: 70,
                  ),
                ),
                Container(
                  height: height / 3 - 53,
                  child: Container(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 2.5,
                        ),
                        Container(
                          height: 15,
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.only(left: 20),
                          child: Text('Ecosystème'),
                        ),
                        const SizedBox(
                          height: 2.5,
                        ),
                        Container(
                          height: height / 3 - 73,
                          child: Row(
                            children: [
                              /*Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  color: Colors.white,
                                  child: Container(),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  color: Colors.white,
                                  child: Container(),
                                ),
                              ),*/
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  color: Colors.white,
                                  child: Container(),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget verticalView(double height, double width, context) {
    return AppLayout(
      content: Container(),
    );
  }

  Widget mobile(double height, double width, context) {
    return AppLayout(
      content: Container(),
    );
  }
}
