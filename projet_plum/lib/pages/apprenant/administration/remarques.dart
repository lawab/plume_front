import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/services/getBehavior.dart';
import 'package:projet_plum/pages/services/getReport.dart';
import 'package:projet_plum/pages/services/getUser.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Remarques extends ConsumerStatefulWidget {
  const Remarques({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<Remarques> createState() => RemarquesState();
}

class RemarquesState extends ConsumerState<Remarques> {
  @override
  void initState() {
    aa();
    // TODO: implement initState
    super.initState();
  }

  var idStudent = '';
  void aa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idStudent = prefs.getString('IdStudent')!;
    });
  }

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

  List<Reports> listRapport = [];
  List<Behavior> listEcart = [];
  bool check = false;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataUserFuture);
    final viewModeleeee = ref.watch(getDataReportsFuture);
    final viewModeleeeee = ref.watch(getDataBehaviorFuture);

    if (check == false) {
      for (int i = 0; i < viewModel.listStudent.length; i++) {
        if (viewModel.listStudent[i].repo == true) {
          for (int j = 0; j < viewModeleeee.listReports.length; j++) {
            if (viewModel.listStudent[i].reports!
                .contains(viewModeleeee.listReports[j].sId)) {
              if (viewModeleeee.listReports[j].validated == true) {
                listRapport.add(viewModeleeee.listReports[j]);
                check = true;
              }
            }
          }
        }
      }
      for (int i = 0; i < viewModel.listStudent.length; i++) {
        if (viewModel.listStudent[i].repo == true) {
          for (int j = 0; j < viewModeleeeee.listBehavior.length; j++) {
            if (viewModel.listStudent[i].reports!
                .contains(viewModeleeeee.listBehavior[j].sId)) {
              if (viewModeleeeee.listBehavior[j].validated == true) {
                listEcart.add(viewModeleeeee.listBehavior[j]);
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
            return horizontalView(height(context), width(context), context);
          } else {
            return verticalView(height(context), width(context), context);
          }
        },
      ),
    );
  }

//List<Children> listStudent
  Widget horizontalView(double height, double width, contextt) {
    return AppLayout(
      content: Container(
        color: Palette.backgroundColor,
        height: height,
        width: width,
        child: Column(children: [
          Container(
            width: width,
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(
                Icons.backspace,
                color: Palette.violetColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            //padding: EdgeInsets.all(20),
            child: const Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Ecart de comportement',
                      style: TextStyle(
                          fontFamily: 'Bevan',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Rapports',
                      style: TextStyle(
                          fontFamily: 'Bevan',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: height - 200,
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    child: Container(
                      child: listEcart.isEmpty
                          ? const Center(
                              child: Text(
                                'Aucun Ecart à signaler',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          : ListView.builder(
                              itemCount: listEcart.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Text('Gravité:  '),
                                              ),
                                              Container(
                                                height: 20,
                                                width: 100,
                                                color: listEcart[index]
                                                            .gravity ==
                                                        'niveau 1'
                                                    ? Colors.amber
                                                    : listEcart[index]
                                                                .gravity ==
                                                            'niveau 2'
                                                        ? const Color.fromARGB(
                                                            255, 177, 134, 5)
                                                        : Colors.red,
                                                child: Center(
                                                  child: Text(
                                                    listEcart[index].gravity!,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Text('Cours:  '),
                                              ),
                                              Container(
                                                height: 20,
                                                width: 100,
                                                child: Center(
                                                  child: Text(
                                                    listEcart[index]
                                                        .course!
                                                        .title!,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Text('Date: '),
                                              ),
                                              Container(
                                                child: Text(listEcart[index]
                                                    .createdAt!),
                                              )
                                            ]),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: const Text('Motif'),
                                      ),
                                      Container(
                                        color: Colors.grey,
                                        height: 100,
                                        width: width / 2,
                                        child: Center(
                                          child: Text(listEcart[index].motif!),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Card(
                    child: Container(
                      child: listRapport.isEmpty
                          ? const Center(
                              child: Text(
                                'Aucun rapport ',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          : ListView.builder(
                              itemCount: listRapport.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Row(children: [
                                    Expanded(
                                        flex: 7,
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 50,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              height: 100,
                                              width: width / 2,
                                              child: Center(
                                                child: Text(
                                                    listRapport[index].report!),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )),
                                  ]),
                                );
                              },
                            ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget verticalView(double height, double width, contextt) {
    return AppLayout(
      content: Container(
        color: Palette.backgroundColor,
        height: height,
        width: width,
        child: Column(children: []),
      ),
    );
  }
}
