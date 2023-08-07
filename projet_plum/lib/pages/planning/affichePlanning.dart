import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

class PlanningAffiche extends ConsumerStatefulWidget {
  const PlanningAffiche({Key? key}) : super(key: key);

  @override
  ConsumerState<PlanningAffiche> createState() => PlanningAfficheState();
}

class PlanningAfficheState extends ConsumerState<PlanningAffiche> {
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

  bool annuel = false;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataClasseFuture);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(
                height(context), width(context), context, viewModel.listClasse);
          } else {
            return verticalView(
                height(context), width(context), context, viewModel.listClasse);
          }
        },
      ),
    );
  }

  Widget horizontalView(
    double height,
    double width,
    contextt,
    List<Classe> listClasses,
  ) {
    return AppLayout(
        content: Container(
      color: Palette.backgroundColor,
      child: Column(children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          height: height - 110,
          child: ListView.builder(
              itemCount: 5, //listClasses.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        height: 70,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 100,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  'Classe $index',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: (Size(100, 60)),
                                  backgroundColor: Palette.violetColor),
                              label: annuel == false
                                  ? Text('Voir le planning annuel')
                                  : Text("Voir l'emploie de temps"),
                              icon: Icon(Icons.add),
                              onPressed: () async {
                                setState(() {
                                  annuel = !annuel;
                                });
                              },
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      annuel == false
                          ? Container(
                              //color: Colors.white,
                              height: height - 190,
                              width: width - 50,
                              child: Image.asset(
                                'assets/planning.jpg',
                              ),
                            )
                          : Container(
                              //color: Colors.white,
                              height: height - 190,
                              width: width - 50,
                              child: Image.asset(
                                'assets/annuel.png',
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                  /*Column(
                    children: [
                      Container(
                        child: Text(listClasses[index].title!),
                      ),
                      Container(
                        height: height / 2,
                        child: listClasses[index].planning != null
                            ? Image.network(
                                'http://13.39.81.126:7003${listClasses[index].planning}')
                            : Center(
                                child: Text('vide'),
                              ),
                      )
                    ],
                  ),*/
                );
              }),
        )
      ]),
    ));
  }

  Widget verticalView(
    double height,
    double width,
    contextt,
    List<Classe> listClasses,
  ) {
    return AppLayout(content: Container());
  }
}
