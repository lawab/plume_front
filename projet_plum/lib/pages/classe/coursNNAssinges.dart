import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/classe/classe.dart';
import 'package:projet_plum/pages/services/getClasse.dart' as p;
import 'package:projet_plum/pages/services/getCourss.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;

class CoursNNAssignes extends ConsumerStatefulWidget {
  //final List<p.Courses> list;
  final String idClasse;
  const CoursNNAssignes({Key? key, required this.idClasse}) : super(key: key);

  @override
  CoursNNAssignesState createState() => CoursNNAssignesState();
}

class CoursNNAssignesState extends ConsumerState<CoursNNAssignes> {
  List<Courses> listNon = [];

  bool filtre = false;
  List<p.Courses> coursAssign = [];
  bool traitement = false;
  @override
  Widget build(BuildContext context) {
    final viewModele = ref.watch(getDataCoursAllFuture);
    final viewModel = ref.watch(p.getDataClasseFuture);
    if (traitement == false) {
      coursAssign = [];
      listNon = [];
      for (int i = 0; i < viewModel.listClasse.length; i++) {
        if (viewModel.listClasse[i].sId == widget.idClasse) {
          coursAssign.addAll(viewModel.listClasse[i].courses!);
        }
      }
      setState(() {
        listNon.addAll(viewModele.listcoursvalide);
      });
      if (coursAssign.length != 0) {
        for (int i = 0; i < viewModele.listcoursvalide.length; i++) {
          for (int j = 0; j < coursAssign.length; j++) {
            if (viewModele.listcoursvalide[i].sId ==
                coursAssign[j].course!.sId) {
              setState(() {
                listNon.remove(viewModele.listcoursvalide[i]);
                traitement = true;
                //filtre = true;
              });
            }
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Container(
        padding: EdgeInsets.all(40),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
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
                      Text(listNon[index].title!),
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

  Future<http.Response> assignation(contextt, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var idclasse = prefs.getString('idClasse');
      //String adress_url = prefs.getString('ipport').toString();
      String urlAssign =
          "http://13.39.81.126:7003/api/classes/assignCourse/$idclasse/$id";
      print(urlAssign);
      final http.Response response = await http.patch(
        Uri.parse(urlAssign),
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
            message: "Cours assigné avec succès",
          ),
        );
        setState(() {
          traitement = false;
        });
        ref.refresh(p.getDataClasseFuture);
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
