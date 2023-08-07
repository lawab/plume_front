import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projet_plum/pages/services/getUser.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarreHaute extends ConsumerStatefulWidget {
  const BarreHaute({
    Key? key,
  }) : super(key: key);
  @override
  BarreHauteState createState() => BarreHauteState();
}

class BarreHauteState extends ConsumerState<BarreHaute> {
  @override
  void initState() {
    loadSettings();
    // TODO: implement initState
    super.initState();
  }

  var role = '';
  var idStudent = '';
  var nom = '';
  var nomStudent = '';
  bool parent = false;
  void loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('Role')!;
      nom = prefs.getString('EmailUser').toString();
      if (role == 'PARENT') {
        parent = true;
        idStudent = prefs.getString('IdStudent')!;
      }
    });
  }

  bool check = false;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataUserFuture);
    if (check == false) {
      if (parent == true) {
        for (int i = 0; i < viewModel.listStudent.length; i++) {
          if (viewModel.listStudent[i].sId == idStudent) {
            nomStudent =
                '${viewModel.listStudent[i].firstName} ${viewModel.listStudent[i].lastName}';
            check = true;
          }
        }
      }
    }
    return Container(
      color: Palette.barColor,
      child: Row(
        children: [
          Container(
            height: 90,
            width: 250,
            alignment: Alignment.center,
            child: Image.asset(
              height: 90,
              width: 250,
              'assets/logo_plum.png',
            ),
          ),
          const Spacer(),
          Container(
            width: 250.0,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            decoration: const BoxDecoration(
              color: Palette.violetColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(05.0),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    )
                    /*Image.asset(
                    "assets/profile.jpg",
                    height: 30,
                  ),*/
                    ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(
                        left: 05.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            nom,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          parent == true
                              ? Text(
                                  'Elève: $nomStudent ',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              : Container(),
                        ],
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
