import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projet_plum/pages/apprenant/quiz/responsiveAfficheQuiz.dart';
import 'package:projet_plum/pages/devoir/creationDevoir.dart';
import 'package:projet_plum/utils/palette.dart';

class WelcomeQuiz extends StatelessWidget {
  final QuizTotal module;
  WelcomeQuiz({
    Key? key,
    required this.module,
  }) : super(key: key);
  var nomcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //QuestionController.print_data();
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      //Color.fromARGB(255, 153, 201, 240),
      body: Container(
        /*constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/arrierplanquiz.jpg"),
                fit: BoxFit.cover)),*/
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Blog.png"), fit: BoxFit.fill),
              ),
            ),
            const Text(
              "Commencer le Quiz",
              style: TextStyle(
                color: Palette.violetColor,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Entrer votre nom",
              style: TextStyle(
                color: Palette.violetColor,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: nomcontroller,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 167, 173, 197),
                  hintText: "nom",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: (() {
                if (module == null) {
                  print('module est null');
                } else {
                  Get.to(ResponsiveAfficheQuiz(
                    module: module,
                  )
                      /*AllAffoicheQuizPage(
                          module: module,
                        )*/
                      );
                }
              }),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20.0 * 0.75),
                //kDefaultPadding
                decoration: const BoxDecoration(
                  gradient: kprimryColor,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Text(
                  "Commencer",
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        /*Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            //backgroundImage.asset("assets/quiz.jpg", fit: BoxFit.cover),
            SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(flex: 2),
                  
                  const Spacer(flex: 2),
                ],
              ),
            ))
          ],
        ),
      ),*/
      ),
    );
  }
}

const kprimryColor = LinearGradient(
    colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight);
