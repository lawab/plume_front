import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/authentification/authentification.dart';
import 'package:projet_plum/pages/Teacher/categorie/categorieTeacher.dart';
import 'package:projet_plum/pages/Teacher/classeTeacher/classeTeacher.dart';
import 'package:projet_plum/pages/Teacher/coursTeacher/coursTeacher.dart';
import 'package:projet_plum/pages/Teacher/devoirTeacher/devoirTeacher.dart';
import 'package:projet_plum/pages/Teacher/journal.dart';
import 'package:projet_plum/pages/accueil.dart';
import 'package:projet_plum/pages/administrationParent/menuParent.dart';
import 'package:projet_plum/pages/apprenant/Dasboard/dashboardApprenant.dart';
import 'package:projet_plum/pages/apprenant/accueilApprenant.dart';
import 'package:projet_plum/pages/apprenant/administration/administration.dart';
import 'package:projet_plum/pages/apprenant/coursApprenant/coursApprenant.dart';
import 'package:projet_plum/pages/apprenant/devoirApprenant/devoirApprenant.dart';
import 'package:projet_plum/pages/apprenant/planning/planning.dart';
import 'package:projet_plum/pages/categorie/categorie.dart';
import 'package:projet_plum/pages/classe/classe.dart';
import 'package:projet_plum/pages/cours/lescours.dart';
import 'package:projet_plum/pages/devoir/devoir.dart';
import 'package:projet_plum/pages/services/getCategorie.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/pages/services/getCourss.dart';
import 'package:projet_plum/pages/tableau%20de%20bord/dashboard.dart';
import 'package:projet_plum/pages/user/user.dart';
import 'package:projet_plum/pages/validation/menuValidation.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navigation extends ConsumerStatefulWidget {
  final Axis orientation;
  Navigation({
    Key? key,
    required this.orientation,
  }) : super(key: key);

  @override
  ConsumerState<Navigation> createState() => _NavigationState();
}

class _NavigationState extends ConsumerState<Navigation> {
  int index = 0;
  @override
  void initState() {
    ind();
    // TODO: implement initState
    super.initState();
  }

  var role = '';
  Future ind() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //if(prefs.getInt('index').toInt().is)
    setState(() {
      role = prefs.getString('Role')!;
      if (prefs.getInt('index') != null) {
        int aa = prefs.getInt('index')!.toInt();
        index = aa;
      } else {
        index = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: widget.orientation,
      children: [
        role == 'ADMIN' || role == 'SUDO'
            ? NavigationButton(
                axis: widget.orientation,
                index: index,
                text: "ACCUEIL",
                selectedIndex: 0,
                onPress: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  setState(() {
                    index = 0;
                    prefs.setInt('index', index);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Accueil(),
                    ),
                  );
                },
              )
            : NavigationButton(
                axis: widget.orientation,
                index: index,
                text: "ACCUEIL",
                selectedIndex: 1,
                onPress: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  setState(() {
                    index = 1;
                    prefs.setInt('index', index);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const AccueilApprenant(),
                    ),
                  );
                },
              ),
        role == 'ADMIN' || role == 'SUDO'
            ? NavigationButton(
                axis: widget.orientation,
                index: index,
                text: "Mes cours",
                selectedIndex: 2,
                onPress: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    index = 2;
                    prefs.setInt('index', index);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Cours(),
                    ),
                  );
                },
              )
            : role == 'TEACHER'
                ? NavigationButton(
                    axis: widget.orientation,
                    index: index,
                    text: "Mes cours",
                    selectedIndex: 3,
                    onPress: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        index = 3;
                        prefs.setInt('index', index);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const CoursTeacher(),
                        ),
                      );
                    },
                  )
                : NavigationButton(
                    axis: widget.orientation,
                    index: index,
                    text: "Mes cours",
                    selectedIndex: 4,
                    onPress: () async {
                      ref.refresh(getDataCoursByAppFuture);
                      ref.refresh(getDataCategorieFuture);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        index = 4;
                        prefs.setInt('index', index);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const CoursApprenant(),
                        ),
                      );
                    },
                  ),
        role == 'ADMIN' || role == 'SUDO'
            ? NavigationButton(
                axis: widget.orientation,
                index: index,
                text: "Classe",
                selectedIndex: 5,
                onPress: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    index = 5;
                    prefs.setInt('index', index);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const ClasseS(),
                    ),
                  );
                },
              )
            : role == 'TEACHER'
                ? NavigationButton(
                    axis: widget.orientation,
                    index: index,
                    text: "Classe",
                    selectedIndex: 6,
                    onPress: () async {
                      ref.refresh(getDataClasseFuture);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        index = 6;
                        prefs.setInt('index', index);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const ClasseTeacher(),
                        ),
                      );
                    },
                  )
                : Container(),
        role == 'ADMIN' || role == 'SUDO'
            ? NavigationButton(
                axis: widget.orientation,
                index: index,
                text: "Journal de bord",
                selectedIndex: 7,
                onPress: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    index = 7;
                    prefs.setInt('index', index);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Dashboard(),
                    ),
                  );
                },
              )
            : role == 'TEACHER'
                ? NavigationButton(
                    axis: widget.orientation,
                    index: index,
                    text: "Journal de bord",
                    selectedIndex: 8,
                    onPress: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        index = 8;
                        prefs.setInt('index', index);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const DashboardTeacher(),
                        ),
                      );
                    },
                  )
                : NavigationButton(
                    axis: widget.orientation,
                    index: index,
                    text: "Journal de bord",
                    selectedIndex: 9,
                    onPress: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        index = 9;
                        prefs.setInt('index', index);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const DashboardApprenant(),
                        ),
                      );
                    },
                  ),
        role == 'ADMIN' || role == 'SUDO'
            ? NavigationButton(
                axis: widget.orientation,
                index: index,
                text: "Utilisateurs",
                selectedIndex: 10,
                onPress: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    index = 10;
                    prefs.setInt('index', index);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Users(),
                    ),
                  );
                },
              )
            : Container(),
        /*role == 'ADMIN' || role == 'SUDO'
            ? NavigationButton(
                axis: widget.orientation,
                index: index,
                text: "Mes fichiers",
                selectedIndex: 8,
                onPress: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    index = 8;
                    prefs.setInt('index', index);
                  });
                  /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const Menu(),
              ),
            );*/
                },
              )
            : Container(),*/
        role == 'ADMIN' || role == 'SUDO'
            ? NavigationButton(
                axis: widget.orientation,
                index: index,
                text: "Mes Catégories",
                selectedIndex: 11,
                onPress: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    index = 11;
                    prefs.setInt('index', index);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const CategorieAll(),
                    ),
                  );
                },
              )
            : role == 'TEACHER'
                ? NavigationButton(
                    axis: widget.orientation,
                    index: index,
                    text: "Mes Catégories",
                    selectedIndex: 12,
                    onPress: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        index = 12;
                        prefs.setInt('index', index);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const CategorieTeacher(),
                        ),
                      );
                    },
                  )
                : Container(),
        role == 'ADMIN' || role == 'SUDO'
            ? NavigationButton(
                axis: widget.orientation,
                index: index,
                text: "Devoir",
                selectedIndex: 13,
                onPress: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    index = 13;
                    prefs.setInt('index', index);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Devoir(),
                    ),
                  );
                },
              )
            : role == 'TEACHER'
                ? NavigationButton(
                    axis: widget.orientation,
                    index: index,
                    text: "Devoir de maison",
                    selectedIndex: 14,
                    onPress: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        index = 14;
                        prefs.setInt('index', index);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const DevoirTeacher(),
                        ),
                      );
                    },
                  )
                : NavigationButton(
                    axis: widget.orientation,
                    index: index,
                    text: "Devoir de maison",
                    selectedIndex: 15,
                    onPress: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        index = 15;
                        prefs.setInt('index', index);
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const DevoiApprenant(),
                        ),
                      );
                    },
                  ),
        role == 'PARENT' || role == 'STUDENT'
            ? NavigationButton(
                axis: widget.orientation,
                index: index,
                text: "Planning",
                selectedIndex: 16,
                onPress: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    index = 16;
                    prefs.setInt('index', index);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Planning(),
                    ),
                  );
                },
              )
            : Container(),
        role == 'PARENT'
            ? NavigationButton(
                axis: widget.orientation,
                index: index,
                text: "Administration",
                selectedIndex: 17,
                onPress: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    index = 17;
                    prefs.setInt('index', index);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Administration(),
                    ),
                  );
                },
              )
            : Container(),
        role == 'ADMIN' || role == 'SUDO'
            ? NavigationButton(
                axis: widget.orientation,
                index: index,
                text: "Validation",
                selectedIndex: 18,
                onPress: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    index = 18;
                    prefs.setInt('index', index);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const MenuValidation(),
                    ),
                  );
                },
              )
            : Container(),
        role == 'ADMIN' || role == 'SUDO'
            ? NavigationButton(
                axis: widget.orientation,
                index: index,
                text: "Administration parent",
                selectedIndex: 19,
                onPress: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    index = 19;
                    prefs.setInt('index', index);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const MenuParent(),
                    ),
                  );
                },
              )
            : Container(),
        NavigationButton(
          axis: widget.orientation,
          index: index,
          text: "Parametre",
          selectedIndex: 20,
          onPress: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            setState(() {
              index = 20;
              prefs.setInt('index', index);
            });
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const RecettesPage(),
              ),
            );*/
          },
        ),
        NavigationButton(
          axis: widget.orientation,
          index: index,
          text: "QUITTER L'APPLICATION",
          selectedIndex: 21,
          onPress: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            setState(() {
              index = 21;
              prefs.setInt('index', 0);
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const Authentification(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class NavigationButton extends StatelessWidget {
  const NavigationButton(
      {super.key,
      required this.text,
      required this.index,
      required this.onPress,
      required this.selectedIndex,
      required this.axis});

  final int index;
  final String text;
  final int selectedIndex;
  final VoidCallback onPress;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 05.0,
      ),
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          foregroundColor: Palette.violetColor,
          backgroundColor:
              (selectedIndex == index) ? Palette.violetColor : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: axis == Axis.vertical ? 12 : 10,
            color: (selectedIndex == index) ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
