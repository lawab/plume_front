import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:projet_plum/utils/applout.dart';

class Creation extends StatefulWidget {
  const Creation({Key? key}) : super(key: key);

  @override
  CreationState createState() => CreationState();
}

class CreationState extends State<Creation> {
  var titlecontroller = TextEditingController();
  var durecontroller = TextEditingController();
  int _counter = 1;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  List<CocheTotal> listCocheTotale = [];
  final questionController = TextEditingController();
  final rep1Controller = TextEditingController();
  final rep2Controller = TextEditingController();
  final rep3Controller = TextEditingController();
  final rep4Controller = TextEditingController();
  bool bonne1 = false;
  bool bonne2 = false;
  bool bonne3 = false;
  bool bonne4 = false;
  List<String> bonneReponse = [];
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      content: Container(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 200,
              child: TextField(
                controller: titlecontroller,
                onChanged: (val) {},
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 5),
                  labelText: 'Titre Quiz :',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 21),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Ecrire le Titre Quiz... *',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 200,
              child: TextField(
                controller: durecontroller,
                onChanged: (val) {},
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 5),
                  labelText: 'Durée du quiz',
                  labelStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 21),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Saisir la durée en seconde *',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    width: 300,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 83, 151),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Ajouter une question'),
                      onPressed: () {
                        if (questionController.text != '' ||
                            rep1Controller.text != '' ||
                            rep2Controller.text != '' ||
                            rep3Controller.text != '' ||
                            rep4Controller.text != '') {
                          if (bonne1 == true) {
                            bonneReponse.add(rep1Controller.text);
                          }
                          if (bonne2 == true) {
                            bonneReponse.add(rep2Controller.text);
                          }
                          if (bonne3 == true) {
                            bonneReponse.add(rep3Controller.text);
                          }
                          if (bonne4 == true) {
                            bonneReponse.add(rep4Controller.text);
                          }
                          List<Reponses> rep = [];
                          var jj1 = Reponses(
                            reponsee: rep1Controller.text,
                            coche: false,
                          );
                          rep.add(jj1);
                          var jj2 = Reponses(
                            reponsee: rep2Controller.text,
                            coche: false,
                          );
                          rep.add(jj2);
                          var jj3 = Reponses(
                            reponsee: rep3Controller.text,
                            coche: false,
                          );
                          rep.add(jj3);
                          var jj4 = Reponses(
                            reponsee: rep4Controller.text,
                            coche: false,
                          );
                          rep.add(jj4);
                          var ee = CocheTotal(
                              correct_answer: bonneReponse,
                              responses: rep,
                              question: questionController.text);
                          listCocheTotale.add(ee);
                          // _addinputText(Context, context);

                          setState(() {
                            bonneReponse = [];
                            rep1Controller.clear();
                            rep2Controller.clear();
                            rep3Controller.clear();
                            rep4Controller.clear();
                            questionController.clear();
                            bonne1 = false;
                            bonne2 = false;
                            bonne3 = false;
                            bonne4 = false;
                          });

                          _incrementCounter();
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 460,
                    width: MediaQuery.of(context).size.width - 200,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          child: TextField(
                            controller: questionController,
                            decoration: const InputDecoration(
                              label: Text('Question'),
                              hintText: '',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          child: Row(
                            children: [
                              const Text('Reponse 1:'),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: rep1Controller,
                                  decoration: const InputDecoration(
                                    label: Text('Ecrire le reponse 1'),
                                    hintText: '',
                                  ),
                                ),
                              ),
                              Text("Cocher si c'est une bonne reponse"),
                              IconButton(
                                onPressed: (() {
                                  setState(() {
                                    bonne1 = !bonne1;
                                  });
                                }),
                                icon: bonne1 == true
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green[700],
                                      )
                                    : const Icon(
                                        Icons.check_circle_outline,
                                        color: Color.fromARGB(255, 139, 32, 32),
                                      ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          child: Row(
                            children: [
                              Text('Reponse 2:'),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: rep2Controller,
                                  decoration: const InputDecoration(
                                    label: Text('Ecrire le reponse 2'),
                                    hintText: '',
                                  ),
                                ),
                              ),
                              Text("Cocher si c'est une bonne reponse"),
                              IconButton(
                                onPressed: (() {
                                  setState(() {
                                    bonne2 = !bonne2;
                                  });
                                }),
                                icon: bonne2 == true
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green[700],
                                      )
                                    : const Icon(
                                        Icons.check_circle_outline,
                                        color: Color.fromARGB(255, 139, 32, 32),
                                      ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          child: Row(
                            children: [
                              Text('Reponse 3:'),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: rep3Controller,
                                  decoration: const InputDecoration(
                                    label: Text('Ecrire le reponse 3'),
                                    hintText: '',
                                  ),
                                ),
                              ),
                              Text("Cocher si c'est une bonne reponse"),
                              IconButton(
                                onPressed: (() {
                                  setState(() {
                                    bonne3 = !bonne3;
                                  });
                                }),
                                icon: bonne3 == true
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green[700],
                                      )
                                    : const Icon(
                                        Icons.check_circle_outline,
                                        color: Color.fromARGB(255, 139, 32, 32),
                                      ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          child: Row(
                            children: [
                              Text('Reponse 4:'),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: rep4Controller,
                                  decoration: const InputDecoration(
                                    label: Text('Ecrire le reponse 4'),
                                    hintText: '',
                                  ),
                                ),
                              ),
                              Text("Cocher si c'est une bonne reponse"),
                              IconButton(
                                onPressed: (() {
                                  setState(() {
                                    bonne4 = !bonne4;
                                  });
                                }),
                                icon: bonne4 == true
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green[700],
                                      )
                                    : const Icon(
                                        Icons.check_circle_outline,
                                        color: Color.fromARGB(255, 139, 32, 32),
                                      ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    child: ElevatedButton(
                      child: Text('Créer le quiz à $_counter questions'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 83, 151),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (questionController.text != '' ||
                            rep1Controller.text != '' ||
                            rep2Controller.text != '' ||
                            rep3Controller.text != '' ||
                            rep4Controller.text != '' ||
                            durecontroller.text != '' ||
                            titlecontroller.text != '') {
                          if (listCocheTotale.length < _counter) {
                            if (bonne1 == true) {
                              bonneReponse.add(rep1Controller.text);
                            }
                            if (bonne2 == true) {
                              bonneReponse.add(rep2Controller.text);
                            }
                            if (bonne3 == true) {
                              bonneReponse.add(rep3Controller.text);
                            }
                            if (bonne4 == true) {
                              bonneReponse.add(rep4Controller.text);
                            }
                            List<Reponses> rep = [];
                            var jj1 = Reponses(
                              reponsee: rep1Controller.text,
                              coche: false,
                            );
                            rep.add(jj1);
                            var jj2 = Reponses(
                              reponsee: rep2Controller.text,
                              coche: false,
                            );
                            rep.add(jj2);
                            var jj3 = Reponses(
                              reponsee: rep3Controller.text,
                              coche: false,
                            );
                            rep.add(jj3);
                            var jj4 = Reponses(
                              reponsee: rep4Controller.text,
                              coche: false,
                            );
                            rep.add(jj4);
                            var ee = CocheTotal(
                                correct_answer: bonneReponse,
                                responses: rep,
                                question: questionController.text);
                            listCocheTotale.add(ee);

                            // _addinputText(Context, context);
                            setState(() {
                              bonneReponse = [];
                              rep1Controller.clear();
                              rep2Controller.clear();
                              rep3Controller.clear();
                              rep4Controller.clear();
                              questionController.clear();
                              bonne1 = false;
                              bonne2 = false;
                              bonne3 = false;
                              bonne4 = false;
                            });
                          }

                          print(jsonEncode(listCocheTotale));
                          /*createQuiz(titlecontroller.text, durecontroller.text,
                              jsonEncode(listCocheTotale));*/
                        } else {
                          print('Une donnée est nulle et doit etre remplie');
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CocheTotal {
  List<String>? correct_answer;
  List<Reponses>? responses;
  String? question;

  CocheTotal({this.correct_answer, this.responses, this.question});

  CocheTotal.fromJson(Map<String, dynamic> json) {
    correct_answer = json['correct_answer'].cast<String>();
    if (json['responses'] != null) {
      responses = <Reponses>[];
      json['responses'].forEach((v) {
        responses!.add(new Reponses.fromJson(v));
      });
    }
    question = json['question'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['correct_answer'] = this.correct_answer;
    if (this.responses != null) {
      data['responses'] = this.responses!.map((v) => v.toJson()).toList();
    }
    data['question'] = this.question;

    return data;
  }
}

class Reponses {
  String? reponsee;
  bool? coche;

  Reponses({
    this.reponsee,
    this.coche,
  });

  Reponses.fromJson(Map<String, dynamic> json) {
    reponsee = json['reponsee'];
    coche = json['coche'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['reponsee'] = this.reponsee;
    data['coche'] = this.coche;

    return data;
  }
}
