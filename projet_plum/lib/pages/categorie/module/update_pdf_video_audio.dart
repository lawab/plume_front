import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projet_plum/pages/services/getCourss.dart' as p;
import 'package:projet_plum/pages/services/getModule.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http_parser/http_parser.dart' show MediaType;

class UpdatePdfVideoAudio extends ConsumerStatefulWidget {
  final String typeModule;
  final Modules module;

  const UpdatePdfVideoAudio(
      {Key? key, required this.typeModule, required this.module})
      : super(key: key);

  @override
  UpdatePdfVideoAudioState createState() => UpdatePdfVideoAudioState();
}

class UpdatePdfVideoAudioState extends ConsumerState<UpdatePdfVideoAudio> {
  @override
  void initState() {
    upda();
    // TODO: implement initState
    super.initState();
  }

  void upda() {
    setState(() {
      titleController.text = widget.module.title!;
      descriptionController.text = widget.module.description!;
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
                            "pdf",
                            "mp4",
                            "mp3",
                            "wav"
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
                          selectedImageInBytes = result!.files.first.bytes;
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
                              borderRadius: BorderRadius.circular(15.0),
                              color: Colors.white,
                            ),
                            child: file!.extension == 'mp3'
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
                          )
                        : Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Palette.violetColor,
                              ),
                            ),
                            child: InkWell(
                              child: widget.module.typeModule == 'audio'
                                  ? const Icon(
                                      Icons.audio_file,
                                      color: Palette.violetColor,
                                      size: 40,
                                    )
                                  : widget.module.typeModule == 'video'
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
                              onTap: () async {
                                /////////////////////
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
                    modificationModule(
                        context,
                        widget.module.sId,
                        titleController.text,
                        descriptionController.text,
                        result,
                        _selectedFile);
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
  Future<void> modificationModule(BuildContext contextt, idModule, nom,
      description, result, selectedFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    print(id);
    print(token);

    var url =
        Uri.parse("http://13.39.81.126:7002/api/modules/update/$idModule");
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

        /*setState(() {
          modif = false;
          titleController.clear();
          descriptionController.clear();
        });*/
        ref.refresh(getDataModulesFuture);
        ref.refresh(p.getDataCourssFuture);
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Module modifié avec succès",
          ),
        );
        Navigator.pop(context);
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
