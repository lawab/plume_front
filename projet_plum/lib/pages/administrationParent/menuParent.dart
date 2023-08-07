import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/administrationParent/documentParent.dart';
import 'package:projet_plum/pages/administrationParent/rdvParent.dart';
import 'package:projet_plum/pages/services/getDocument.dart';
import 'package:projet_plum/pages/services/getRDV.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

class MenuParent extends ConsumerStatefulWidget {
  const MenuParent({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MenuParent> createState() => MenuParentState();
}

class MenuParentState extends ConsumerState<MenuParent> {
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
    final viewModel = ref.watch(getDataRDVFuture);
    final viewModele = ref.watch(getDataDocumentFuture);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listAppointment, viewModele.listDocument);
          } else {
            return verticalView(height(context), width(context), context);
          }
        },
      ),
    );
  }

  Widget horizontalView(double height, double width, context,
      List<Appointment> listAppointment, List<Document> listDocument) {
    return AppLayout(
      content: Container(
        height: height,
        padding: EdgeInsets.all(40),
        color: Palette.backgroundColor,
        child: Container(
          height: 100,
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      InkWell(
                        child: Container(
                          height: 100,
                          color: Palette.violetColor,
                          child: const Center(
                            child: Text(
                              "Confirmation de demande rendez-vous",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => RdvParent(
                                listAppointment: listAppointment,
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        left: 2,
                        top: 2,
                        child: Container(
                          height: 50,
                          width: 100,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 10,
                            child: Text(listAppointment.length.toString()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      InkWell(
                        child: Container(
                          height: 100,
                          color: Palette.violetColor,
                          child: const Center(
                            child: Text(
                              "Confirmation de demande d'un document",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => DocumentParent(
                                listDocument: listDocument,
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        left: 2,
                        top: 2,
                        child: Container(
                          height: 50,
                          width: 100,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 10,
                            child: Text(listDocument.length.toString()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget verticalView(
    double height,
    double width,
    context,
  ) {
    return AppLayout(
      content: Container(
        height: height,
        padding: EdgeInsets.all(40),
        color: Palette.backgroundColor,
        child: Container(
          height: 100,
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Palette.violetColor,
                    child: Center(
                      child: Text("Validation d'écart de comportement"),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    color: Palette.violetColor,
                    child: Center(
                      child: Text('Validation de rapport'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
