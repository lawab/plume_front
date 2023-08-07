import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projet_plum/pages/Teacher/categorie/module/moduleTeacher.dart';
import 'package:projet_plum/pages/categorie/module/module.dart';
import 'package:projet_plum/pages/services/getCourss.dart';
import 'package:projet_plum/pages/services/getModule.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http_parser/http_parser.dart' show MediaType;

class PdfVideoAudio extends ConsumerStatefulWidget {
  final String typeModule;

  const PdfVideoAudio({Key? key, required this.typeModule}) : super(key: key);

  @override
  PdfVideoAudioState createState() => PdfVideoAudioState();
}

class PdfVideoAudioState extends ConsumerState<PdfVideoAudio> {
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

  bool _selectFile = false;
  List<int> _selectedFile = [];
  FilePickerResult? result;
  PlatformFile? file;
  Uint8List? selectedImageInBytes;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      content: Container(
        child: Column(
          children: [
            Container(
                color: Palette.backgroundColor,
                height: 100,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.backspace,
                      ),
                      onPressed: (() {
                        Navigator.pop(context);
                      }),
                    ),
                    Expanded(child: Container()),
                    Text(
                      widget.typeModule,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    Expanded(child: Container()),
                  ],
                )
                /**/
                ),
            Container(
              color: Palette.backgroundColor,
              height: MediaQuery.of(context).size.height - 200,
              padding: EdgeInsets.all(50),
              child: Column(children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
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
                        hintText: "Entrer le nom du module",
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
                  width: MediaQuery.of(context).size.width - 100,
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
                Container(
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
                            "pdf",
                            "mp4",
                            "mp3",
                            "wav"
                          ]);
                      if (result != null) {
                        setState(() {
                          file = result!.files.single;

                          Uint8List fileBytes =
                              result!.files.single.bytes as Uint8List;

                          _selectedFile = fileBytes;

                          selectedImageInBytes = result!.files.first.bytes;
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
                                Icons.file_copy,
                                color: Palette.violetColor,
                                size: 40,
                              )
                            : file!.extension == 'mp3'
                                ? const Icon(
                                    Icons.audio_file,
                                    color: Palette.violetColor,
                                    size: 40,
                                  )
                                : file!.extension == 'mp4'
                                    ? const Icon(
                                        Icons.video_file_rounded,
                                        color: Palette.violetColor,
                                        size: 40,
                                      )
                                    : const Icon(
                                        Icons.picture_as_pdf,
                                        color: Palette.violetColor,
                                        size: 40,
                                      ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.create,
                    size: 14,
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 70),
                      backgroundColor: Palette.violetColor),
                  onPressed: () {
                    creationModule(context, titleController.text,
                        descriptionController.text, result, _selectedFile);
                  },
                  label: const Text("Continuer."),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////////////////  SERVICES
  Future<void> creationModule(
      BuildContext contextt, nom, description, result, selectedFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    var idSection = prefs.getString('idSection');
    var role = prefs.getString('Role');
    print(id);
    print(token);

    var url = Uri.parse("http://13.39.81.126:7002/api/modules/create");
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
      "typeModule": 'file',
      "title": nom,
      "description": description,
      "creator": id,
      "sectionId": idSection
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

        /*setState(() {
          modif = false;
          titleController.clear();
          descriptionController.clear();
        });*/
        ref.refresh(getDataModulesFuture);
        ref.refresh(getDataCourssFuture);
        showTopSnackBar(
          Overlay.of(contextt)!,
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Module créé avec succès",
          ),
        );
        if (role == 'SUDO' || role == 'ADMIN') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Module()));
        } else if (role == 'TEACHER') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ModuleTeacher()));
        }
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
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
