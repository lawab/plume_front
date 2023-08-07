import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/gestionPresence/presenceAdmin.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/pages/services/getPresence.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GestionMenu extends ConsumerStatefulWidget {
  final String idClasse;
  final List<Students> listeleve;
  final Classe classe;
  const GestionMenu({
    Key? key,
    required this.idClasse,
    required this.listeleve,
    required this.classe,
  }) : super(key: key);

  @override
  GestionMenuState createState() => GestionMenuState();
}

class GestionMenuState extends ConsumerState<GestionMenu> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _load(List<Course> c) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('idCours', c[0].sId!);
    });
  }

  List<Course> coursAssign = [];
  bool traitement = false;
  @override
  Widget build(BuildContext context) {
    //final viewModel = ref.watch(getDataClasseFuture);
    if (traitement == false) {
      for (int i = 0; i < widget.classe.courses!.length; i++) {
        coursAssign.add(widget.classe.courses![i].course!);
        traitement = true;
        _load(coursAssign);
      }
    }
    _load(coursAssign);
    return AppLayout(
      content: DefaultTabController(
        length: coursAssign.isEmpty ? 1 : coursAssign.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Palette.violetColor,
            automaticallyImplyLeading: false,
            bottom: TabBar(
              onTap: (value) async {
                print('value');
                print(value);
                print(jsonEncode(coursAssign));
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('idCours', coursAssign[value].sId!);
                ref.refresh(getDataPresenceFuture);
              },
              tabs: [
                if (coursAssign.isEmpty)
                  const Tab(
                    text: 'Vide',
                    icon: Icon(Icons.book_online),
                  ),
                if (coursAssign.isNotEmpty)
                  for (int i = 0; i < coursAssign.length; i++)
                    Tab(
                      text: coursAssign[i].title!,
                      icon: const Icon(Icons.book_online),
                    ),
              ],
            ),
            title: Center(
              child: Text(
                  'LISTE DE PRESENCE ${widget.classe.title!.toUpperCase()}'),
            ),
            leading: IconButton(
              icon: const Icon(Icons.backspace),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 232, 228, 213),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: TabBarView(
              children: [
                if (coursAssign.isEmpty)
                  const Center(
                    child: Text('Pas de cours'),
                  ),
                if (coursAssign.isNotEmpty)
                  for (int i = 0; i < coursAssign.length; i++)
                    PresenceAdmin(
                      idClasse: widget.idClasse,
                      idCourse: coursAssign[i].sId!,
                      listEleve: widget.listeleve,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
