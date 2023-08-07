import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/pages/services/getPresence.dart';
import 'package:projet_plum/utils/palette.dart';

class PresenceAdmin extends ConsumerStatefulWidget {
  final List<Students> listEleve;
  final String idClasse;
  final String idCourse;
  const PresenceAdmin({
    Key? key,
    required this.listEleve,
    required this.idClasse,
    required this.idCourse,
  }) : super(key: key);

  @override
  ConsumerState<PresenceAdmin> createState() => PresenceAdminState();
}

class PresenceAdminState extends ConsumerState<PresenceAdmin> {
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

  bool isselect = false;
  bool check2 = false;
  bool check = false;
  bool check1 = false;

  List<Presences> listPresence = [];
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataPresenceFuture);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.presenceList);
          } else {
            return verticalView(height(context), width(context), context);
          }
        },
      ),
    );
  }

  int date = 0;
  Widget horizontalView(
      double height, double width, contextt, List<Presences> listPresence) {
    date = DateTime.now().weekday;
    var day = '';
    var month = '';
    if (DateTime.now().day.toString().length == 1) {
      day = '0${DateTime.now().day}';
    } else {
      day = '${DateTime.now().day}';
    }
    if (DateTime.now().month.toString().length == 1) {
      month = '0${DateTime.now().month}';
    } else {
      month = '${DateTime.now().month}';
    }
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height - 130,
        width: MediaQuery.of(context).size.width,
        color: Palette.backgroundColor,
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Container(
              child: Container(
                child: Row(
                  children: [
                    const Text('Date:  '),
                    Text('$day-$month-${DateTime.now().year}'),
                    Expanded(
                      child: Container(),
                    ),
                    const SizedBox(
                      width: 5,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            /////////////////////////
            Container(
              height: 5,
              child: Row(children: [
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 4,
                  child: Container(),
                ),
                date != 1
                    ? Expanded(
                        flex: 1,
                        child: Container(),
                      )
                    : Expanded(
                        flex: 1,
                        child: Container(
                          color: Color.fromARGB(255, 42, 237, 240),
                        ),
                      ),
                date != 2
                    ? Expanded(
                        flex: 1,
                        child: Container(),
                      )
                    : Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.pink,
                        ),
                      ),
                date != 3
                    ? Expanded(
                        flex: 1,
                        child: Container(),
                      )
                    : Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.amber,
                        ),
                      ),
                date != 4
                    ? Expanded(
                        flex: 1,
                        child: Container(),
                      )
                    : Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.green,
                        ),
                      ),
                date != 5
                    ? Expanded(
                        flex: 1,
                        child: Container(),
                      )
                    : Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.blue,
                        ),
                      ),
                const SizedBox(
                  width: 5,
                ),
              ]),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 50,
              child: Row(children: [
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Color.fromARGB(255, 209, 208, 208),
                    child: Center(
                      child: Text('Nom et prenom'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Color.fromARGB(255, 42, 237, 240),
                    child: Center(
                      child: Text('Lundi'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.pink,
                    child: Center(
                      child: Text('Mardi'),
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.amber,
                      child: Center(
                        child: Text('Mercredi'),
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.green,
                    child: Center(
                      child: Text('Jeudi'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.blue,
                    child: Center(
                      child: Text('Vendredi'),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
              ]),
            ),

            ////////////////////////
            Container(
              height: height - 334, //204,
              child: listPresence.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucune liste de présence',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  : ListView.builder(
                      itemCount: listPresence.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              height: 30,
                              child: Row(children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    color: Color.fromARGB(255, 230, 229, 229),
                                    child: Center(
                                      child: Text(
                                          '${listPresence[index].student!.firstName} ${listPresence[index].student!.lastName}'),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Color.fromARGB(255, 127, 242, 244),
                                    child: Center(
                                      child: presenceY(
                                          listPresence,
                                          'lundi',
                                          listPresence[index].lundi!.presence!,
                                          index),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Color.fromARGB(255, 252, 132, 172),
                                    child: Center(
                                      child: presenceY(
                                          listPresence,
                                          'mardi',
                                          listPresence[index].mardi!.presence!,
                                          index),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Color.fromARGB(255, 244, 211, 114),
                                      child: Center(
                                        child: presenceY(
                                            listPresence,
                                            'mercredi',
                                            listPresence[index]
                                                .mercredi!
                                                .presence!,
                                            index),
                                      ),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Color.fromARGB(255, 158, 247, 161),
                                    child: Center(
                                      child: presenceY(
                                          listPresence,
                                          'jeudi',
                                          listPresence[index].jeudi!.presence!,
                                          index),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Color.fromARGB(255, 134, 195, 245),
                                    child: Center(
                                      child: presenceY(
                                          listPresence,
                                          'vendredi',
                                          listPresence[index]
                                              .vendredi!
                                              .presence!,
                                          index),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ]),
                            ),
                            Container(height: 2, color: Colors.white),
                          ],
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, contextt) {
    return Scaffold(body: Container());
  }

  Widget presenceY(
      List<Presences> presence, String day, bool isSelected, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isSelected == false ? Text('Absent  ') : Text('Présent '),
        isSelected == true
            ? Icon(
                Icons.check_box,
                color: Colors.green[700],
              )
            : const Icon(
                Icons.check_box_outline_blank_outlined,
                color: Color.fromARGB(255, 139, 32, 32),
              ),
      ],
    );
  }
}
