import 'package:flutter/material.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

class Accueil extends StatefulWidget {
  const Accueil({
    Key? key,
  }) : super(key: key);

  @override
  State<Accueil> createState() => AccueilState();
}

class AccueilState extends State<Accueil> {
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
        padding: EdgeInsets.all(20),
        color: Palette.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenue',
              style: TextStyle(
                  color: Palette.violetColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Heureux de vous revoir parmis nous pour une journée',
              style: TextStyle(
                color: Color.fromARGB(255, 139, 138, 138),
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Text(
              'Précedement',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: ((context, index) {
                  return Card(
                    elevation: 10,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(5)),
                      width: 100,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.history,
                            size: 30,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text('Devoir')
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 200,
              child: const ListTile(
                title: Text(
                  'Devoir',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                trailing: Icon(
                  Icons.turn_right,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    return AppLayout(
      content: Container(),
    );
  }
}
