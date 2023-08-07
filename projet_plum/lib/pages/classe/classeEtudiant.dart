import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/classe/etuAssignes.dart';
import 'package:projet_plum/pages/classe/etuNNAssignes.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

class classeEtudiant extends ConsumerStatefulWidget {
  final String classe;
  final String idClasse;
  const classeEtudiant({Key? key, required this.classe, required this.idClasse})
      : super(key: key);

  @override
  classeEtudiantState createState() => classeEtudiantState();
}

class classeEtudiantState extends ConsumerState<classeEtudiant> {
  @override
  Widget build(BuildContext context) {
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
                  text: "Elèves assignés",
                  icon: Icon(Icons.published_with_changes),
                ),
                Tab(
                  text: "Elèves Non assignés",
                  icon: Icon(Icons.person),
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
                    EtudiantAssignes(
                      idClasse: widget.idClasse,
                    ),
                    EtudiantNNAssignes(
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
