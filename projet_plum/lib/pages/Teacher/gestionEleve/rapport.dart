import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:projet_plum/pages/services/getReport.dart' as r;
import 'package:projet_plum/pages/services/getUser.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Rapport extends ConsumerStatefulWidget {
  final bool modif;
  final User eleve;
  const Rapport({Key? key, required this.eleve, required this.modif})
      : super(key: key);

  @override
  ConsumerState<Rapport> createState() => RapportState();
}

class RapportState extends ConsumerState<Rapport> {
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

  bool check = false;
  String id = '';
  List<r.Reports> listreports = [];
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataUserFuture);
    final viewModele = ref.watch(r.getDataReportsFuture);
    if (check == false) {
      for (int i = 0; i < viewModel.listStudent.length; i++) {
        if (viewModel.listStudent[i].sId == widget.eleve.sId) {
          if (viewModel.listStudent[i].repo == true) {
            for (int j = 0; j < viewModele.listReports.length; j++) {
              if (viewModel.listStudent[i].reports!
                  .contains(viewModele.listReports[j].sId!)) {
                listreports.add(viewModele.listReports[j]);
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
                    child: listreports.isEmpty
                        ? const Center(
                            child: Text(
                              'Aucun rapport ',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          )
                        : ListView.builder(
                            itemCount: listreports.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Row(children: [
                                  Expanded(
                                    flex: 2,
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Palette.backgroundColor,
                                      child: ImageNetwork(
                                        image:
                                            'http://13.39.81.126:7001${widget.eleve.image}',
                                        /* imageCache:
                                                CachedNetworkImageProvider(
                                                    imageUrl),*/
                                        height: 50,
                                        width: 50,
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
                                  ),
                                  Expanded(
                                      flex: 7,
                                      child: Column(
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
                                                    child: Text('Valider:  '),
                                                  ),
                                                  Container(
                                                    height: 20,
                                                    width: 100,
                                                    child: Center(
                                                      child: Text(
                                                        listreports[index]
                                                            .validated
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            color: Colors.grey,
                                            height: 100,
                                            width: width / 2,
                                            child: Center(
                                              child: Text(
                                                  listreports[index].report!),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      )),
                                ]),
                              );
                            },
                          ),
                  )
                : Container(
                    height: height - 220,
                    child: ListView.builder(
                      itemCount: widget.eleve.reports!.length,
                      itemBuilder: (context, index) {
                        return listreports[index].validated == true
                            ? Container()
                            : Card(
                                child: Row(children: [
                                  Expanded(
                                    flex: 2,
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Palette.backgroundColor,
                                      child: ImageNetwork(
                                        image:
                                            'http://13.39.81.126:7001${widget.eleve.image}',
                                        /* imageCache:
                                                CachedNetworkImageProvider(
                                                    imageUrl),*/
                                        height: 50,
                                        width: 50,
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
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Column(
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
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          color: Colors.grey,
                                          height: 100,
                                          width: width / 2,
                                          child: Center(
                                            child: Text(
                                                listreports[index].report!),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                minimumSize: Size(150, 60),
                                                backgroundColor: Colors.green),
                                            child: const Text('Validé'),
                                            onPressed: () {
                                              serviceValidation(context,
                                                  listreports[index].sId);
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ]),
                              );
                      },
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
        height: height,
        padding: EdgeInsets.all(40),
        color: Palette.backgroundColor,
      ),
    );
  }

  Future<void> serviceValidation(BuildContext contextT, reporstId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');

    print(id);
    print(token);

    var url =
        Uri.parse("http://13.39.81.126:7001/api/reports/update/$reporstId");
    final request = MultipartRequest(
      'PATCH',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );

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
            message: "Rapport validé avec succès",
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
