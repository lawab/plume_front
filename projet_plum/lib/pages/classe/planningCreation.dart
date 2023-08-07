import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http_parser/http_parser.dart' show MediaType;

class PlanningCreation extends ConsumerStatefulWidget {
  final String idClasse;
  const PlanningCreation({Key? key, required this.idClasse}) : super(key: key);

  @override
  ConsumerState<PlanningCreation> createState() => PlanningCreationState();
}

class PlanningCreationState extends ConsumerState<PlanningCreation> {
  bool _selectFile1 = false;
  bool _selectFile2 = false;
  List<int> _selectedFile = [];
  FilePickerResult? result;
  PlatformFile? file;
  Uint8List? selectedImageInBytes;
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

  var nomcontroller = TextEditingController();
  var descriptioncontroller = TextEditingController();
  bool check = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataClasseFuture);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (contextt, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(
                height(context), width(context), context, viewModel.listClasse);
          } else {
            return verticalView(
                height(context), width(context), context, viewModel.listClasse);
          }
        },
      ),
    );
  }

  Widget horizontalView(
    double height,
    double width,
    contextt,
    List<Classe> listClasses,
  ) {
    return AppLayout(
      content: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  print('ggggg');
                  Navigator.pop(context);
                },
                icon: Icon(Icons.backspace),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 300,
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 120,
                      child: Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              width: 200,
                              color: check == false
                                  ? Palette.yellowColor
                                  : Palette.violetColor,
                              height: 50,
                              child: const Center(
                                child: Text(
                                  'Emploie de temps ',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                check = false;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            child: Container(
                              width: 200,
                              color: check == true
                                  ? Palette.yellowColor
                                  : Palette.violetColor,
                              height: 50,
                              child: const Center(
                                child: Text(
                                  'Planning annuel ',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                check = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  check == false
                      ? Expanded(
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
                                  _selectFile1 = true;
                                });
                              }
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Palette.yellowColor,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: _selectFile1 == false
                                    ? const Icon(
                                        Icons.camera_alt_outlined,
                                        color: Palette.yellowColor,
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
                      : Expanded(
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
                                  _selectFile2 = true;
                                });
                              }
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Palette.yellowColor,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: _selectFile2 == false
                                    ? const Icon(
                                        Icons.camera_alt_outlined,
                                        color: Palette.yellowColor,
                                        size: 40,
                                      )
                                    : Image.memory(
                                        selectedImageInBytes!,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Spacer(),
            Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(150, 60),
                    backgroundColor: Palette.violetColor),
                child: const Text('Continuer'),
                onPressed: () {
                  if (check == true && _selectFile2 == true) {
                    modificationClasse(
                        context, true, widget.idClasse, _selectedFile, result);
                  } else if (check == false && _selectFile1 == true) {
                    modificationClasse(
                        context, false, widget.idClasse, _selectedFile, result);
                  }
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget verticalView(
    double height,
    double width,
    context,
    List<Classe> listClasses,
  ) {
    return AppLayout(
      content: Container(),
    );
  }

  Future<void> modificationClasse(BuildContext contextt, bool plan,
      String idUpdate, selectedFile, result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');

    print(id);
    print(token);

    var url =
        Uri.parse("http://13.39.81.126:7003/api/classes/update/$idUpdate");
    final request = MultipartRequest(
      'PATCH',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    print(url);
    Map<String, dynamic>? json;
    if (plan == true) {
      json = {"planning": 'oui', "creator": id};
    } else {
      json = {"time_table": 'oui', "creator": id};
    }

    var body = jsonEncode(json);
    print(body);
    request.headers.addAll({
      "body": body,
    });
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

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });
        ref.refresh(getDataClasseFuture);

        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: plan == true
                ? "Planning créer avec succès"
                : "Emploie de temps créer avec succès",
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
