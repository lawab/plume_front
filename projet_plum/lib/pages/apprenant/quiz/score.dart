import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projet_plum/pages/apprenant/devoirApprenant/devoirApprenant.dart';

import 'package:projet_plum/pages/devoir/creationDevoir.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

const double kDefaultPadding = 20.0;

class Score extends StatefulWidget {
  final QuizTotal modueleQuiz;
  const Score({Key? key, required this.modueleQuiz}) : super(key: key);
  @override
  ScoreState createState() => ScoreState();
}

class ScoreState extends State<Score> {
  @override
  void initState() {
    rrrr();
    // TODO: implement initState
    super.initState();
  }

  String score = '';
  String correction = '';
  bool voir = false;
  QuizTotal? listcorrection;
  Future<void> rrrr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      score = prefs.getString('note')!.toString();
      correction = prefs.getString('afficheScore').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      content: Container(
        //margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        //padding: EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          color: Palette.backgroundColor,
          //borderRadius: BorderRadius.circular(25),
        ),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Palette.backgroundColor,
          appBar: AppBar(
              backgroundColor: Color.fromARGB(0, 241, 240, 243),
              elevation: 0,
              actions: [
                TextButton(
                  onPressed: () {
                    Get.to(DevoiApprenant());
                  },
                  child: Text(
                    "Quitter",
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: Colors.black),
                  ),
                )
              ]),
          body: Stack(
            fit: StackFit.expand,
            children: [
              //SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
              Column(
                children: [
                  // const Spacer(flex: 3),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color.fromRGBO(102, 45, 145, 1),
                        image: DecorationImage(
                          image: AssetImage('ex.png'),
                        ),
                      ),
                      height: 200,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Votre score est',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            score,
                            style: const TextStyle(
                                fontSize: 25,
                                color: Colors.blue,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: const Text(
                        'voir la correction ?',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        setState(() {
                          print(correction);
                          //var rr = jsonDecode(correction);
                          listcorrection = widget.modueleQuiz;
                          /*for (int i = 0; i < rr.length; i++) {
                          listcorrection.add(CocheTotal.fromJson(rr[i]));
                        }*/

                          voir = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  voir == true
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height - 336,
                          child: ListView.builder(
                            itemCount: listcorrection!.corps!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${index + 1} . ${listcorrection!.corps![index].question.toString()}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 200,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: ListView.builder(
                                        itemCount: listcorrection!
                                            .corps![index].responses!.length,
                                        itemBuilder: (context, inde) {
                                          return Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(25)),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: listcorrection!
                                                              .corps![index]
                                                              .correct_answer!
                                                              .contains(
                                                                  listcorrection!
                                                                      .corps![
                                                                          index]
                                                                      .responses![
                                                                          inde]
                                                                      .reponsee)
                                                          ? Colors.green
                                                          : listcorrection!
                                                                      .corps![
                                                                          index]
                                                                      .responses![
                                                                          inde]
                                                                      .coche ==
                                                                  true
                                                              ? Colors.red
                                                              : Colors.grey),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      flex: 7,
                                                      child: Text(
                                                          "${inde + 1}. ${listcorrection!.corps![index].responses![inde].reponsee!} "),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: listcorrection!
                                                              .corps![index]
                                                              .correct_answer!
                                                              .contains(
                                                                  listcorrection!
                                                                      .corps![
                                                                          index]
                                                                      .responses![
                                                                          inde]
                                                                      .reponsee)
                                                          ? Container(
                                                              width: 20,
                                                              child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .check_circle,
                                                                      color: Colors
                                                                              .green[
                                                                          700],
                                                                    ),
                                                                    listcorrection!.corps![index].responses![inde].coche ==
                                                                            true
                                                                        ? Icon(
                                                                            Icons.touch_app,
                                                                            color:
                                                                                Colors.green[700],
                                                                          )
                                                                        : Container()
                                                                  ]),
                                                            )
                                                          : listcorrection!
                                                                      .corps![
                                                                          index]
                                                                      .responses![
                                                                          inde]
                                                                      .coche ==
                                                                  true
                                                              ? Container(
                                                                  width: 20,
                                                                  child: Row(
                                                                    children: const [
                                                                      Icon(
                                                                        Icons
                                                                            .close_outlined,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .touch_app,
                                                                        color: Colors
                                                                            .red,
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container(
                                                                  width: 20,
                                                                  child: Row(
                                                                    children: [
                                                                      const Icon(
                                                                          Icons
                                                                              .close_outlined,
                                                                          color:
                                                                              Colors.red),
                                                                      Container()
                                                                    ],
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
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : Container()
                  // const Spacer(flex: 3),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

const kprimryColor = LinearGradient(
    colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight);
