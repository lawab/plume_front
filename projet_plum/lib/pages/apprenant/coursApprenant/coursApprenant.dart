import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/sections/sectionAffiche.dart';
import 'package:projet_plum/pages/services/getCategorie.dart';
import 'package:projet_plum/pages/services/getCourss.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

enum SampleItem { itemOne, itemTwo, itemThree, itemFour }

class CoursApprenant extends ConsumerStatefulWidget {
  const CoursApprenant({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CoursApprenant> createState() => CoursApprenantState();
}

class CoursApprenantState extends ConsumerState<CoursApprenant> {
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

  bool search = false;
  List<CoursCategorie> CoursSearch = [];

  String id = '';
  void filterSearchResults(String query, List<CoursCategorie> listCours) {
    //final viewModel = ref.watch(getDataCoursAllFuture);
    List<CoursCategorie> dummySearchList = [];

    dummySearchList.addAll(listCours);
    if (query.isNotEmpty) {
      List<CoursCategorie> dummyListData = [];
      for (var item in dummySearchList) {
        for (int i = 0; i < item.courses!.length; i++) {
          if (item.title!.contains(query) ||
              item.courses![i].title!.contains(query)) {
            dummyListData.add(item);
          }
        }
      }
      setState(() {
        search = true;
        CoursSearch.clear();
        CoursSearch.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        search = false;
      });
    }
  }

  List<CoursCategorie> listCours = [];
  bool filtre = false;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataCoursByAppFuture);
    final viewModelCat = ref.watch(getDataCategorieFuture);

    if (filtre == false) {
      for (int i = 0; i < viewModelCat.listCategorie.length; i++) {
        for (int s = 0; s < viewModel.listcoursvalide.length; s++) {
          List<Courses> dummySearchList = [];

          if (viewModelCat.listCategorie[i].courses!
              .contains(viewModel.listcoursvalide[s].sId)) {
            dummySearchList.add(viewModel.listcoursvalide[s]);

            List<CoursCategorie> json = [];
            for (var o = 0; o < dummySearchList.length; o++) {
              final jsonn =
                  '[{"title":"${viewModelCat.listCategorie[i].title.toString()}","sid":"${viewModelCat.listCategorie[i].sId.toString()}", "courses":[{ "title": "${dummySearchList[o].title.toString()}", "_id": "${dummySearchList[o].sId}","image":"${dummySearchList[o].image.toString()}","description":"${dummySearchList[o].description.toString()}", "validated":${dummySearchList[o].validated},"createdAt":"${dummySearchList[o].createdAt.toString()}","updatedAt":"${dummySearchList[o].updatedAt.toString()}"}]}]';

              var aa = jsonDecode(jsonn);

              var gg = CoursCategorie.fromJson(aa[0]);

              json.add(gg);
            }

            setState(() {
              listCours.addAll(json);

              filtre = true;
            });
          }
        }
      }
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                listCours, viewModel.listcoursvalide);
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
    context,
    List<CoursCategorie> listCours,
    List<Courses> listCourses,
  ) {
    return AppLayout(
      content: Container(
        color: Palette.backgroundColor,
        child: Column(
          children: [
            Container(
              height: 80,
              child: Container(
                width: 350,
                child: TextField(
                  // onChanged: (value) => onSearch(value.toLowerCase()),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  onChanged: (value) {
                    filterSearchResults(value, listCours);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(0),
                    prefixIcon:
                        const Icon(Icons.search, color: Palette.violetColor),
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
            ),
            search == false
                ? Container(
                    height: height - 180,
                    child: listCours.isEmpty
                        ? const Center(
                            child: Text(
                              'Aucun cours',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          )
                        : GridView.builder(
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 250,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 50,
                                    mainAxisExtent: 250),
                            itemCount: listCours.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    height: 250,
                                    child: GridView.builder(
                                      scrollDirection: Axis.vertical,
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 250,
                                              childAspectRatio: 3 / 2,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 50,
                                              mainAxisExtent: 250),
                                      itemCount:
                                          listCours[index].courses!.length,
                                      itemBuilder: ((context, indexx) {
                                        return InkWell(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            color: Colors.white,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                'http://13.39.81.126:7002${listCours[index].courses![indexx].image.toString()}'),
                                                            fit: BoxFit.cover),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color:
                                                            Palette.barColor),
                                                    height: 140,
                                                    width: 200,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    height: 85,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                const TextSpan(
                                                                  text:
                                                                      "Cours: ",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Allerta',
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                TextSpan(
                                                                  text: listCours[
                                                                          index]
                                                                      .courses![
                                                                          indexx]
                                                                      .title!,
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'Bevan',
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 20,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: InkWell(
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  const TextSpan(
                                                                    text:
                                                                        "Categorie: ",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Allerta',
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  TextSpan(
                                                                    text: listCours[
                                                                            index]
                                                                        .title!,
                                                                    style: const TextStyle(
                                                                        fontFamily:
                                                                            'Bevan',
                                                                        fontSize:
                                                                            15,
                                                                        color: Palette
                                                                            .barColor,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Container(
                                                          height: 40,
                                                          width: 200,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            color: Palette
                                                                .violetColor,
                                                          ),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            'GO',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            List<Sections> listsec = [];
                                            var title = '';
                                            var desc = '';
                                            var image = '';
                                            for (int i = 0;
                                                i < listCourses.length;
                                                i++) {
                                              if (listCourses[i].sId ==
                                                  listCours[index]
                                                      .courses![indexx]
                                                      .sId) {
                                                setState(() {
                                                  listsec =
                                                      listCourses[i].sections!;
                                                  title = listCourses[i].title!;
                                                  desc = listCourses[i]
                                                      .description!;
                                                  image = listCourses[i].image!;
                                                });
                                              }
                                            }
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AfficheSection(
                                                  descripCours: desc,
                                                  listSection: listsec,
                                                  titleCours: title,
                                                  image: image,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }),
                                    ),
                                  )
                                ],
                              );
                            }),
                  )
                : Container(
                    height: height - 180,
                    child: CoursSearch.isEmpty
                        ? const Center(
                            child: Text(
                              'Aucun cours trouvé',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          )
                        : GridView.builder(
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 250,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 50,
                                    mainAxisExtent: 250),
                            itemCount: CoursSearch.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    height: 250,
                                    child: GridView.builder(
                                      scrollDirection: Axis.vertical,
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 250,
                                              childAspectRatio: 3 / 2,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 50,
                                              mainAxisExtent: 250),
                                      itemCount:
                                          CoursSearch[index].courses!.length,
                                      itemBuilder: ((context, indexx) {
                                        return InkWell(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            color: Colors.white,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                'http://13.39.81.126:7002${CoursSearch[index].courses![indexx].image.toString()}'),
                                                            fit: BoxFit.cover),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color:
                                                            Palette.barColor),
                                                    height: 140,
                                                    width: 200,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    height: 85,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                const TextSpan(
                                                                  text:
                                                                      "Cours: ",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Allerta',
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                TextSpan(
                                                                  text: CoursSearch[
                                                                          index]
                                                                      .courses![
                                                                          indexx]
                                                                      .title!,
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'Bevan',
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 20,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                const TextSpan(
                                                                  text:
                                                                      "Categorie: ",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Allerta',
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                TextSpan(
                                                                  text: CoursSearch[
                                                                          index]
                                                                      .title!,
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'Bevan',
                                                                      fontSize:
                                                                          15,
                                                                      color: Palette
                                                                          .barColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Container(
                                                          height: 40,
                                                          width: 200,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            color: Palette
                                                                .violetColor,
                                                          ),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            'GO',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            List<Sections> listsec = [];
                                            var title = '';
                                            var desc = '';
                                            var image = '';
                                            for (int i = 0;
                                                i < listCourses.length;
                                                i++) {
                                              if (listCourses[i].sId ==
                                                  listCours[index]
                                                      .courses![indexx]
                                                      .sId) {
                                                setState(() {
                                                  listsec =
                                                      listCourses[i].sections!;
                                                  title = listCourses[i].title!;
                                                  desc = listCourses[i]
                                                      .description!;
                                                  image = listCourses[i].image!;
                                                });
                                              }
                                            }
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AfficheSection(
                                                  descripCours: desc,
                                                  listSection: listsec,
                                                  titleCours: title,
                                                  image: image,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }),
                                    ),
                                  )
                                ],
                              );
                            }),
                  )
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
      content: Container(),
    );
  }
}
