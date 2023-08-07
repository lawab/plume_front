import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;

class CoursAssignes extends ConsumerStatefulWidget {
  final String idClasse;
  const CoursAssignes({Key? key, required this.idClasse}) : super(key: key);

  @override
  CoursAssignesState createState() => CoursAssignesState();
}

class CoursAssignesState extends ConsumerState<CoursAssignes> {
  List<Courses> coursAssign = [];
  bool traitement = false;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataClasseFuture);
    if (traitement == false) {
      for (int i = 0; i < viewModel.listClasse.length; i++) {
        if (viewModel.listClasse[i].sId == widget.idClasse) {
          coursAssign.addAll(viewModel.listClasse[i].courses!);
          traitement = true;
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
            itemCount: coursAssign.length,
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
                      Text(coursAssign[index].course!.title!),
                      const Spacer(),
                      CircleAvatar(
                        maxRadius: 20,
                        backgroundColor: Colors.black,
                        child: IconButton(
                            onPressed: () {
                              desassignation(
                                  context, coursAssign[index].course!.sId!);
                            },
                            icon: Icon(
                              Icons.close,
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

  Future<http.Response> desassignation(contextt, String idCours) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var idclasse = prefs.getString('idClasse');
      //String adress_url = prefs.getString('ipport').toString();
      String url =
          "http://13.39.81.126:7003/api/classes/unAssignCourse/$idclasse/$idCours";
      print(url);
      final http.Response response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'application/json',
          'authorization': 'Bearer $token',
        },
      );
      print('ttttttttttttttttttttttttttttt');
      print(response.statusCode);
      if (response.statusCode == 200) {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Cours désassigné avec succès",
          ),
        );
        setState(() {
          coursAssign = [];
          traitement = false;
        });
        ref.refresh(getDataClasseFuture);
        return response;
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de désassignation",
          ),
        );
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
