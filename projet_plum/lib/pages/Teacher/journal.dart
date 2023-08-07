import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:projet_plum/pages/services/getClasse.dart' as c;
import 'package:projet_plum/pages/services/getCourss.dart';
import 'package:projet_plum/pages/tableau%20de%20bord/banniere.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

class DashboardTeacher extends ConsumerStatefulWidget {
  const DashboardTeacher({Key? key}) : super(key: key);

  @override
  DashboardTeacherState createState() => DashboardTeacherState();
}

class DashboardTeacherState extends ConsumerState<DashboardTeacher> {
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
    final viewModel = ref.watch(getDataCoursAllFuture);
    final viewModele = ref.watch(c.getDataClasseFuture);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(
                height(context),
                width(context),
                context,
                viewModel.listcoursNonvalideTeacher,
                viewModele.listClasseForTeacher,
                viewModel.listDevoirTeacher);
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
    context,
    List<Courses> listCours,
    List<c.Classe> listClasses,
    List<Homework> listDevoir,
  ) {
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
                                      "Cours non validés",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2.5,
                                  ),
                                  Container(
                                    height: height / 4 - 20,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      color: Palette.violetColor,
                                      child: Container(
                                        child: Center(
                                          child: listCours.isEmpty
                                              ? const Center(
                                                  child: Text(
                                                    'Aucun cours non validé',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                )
                                              : ListView.builder(
                                                  itemCount: listCours.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                          border: Border()),
                                                      child: Row(children: [
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Container(
                                                          width: 100,
                                                          child: CircleAvatar(
                                                            radius: 20,
                                                            backgroundColor: Palette
                                                                .backgroundColor,
                                                            child: ImageNetwork(
                                                              image:
                                                                  'http://13.39.81.126:7002${listCours[index].image}',
                                                              height: 100,
                                                              width: 100,
                                                              duration: 1500,
                                                              curve:
                                                                  Curves.easeIn,
                                                              onPointer: true,
                                                              debugPrint: false,
                                                              fullScreen: false,
                                                              fitAndroidIos:
                                                                  BoxFit.cover,
                                                              fitWeb: BoxFitWeb
                                                                  .cover,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          70),
                                                              onLoading:
                                                                  const CircularProgressIndicator(
                                                                color: Colors
                                                                    .indigoAccent,
                                                              ),
                                                              onError:
                                                                  const Icon(
                                                                Icons.error,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: Container()),
                                                        Text(
                                                          listCours[index]
                                                              .title!,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Expanded(
                                                            child: Container()),
                                                        Text(
                                                          listCours[index]
                                                              .createdAt!,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
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
                                    padding: const EdgeInsets.only(left: 20),
                                    child: const Text(
                                      'Utilisateur par classe',
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
                                            child: Container(
                                              child: listClasses.isEmpty
                                                  ? const Center(
                                                      child: Text(
                                                        'Aucune classe',
                                                        style: TextStyle(
                                                            fontSize: 30,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          listClasses.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Container(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                listClasses[
                                                                        index]
                                                                    .title!,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                maxRadius: 20,
                                                                child: Text(listClasses[
                                                                        index]
                                                                    .students!
                                                                    .length
                                                                    .toString()),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
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
                              padding: const EdgeInsets.only(left: 20),
                              child: const Text('Devoir de maison'),
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
                                padding: const EdgeInsets.all(10),
                                height: height / 2 - 28,
                                child: bb(listDevoir),
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

  Widget bb(
    List<Homework> listDevoir,
  ) {
    return listDevoir.isEmpty
        ? const Center(
            child: Text(
              'Aucun devoirs',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            ),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 50,
                mainAxisExtent: 100),
            itemCount: listDevoir.length,
            itemBuilder: (context, index) {
              DateTime aa = DateTime.parse(listDevoir[index].limitDate!);
              DateTime bb = DateTime.now();

              aa = DateTime(aa.year, aa.month, aa.day);
              bb = DateTime(bb.year, bb.month, bb.day);
              print('jour');
              print((bb.difference(aa).inHours / 24).round());
              int jour = (aa.difference(bb).inHours / 24).round();
              return jour < 0
                  ? Container()
                  : Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                                height: 100,
                                color: jour > 3
                                    ? const Color.fromARGB(255, 15, 68, 16)
                                    : jour < 3 && jour >= 2
                                        ? const Color.fromARGB(255, 143, 87, 4)
                                        : const Color.fromARGB(255, 146, 12, 2),
                                child: Image.asset('assets/devoir.png')),
                          ),
                          Expanded(
                            flex: 6,
                            child: Container(
                              color: jour > 3
                                  ? Colors.green
                                  : jour < 3 && jour >= 2
                                      ? Colors.orange
                                      : Colors.red,
                              child: Column(
                                children: [
                                  Text(
                                    listDevoir[index].title!,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Divider(
                                    height: 5,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    listDevoir[index].description!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${aa.day}-${aa.month}-${aa.year}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      //
                    );
            });
  }
}
