import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/Teacher/coursTeacher/coursTeacher.dart';
import 'package:projet_plum/pages/apprenant/coursApprenant/coursApprenant.dart';
import 'package:projet_plum/pages/cours/lescours.dart';
import 'package:projet_plum/pages/moduleAffiche/moduleAffiche.dart';
import 'package:projet_plum/pages/sections/movie.dart';
import 'package:projet_plum/pages/services/getCourss.dart';
import 'package:projet_plum/pages/services/getModule.dart' as p;
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AfficheSection extends ConsumerStatefulWidget {
  final String titleCours;
  final String descripCours;
  final String image;
  final List<Sections> listSection;
  const AfficheSection(
      {Key? key,
      required this.listSection,
      required this.titleCours,
      required this.descripCours,
      required this.image})
      : super(key: key);

  @override
  ConsumerState<AfficheSection> createState() => AfficheSectionState();
}

class AfficheSectionState extends ConsumerState<AfficheSection> {
  ScrollController _scrollController1 = ScrollController();

  @override
  void initState() {
    ind();
    super.initState();
  }

  List movies1 = [
    'Mcf_Junior.png',
    'logo_plum.png',
  ];
  var role = '';
  bool moov = false;
  Future ind() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //if(prefs.getInt('index').toInt().is)
    setState(() {
      role = prefs.getString('Role')!;
      movies1.add(widget.image);
      moov = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double minScrollExtent1 = _scrollController1.position.minScrollExtent;
      double maxScrollExtent1 = _scrollController1.position.maxScrollExtent;

      //
      animateToMaxMin(maxScrollExtent1, minScrollExtent1, maxScrollExtent1, 10,
          _scrollController1);
    });
  }

  animateToMaxMin(double max, double min, double direction, int seconds,
      ScrollController scrollController) {
    scrollController
        .animateTo(direction,
            duration: Duration(seconds: seconds), curve: Curves.linear)
        .then((value) {
      direction = direction == max ? min : max;
      animateToMaxMin(max, min, direction, seconds, scrollController);
    });
  }

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

  bool module = false;
  List<Modules> listModule = [];

  @override
  Widget build(BuildContext context) {
    print('----------------------------------------------------------------');
    print(jsonEncode(widget.listSection));
    //final viewModel = ref.watch(getDataClasseFuture);
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

  Widget horizontalView(
    double height,
    double width,
    contextt,
  ) {
    return AppLayout(
      content: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 200,
              color: Palette.violetColor,
              child: Row(
                children: [
                  Container(
                    width: 50,
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.backspace,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (role == 'SUDO' || role == 'ADMIN') {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Cours()));
                        } else if (role == 'TEACHER') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CoursTeacher()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CoursApprenant()));
                        }
                      },
                    ),
                  ),
                  Spacer(),
                  Container(
                    child: Text(
                      widget.titleCours,
                      style: TextStyle(
                          fontFamily: 'Boogaloo',
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Spacer(),
                  moov == false
                      ? Container()
                      : Container(
                          color: Colors.white,
                          height: 150,
                          width: 300,
                          child: MoviesListView(
                            scrollController: _scrollController1,
                            images: movies1,
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 345,
              child: Row(children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('section.png'),
                          opacity: 100,
                          fit: BoxFit.cover),
                      color: Palette.violetColor,
                    ),
                    child: ListView.builder(
                      itemCount: widget.listSection.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Text(
                            widget.listSection[i].title!,
                            style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.white),
                          ),
                          trailing: const Icon(
                            Icons.work,
                            color: Color.fromARGB(255, 25, 0, 255),
                          ),
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            setState(() {
                              listModule = [];
                            });
                            prefs.setString(
                                'idSection', widget.listSection[i].sId!);
                            for (int j = 0;
                                j < widget.listSection[i].modules!.length;
                                j++) {
                              if (widget.listSection[i].modules![j].deletedAt ==
                                  null) {
                                setState(() {
                                  module = true;

                                  listModule
                                      .add(widget.listSection[i].modules![j]);
                                });
                              }
                            }
                            ref.refresh(p.getDataModulesFuture);
                          },
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: module == true
                      ? Container(
                          color: Palette.backgroundColor,
                          child: ListView.builder(
                            itemCount: listModule.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                leading: Image.asset(
                                  'module.png',
                                  height: 40,
                                  width: 40,
                                ),
                                /*const Icon(
                                  Icons.attach_file_sharp,
                                  color: Colors.black,
                                ),*/
                                title: Text(
                                  listModule[i].title!,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black),
                                ),
                                onTap: () {
                                  //ref.watch(getDataModulesFuture);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ModuleAffiche(
                                                titleCours: widget.titleCours,
                                                listSection: widget.listSection,
                                                descripCours:
                                                    widget.descripCours,
                                                module: listModule[i],
                                                image: widget.image,
                                              )));
                                },
                              );
                            },
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          color: Palette.backgroundColor,
                          child: Text(
                            widget.descripCours,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                ),
              ]),
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
  ) {
    return AppLayout(
      content: Container(),
    );
  }
}
