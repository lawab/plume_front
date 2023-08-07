import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:projet_plum/pages/apprenant/quiz/score.dart';
import 'package:projet_plum/pages/devoir/creationDevoir.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResponsiveScore extends ConsumerStatefulWidget {
  final QuizTotal module;

  const ResponsiveScore({Key? key, required this.module}) : super(key: key);

  @override
  ResponsiveScoreTraining createState() => ResponsiveScoreTraining();
}

class ResponsiveScoreTraining extends ConsumerState<ResponsiveScore> {
  /*Future ad() async {
    timer = Timer(const Duration(seconds: 1), ad);
    return ref.refresh(getFormaallstagaireFuturApi);
  }*/

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          print(constraints.maxWidth);
          print(constraints.maxHeight);
          if (constraints.maxWidth <= 400 && constraints.maxHeight <= 1000) {
            print('Mobile Formation');
            return ScoreModule(
              modueleQuiz: widget.module,
            );
          } else {
            print('Web');
            return Score(
              modueleQuiz: widget.module,
            );
          }
        },
      ),
    );
  }
}

const double kDefaultPadding = 20.0;

class ScoreModule extends StatefulWidget {
  final QuizTotal modueleQuiz;
  const ScoreModule({Key? key, required this.modueleQuiz}) : super(key: key);
  @override
  ScoreModuleState createState() => ScoreModuleState();
}

class ScoreModuleState extends State<ScoreModule> {
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 52, 11, 235),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 52, 11, 235),
        extendBodyBehindAppBar: true,
        /*appBar: AppBar(
            backgroundColor: Color.fromARGB(0, 241, 240, 243),
            elevation: 0,
            actions: [
              TextButton(
                onPressed: () {
                  //Get.to(FormationContenuAll());
                  Get.to(ResponsiveContenu());
                },
                child: Text(
                  "Quitter",
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(color: Colors.black),
                ),
              )
            ]),*/
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
                /*Container(
                  height: 50,
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),*/
                Container(
                    width: MediaQuery.of(context).size.width - 10,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    height: 100,
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
                      style: TextStyle(color: Colors.white),
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
                        width: MediaQuery.of(context).size.width - 10,
                        height: MediaQuery.of(context).size.height - 320,
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
                                  width: MediaQuery.of(context).size.width - 15,
                                  child: ListView.builder(
                                      itemCount: listcorrection!
                                          .corps![index].responses!.length,
                                      itemBuilder: (context, inde) {
                                        return Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  15,
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
                                                                  listcorrection!
                                                                              .corps![index]
                                                                              .responses![inde]
                                                                              .coche ==
                                                                          true
                                                                      ? Icon(
                                                                          Icons
                                                                              .touch_app,
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
                                                                        color: Colors
                                                                            .red),
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
    );
  }
}

const kprimryColor = LinearGradient(
    colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight);
