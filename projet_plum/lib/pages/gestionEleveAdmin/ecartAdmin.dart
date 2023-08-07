import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/services/getBehavior.dart' as b;
import 'package:projet_plum/pages/services/getUser.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class EcartAdmin extends ConsumerStatefulWidget {
  final bool modif;
  final User eleve;
  const EcartAdmin({Key? key, required this.eleve, required this.modif})
      : super(key: key);

  @override
  ConsumerState<EcartAdmin> createState() => EcartAdminState();
}

class EcartAdminState extends ConsumerState<EcartAdmin> {
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

  var descriptioncontroller = TextEditingController();

  bool search = false;
  bool check = false;
  String id = '';
  List<b.Behavior> listBehavior = [];
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataUserFuture);
    final viewModele = ref.watch(b.getDataBehaviorFuture);
    if (check == false) {
      for (int i = 0; i < viewModel.listStudent.length; i++) {
        if (viewModel.listStudent[i].sId == widget.eleve.sId) {
          if (viewModel.listStudent[i].behav == true) {
            for (int j = 0; j < viewModele.listBehavior.length; j++) {
              if (viewModel.listStudent[i].behavior!
                  .contains(viewModele.listBehavior[j].sId)) {
                listBehavior.add(viewModele.listBehavior[j]);
                check = true;
              }
            }
          }
        }
      }
    }
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
          height: height,
          padding: EdgeInsets.all(40),
          color: Palette.backgroundColor,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.backspace),
                ),
              ),
              widget.modif == false
                  ? Container(
                      height: height - 220,
                      child: listBehavior.isEmpty
                          ? const Center(
                              child: Text(
                                'Aucun Ecart à signaler',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          : ListView.builder(
                              itemCount: listBehavior.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${widget.eleve.firstName} ${widget.eleve.lastName}',
                                        style: const TextStyle(
                                            fontFamily: 'Bevan',
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Container(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Text('Gravité:  '),
                                              ),
                                              Container(
                                                height: 20,
                                                width: 100,
                                                color: listBehavior[index]
                                                            .gravity ==
                                                        'niveau 1'
                                                    ? Colors.amber
                                                    : listBehavior[index]
                                                                .gravity ==
                                                            'niveau 2'
                                                        ? const Color.fromARGB(
                                                            255, 177, 134, 5)
                                                        : Colors.red,
                                                child: Center(
                                                  child: Text(
                                                    listBehavior[index]
                                                        .gravity!,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Text('Cours:  '),
                                              ),
                                              Container(
                                                height: 20,
                                                width: 100,
                                                child: Center(
                                                  child: Text(
                                                    listBehavior[index]
                                                        .course!
                                                        .title!,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Text('Valider:  '),
                                              ),
                                              Container(
                                                height: 20,
                                                width: 100,
                                                child: Center(
                                                  child: Text(
                                                    listBehavior[index]
                                                        .validated
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Text('Date: '),
                                              ),
                                              Container(
                                                child: Text(listBehavior[index]
                                                    .createdAt!),
                                              )
                                            ]),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: const Text('Motif'),
                                      ),
                                      Container(
                                        color: Colors.grey,
                                        height: 100,
                                        width: width / 2,
                                        child: Center(
                                          child:
                                              Text(listBehavior[index].motif!),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    )
                  : Container(
                      height: height - 220,
                      child: ListView.builder(
                        itemCount: listBehavior.length,
                        itemBuilder: (context, index) {
                          return listBehavior[index].validated == false
                              ? Container()
                              : Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${widget.eleve.firstName} ${widget.eleve.lastName}',
                                        style: const TextStyle(
                                            fontFamily: 'Bevan',
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Container(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Text('Gravité:  '),
                                              ),
                                              Container(
                                                height: 20,
                                                width: 100,
                                                color: listBehavior[index]
                                                            .gravity ==
                                                        'niveau 1'
                                                    ? Colors.amber
                                                    : listBehavior[index]
                                                                .gravity ==
                                                            'niveau 2'
                                                        ? const Color.fromARGB(
                                                            255, 177, 134, 5)
                                                        : Colors.red,
                                                child: Center(
                                                  child: Text(
                                                    listBehavior[index]
                                                        .gravity!,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Text('Cours:  '),
                                              ),
                                              Container(
                                                height: 20,
                                                width: 100,
                                                child: Center(
                                                  child: Text(
                                                    listBehavior[index]
                                                        .course!
                                                        .title!,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Text('Date: '),
                                              ),
                                              Container(
                                                child: Text(listBehavior[index]
                                                    .createdAt!),
                                              )
                                            ]),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: const Text('Motif'),
                                      ),
                                      Container(
                                        color: Colors.grey,
                                        height: 100,
                                        width: width / 2,
                                        child: Center(
                                          child:
                                              Text(listBehavior[index].motif!),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            minimumSize: Size(150, 60),
                                            backgroundColor: Colors.green),
                                        child: const Text('Validé'),
                                        onPressed: () {
                                          serviceEcartValidation(context,
                                              listBehavior[index].sId!);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                        },
                      ),
                    )
            ],
          )),
    );
  }

  Widget verticalView(double height, double width, contextt) {
    return AppLayout(
      content: Container(
        height: height,
        padding: EdgeInsets.all(40),
        color: Palette.backgroundColor,
      ),
    );
  }

  Future<void> serviceEcartValidation(BuildContext contextT, idbehavior) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');

    print(id);
    print(token);

    var url =
        Uri.parse("http://13.39.81.126:7001/api/behaviors/update/$idbehavior");
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
      "creator": id,
      "validated": true,
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
            message: "Valider avec succès",
          ),
        );
        Navigator.pop(context);
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de validation",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}
