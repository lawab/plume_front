import 'package:flutter/material.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:url_launcher/url_launcher.dart';

class Banne extends StatefulWidget {
  const Banne({Key? key}) : super(key: key);
  @override
  BanneState createState() => BanneState();
}

class BanneState extends State<Banne> {
  @override
  Widget build(BuildContext context) {
    return Container(
      /*decoration: BoxDecoration(
        color: Styles.defaultYellowColor,
        borderRadius: Styles.defaultBorderRadius,
      ),
      padding: EdgeInsets.symmetric(horizontal: Styles.defaultPadding),*/
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          const Expanded(
            flex: 5,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                ScrollLoopAutoScroll(
                  scrollDirection: Axis.horizontal,
                  duration: Duration(seconds: 120),
                  child: Text(
                    "Bienvenue sur votre plateforme de l'école MCF Junior!!                   ",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Image.asset("Mcf_Junior.png"),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                height: 50,
                width: 50,
                child: IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    laucheURL();
                    /*Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Actualite()));*/
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  laucheURL() async {
    final url = Uri.parse('https://mcfjunior.ma');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch';
    }
  }
}
