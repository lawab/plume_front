import 'package:flutter/material.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

class PlanningTeacher extends StatefulWidget {
  final Classe classe;
  const PlanningTeacher({Key? key, required this.classe}) : super(key: key);

  @override
  State<PlanningTeacher> createState() => PlanningTeacherState();
}

class PlanningTeacherState extends State<PlanningTeacher> {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context);
          } else {
            return verticalView(height(context), width(context), context);
          }
        },
      ),
    );
  }

  Widget horizontalView(double height, double width, contextt) {
    return AppLayout(
      content: Container(
        height: height,
        width: width,
        color: Palette.backgroundColor,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              height: 70,
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.backspace)),
                  Spacer(),
                  annuel == false
                      ? Text('${widget.classe.title!} - Emploie de temps')
                      : Text('${widget.classe.title!} - Planning annuel'),
                  Spacer(),
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
                ],
              ),
            ),
            annuel == false
                ? Container(
                    //color: Colors.white,
                    height: height - 190,
                    width: width - 50,
                    child: widget.classe.timeTable == null
                        ? const Center(
                            child: Text("PAS D'EMPLOIE DE TEMPS"),
                          )
                        : Image.network(
                            'http://13.39.81.126:7003${widget.classe.timeTable!}'),
                  )
                : Container(
                    //color: Colors.white,
                    height: height - 190,
                    width: width - 50,
                    child: widget.classe.planning == null
                        ? const Center(
                            child: Text("PAS DE PLANNING ANNUEL"),
                          )
                        : Image.network(
                            'http://13.39.81.126:7003${widget.classe.planning!}',
                          ),
                  ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    return AppLayout(content: Container());
  }
}
