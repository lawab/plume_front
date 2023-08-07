import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/classe/coursAssignes.dart';
import 'package:projet_plum/pages/classe/coursNNAssinges.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

class classeCours extends ConsumerStatefulWidget {
  final String idClasse;
  final String classe;
  const classeCours({Key? key, required this.classe, required this.idClasse})
      : super(key: key);

  @override
  classeCoursState createState() => classeCoursState();
}

class classeCoursState extends ConsumerState<classeCours> {
  @override
  Widget build(BuildContext context) {
    //final viewModele = ref.watch(getParametreApi);

    return AppLayout(
      content: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Palette.violetColor,
            automaticallyImplyLeading: false,
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Cours assignés",
                  icon: Icon(Icons.published_with_changes),
                ),
                Tab(
                  text: "Cours Non assignés",
                  icon: Icon(Icons.bookmark),
                ),
              ],
            ),
            title: Center(
              child: Text(widget.classe),
            ),
            leading: IconButton(
              icon: Icon(Icons.backspace),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: Color.fromARGB(255, 232, 228, 213),
          body: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: TabBarView(
                  children: [
                    CoursAssignes(
                      idClasse: widget.idClasse,
                    ),
                    CoursNNAssignes(
                      idClasse: widget.idClasse,
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
