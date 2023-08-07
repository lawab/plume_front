import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/Teacher/gestionEleve/gestionEleve.dart';
import 'package:projet_plum/pages/Teacher/planningTeacher/PlanningTeacher.dart';
import 'package:projet_plum/pages/Teacher/presence/menuPresence.dart';
import 'package:projet_plum/pages/devoir/creationDevoir.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SampleItem { itemOne, itemTwo, itemThree, itemFour }

class ClasseTeacher extends ConsumerStatefulWidget {
  const ClasseTeacher({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ClasseTeacher> createState() => ClasseTeacherState();
}

class ClasseTeacherState extends ConsumerState<ClasseTeacher> {
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

  bool tablette = false;
  bool modif = false;
  bool ajout = false;
  bool search = false;
  List<Classe> ClasseSearch = [];

  String id = '';
  void filterSearchResults(String query) {
    final viewModel = ref.watch(getDataClasseFuture);
    List<Classe> dummySearchList = [];

    dummySearchList.addAll(viewModel.listClasseForTeacher);
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
            return horizontalView(height(context), width(context), context,
                viewModel.listClasseForTeacher);
          } else {
            return verticalView(height(context), width(context), context,
                viewModel.listClasseForTeacher);
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
      content: Container(
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
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            search == false
                ? listClasses.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucune classe',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height - 360,
                        child: GridView.builder(
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
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        more(
                                            listClasses[index].sId!,
                                            listClasses[index].title!,
                                            listClasses[index].description!,
                                            listClasses[index].students!,
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
                : ClasseSearch.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucune classe trouvée',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height - 360,
                        child: GridView.builder(
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
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        more(
                                            ClasseSearch[index].sId!,
                                            ClasseSearch[index].title!,
                                            ClasseSearch[index].description!,
                                            ClasseSearch[index].students!,
                                            ClasseSearch[index].courses!,
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
      content: Container(
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
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            search == false
                ? listClasses.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucune classe',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height - 370,
                        child: GridView.builder(
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
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        more(
                                          listClasses[index].sId!,
                                          listClasses[index].title!,
                                          listClasses[index].description!,
                                          listClasses[index].students!,
                                          listClasses[index].courses!,
                                          listClasses[index],
                                        ),
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
                : ClasseSearch.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucune classe trouvée',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height - 360,
                        child: GridView.builder(
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
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        more(
                                          ClasseSearch[index].sId!,
                                          ClasseSearch[index].title!,
                                          ClasseSearch[index].description!,
                                          ClasseSearch[index].students!,
                                          ClasseSearch[index].courses!,
                                          ClasseSearch[index],
                                        ),
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

  Widget more(
    String id,
    String nom,
    String decription,
    List<Students> listStudent,
    List<Courses> listCourses,
    Classe classe,
  ) {
    return PopupMenuButton(
      tooltip: 'Menu',
      initialValue: selectedMenu,
      onSelected: (SampleItem item) async {
        setState(() {
          selectedMenu = item;
        });

        if (item == SampleItem.itemOne) {
          print(jsonEncode(listCourses));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GestionEleve(
                listEleve: listStudent,
                list: listCourses,
                classe: classe.title!,
              ),
            ),
          );
        } else if (item == SampleItem.itemTwo) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('idClasse', id);
          prefs.setString('lesElèves', jsonEncode(listStudent));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MenuPresence(
                idClasse: id,
                listeleve: listStudent,
                classe: classe,
              ),
            ),
          );
        } else if (item == SampleItem.itemThree) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DevoirCreation(
                list: listCourses,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlanningTeacher(
                classe: classe,
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
          child: Text('Gestion de mes élèves'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemTwo,
          child: Text('Liste de Présence'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemFour,
          child: Text('Visualiser les plannings'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemThree,
          child: Text('Ajouter un devoir de maison'),
        ),
      ],
    );
  }
}
