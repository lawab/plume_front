import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/pages/services/getPresence.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Presence extends ConsumerStatefulWidget {
  final List<Students> listEleve;
  final String idClasse;
  final String idCourse;
  const Presence({
    Key? key,
    required this.listEleve,
    required this.idClasse,
    required this.idCourse,
  }) : super(key: key);

  @override
  ConsumerState<Presence> createState() => PresenceState();
}

class PresenceState extends ConsumerState<Presence> {
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
                viewModel.listPresence.presences!, viewModel.listPresence);
          } else {
            return verticalView(height(context), width(context), context);
          }
        },
      ),
    );
  }

  int date = 0;
  Widget horizontalView(double height, double width, contextt,
      List<Presences> listPresence, PresenceS presence) {
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
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: (Size(100, 30)),
                          backgroundColor: Palette.violetColor),
                      label: Text("Valider la semaine"),
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        if (date == 3) {
                          presenceValidation(context, presence.coursesId,
                              presence.classeId, presence.week);
                        } else {
                          showDialog(
                              context: context,
                              builder: (con) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: const Center(
                                    child: Text(
                                      "Avertissement",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'HelveticaNeue',
                                      ),
                                    ),
                                  ),
                                  content: Container(
                                    height: 100,
                                    child: Center(
                                      child: Text(
                                          'La validation de la semaine se fait Vendredi'),
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton.icon(
                                      icon: const Icon(
                                        Icons.create,
                                        size: 14,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Palette.violetColor),
                                      onPressed: () {
                                        Navigator.pop(con);
                                      },
                                      label: const Text("Compris."),
                                    ),
                                  ],
                                );
                              });
                        }
                      },
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
                                      child: date == 1
                                          ? presenceW(
                                              listPresence,
                                              'lundi',
                                              listPresence[index]
                                                  .lundi!
                                                  .presence!,
                                              index,
                                              presence)
                                          : presenceY(
                                              listPresence,
                                              'lundi',
                                              listPresence[index]
                                                  .lundi!
                                                  .presence!,
                                              index),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Color.fromARGB(255, 252, 132, 172),
                                    child: Center(
                                      child: date == 2
                                          ? presenceW(
                                              listPresence,
                                              'mardi',
                                              listPresence[index]
                                                  .mardi!
                                                  .presence!,
                                              index,
                                              presence)
                                          : presenceY(
                                              listPresence,
                                              'mardi',
                                              listPresence[index]
                                                  .mardi!
                                                  .presence!,
                                              index),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      color: Color.fromARGB(255, 244, 211, 114),
                                      child: Center(
                                        child: date == 3
                                            ? presenceW(
                                                listPresence,
                                                'mercredi',
                                                listPresence[index]
                                                    .mercredi!
                                                    .presence!,
                                                index,
                                                presence)
                                            : presenceY(
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
                                      child: date == 4
                                          ? presenceW(
                                              listPresence,
                                              'jeudi',
                                              listPresence[index]
                                                  .jeudi!
                                                  .presence!,
                                              index,
                                              presence)
                                          : presenceY(
                                              listPresence,
                                              'jeudi',
                                              listPresence[index]
                                                  .jeudi!
                                                  .presence!,
                                              index),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Color.fromARGB(255, 134, 195, 245),
                                    child: Center(
                                      child: date == 5
                                          ? presenceW(
                                              listPresence,
                                              'vendredi',
                                              listPresence[index]
                                                  .vendredi!
                                                  .presence!,
                                              index,
                                              presence)
                                          : presenceY(
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

  Widget presenceW(List<Presences> presencee, String day, bool isSelected,
      int index, PresenceS presence) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isSelected == false ? Text('Absent  ') : Text('Présent '),
        IconButton(
          onPressed: () {
            setState(() {
              if (isSelected == false) {
                isSelected = true;
                if (day == 'lundi') {
                  presencee[index].lundi!.presence = true;
                } else if (day == 'mardi') {
                  presencee[index].mardi!.presence = true;
                } else if (day == 'mercredi') {
                  presencee[index].mercredi!.presence = true;
                } else if (day == 'jeudi') {
                  presencee[index].jeudi!.presence = true;
                } else {
                  presencee[index].vendredi!.presence = true;
                }
                presenceService(
                    context,
                    widget.listEleve[index].user!.sId!,
                    widget.idCourse,
                    widget.idClasse,
                    day,
                    true,
                    DateTime.now().toString(),
                    'cpt',
                    presence.week);
              } else {
                isSelected = false;
                if (day == 'lundi') {
                  presencee[index].lundi!.presence = false;
                } else if (day == 'mardi') {
                  presencee[index].mardi!.presence = false;
                } else if (day == 'mercredi') {
                  presencee[index].mercredi!.presence = false;
                } else if (day == 'jeudi') {
                  presencee[index].jeudi!.presence = false;
                } else {
                  presencee[index].vendredi!.presence = false;
                }
                presenceService(
                    context,
                    widget.listEleve[index].user!.sId!,
                    widget.idCourse,
                    widget.idClasse,
                    day,
                    false,
                    DateTime.now().toString(),
                    'cpt',
                    presence.week);
              }
            });
          },
          icon: isSelected == true
              ? Icon(
                  Icons.check_box,
                  color: Colors.green[700],
                )
              : const Icon(
                  Icons.check_box_outline_blank_outlined,
                  color: Color.fromARGB(255, 139, 32, 32),
                ),
        ),
      ],
    );
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

  Future<void> presenceService(
    BuildContext context,
    idStudent,
    idCourse,
    idClasse,
    day,
    presence,
    date,
    cpt,
    week,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var year = DateTime.now().year;
    print(id);
    print(token);

    var url = Uri.parse("http://13.39.81.126:7003/api/presences/create");
    final request = MultipartRequest(
      'PUT',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
// "creator": id,
    var json = {
      "studentId": idStudent,
      "courseId": idCourse,
      "creator": id,
      "classeId": idClasse,
      "day": day,
      "presence": presence,
      "date": date,
      "cpt": cpt,
      "week": week,
      "year": year
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    print("RESPENSE SEND STEAM FILE REQ");

    var response = await request.send();
    print("Upload Response$response");
    print(response.statusCode);
    print(request.headers);
    print(request.fields);
    print(response.request);

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });

        //ref.refresh(getDataCourssFuture);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Présence notifié avec succès",
          ),
        );
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de modification",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> presenceValidation(
      BuildContext contextT, idCourse, idClasse, week) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var year = DateTime.now().year;
    print(id);
    print(token);

    var url = Uri.parse("http://13.39.81.126:7003/api/presences/createWeek");
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    int wee = int.parse(week) + 1;
// "creator": id,
    var json = {
      "courseId": idCourse,
      "classeId": widget.idClasse,
      "creator": id,
      "week": wee,
      "year": year
    };
    var body = jsonEncode(json);
    print(body);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    print("RESPENSE SEND STEAM FILE REQ");

    var response = await request.send();
    print("Upload Response$response");
    print(response.statusCode);

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });

        //ref.refresh(getDataCourssFuture);
        setState(() {
          ref.refresh(getDataPresenceFuture);
        });

        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Semaine Validée avec succès",
          ),
        );
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de validation",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}
