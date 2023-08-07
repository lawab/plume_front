import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:projet_plum/pages/apprenant/quiz/score.dart';
import 'package:projet_plum/pages/devoir/creationDevoir.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

import 'package:shared_preferences/shared_preferences.dart';

class QuizStagiaire extends StatefulWidget {
  QuizTotal module;
  QuizStagiaire({Key? key, required this.module}) : super(key: key);

  @override
  QuizStagiaireState createState() => QuizStagiaireState();
}

class QuizStagiaireState extends State<QuizStagiaire>
    with TickerProviderStateMixin {
  late AnimationController controller;
  QuizTotal? _list;
  int _counter = 1;
  int note = 0;
  int nombre = 0;
  int time = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _Nombrereponse() {
    setState(() {
      nombre++;
    });
  }

  void ee() {
    setState(() {
      _list = widget.module;
      int z = int.parse(widget.module.dure!);
      time = z;
    });
  }

  Animation? _animation;
  Animation get animation => _animation!;

  @override
  void initState() {
    ee();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: time),
    )..addListener(() {
        setState(() {});
      });
    //controller.repeat(reverse: true);
    controller.forward().whenComplete(nextQuestion);
    // TODO: implement initState
    super.initState();
  }

  void nextQuestion() async {
    print('FINI');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool vide = false;
    bool videRep = false;
    for (int i = 0; i < _list!.corps!.length; i++) {
      List nnn = [];
      for (int j = 0; j < _list!.corps![i].responses!.length; j++) {
        if (_list!.corps![i].responses![j].coche == true) {
          if (_list!.corps![i].correct_answer!.isNotEmpty) {
            if (_list!.corps![i].correct_answer!
                .contains(_list!.corps![i].responses![j].reponsee)) {
              nnn.add('ok');
            } else {
              nnn.remove('ok');

              //Mauvaise reponse
            }
          } else {
            vide = true;
            if (_list!.corps![i].responses![j].coche == true) {
              videRep = true;
            }
          }
        }
      }
      if (vide == true) {
        vide = false;
        if (videRep == false) {
          note = note + 1;
        }
      } else {
        if (_list!.corps![i].correct_answer!.length == nnn.length) {
          note = note + 1;
        }
      }
    }

    print('$note/${_list!.corps!.length}');
    print('jsonEncode(_list)');
    prefs.setString('note', '$note/${_list!.corps!.length}');
    prefs.setString('afficheScore', jsonEncode(_list));

    Future.delayed(Duration.zero, () async {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Score(
                    modueleQuiz: _list!,
                  )));
    });

    /* Get.to(AllScoreScreen(
      modueleQuiz: _list,
    ));*/
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool bonne1 = false;
  bool bonne2 = false;
  bool bonne3 = false;
  bool bonne4 = false;
  List<String> bonneReponse = [];
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      content: Container(
        color: Palette.backgroundColor,
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 50,
            height: 50,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    //gradient: kprimryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: LinearProgressIndicator(
                    semanticsValue: '',
                    minHeight: 40,
                    value: controller.value,
                    semanticsLabel: '',
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20 / 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${(controller.value * time).round()} sec"),
                        Image.asset('dure.png'),
                        /*const Icon(
                          Icons.hourglass_bottom,
                          color: Colors.white,
                        )*/
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Palette.backgroundColor,
            height: 50,
            width: MediaQuery.of(context).size.width / 2,
            alignment: Alignment.center,
            child: const ListTile(
              title: Text(
                'Ce formulaire sera fermé automatiquement à la fin du temps dédié',
                style: TextStyle(color: Color.fromARGB(255, 248, 96, 85)),
              ),
              leading: Icon(Icons.dangerous,
                  color: Color.fromARGB(255, 248, 96, 85)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color.fromARGB(255, 35, 98, 164),
                )),
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height - 360,
            child: ListView.builder(
              itemCount: _list!.corps!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${index + 1}. ${_list!.corps![index].question!}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width / 3,
                      child: ListView.builder(
                          itemCount: _list!.corps![index].responses!.length,
                          itemBuilder: (context, inde) {
                            return Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25)),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                            "${inde + 1}. ${_list!.corps![index].responses![inde].reponsee!} "),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: IconButton(
                                          onPressed: (() {
                                            setState(() {
                                              _list!.corps![index]
                                                      .responses![inde].coche =
                                                  !_list!.corps![index]
                                                      .responses![inde].coche!;
                                            });
                                          }),
                                          icon: _list!.corps![index]
                                                      .responses![inde].coche ==
                                                  true
                                              ? Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green[700],
                                                )
                                              : const Icon(
                                                  Icons.check_circle_outline,
                                                  color: Color.fromARGB(
                                                      255, 139, 32, 32),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 300,
            height: 50,
            child: Row(
              children: [
                /* Expanded(
                    child: ElevatedButton(
                  child: Text('Annuler'),
                  onPressed: () {
                    controller.dispose();
                  },
                )),
                const SizedBox(
                  width: 10,
                ),*/
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 35, 98, 164),
                    ),
                    onPressed: (() async {
                      //controller.forward().whenComplete(nextQuestion);
                      controller.dispose();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      bool vide = false;
                      bool videRep = false;
                      for (int i = 0; i < _list!.corps!.length; i++) {
                        List nnn = [];
                        for (int j = 0;
                            j < _list!.corps![i].responses!.length;
                            j++) {
                          if (_list!.corps![i].responses![j].coche == true) {
                            if (_list!.corps![i].correct_answer!.isNotEmpty) {
                              if (_list!.corps![i].correct_answer!.contains(
                                  _list!.corps![i].responses![j].reponsee)) {
                                nnn.add('ok');
                              } else {
                                nnn.remove('ok');

                                //Mauvaise reponse
                              }
                            } else {
                              vide = true;
                              if (_list!.corps![i].responses![j].coche ==
                                  true) {
                                videRep = true;
                              }
                            }
                          }
                        }
                        if (vide == true) {
                          vide = false;
                          if (videRep == false) {
                            note = note + 1;
                          }
                        } else {
                          if (_list!.corps![i].correct_answer!.length ==
                              nnn.length) {
                            note = note + 1;
                          }
                        }
                      }

                      print('$note/${_list!.corps!.length}');
                      print('jsonEncode(_list)');
                      prefs.setString('note', '$note/${_list!.corps!.length}');
                      prefs.setString('afficheScore', jsonEncode(_list));
                      /*Modules? tttt;
                      setState(() {
                        tttt = _list!;
                      });

                      for (int i = 0;
                          i < _list!.quizContent!.questions!.length;
                          i++) {
                        for (int j = 0;
                            j <
                                _list!
                                    .quizContent!.questions![i].answers!.length;
                            j++) {
                          setState(() {
                            _list!.quizContent!.questions![i].answers![j]
                                .coche = false;
                          });
                        }
                      }*/

                      Future.delayed(Duration.zero, () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Score(
                                      modueleQuiz: _list!,
                                    )));
                      });
                    }),
                    child: Text('Soumettre'),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
    /*Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/arrierplanquiz.jpg"),
              fit: BoxFit.cover)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar:
            AppBar(backgroundColor: Colors.transparent, elevation: 0, actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ShowModuleAll()));
            },
            child: Text("Quitter"),
          )
        ]),
        body: Body(),
      ),
    );*/
  }
}
