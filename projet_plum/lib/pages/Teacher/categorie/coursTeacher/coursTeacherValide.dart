import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:projet_plum/pages/Teacher/categorie/section/sectionTeacher.dart';
import 'package:projet_plum/pages/categorie/section/section.dart';
import 'package:projet_plum/pages/services/getCourss.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:http/http.dart' as http;

class CoursValideTeacher extends ConsumerStatefulWidget {
  final String id;
  const CoursValideTeacher({Key? key, required this.id}) : super(key: key);

  @override
  CoursValideTeacherState createState() => CoursValideTeacherState();
}

class CoursValideTeacherState extends ConsumerState<CoursValideTeacher> {
  /*Timer? timer;
  @override
  void initState() {
    ad();
    Future.delayed(const Duration(milliseconds: 0))
        .then((_) => timer?.cancel());
    super.initState();
  }

  Future ad() async {
    timer = Timer(const Duration(seconds: 1), ad);
    return ref.refresh(getDataCourssFuture);
  }*/

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
    //dialogCreationModification(idd, image);
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool modif = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Consumer(builder: (context, ref, _) {
        final viewModele = ref.watch(getDataCourssFuture);
        return Container(
          child: ListView.builder(
            itemCount: viewModele.listcoursvalideTeacher.length,
            itemBuilder: (context, index) => Card(
              color: Colors.grey[850],
              shadowColor: Colors.blue,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        //formation image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Colors.red,
                                child: Image.network(
                                  'http://13.39.81.126:7002${viewModele.listcoursvalideTeacher[index].image}',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        //formation info
                        Container(
                          height: 90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                viewModele.listcoursvalideTeacher[index].title!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    //control buttons
                    Container(
                      height: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Tooltip(
                            message: 'Créer une section',
                            child: IconButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                prefs.setString(
                                    'idCours',
                                    viewModele
                                        .listcoursvalideTeacher[index].sId!);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SectionTeacher()));
                              },
                              icon: Icon(
                                Icons.control_point_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              modification(
                                viewModele.listcoursvalideTeacher[index].sId,
                                viewModele.listcoursvalideTeacher[index].title,
                                viewModele
                                    .listcoursvalideTeacher[index].description,
                                viewModele.listcoursvalideTeacher[index].image,
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              dialogDelete(
                                  viewModele.listcoursvalideTeacher[index].sId!,
                                  viewModele
                                      .listcoursvalideTeacher[index].title);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
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
                  //deleteClasse(context, id);
                  deleteCours(context, id);
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
                "Voulez vous supprimer la classe $nom ?",
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
                      "Création de cours",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'HelveticaNeue',
                      ),
                    )
                  : const Text(
                      "Modification de cours",
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
                      _selectedFile.cast();
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
                    modificationCours(context, id, titleController.text,
                        descriptionController.text, result, _selectedFile);
                    /*modificationCategorie(context, id, titleController.text,
                        descriptionController.text, result, _selectedFile);*/
                    Navigator.pop(con);
                  } else {
                    creationCours(context, titleController.text,
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
                            hintText: "Entrer le nom du cours",
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
                                        image: 'http://13.39.81.126:7002$image',
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
  Future<void> creationCours(
      BuildContext context, nom, description, result, selectedFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    print(id);
    print(token);

    var url = Uri.parse("http://13.39.81.126:7002/api/courses/create");
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
      "subjectId": widget.id
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
        ref.refresh(getDataCourssFuture);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Cours créé avec succès",
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

  Future<void> modificationCours(BuildContext context, idUpdate, nom,
      description, result, selectedFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    print(id);
    print(token);

    var url =
        Uri.parse("http://13.39.81.126:7002/api/courses/update/$idUpdate");
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
      "subjectId": widget.id
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
        ref.refresh(getDataCourssFuture);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Cours modifié avec succès",
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

  Future<http.Response> deleteCours(contextt, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      //String adress_url = prefs.getString('ipport').toString();
      String urlDelete = "http://13.39.81.126:7002/api/courses/delete/$id";
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
            message: "Cours supprimé avec succès",
          ),
        );
        ref.refresh(getDataCourssFuture);
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

  Future<http.Response> valide_invalide(contextt, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      //String adress_url = prefs.getString('ipport').toString();
      String url = "http://13.39.81.126:7002/api/courses/validate/$id";
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
            message: "Cours invalidé",
          ),
        );
        ref.refresh(getDataCourssFuture);
        return response;
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de validation",
          ),
        );
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
