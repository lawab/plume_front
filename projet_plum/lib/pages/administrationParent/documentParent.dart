import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../services/getDocument.dart';

class DocumentParent extends ConsumerStatefulWidget {
  final List<Document> listDocument;
  const DocumentParent({Key? key, required this.listDocument})
      : super(key: key);

  @override
  ConsumerState<DocumentParent> createState() => DocumentParentState();
}

class DocumentParentState extends ConsumerState<DocumentParent> {
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

  var objetController = TextEditingController();
  var corpsController = TextEditingController();
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

  Widget horizontalView(
    double height,
    double width,
    contextT,
  ) {
    return AppLayout(
      content: Container(
        height: height,
        padding: EdgeInsets.all(40),
        color: Palette.backgroundColor,
        child: Column(
          children: [
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
            const SizedBox(
              height: 10,
            ),
            Container(
              height: height - 230,
              child: widget.listDocument.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucune demande de document',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    )
                  : ListView.builder(
                      itemCount: widget.listDocument.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: "Demandeur: ",
                                                style: TextStyle(
                                                    fontFamily: 'Allerta',
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text:
                                                    ' ${widget.listDocument[index].creator!.firstName} ${widget.listDocument[index].creator!.lastName}',
                                                style: const TextStyle(
                                                    fontFamily: 'Bevan',
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: "Date demandée: ",
                                                style: TextStyle(
                                                    fontFamily: 'Allerta',
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: widget
                                                    .listDocument[index].date,
                                                style: const TextStyle(
                                                    fontFamily: 'Bevan',
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: "Document demandé: ",
                                                style: TextStyle(
                                                    fontFamily: 'Allerta',
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: widget.listDocument[index]
                                                    .document,
                                                style: const TextStyle(
                                                    fontFamily: 'Bevan',
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: "Etudiant: ",
                                                style: TextStyle(
                                                    fontFamily: 'Allerta',
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: widget.listDocument[index]
                                                    .studentId,
                                                style: const TextStyle(
                                                    fontFamily: 'Bevan',
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: CircleAvatar(
                                      maxRadius: 20,
                                      backgroundColor: Colors.black,
                                      child: IconButton(
                                          onPressed: () {
                                            dialogMail(
                                                widget.listDocument[index].sId,
                                                widget.listDocument[index]
                                                    .creator!.firstName,
                                                widget.listDocument[index]
                                                    .creator!.sId);
                                          },
                                          icon: const Icon(
                                            Icons.mail,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
  ) {
    return AppLayout(
      content: Container(
        height: height,
        padding: EdgeInsets.all(40),
        color: Palette.backgroundColor,
      ),
    );
  }

  Future dialogMail(id, nom, idReceiver) {
    return showDialog(
        context: context,
        builder: (con) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Center(
              child: Row(
                children: [
                  const Icon(Icons.mail),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Mail à  ",
                          style: TextStyle(
                              fontFamily: 'Allerta',
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: nom,
                          style: const TextStyle(
                              fontFamily: 'Bevan',
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.send,
                  size: 14,
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  serviceMail(context, idReceiver, id, corpsController.text,
                      objetController.text);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                label: const Text("Envoyer  "),
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
              height: 400,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                      maxLines: 2,
                      minLines: 2,
                      controller: objetController,
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
                          labelText: "Objet",
                          hintText: "Objet du mail",
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon:
                              const Icon(Icons.document_scanner_outlined)),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                      maxLines: 10,
                      minLines: 10,
                      controller: corpsController,
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
                          labelText: "corps",
                          hintText: "Corps du mail",
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

  Future<void> serviceMail(
      BuildContext contextT, receiverId, documentId, emailBody, subject) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');

    print(id);
    print(token);

    var url = Uri.parse("http://13.39.81.126:7001/api/documents/validate");
    final request = MultipartRequest(
      'PATCH',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );

    var json = {
      "receiverId": receiverId,
      "creator": id,
      "documentId": documentId,
      "emailBody": emailBody,
      "subject": subject
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
            message: "Mail envoyé avec succès",
          ),
        );
        Navigator.pop(context);
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de mail",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}
