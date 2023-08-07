import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:projet_plum/pages/services/getBehavior.dart';
import 'package:projet_plum/pages/services/getCourss.dart';
import 'package:projet_plum/pages/services/getDocument.dart';
import 'package:projet_plum/pages/services/getRDV.dart';
import 'package:projet_plum/pages/services/getReport.dart';
import 'package:projet_plum/pages/services/getUser.dart';
import 'package:projet_plum/pages/tableau%20de%20bord/banniere.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends ConsumerState<Dashboard> {
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

  List<User> eleveAssign = [];
  int countEcart = 0;
  int countRapport = 0;
  bool check = false;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataCoursAllFuture);
    final viewModele = ref.watch(getDataUserFuture);
    final viewModelee = ref.watch(getDataRDVFuture);
    final viewModeleee = ref.watch(getDataDocumentFuture);
    final viewModeleeee = ref.watch(getDataReportsFuture);
    final viewModeleeeee = ref.watch(getDataBehaviorFuture);

    if (check == false) {
      for (int i = 0; i < viewModele.listStudent.length; i++) {
        if (viewModele.listStudent[i].repo == true) {
          for (int j = 0; j < viewModeleeee.listReports.length; j++) {
            if (viewModele.listStudent[i].reports!
                .contains(viewModeleeee.listReports[j].sId)) {
              if (viewModeleeee.listReports[j].validated == false) {
                countRapport++;
                check = true;
              }
            }
          }
        }
      }
      for (int i = 0; i < viewModele.listStudent.length; i++) {
        if (viewModele.listStudent[i].repo == true) {
          for (int j = 0; j < viewModeleeeee.listBehavior.length; j++) {
            if (viewModele.listStudent[i].reports!
                .contains(viewModeleeeee.listBehavior[j].sId)) {
              if (viewModeleeeee.listBehavior[j].validated == false) {
                countEcart++;
                check = true;
              }
            }
          }
        }
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(
                height(context),
                width(context),
                context,
                viewModel.listcoursNonvalide,
                viewModele.listStudent,
                viewModele.listParent,
                viewModele.listAllUsers,
                viewModelee.listAppointment,
                viewModeleee.listDocument);
          } else if (constraints.maxWidth >= 400) {
            return verticalView(height(context), width(context), context);
          } else {
            return mobile(height(context), width(context), context);
          }
        },
      ),
    );
  }

  Widget horizontalView(
    double height,
    double width,
    contextt,
    List<Courses> listCours,
    List<User> liststudent,
    List<User> listParent,
    List<User> listTotal,
    List<Appointment> listRdv,
    List<Document> listDoc,
  ) {
    return AppLayout(
      content: Container(
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
                                    child: Text(
                                      'Utilisateurs',
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
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                            'Elèves',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            maxRadius: 20,
                                                            child: Text(
                                                                liststudent
                                                                    .length
                                                                    .toString()),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                            'Parent',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            maxRadius: 20,
                                                            child: Text(
                                                                listParent
                                                                    .length
                                                                    .toString()),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            color: Colors.white,
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'Utilisateurs',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Palette.violetColor,
                                                    maxRadius: 50,
                                                    child: Text(
                                                      listTotal.length
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
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
                                    child: Row(children: [
                                      Expanded(
                                        child: Container(
                                          height: 15,
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: 20),
                                          child: const Text(
                                            'Demandes',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 15,
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: 20),
                                          child: const Text(
                                            'Validations',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ]),
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
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                          text:
                                                              "Demande de rendez-vous: ",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Allerta',
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        TextSpan(
                                                          text: listRdv.length
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Bevan',
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                          text:
                                                              "Demande de document: ",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Allerta',
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        TextSpan(
                                                          text: listDoc.length
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Bevan',
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            color: Colors.white,
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                          text:
                                                              "Ecart non confirmé: ",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Allerta',
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        TextSpan(
                                                          text: countEcart
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Bevan',
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                          text:
                                                              "Rapport non confirmé: ",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Allerta',
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        TextSpan(
                                                          text: countRapport
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Bevan',
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
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
                              child: Text('Cours non validés'),
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
                                padding: const EdgeInsets.all(10),
                                child: Center(
                                  child: listCours.isEmpty
                                      ? const Center(
                                          child: Text(
                                            'Aucun cours non validé',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: listCours.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          Palette.violetColor)),
                                              child: Row(children: [
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor:
                                                        Palette.backgroundColor,
                                                    child: ImageNetwork(
                                                      image:
                                                          'http://13.39.81.126:7002${listCours[index].image}',
                                                      height: 100,
                                                      width: 100,
                                                      duration: 1500,
                                                      curve: Curves.easeIn,
                                                      onPointer: true,
                                                      debugPrint: false,
                                                      fullScreen: false,
                                                      fitAndroidIos:
                                                          BoxFit.cover,
                                                      fitWeb: BoxFitWeb.cover,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              70),
                                                      onLoading:
                                                          const CircularProgressIndicator(
                                                        color:
                                                            Colors.indigoAccent,
                                                      ),
                                                      onError: const Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(child: Container()),
                                                Text(
                                                  listCours[index].title!,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                Expanded(child: Container()),
                                                Text(
                                                  listCours[index].createdAt!,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                              ]),
                                            );
                                          }),
                                ),
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
                    child: Banne(),
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
                          child: Text('Chiffres'),
                        ),
                        const SizedBox(
                          height: 2.5,
                        ),
                        Container(
                          height: height / 3 - 73,
                          child: Row(
                            children: [
                              Expanded(
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
                              ),
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
