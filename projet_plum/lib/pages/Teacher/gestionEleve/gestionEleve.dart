import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:projet_plum/pages/Teacher/gestionEleve/rapport.dart';
import 'package:projet_plum/pages/Teacher/gestionEleve/signaler.dart';
import 'package:projet_plum/pages/gestionEleveAdmin/ecartAdmin.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../utils/multipart.dart';

enum SampleItem { itemOne, itemTwo, itemThree, itemFour }

class GestionEleve extends ConsumerStatefulWidget {
  final List<Students> listEleve;
  final List<Courses> list;
  final String classe;

  const GestionEleve(
      {Key? key,
      required this.listEleve,
      required this.list,
      required this.classe})
      : super(key: key);

  @override
  ConsumerState<GestionEleve> createState() => GestionEleveState();
}

class GestionEleveState extends ConsumerState<GestionEleve> {
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

  List<Courses> listCours = [];
  bool check = false;
  String? cours;
  var rapportController = TextEditingController();
  SampleItem? selectedMenu;
  bool isselect = false;
  //bool annuel = false;

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

  bool search = false;
  List<Students> listSearch = [];
  int date = 0;
  Widget horizontalView(double height, double width, contextt) {
    return AppLayout(
      content: Container(
        color: Palette.backgroundColor,
        child: Column(
          children: [
            Container(
                color: Palette.backgroundColor,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.backspace),
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      width: 350,
                      child: TextField(
                        // onChanged: (value) => onSearch(value.toLowerCase()),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        onChanged: (value) {
                          filterSearchResults(value);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(0),
                          prefixIcon: const Icon(Icons.search,
                              color: Palette.violetColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                          hintText: "Recherche",
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    const SizedBox(
                      width: 50,
                    ),
                  ],
                )),
            const SizedBox(
              height: 50,
            ),
            search == false
                ? Container(
                    padding: EdgeInsets.all(20),
                    color: Palette.backgroundColor,
                    height: MediaQuery.of(context).size.height - 200,
                    child: widget.listEleve.isEmpty
                        ? Center(
                            child: Text(
                              'Aucun élève dans la classe ${widget.classe}',
                              style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 50,
                                    mainAxisExtent: 100),
                            itemCount: widget.listEleve.length,
                            itemBuilder: ((context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Palette.backgroundColor,
                                      child: ImageNetwork(
                                        image:
                                            'http://13.39.81.126:7001${widget.listEleve[index].user!.image}',
                                        height: 50,
                                        width: 50,
                                        duration: 1500,
                                        curve: Curves.easeIn,
                                        onPointer: true,
                                        debugPrint: false,
                                        fullScreen: false,
                                        fitAndroidIos: BoxFit.cover,
                                        fitWeb: BoxFitWeb.cover,
                                        borderRadius: BorderRadius.circular(70),
                                        onLoading:
                                            const CircularProgressIndicator(
                                          color: Colors.indigoAccent,
                                        ),
                                        onError: const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              height: 50,
                                              child: Row(children: [
                                                Text(widget.listEleve[index]
                                                    .user!.firstName!),
                                                Spacer(),
                                                more(
                                                    widget.listEleve[index]
                                                        .user!.sId!,
                                                    widget.listEleve[index]
                                                        .user!.lastName!,
                                                    widget.listEleve[index]
                                                        .user!.firstName!,
                                                    widget.listEleve[index]
                                                        .user!.email!,
                                                    widget.listEleve[index]
                                                        .user!.role!,
                                                    widget.listEleve[index]
                                                        .user!.image!,
                                                    widget.listEleve[index]),
                                              ]),
                                            ),
                                            Container(
                                              height: 50,
                                              padding: EdgeInsets.only(
                                                  right: 30, left: 30),
                                              child: Row(children: [
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      color: Palette.barColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Center(
                                                    child: Text(
                                                      widget.listEleve[index]
                                                          .user!.role!,
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                  child: const Text(
                                                    'Détails',
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                  onTap: () {
                                                    /* dialogDetails(
                                    listUsers[index].lastName!,
                                    listUsers[index].firstName!,
                                    listUsers[index].email!,
                                    listUsers[index].role!);*/
                                                  },
                                                )
                                              ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                          ),
                  )
                : Container(
                    padding: EdgeInsets.all(20),
                    color: Palette.backgroundColor,
                    height: MediaQuery.of(context).size.height - 200,
                    child: listSearch.isEmpty
                        ? Center(
                            child: Text(
                              'Aucun élève dans la classe ${widget.classe} trouvé',
                              style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 50,
                                    mainAxisExtent: 100),
                            itemCount: listSearch.length,
                            itemBuilder: ((context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Palette.backgroundColor,
                                      child: ImageNetwork(
                                        image:
                                            'http://13.39.81.126:7001${listSearch[index].user!.image}',
                                        height: 50,
                                        width: 50,
                                        duration: 1500,
                                        curve: Curves.easeIn,
                                        onPointer: true,
                                        debugPrint: false,
                                        fullScreen: false,
                                        fitAndroidIos: BoxFit.cover,
                                        fitWeb: BoxFitWeb.cover,
                                        borderRadius: BorderRadius.circular(70),
                                        onLoading:
                                            const CircularProgressIndicator(
                                          color: Colors.indigoAccent,
                                        ),
                                        onError: const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              height: 50,
                                              child: Row(children: [
                                                Text(widget.listEleve[index]
                                                    .user!.firstName!),
                                                Spacer(),
                                                more(
                                                    listSearch[index]
                                                        .user!
                                                        .sId!,
                                                    listSearch[index]
                                                        .user!
                                                        .lastName!,
                                                    listSearch[index]
                                                        .user!
                                                        .firstName!,
                                                    listSearch[index]
                                                        .user!
                                                        .email!,
                                                    listSearch[index]
                                                        .user!
                                                        .role!,
                                                    listSearch[index]
                                                        .user!
                                                        .image!,
                                                    listSearch[index]),
                                              ]),
                                            ),
                                            Container(
                                              height: 50,
                                              padding: EdgeInsets.only(
                                                  right: 30, left: 30),
                                              child: Row(children: [
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      color: Palette.barColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Center(
                                                    child: Text(
                                                      listSearch[index]
                                                          .user!
                                                          .role!,
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                  child: const Text(
                                                    'Détails',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  onTap: () {
                                                    /* dialogDetails(
                                    listUsers[index].lastName!,
                                    listUsers[index].firstName!,
                                    listUsers[index].email!,
                                    listUsers[index].role!);*/
                                                  },
                                                )
                                              ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                          ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, contextt) {
    return AppLayout(content: Container());
  }

  Widget more(
    String id,
    String nom,
    String premnom,
    String email,
    String role,
    String image,
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
                  builder: (context) => Signaler(
                        eleve: apprenant,
                        list: widget.list,
                      )));
        } else if (item == SampleItem.itemTwo) {
          dialogRapport(id, '$nom $premnom');
          /* Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Signaler(
                        apprenant: apprenant,
                      )));*/
        } else if (item == SampleItem.itemThree) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EcartAdmin(
                        eleve: apprenant.user!,
                        modif: false,
                      )));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Rapport(
                eleve: apprenant.user!,
                modif: false,
              ),
            ),
          );
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

  void filterSearchResults(String query) {
    List<Students> dummySearchList = [];
    dummySearchList.addAll(widget.listEleve);
    if (query.isNotEmpty) {
      List<Students> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.user!.lastName!.contains(query) ||
            item.user!.firstName!.contains(query) ||
            item.user!.email!.contains(query)) {
          dummyListData.add(item);
          //print(dummyListData);
        }
      }
      setState(() {
        search = true;
        listSearch.clear();
        listSearch.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        search = false;
      });
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
                  serviceRapport(context, cours, id, rapportController.text);
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
