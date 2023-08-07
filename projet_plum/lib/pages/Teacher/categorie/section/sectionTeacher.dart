import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:projet_plum/pages/Teacher/categorie/module/moduleTeacher.dart';
import 'package:projet_plum/pages/categorie/module/module.dart';
import 'package:projet_plum/pages/services/getModule.dart';
import 'package:projet_plum/pages/services/getSection.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http_parser/http_parser.dart' show MediaType;

enum SampleItem { itemOne, itemTwo }

class SectionTeacher extends ConsumerStatefulWidget {
  const SectionTeacher({Key? key}) : super(key: key);

  @override
  SectionTeacherState createState() => SectionTeacherState();
}

class SectionTeacherState extends ConsumerState<SectionTeacher> {
  Timer? timer;
  @override
  void initState() {
    ad();
    Future.delayed(const Duration(milliseconds: 0))
        .then((_) => timer?.cancel());
    super.initState();
  }

  Future ad() async {
    timer = Timer(const Duration(seconds: 1), ad);
    return ref.refresh(getDataSectionFuture);
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

  SampleItem? selectedMenu;
  bool _selectFile = false;
  List<int> _selectedFile = [];
  FilePickerResult? result;
  PlatformFile? file;
  Uint8List? selectedImageInBytes;

  void modification(idd, nom, description, image) {
    setState(() {
      titleController.text = nom;
      descriptionController.text = description;
      modif = true;
    });
    dialogCreationModification(idd, image);
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool modif = false;
  bool refresh = false;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataSectionFuture);
    /* if (refresh == false) {
      ref.refresh(getDataSectionFuture);
      setState(() {
        refresh = true;
      });
    }*/

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listSection);
          } else {
            return verticalView(height(context), width(context), context);
          }
        },
      ),
    );
  }

  Widget horizontalView(
    double height,
    double width,
    contextt,
    List<Section> listSection,
  ) {
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
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(child: Container()),
                    Container(
                      height: 60,
                      width: 120,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            minimumSize: (Size(120, 60)),
                            backgroundColor: Palette.violetColor),
                        label: Text('Ajouter'),
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          dialogCreationModification('', '');
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
              Container(
                color: Palette.violetColor,
                height: height - 200,
                //padding: const EdgeInsets.only(right: 50),
                child: Column(
                  children: [
                    Card(
                      elevation: 5,
                      color: Palette.violetColor,
                      child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Section',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      color: Palette.violetColor,
                      height: height - 258,
                      child: listSection.isEmpty
                          ? const Center(
                              child: Text(
                                'Aucune section',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          : ListView.builder(
                              itemCount: listSection.length,
                              itemBuilder: ((context, index) {
                                return InkWell(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    height: 50,
                                    child: Row(children: [
                                      const Icon(Icons.work,
                                          color: Colors.white),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        listSection[index].title!,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const Spacer(),
                                      more(
                                          listSection[index].sId!,
                                          listSection[index].title!,
                                          listSection[index].description!,
                                          listSection[index].image!),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                    ]),
                                  ),
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();

                                    prefs.setString(
                                        'idSection', listSection[index].sId!);
                                    ref.refresh(getDataModulesFuture);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ModuleTeacher()));
                                  },
                                );
                              }),
                            ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    return Scaffold();
  }

  Widget more(String id, String nom, String description, String image) {
    return PopupMenuButton(
      tooltip: 'Menu',
      initialValue: selectedMenu,
      // Callback that sets the selected popup menu item.
      onSelected: (SampleItem item) async {
        setState(() {
          selectedMenu = item;
        });

        if (item == SampleItem.itemOne) {
          modification(
            id,
            nom,
            description,
            image,
          );
        } else {
          dialogDelete(id, nom);
        }
      },
      child: const Icon(
        Icons.menu,
        size: 20,
        color: Colors.white,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          child: Text('Modifier'),
        ),
        const PopupMenuItem<SampleItem>(
            value: SampleItem.itemTwo, child: Text('Supprimer')),
      ],
    );
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
                  deleteSection(context, id);
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
                "Voulez vous supprimer la section $nom ?",
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'HelveticaNeue',
                ),
              ),
            ),
          );
        });
  }

  Future dialogCreationModification(id, image) {
    return showDialog(
        context: context,
        builder: (con) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Center(
              child: modif == false
                  ? const Text(
                      "Création de Section",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'HelveticaNeue',
                      ),
                    )
                  : const Text(
                      "Modification de Section",
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
                    setState(() {
                      modif = false;
                      titleController.clear();
                      descriptionController.clear();
                      _selectedFile.clear();
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  label: const Text("Quitter   ")),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.create,
                  size: 14,
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.violetColor),
                onPressed: () {
                  if (modif == true) {
                    modificationSection(context, id, titleController.text,
                        descriptionController.text, result, _selectedFile);
                    Navigator.pop(con);
                  } else {
                    creationSection(context, titleController.text,
                        descriptionController.text, result, _selectedFile);
                    Navigator.pop(con);
                  }
                },
                label: const Text("Continuer."),
              ),
            ],
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                alignment: Alignment.center,
                color: Colors.white,
                height: 300,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: titleController,
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
                            labelText: "Titre",
                            hintText: "Entrer le nom de la section",
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: const Icon(Icons.food_bank)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: descriptionController,
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
                            labelText: "Description",
                            hintText: "Entrer la description",
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: const Icon(Icons.food_bank)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    modif == false
                        ? Container(
                            padding: EdgeInsets.only(right: 70),
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () async {
                                result = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      "png",
                                      "jpg",
                                      "jpeg",
                                    ]);
                                if (result != null) {
                                  setState(() {
                                    file = result!.files.single;

                                    Uint8List fileBytes =
                                        result!.files.single.bytes as Uint8List;

                                    _selectedFile = fileBytes;

                                    selectedImageInBytes =
                                        result!.files.first.bytes;
                                    _selectFile = true;
                                  });
                                }
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Palette.violetColor,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: _selectFile == false
                                      ? const Icon(
                                          Icons.camera_alt_outlined,
                                          color: Palette.violetColor,
                                          size: 40,
                                        )
                                      : Image.memory(
                                          selectedImageInBytes!,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: InkWell(
                              onTap: () async {
                                /////////////////////
                                result = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      "png",
                                      "jpg",
                                      "jpeg",
                                    ]);
                                if (result != null) {
                                  file = result!.files.single;

                                  Uint8List fileBytes =
                                      result!.files.single.bytes as Uint8List;
                                  //print(base64Encode(fileBytes));
                                  //List<int>
                                  _selectedFile = fileBytes;
                                  setState(() {
                                    _selectFile = true;
                                    selectedImageInBytes =
                                        result!.files.first.bytes;
                                  });
                                } else {
                                  setState(() {
                                    _selectFile = false;
                                  });
                                }
                                ////////////////////
                              },
                              //splashColor: Colors.brown.withOpacity(0.5),
                              child: _selectFile == true
                                  ? Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 3,
                                            color: Palette.violetColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: MemoryImage(
                                              selectedImageInBytes!,
                                              //fit: BoxFit.fill,
                                            ),
                                          )),
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        color: Palette.violetColor,
                                        size: 40,
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 3,
                                          color: Palette.violetColor,
                                        ),
                                      ),
                                      child: ImageNetwork(
                                        image: 'http://13.39.81.126:7004$image',
                                        height: 100,
                                        width: 100,
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
                                        onTap: () async {
                                          /////////////////////
                                          result = await FilePicker.platform
                                              .pickFiles(
                                                  type: FileType.custom,
                                                  allowedExtensions: [
                                                "png",
                                                "jpg",
                                                "jpeg",
                                              ]);
                                          if (result != null) {
                                            file = result!.files.single;

                                            Uint8List fileBytes = result!.files
                                                .single.bytes as Uint8List;
                                            //print(base64Encode(fileBytes));
                                            //List<int>
                                            _selectedFile = fileBytes;
                                            setState(() {
                                              _selectFile = true;
                                              selectedImageInBytes =
                                                  result!.files.first.bytes;
                                            });
                                          } else {
                                            setState(() {
                                              _selectFile = false;
                                            });
                                          }
                                          ////////////////////
                                        },
                                      ),
                                    ),
                            ),
                          ),
                  ],
                ),
              );
            }),
          );
        });
  }

  //////////////////////////////////////////////////////////////////////////////////////////  SERVICES
  Future<void> creationSection(
      BuildContext context, nom, description, result, selectedFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var idCours = prefs.getString('idCours');
    print(id);
    print(token);

    var url = Uri.parse("http://13.39.81.126:7002/api/sections/create");
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
// "creator": id,
    var json = {
      "title": nom,
      "description": description,
      "creator": id,
      "courseId": idCours,
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    if (result != null) {
      request.files.add(http.MultipartFile.fromBytes('file', selectedFile,
          contentType: MediaType('application', 'octet-stream'),
          filename: result!.files.first.name));
    }
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

        setState(() {
          modif = false;
          titleController.clear();
          descriptionController.clear();
        });
        ref.refresh(getDataSectionFuture);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Section créé avec succès",
          ),
        );
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

  Future<void> modificationSection(BuildContext context, idUpdate, nom,
      description, result, selectedFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');

    print(id);
    print(token);

    var url =
        Uri.parse("http://13.39.81.126:7002/api/sections/update/$idUpdate");
    final request = MultipartRequest(
      'PATCH',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
// "creator": id,
    var json = {
      "title": nom,
      "description": description,
      "creator": id,
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    if (result != null) {
      request.files.add(http.MultipartFile.fromBytes('file', selectedFile,
          contentType: MediaType('application', 'octet-stream'),
          filename: result!.files.first.name));
    }
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

        setState(() {
          modif = false;
          titleController.clear();
          descriptionController.clear();
        });

        ref.refresh(getDataSectionFuture);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Section modifiée avec succès",
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

  Future<http.Response> deleteSection(contextt, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      //String adress_url = prefs.getString('ipport').toString();
      String urlDelete = "http://13.39.81.126:7002/api/sections/delete/$id";
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
          Overlay.of(contextt),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Section supprimée",
          ),
        );
        ref.refresh(getDataSectionFuture);
        return response;
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
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
