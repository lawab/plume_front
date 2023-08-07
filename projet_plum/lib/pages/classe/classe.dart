import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/Teacher/planningTeacher/PlanningTeacher.dart';
import 'package:projet_plum/pages/classe/classeCours.dart';
import 'package:projet_plum/pages/classe/classeEtudiant.dart';
import 'package:projet_plum/pages/classe/planningCreation.dart';
import 'package:projet_plum/pages/devoir/creationDevoir.dart';
import 'package:projet_plum/pages/gestionPresence/gestionMenu.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum SampleItem {
  itemOne,
  itemTwo,
  itemThree,
  itemFour,
  itemFive,
  itemSix,
  itemSeven,
  itemNine
}

class ClasseS extends ConsumerStatefulWidget {
  const ClasseS({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ClasseS> createState() => ClasseSState();
}

class ClasseSState extends ConsumerState<ClasseS> {
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

  SampleItem? selectedMenu;
  var nomcontroller = TextEditingController();
  var descriptioncontroller = TextEditingController();

  void modification(idd, nom, description) {
    setState(() {
      nomcontroller.text = nom;
      descriptioncontroller.text = description;
      id = idd;
      ajout = true;
      modif = true;
    });
  }

  bool tablette = false;
  bool modif = false;
  bool ajout = false;
  bool search = false;
  List<Classe> ClasseSearch = [];

  String id = '';
  void filterSearchResults(String query) {
    final viewModel = ref.watch(getDataClasseFuture);
    List<Classe> dummySearchList = [];

    dummySearchList.addAll(viewModel.listClasse);
    if (query.isNotEmpty) {
      List<Classe> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.title!.contains(query)) {
          dummyListData.add(item);
          //print(dummyListData);
        }
      }
      setState(() {
        search = true;
        ClasseSearch.clear();
        ClasseSearch.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        search = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataClasseFuture);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(
                height(context), width(context), context, viewModel.listClasse);
          } else {
            return verticalView(
                height(context), width(context), context, viewModel.listClasse);
          }
        },
      ),
    );
  }

  Widget horizontalView(
    double height,
    double width,
    context,
    List<Classe> listClasses,
  ) {
    tablette = false;
    return AppLayout(
      content: ajout == true
          ? Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(right: 40, left: 40, bottom: 5, top: 5),
              color: Palette.backgroundColor,
              child: creation(id, tablette),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(40),
              color: Palette.backgroundColor,
              child: Column(
                children: [
                  Container(
                    child: Row(children: const [
                      Icon(
                        Icons.book,
                        size: 40,
                      ),
                      Text(
                        'Classes',
                        style: TextStyle(
                            color: Palette.violetColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 100,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Text('Filter'),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 350,
                          child: TextField(
                            // onChanged: (value) => onSearch(value.toLowerCase()),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            onChanged: (value) {
                              filterSearchResults(value);
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(0),
                              prefixIcon: const Icon(Icons.search,
                                  color: Palette.violetColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                              hintText: "Recherche",
                            ),
                          ),
                        ),
                        Spacer(),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              minimumSize: (Size(100, 60)),
                              backgroundColor: Palette.violetColor),
                          label: Text('Ajouter'),
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            setState(() {
                              ajout = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  search == false
                      ? Container(
                          height: MediaQuery.of(context).size.height - 360,
                          child: listClasses.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Aucune classe',
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              : GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 120,
                                          childAspectRatio: 3 / 2,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 50,
                                          mainAxisExtent: 100),
                                  itemCount: listClasses.length,
                                  itemBuilder: ((context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              height: 50,
                                              child: Row(children: [
                                                Text(
                                                  listClasses[index].title!,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Spacer(),
                                                more(
                                                    listClasses[index].sId!,
                                                    listClasses[index].title!,
                                                    listClasses[index]
                                                        .description!,
                                                    listClasses[index]
                                                        .students!,
                                                    listClasses[index].courses!,
                                                    listClasses[index]),
                                              ]),
                                            ),
                                          ),
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  '${listClasses[index].students!.length} élèves inscrits')),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  '${listClasses[index].courses!.length} cours inscrits')),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height - 360,
                          child: ClasseSearch.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Aucune classe trouvée',
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              : GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 120,
                                          childAspectRatio: 3 / 2,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 50,
                                          mainAxisExtent: 100),
                                  itemCount: ClasseSearch.length,
                                  itemBuilder: ((context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              height: 50,
                                              child: Row(children: [
                                                Text(
                                                  ClasseSearch[index].title!,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Spacer(),
                                                more(
                                                    ClasseSearch[index].sId!,
                                                    ClasseSearch[index].title!,
                                                    ClasseSearch[index]
                                                        .description!,
                                                    ClasseSearch[index]
                                                        .students!,
                                                    ClasseSearch[index]
                                                        .courses!,
                                                    ClasseSearch[index]),
                                              ]),
                                            ),
                                          ),
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  '${ClasseSearch[index].students!.length}  élèves inscrits')),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  '${ClasseSearch[index].courses!.length} cours inscrits')),
                                          const SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    );
                                  }),
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
    List<Classe> listClasses,
  ) {
    tablette = true;
    return AppLayout(
      content: ajout == true
          ? Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(right: 40, left: 40, bottom: 5, top: 5),
              color: Palette.backgroundColor,
              child: creation(id, true),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(40),
              color: Palette.backgroundColor,
              child: Column(
                children: [
                  Container(
                    child: Row(children: const [
                      Icon(
                        Icons.book,
                        size: 30,
                      ),
                      Text(
                        'Classes',
                        style: TextStyle(
                            color: Palette.violetColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 100,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Text('Filter'),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: 200,
                          child: TextField(
                            // onChanged: (value) => onSearch(value.toLowerCase()),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            onChanged: (value) {
                              filterSearchResults(value);
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(0),
                              prefixIcon: const Icon(Icons.search,
                                  color: Palette.violetColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                              hintText: "Recherche",
                            ),
                          ),
                        ),
                        Spacer(),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              minimumSize: (Size(100, 60)),
                              backgroundColor: Palette.violetColor),
                          label: Text('Ajouter'),
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            setState(() {
                              ajout = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  search == false
                      ? Container(
                          height: MediaQuery.of(context).size.height - 370,
                          child: listClasses.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Aucune classe ',
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              : GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 120,
                                          childAspectRatio: 3 / 2,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 50,
                                          mainAxisExtent: 100),
                                  itemCount: listClasses.length,
                                  itemBuilder: ((context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              height: 50,
                                              child: Row(children: [
                                                Text(
                                                  listClasses[index].title!,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Spacer(),
                                                more(
                                                    listClasses[index].sId!,
                                                    listClasses[index].title!,
                                                    listClasses[index]
                                                        .description!,
                                                    listClasses[index]
                                                        .students!,
                                                    listClasses[index].courses!,
                                                    listClasses[index]),
                                              ]),
                                            ),
                                          ),
                                          Expanded(
                                              child: Text(
                                                  '${listClasses[index].students!.length}  élèves inscrits')),
                                          Expanded(
                                              child: Text(
                                                  '${listClasses[index].courses!.length} cours inscrits')),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height - 360,
                          child: ClasseSearch.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Aucune classe trouvée',
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              : GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 120,
                                          childAspectRatio: 3 / 2,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 50,
                                          mainAxisExtent: 100),
                                  itemCount: ClasseSearch.length,
                                  itemBuilder: ((context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              height: 50,
                                              child: Row(children: [
                                                Text(
                                                  ClasseSearch[index].title!,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Spacer(),
                                                more(
                                                    ClasseSearch[index].sId!,
                                                    ClasseSearch[index].title!,
                                                    ClasseSearch[index]
                                                        .description!,
                                                    ClasseSearch[index]
                                                        .students!,
                                                    ClasseSearch[index]
                                                        .courses!,
                                                    ClasseSearch[index]),
                                              ]),
                                            ),
                                          ),
                                          Expanded(
                                              child: Text(
                                                  '${ClasseSearch[index].students!.length}  élèves inscrits')),
                                          Expanded(
                                              child: Text(
                                                  '${ClasseSearch[index].courses!.length} cours inscrits')),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                        ),
                ],
              ),
            ),
    );
  }

  Widget creation(id, bool tablette) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Row(children: [
              Icon(
                Icons.person,
                size: tablette == true ? 30 : 40,
              ),
              const SizedBox(
                width: 10,
              ),
              modif == true
                  ? Text(
                      "Modification de classe",
                      style: TextStyle(
                          color: Palette.violetColor,
                          fontSize: tablette == true ? 20 : 30,
                          fontWeight: FontWeight.bold),
                    )
                  : Text(
                      "Ajout de classe",
                      style: TextStyle(
                          color: Palette.violetColor,
                          fontSize: tablette == true ? 20 : 30,
                          fontWeight: FontWeight.bold),
                    ),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: TextFormField(
              controller: nomcontroller,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {},
              decoration: InputDecoration(
                  hoverColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.violetColor),
                    gapPadding: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.violetColor),
                    gapPadding: 10,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.violetColor),
                    gapPadding: 10,
                  ),
                  labelText: "Nom",
                  hintText: "Entrer le nom de la classe",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(Icons.food_bank)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: TextFormField(
              controller: descriptioncontroller,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {},
              decoration: InputDecoration(
                  hoverColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.violetColor),
                    gapPadding: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.violetColor),
                    gapPadding: 10,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.violetColor),
                    gapPadding: 10,
                  ),
                  labelText: "Description",
                  hintText: "Entrer la description",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(Icons.food_bank)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.centerRight,
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
                      child: Text('Continuer'),
                      onPressed: () {
                        if (modif == false) {
                          creationClasse(
                            context,
                            nomcontroller.text,
                            descriptioncontroller.text,
                          );
                        } else {
                          modificationClasse(
                            context,
                            id,
                            nomcontroller.text,
                            descriptioncontroller.text,
                          );
                        }
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
                        setState(() {
                          ajout = false;
                          modif = false;
                          nomcontroller.clear();
                          descriptioncontroller.clear();
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),

          /*Container(
          height: MediaQuery.of(context).size.height - 360,
          child: ,
        )*/
        ],
      ),
    );
  }

  Future dialogDelete(id, nom) {
    return showDialog(
        context: context,
        builder: (con) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                "Confirmez la suppression",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'HelveticaNeue',
                ),
              ),
            ),
            actions: [
              ElevatedButton.icon(
                  icon: const Icon(
                    Icons.close,
                    size: 14,
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  label: const Text("Quitter   ")),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.delete,
                  size: 14,
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  deleteClasse(context, id);
                  Navigator.pop(con);
                },
                label: const Text("Supprimer."),
              ),
            ],
            content: Container(
              alignment: Alignment.center,
              color: Colors.white,
              height: 150,
              child: Text(
                "Voulez vous supprimer la classe $nom ?",
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'HelveticaNeue',
                ),
              ),
            ),
          );
        });
  }

  Widget more(String id, String nom, String decription,
      List<Students> listStudent, List<Courses> listCourses, Classe c) {
    return PopupMenuButton(
      tooltip: 'Menu',
      initialValue: selectedMenu,
      onSelected: (SampleItem item) async {
        setState(() {
          selectedMenu = item;
        });

        if (item == SampleItem.itemOne) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('idClasse', id);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => classeCours(
                        idClasse: id,
                        classe: nom,
                      )));
        } else if (item == SampleItem.itemTwo) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('idClasse', id);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => classeEtudiant(
                        idClasse: id,
                        classe: nom,
                      )));
        } else if (item == SampleItem.itemThree) {
          modification(id, nom, decription);
        } else if (item == SampleItem.itemFour) {
          dialogDelete(id, nom);
        } else if (item == SampleItem.itemSix) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlanningCreation(
                        idClasse: id,
                      )));
        } else if (item == SampleItem.itemSeven) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('idClasse', id);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GestionMenu(
                        idClasse: id,
                        listeleve: listStudent,
                        classe: c,
                      )));
        } else if (item == SampleItem.itemFive) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DevoirCreation(
                        list: listCourses,
                      )));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlanningTeacher(
                classe: c,
              ),
            ),
          );
        }
      },
      child: const Icon(
        Icons.more_vert,
        size: 20,
        color: Colors.black,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          child: Text('Gestion des cours'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemTwo,
          child: Text('Gestion des élèves'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemSeven,
          child: Text('Voir la présence'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemSix,
          child: Text('Ajouter un planning'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemNine,
          child: Text('Voir les plannings'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemFive,
          child: Text('Ajouter un devoir de maison'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemThree,
          child: Text('Modifier la classe'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemFour,
          child: Text('Supprimer la classe'),
        ),
      ],
    );
  }

//////////////////////////////////////////////////////////////////////////////////////////  SERVICES
  Future<void> creationClasse(
    BuildContext context,
    nom,
    description,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');

    print(id);
    print(token);

    var url = Uri.parse("http://13.39.81.126:7003/api/classes/create");
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
      "title": nom,
      "description": description,
      "creator": id,
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';

    print("RESPENSE SEND STEAM FILE REQ");

    var response = await request.send();
    print("Upload Response$response");
    print(response.statusCode);
    print(request.headers);
    print(request.fields);
    print(response.request);

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });

        setState(() {
          ajout = false;
          modif = false;
          nomcontroller.clear();
          descriptioncontroller.clear();
        });
        ref.refresh(getDataClasseFuture);
        showTopSnackBar(
          Overlay.of(context)!,
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Classe créé avec succès",
          ),
        );
      } else {
        showTopSnackBar(
          Overlay.of(context)!,
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

  Future<void> modificationClasse(
    BuildContext context,
    idUpdate,
    nom,
    description,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');

    print(id);
    print(token);

    var url =
        Uri.parse("http://13.39.81.126:7003/api/classes/update/$idUpdate");
    final request = MultipartRequest(
      'PATCH',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    print(url);
    var json = {"title": nom, "description": description, "creator": id};
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });
    request.headers['authorization'] = 'Bearer $token';

    print("RESPENSE SEND STEAM FILE REQ");
    var response = await request.send();
    print("Upload Response$response");
    print(response.statusCode);
    print(request.headers);

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });
        ref.refresh(getDataClasseFuture);
        setState(() {
          ajout = false;
          modif = false;
          nomcontroller.clear();
          descriptioncontroller.clear();
        });
        showTopSnackBar(
          Overlay.of(context)!,
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Classe modifié avec succès",
          ),
        );
      } else {
        showTopSnackBar(
          Overlay.of(context)!,
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de modification",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> deleteClasse(contextt, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      //String adress_url = prefs.getString('ipport').toString();
      String urlDelete = "http://13.39.81.126:7003/api/classes/delete/$id";
      print(urlDelete);
      final http.Response response = await http.patch(
        Uri.parse(urlDelete),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        showTopSnackBar(
          Overlay.of(contextt)!,
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "User supprimé",
          ),
        );
        ref.refresh(getDataClasseFuture);
        return response;
      } else {
        showTopSnackBar(
          Overlay.of(contextt)!,
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de suppression",
          ),
        );
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
