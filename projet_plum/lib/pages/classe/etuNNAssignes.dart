import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/classe/classe.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/pages/services/getUser.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;

class EtudiantNNAssignes extends ConsumerStatefulWidget {
  final String idClasse;
  const EtudiantNNAssignes({Key? key, required this.idClasse})
      : super(key: key);

  @override
  EtudiantNNAssignesState createState() => EtudiantNNAssignesState();
}

class EtudiantNNAssignesState extends ConsumerState<EtudiantNNAssignes> {
  List<User> listNon = [];

  bool filtre = false;
  List<Students> eleveAssign = [];
  bool traitement = false;
  @override
  Widget build(BuildContext context) {
    final viewModele = ref.watch(getDataUserFuture);
    final viewModel = ref.watch(getDataClasseFuture);
    if (traitement == false) {
      eleveAssign = [];
      listNon = [];
      for (int i = 0; i < viewModel.listClasse.length; i++) {
        if (viewModel.listClasse[i].sId == widget.idClasse) {
          eleveAssign.addAll(viewModel.listClasse[i].students!);
        }
      }
      setState(() {
        listNon.addAll(viewModele.listStudent);
      });
      if (eleveAssign.length != 0) {
        for (int i = 0; i < viewModele.listStudent.length; i++) {
          for (int j = 0; j < eleveAssign.length; j++) {
            if (viewModele.listStudent[i].sId == eleveAssign[j].user!.sId) {
              setState(() {
                listNon.remove(viewModele.listStudent[i]);
                traitement = true;
                //filtre = true;
              });
            }
          }
        }
      }
    }
    /* if (filtre == false) {
      setState(() {
        listNon.addAll(viewModele.listStudent);
      });

      if (eleveAssign.length != 0) {
        for (int i = 0; i < viewModele.listStudent.length; i++) {
          for (int j = 0; j < eleveAssign.length; j++) {
            if (viewModele.listStudent[i].sId == eleveAssign[j].user!.sId) {
              setState(() {
                listNon.remove(viewModele.listStudent[i]);

                filtre = true;
              });
            }
          }
        }
      }
    }*/
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Container(
        padding: EdgeInsets.all(40),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 50,
                mainAxisExtent: 100),
            itemCount: listNon.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 50,
                  child: Row(
                    children: [
                      Text(listNon[index].firstName!),
                      const Spacer(),
                      CircleAvatar(
                        maxRadius: 20,
                        backgroundColor: Colors.black,
                        child: IconButton(
                            onPressed: () {
                              assignation(context, listNon[index].sId!);
                            },
                            icon: Icon(
                              Icons.done,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Future<http.Response> assignation(
    contextt,
    String iduser,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      //String adress_url = prefs.getString('ipport').toString();
      var idclasse = prefs.getString('idClasse');
      var urlAssigne =
          "http://13.39.81.126:7003/api/classes/assignUser/$idclasse/$iduser";
      print(urlAssigne);
      final http.Response response = await http.patch(
        Uri.parse(urlAssigne),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          // eleveAssign = [];
          // listNon = [];
          traitement = false;
          // filtre = false;
        });
        ref.refresh(getDataClasseFuture);
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Elève assigné avec succès",
          ),
        );

        return response;
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur d'assignation",
          ),
        );
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
