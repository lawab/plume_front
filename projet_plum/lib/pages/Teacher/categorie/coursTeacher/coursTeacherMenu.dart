import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/Teacher/categorie/coursTeacher/coursTeacher.dart';
import 'package:projet_plum/pages/Teacher/categorie/coursTeacher/coursTeacherValide.dart';
import 'package:projet_plum/pages/categorie/cours/courNonValide.dart';
import 'package:projet_plum/pages/categorie/cours/coursValide.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

class MenuCoursTeacher extends ConsumerStatefulWidget {
  final String id;
  const MenuCoursTeacher({Key? key, required this.id}) : super(key: key);

  @override
  MenuCoursTeacherState createState() => MenuCoursTeacherState();
}

class MenuCoursTeacherState extends ConsumerState<MenuCoursTeacher> {
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
                  text: "Cours non valide",
                  icon: Icon(Icons.published_with_changes),
                ),
                Tab(
                  text: "Cours valide",
                  icon: Icon(Icons.bookmark),
                ),
              ],
            ),
            title: Center(
              child: Text('Les cours'),
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
                    CoursNonValideTeacher(
                      id: widget.id,
                    ),
                    CoursValideTeacher(
                      id: widget.id,
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
