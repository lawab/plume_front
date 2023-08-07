import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projet_plum/pages/categorie/module/document/pages/home_page.dart';
import 'package:projet_plum/pages/categorie/module/document/pages/modifHomePage.dart';
import 'dart:async';
//import 'package:projet_plum/pages/categorie/module/document/article.dart';
import 'package:projet_plum/pages/categorie/module/pdf_video_audio.dart';
import 'package:projet_plum/pages/categorie/module/update_pdf_video_audio.dart';
import 'package:projet_plum/pages/services/getCourss.dart' as p;
import 'package:projet_plum/pages/services/getModule.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Module extends ConsumerStatefulWidget {
  const Module({Key? key}) : super(key: key);

  @override
  ModuleState createState() => ModuleState();
}

class ModuleState extends ConsumerState<Module> {
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

  bool ajout = false;
  bool modif = false;
  Modules? module;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataModulesFuture);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listModules);
          } else {
            return verticalView(height(context), width(context), context);
          }
        },
      ),
    );
  }

  Widget horizontalView(
      double height, double width, contextt, List<Modules> listModules) {
    return Scaffold(
      body: AppLayout(
        content: Container(
          color: Palette.backgroundColor,
          child: Column(
            children: [
              Container(
                height: 100,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton(
                      icon: Icon(Icons.backspace),
                      onPressed: () {
                        if (ajout == true) {
                          setState(() {
                            ajout = false;
                          });
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    Expanded(child: Container()),
                    ajout == true
                        ? Container()
                        : Container(
                            height: 60,
                            width: 120,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: (Size(120, 60)),
                                  backgroundColor: Palette.violetColor),
                              label: Text('Ajouter'),
                              icon: Icon(Icons.add),
                              onPressed: () async {
                                setState(() {
                                  ajout = true;
                                });
                                //dialogCreationModification('', '');
                              },
                            ),
                          ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                /**/
              ),
              ajout == false
                  ? Container(
                      height: height - 200,
                      padding: const EdgeInsets.all(20),
                      //padding: const EdgeInsets.only(right: 50),
                      child: listModules.isEmpty
                          ? const Center(
                              child: Text(
                                'Aucun module',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          : ListView.builder(
                              itemCount: listModules.length,
                              itemBuilder: ((context, index) {
                                return Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.view_module,
                                                color: Colors.black),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    listModules[index].title!,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    'Type: ${listModules[index].typeModule}',
                                                    style: const TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(child: Container()),
                                            IconButton(
                                              onPressed: (() {
                                                setState(() {
                                                  ajout = true;
                                                  modif = true;
                                                  module = listModules[index];
                                                });
                                              }),
                                              icon: Icon(Icons.edit),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                              onPressed: (() {
                                                dialogDelete(
                                                    listModules[index].sId!,
                                                    listModules[index].title!);
                                              }),
                                              icon: Icon(Icons.delete),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                    )
                  : Container(
                      height: height - 200,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                          ),
                          Container(
                            height: height - 300,
                            child: Column(
                              children: [
                                modif == false
                                    ? Text("Sélectionner le type de module")
                                    : Text(
                                        "Type de module au préalable: ${module!.typeModule} "),
                                const SizedBox(
                                  height: 50,
                                ),
                                Container(
                                  height: 100,
                                  child: Row(children: [
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        child: Container(
                                          color: Palette.violetColor,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.video_library,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                'Charger une video',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          if (modif == true) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdatePdfVideoAudio(
                                                  typeModule: "video",
                                                  module: module!,
                                                ),
                                              ),
                                            );
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PdfVideoAudio(
                                                  typeModule: "video",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        child: Container(
                                          color: Palette.violetColor,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.audio_file,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                'Charger un audio',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          if (modif == true) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdatePdfVideoAudio(
                                                  typeModule: "audio",
                                                  module: module!,
                                                ),
                                              ),
                                            );
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PdfVideoAudio(
                                                  typeModule: "audio",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                  ]),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  height: 100,
                                  child: Row(children: [
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Expanded(
                                      child: Builder(builder: (context) {
                                        return InkWell(
                                          child: Container(
                                            color: Palette.violetColor,
                                            child: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.document_scanner,
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  'Saisir un document',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            if (modif == true) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ModifHomePage(
                                                    typeModule: "document",
                                                    module: module!,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomePage(
                                                    typeModule: "document",
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }),
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        child: Container(
                                          color: Palette.violetColor,
                                          child: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.picture_as_pdf,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                'Charger un pdf',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          if (modif == true) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdatePdfVideoAudio(
                                                  typeModule: "pdf",
                                                  module: module!,
                                                ),
                                              ),
                                            );
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PdfVideoAudio(
                                                  typeModule: "pdf",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    return Scaffold();
  }

  Future dialogDelete(id, nom) {
    return showDialog(
        context: context,
        builder: (con) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                "Confirmez la suppression",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'HelveticaNeue',
                ),
              ),
            ),
            actions: [
              ElevatedButton.icon(
                  icon: const Icon(
                    Icons.close,
                    size: 14,
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  label: const Text("Quitter   ")),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.delete,
                  size: 14,
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  deleteModule(context, id);
                  Navigator.pop(con);
                },
                label: const Text("Supprimer."),
              ),
            ],
            content: Container(
              alignment: Alignment.center,
              color: Colors.white,
              height: 150,
              child: Text(
                "Voulez vous supprimer la module $nom ?",
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'HelveticaNeue',
                ),
              ),
            ),
          );
        });
  }

  Future<http.Response> deleteModule(contextt, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      //String adress_url = prefs.getString('ipport').toString();
      String urlDelete = "http://13.39.81.126:7002/api/modules/delete/$id";
      print(urlDelete);
      final http.Response response = await http.patch(
        Uri.parse(urlDelete),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        showTopSnackBar(
          Overlay.of(contextt)!,
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Module supprimé avec succès",
          ),
        );
        ref.refresh(getDataModulesFuture);
        ref.refresh(p.getDataCourssFuture);
        return response;
      } else {
        showTopSnackBar(
          Overlay.of(contextt)!,
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de suppression",
          ),
        );
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
