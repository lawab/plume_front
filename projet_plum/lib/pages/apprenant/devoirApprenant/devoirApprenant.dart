import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:projet_plum/pages/apprenant/devoirApprenant/devoirApprenantdetails.dart';
import 'package:projet_plum/pages/services/getCourss.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

class DevoiApprenant extends ConsumerStatefulWidget {
  const DevoiApprenant({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<DevoiApprenant> createState() => DevoiApprenantState();
}

class DevoiApprenantState extends ConsumerState<DevoiApprenant> {
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
    final viewModel = ref.watch(getDataCoursByAppFuture);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(
                height(context), width(context), context, viewModel.listDevoir);
          } else {
            return verticalView(
                height(context), width(context), context, viewModel.listDevoir);
          }
        },
      ),
    );
  }

  Widget horizontalView(
      double height, double width, context, List<Homework> listDevoir) {
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
            child: Row(children: const [
              Icon(
                Icons.document_scanner,
                size: 40,
              ),
              Text(
                'Devoir de maison',
                style: TextStyle(
                    color: Palette.violetColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )
            ]),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Legende :',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  child: Row(children: [
                    Text('Devoir à rendre dans moins de 2 jours   '),
                    Container(
                      height: 15,
                      width: 15,
                      color: Colors.red,
                    )
                  ]),
                ),
                const SizedBox(
                  height: 2,
                ),
                Container(
                  child: Row(children: [
                    Text('Devoir à rendre dans moins de 3 jours   '),
                    Container(
                      height: 15,
                      width: 15,
                      color: Colors.amber,
                    )
                  ]),
                ),
                const SizedBox(
                  height: 2,
                ),
                Container(
                  child: Row(children: [
                    Text('Devoir à rendre dans plus de 3 jours       '),
                    Container(
                      height: 15,
                      width: 15,
                      color: Colors.green,
                    )
                  ]),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            //color: Colors.white,
            height: height - 430,
            width: width - 50,
            child: listDevoir.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun devoir de maison',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 50,
                            mainAxisExtent: 100),
                    itemCount: listDevoir.length,
                    itemBuilder: (context, index) {
                      DateTime aa =
                          DateTime.parse(listDevoir[index].limitDate!);
                      DateTime bb = DateTime.now();

                      aa = DateTime(aa.year, aa.month, aa.day);
                      bb = DateTime(bb.year, bb.month, bb.day);
                      print('jour');
                      print((bb.difference(aa).inHours / 24).round());
                      int jour = (aa.difference(bb).inHours / 24).round();
                      return InkWell(
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                    height: 100,
                                    color: jour > 3
                                        ? const Color.fromARGB(255, 15, 68, 16)
                                        : jour < 3 && jour >= 2
                                            ? const Color.fromARGB(
                                                255, 143, 87, 4)
                                            : const Color.fromARGB(
                                                255, 146, 12, 2),
                                    child: Image.asset('assets/devoir.png')),
                              ),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  color: jour > 3
                                      ? Colors.green
                                      : jour < 3 && jour >= 2
                                          ? Colors.orange
                                          : Colors.red,
                                  child: Column(
                                    children: [
                                      Text(
                                        listDevoir[index].title!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(
                                        height: 5,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        listDevoir[index].description!,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${aa.day}-${aa.month}-${aa.year}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DevoiDetails(
                                        devoir: listDevoir[index],
                                      )));
                        },
                      );
                    }),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    ));
  }

  Widget verticalView(
      double height, double width, context, List<Homework> listDevoir) {
    return AppLayout(content: Container());
  }
}
