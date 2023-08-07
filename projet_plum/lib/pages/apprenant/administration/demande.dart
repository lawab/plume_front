import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/services/getUser.dart';
import 'package:projet_plum/pages/services/getUserOne.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Demande extends ConsumerStatefulWidget {
  const Demande({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<Demande> createState() => DemandeState();
}

class DemandeState extends ConsumerState<Demande> {
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

  List<String> listOfDoc = [
    "Document *",
    "Attestation de scolarité",
    "Attestation d'inscription",
  ];
  String? doc;
  String? student;
  bool annuel = false;
  var motifController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataUserbyOneFuture);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listStudent);
          } else {
            return verticalView(height(context), width(context), context);
          }
        },
      ),
    );
  }

  Widget horizontalView(
      double height, double width, contextt, List<Children> listStudent) {
    return AppLayout(
      content: Container(
        color: Palette.backgroundColor,
        height: height,
        width: width,
        child: Column(children: [
          Container(
            width: width,
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(
                Icons.backspace,
                color: Palette.violetColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(50),
            height: height - 222,
            child: Row(children: [
              Expanded(
                child: Container(
                  height: height / 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Card(
                          color: Colors.amber,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            height: height / 4 - 10,
                            child: DropdownButtonFormField(
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
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              value: doc,
                              hint: const Text(
                                'Document demandé*',
                              ),
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  doc = value;
                                });
                              },
                              onSaved: (value) {
                                setState(() {
                                  doc = value;
                                });
                              },
                              validator: (String? value) {
                                if (value == null) {
                                  return "Le rôle de l'utilisateur est obligatoire.";
                                } else {
                                  return null;
                                }
                              },
                              items: listOfDoc.map((String val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(
                                    val,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Card(
                          color: Palette.violetColor,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            height: height / 4 - 10,
                            child: DropdownButtonFormField(
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
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              value: student,
                              hint: const Text(
                                'Elève*',
                              ),
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  student = value;
                                });
                              },
                              onSaved: (value) {
                                setState(() {
                                  student = value;
                                });
                              },
                              items: listStudent.map((Children val) {
                                return DropdownMenuItem(
                                  value: val.sId,
                                  child: Text(
                                    val.firstName!,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    height: height / 2,
                    child: Column(
                      children: [
                        Text('Motif'),
                        const Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 50,
                          child: TextFormField(
                            maxLength: 10,
                            maxLines: 10,
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
                                suffixIcon: const Icon(Icons.border_all)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minimumSize: Size(150, 60),
                backgroundColor: Colors.green),
            child: const Text('Validé'),
            onPressed: () {
              if (doc!.isNotEmpty &&
                  student!.isNotEmpty &&
                  motifController.text.isNotEmpty) {
                serviceDemande(context, student, motifController.text, doc);
              } else {
                showTopSnackBar(
                  Overlay.of(context),
                  const CustomSnackBar.info(
                    backgroundColor: Colors.amber,
                    message: "Veuillez remplir tous les champs",
                  ),
                );
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
        ]),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    return AppLayout(content: Container());
  }

  Future<void> serviceDemande(
      BuildContext contextT, studentId, motif, document) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');

    print(id);
    print(token);

    var url = Uri.parse("http://13.39.81.126:7001/api/documents/create");
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
      "creator": id,
      "studentId": studentId,
      "motif": motif,
      "document": document
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
            message:
                "Demande de document envoyé. Vous recevrez la reponse sur votre mail",
          ),
        );
        Navigator.pop(context);
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de service",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}
