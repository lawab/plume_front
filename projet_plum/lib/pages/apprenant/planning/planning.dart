import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/pages/services/getUser.dart';
import 'package:projet_plum/pages/services/getUserOne.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Planning extends ConsumerStatefulWidget {
  const Planning({Key? key, required}) : super(key: key);

  @override
  ConsumerState<Planning> createState() => PlanningState();
}

class PlanningState extends ConsumerState<Planning> {
  @override
  void initState() {
    aa();
    // TODO: implement initState
    super.initState();
  }

  var idStu = '';
  var role = '';
  void aa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('Role')!;
      idStu = (role == 'STUDENT'
          ? prefs.getString('IdUser')
          : prefs.getString('IdStudent')!)!;
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

  Classe? classe;
  bool annuel = false;
  bool check = false;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataUserbyOneFuture);
    final viewModele = ref.watch(getDataClasseFuture);
    final viewModelee = ref.watch(getDataUserFuture);
    if (role == 'STUDENT') {
      if (check == false) {
        for (int i = 0; i < viewModelee.listStudent.length; i++) {
          if (viewModelee.listStudent[i].sId == idStu) {
            for (int j = 0; j < viewModele.listClasse.length; j++) {
              if (viewModelee.listStudent[i].classe!.body!.sId ==
                  viewModele.listClasse[j].sId) {
                classe = viewModele.listClasse[j];
                check = true;
              }
            }
          }
        }
      }
    } else {
      if (check == false) {
        for (int i = 0; i < viewModel.listStudent.length; i++) {
          if (viewModel.listStudent[i].sId == idStu) {
            for (int j = 0; j < viewModele.listClasse.length; j++) {
              if (viewModel.listStudent[i].classe!.body!.sId ==
                  viewModele.listClasse[j].sId) {
                classe = viewModele.listClasse[j];
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

  Widget horizontalView(double height, double width, contextt) {
    return AppLayout(
      content: Container(
        height: height,
        width: width,
        color: Palette.backgroundColor,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              height: 70,
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  annuel == false
                      ? classe == null
                          ? Text('Emploie de temps')
                          : Text('${classe!.title!} - Emploie de temps')
                      : classe == null
                          ? Text('Planning annuel')
                          : Text('${classe!.title!} - Planning annuel'),
                  Spacer(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: (Size(100, 60)),
                        backgroundColor: Palette.violetColor),
                    label: annuel == false
                        ? Text('Voir le planning annuel')
                        : Text("Voir l'emploie de temps"),
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () async {
                      setState(() {
                        annuel = !annuel;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            annuel == false
                ? Container(
                    //color: Colors.white,
                    height: height - 190,
                    width: width - 50,
                    child: classe == null //
                        ? const Center(
                            child: Text("PAS D'EMPLOIE DE TEMPS"),
                          )
                        : classe!.timeTable == null
                            ? const Center(
                                child: Text("PAS D'EMPLOIE DE TEMPS"))
                            : Image.network(
                                'http://13.39.81.126:7003${classe!.timeTable!}'),
                  )
                : Container(
                    //color: Colors.white,
                    height: height - 190,
                    width: width - 50,
                    child: classe == null // classe!.planning == null
                        ? const Center(
                            child: Text("PAS DE PLANNING ANNUEL"),
                          )
                        : classe!.planning == null
                            ? const Center(
                                child: Text("PAS DE PLANNING ANNUEL"))
                            : Image.network(
                                'http://13.39.81.126:7003${classe!.planning!}',
                              ),
                  ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    return AppLayout(content: Container());
  }
}
