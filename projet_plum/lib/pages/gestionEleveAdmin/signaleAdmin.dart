import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum SingingCharacter { medium, intermediaire, grave }

class SignalerAdmin extends ConsumerStatefulWidget {
  final Students eleve;

  const SignalerAdmin({Key? key, required this.eleve}) : super(key: key);

  @override
  ConsumerState<SignalerAdmin> createState() => SignalerAdminState();
}

class SignalerAdminState extends ConsumerState<SignalerAdmin> {
  @override
  void initState() {
    // TODO: implement initState

    ad();
    super.initState();
  }

  var idTeacher = '';
  Future ad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idTeacher = prefs.getString('IdUser')!;
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

  List<Courses> listCours = [];
  bool check = false;

  SingingCharacter? _character = SingingCharacter.medium;
  var motifController = TextEditingController();
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

  Widget horizontalView(double height, double width, contextt) {
    return AppLayout(
      content: Container(
        padding:
            const EdgeInsets.only(right: 50, bottom: 10, left: 50, top: 50),
        height: height,
        width: width,
        color: Palette.backgroundColor,
        child: Column(
          children: [
            Container(
              height: height / 2,
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: height / 2,
                        child: Column(
                          children: [
                            const Text(
                              'Ecart de comportement',
                              style: TextStyle(
                                  fontFamily: 'Bevan',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              child: TextFormField(
                                maxLines: 10,
                                minLines: 5,
                                controller: motifController,
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
                                      borderSide: const BorderSide(
                                          color: Palette.violetColor),
                                      gapPadding: 10,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Palette.violetColor),
                                      gapPadding: 10,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Palette.violetColor),
                                      gapPadding: 10,
                                    ),
                                    labelText: "Motif",
                                    hintText: "",
                                    // If  you are using latest version of flutter then lable text and hint text shown like this
                                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    suffixIcon: const Icon(Icons.key)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Card(
                            color: Colors.white,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: width / 5,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Palette.backgroundColor,
                                    child: ImageNetwork(
                                      image:
                                          'http://13.39.81.126:7001${widget.eleve.user!.image}',
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
                                    ),
                                  ),
                                  Text(widget.eleve.user!.firstName!)
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Card(
                            color: Colors.white,
                            child: Container(
                                width: width / 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Gravité',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Container(
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                              title: const Text('Niveau 1'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.medium,
                                                groupValue: _character,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  setState(() {
                                                    _character = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              title: const Text('Niveau 2'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter
                                                    .intermediaire,
                                                groupValue: _character,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  setState(() {
                                                    _character = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              title: const Text('Niveau 3'),
                                              leading: Radio<SingingCharacter>(
                                                value: SingingCharacter.grave,
                                                groupValue: _character,
                                                onChanged:
                                                    (SingingCharacter? value) {
                                                  setState(() {
                                                    _character = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
            Container(
              alignment: Alignment.center,
              child: Container(
                width: 370,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: Size(150, 60),
                            backgroundColor: Palette.violetColor),
                        child: const Text('Confirmer'),
                        onPressed: () {
                          var niv = '';
                          if (_character == SingingCharacter.intermediaire) {
                            niv = 'niveau 2';
                          } else if (_character == SingingCharacter.medium) {
                            niv = 'niveau 1';
                          } else {
                            niv = 'niveau 3';
                          }
                          serviceEcart(context, widget.eleve.user!.sId!,
                              motifController.text, niv);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minimumSize: Size(150, 60),
                            backgroundColor: Colors.white),
                        child: Text(
                          'Annuler',
                          style: TextStyle(color: Palette.violetColor),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, contextt) {
    return AppLayout(
        content: Container(
      color: Palette.backgroundColor,
    ));
  }

  Future<void> serviceEcart(
      BuildContext contextT, studentId, motif, gravity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');

    print(id);
    print(token);

    var url = Uri.parse("http://13.39.81.126:7001/api/behaviors/create");
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
      "courseId": null,
      "creator": id,
      "studentId": studentId,
      "motif": motif,
      "gravity": gravity
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
            message: "Ecart signalé avec succès",
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
