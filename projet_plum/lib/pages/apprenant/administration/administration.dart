import 'package:flutter/material.dart';
import 'package:projet_plum/pages/apprenant/administration/demande.dart';
import 'package:projet_plum/pages/apprenant/administration/remarques.dart';
import 'package:projet_plum/pages/apprenant/administration/rendezvous.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

class Administration extends StatefulWidget {
  const Administration({
    Key? key,
  }) : super(key: key);

  @override
  State<Administration> createState() => AdministrationState();
}

class AdministrationState extends State<Administration> {
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

  Widget horizontalView(double height, double width, context) {
    return AppLayout(
        content: Container(
      padding: EdgeInsets.all(50),
      height: height,
      width: width,
      color: Palette.backgroundColor,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
              alignment: Alignment.centerLeft,
              height: 70,
              child: Text('Bonjour Mr')),
          const SizedBox(
            height: 50,
          ),
          Container(
              //color: Colors.white,
              height: 300,
              width: width - 50,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/rdv.png',
                              height: 150,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('Prendre un rendez vous'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RendezVous()));
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Expanded(
                      child: InkWell(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/doc_.png',
                            height: 150,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text('Demander un document'),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Demande()));
                    },
                  )),
                  const SizedBox(
                    width: 50,
                  ),
                  Expanded(
                      child: InkWell(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/enfant.png',
                            height: 150,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text('Voir les remarques sur son enfant'),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Remarques()));
                    },
                  )),
                ],
              )),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    ));
  }

  Widget verticalView(double height, double width, context) {
    return AppLayout(content: Container());
  }
}
