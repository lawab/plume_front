import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/Teacher/gestionEleve/rapport.dart';
import 'package:projet_plum/pages/gestionEleveAdmin/ecartAdmin.dart';
import 'package:projet_plum/pages/gestionEleveAdmin/signaleAdmin.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;

enum SampleItem { itemOne, itemTwo, itemThree, itemFour }

class EtudiantAssignes extends ConsumerStatefulWidget {
  final String idClasse;
  const EtudiantAssignes({Key? key, required this.idClasse}) : super(key: key);

  @override
  EtudiantAssignesState createState() => EtudiantAssignesState();
}

class EtudiantAssignesState extends ConsumerState<EtudiantAssignes> {
  List<Students> eleveAssign = [];
  SampleItem? selectedMenu;
  bool traitement = false;
  var rapportController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataClasseFuture);
    if (traitement == false) {
      for (int i = 0; i < viewModel.listClasse.length; i++) {
        if (viewModel.listClasse[i].sId == widget.idClasse) {
          eleveAssign.addAll(viewModel.listClasse[i].students!);
          traitement = true;
        }
      }
    }

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Container(
        padding: EdgeInsets.all(40),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 50,
                mainAxisExtent: 100),
            itemCount: eleveAssign.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 50,
                  child: Row(
                    children: [
                      Text(eleveAssign[index].user!.firstName!),
                      const Spacer(),
                      Container(
                        child: Column(
                          children: [
                            more(eleveAssign[index]),
                            const Spacer(),
                            CircleAvatar(
                              maxRadius: 20,
                              backgroundColor: Colors.black,
                              child: IconButton(
                                  onPressed: () {
                                    desassignation(
                                        context, eleveAssign[index].user!.sId!);
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  )),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget more(
    Students apprenant,
  ) {
    return PopupMenuButton(
      tooltip: 'Menu',
      initialValue: selectedMenu,
      // Callback that sets the selected popup menu item.
      onSelected: (SampleItem item) async {
        setState(() {
          selectedMenu = item;
        });

        if (item == SampleItem.itemOne) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignalerAdmin(
                        eleve: apprenant,
                      )));
        } else if (item == SampleItem.itemTwo) {
          dialogRapport(apprenant.user!.sId, apprenant.user!.firstName);
        } else if (item == SampleItem.itemThree) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EcartAdmin(
                eleve: apprenant.user!,
                modif: false,
              ),
            ),
          );
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Rapport(
                        eleve: apprenant.user!,
                        modif: false,
                      )));
        }
      },
      child: const Icon(
        Icons.menu,
        size: 20,
        color: Colors.black,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          child: Text('Signaler un écart'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemTwo,
          child: Text('Rapport'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemThree,
          child: Text('Voir les écarts'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemFour,
          child: Text('voir les rapports'),
        ),
      ],
    );
  }

  Future<http.Response> desassignation(contextt, String idUser) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var idclasse = prefs.getString('idClasse');
      //String adress_url = prefs.getString('ipport').toString();
      String url =
          "http://13.39.81.126:7003/api/classes/unAssignUser/$idclasse/$idUser";
      print(url);
      final http.Response response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Elève désassigné avec succès",
          ),
        );
        setState(() {
          eleveAssign = [];
          traitement = false;
        });
        ref.refresh(getDataClasseFuture);

        return response;
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de désassignation",
          ),
        );
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future dialogRapport(id, nom) {
    return showDialog(
        context: context,
        builder: (con) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Center(
              child: Row(
                children: [
                  const Icon(Icons.document_scanner_outlined),
                  Text(
                    "Rapport de $nom",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'HelveticaNeue',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.edit,
                  size: 14,
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  serviceRapport(context, 'cours', id, rapportController.text);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Confirmer   "),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.close,
                  size: 14,
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(con);
                },
                label: const Text("Annuler."),
              ),
            ],
            content: Container(
              alignment: Alignment.center,
              color: Colors.white,
              height: 255,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                      maxLines: 10,
                      minLines: 10,
                      controller: rapportController,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                          hoverColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 42, vertical: 20),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Palette.violetColor),
                            gapPadding: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Palette.violetColor),
                            gapPadding: 10,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Palette.violetColor),
                            gapPadding: 10,
                          ),
                          labelText: "Rapport",
                          hintText: "",
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon:
                              const Icon(Icons.document_scanner_outlined)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> serviceRapport(
      BuildContext contextT, idCourse, studentId, rapport) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');

    print(id);
    print(token);

    var url = Uri.parse("http://13.39.81.126:7001/api/reports/create");
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );

    var json = {
      "courseId": idCourse,
      "creator": id,
      "studentId": studentId,
      "report": rapport,
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

        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Rapport créé avec succès",
          ),
        );
        Navigator.pop(context);
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de création",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}
