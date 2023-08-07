import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/gestionEleveAdmin/ecartAdmin.dart';
import 'package:projet_plum/pages/services/getBehavior.dart';
import 'package:projet_plum/pages/services/getUser.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/palette.dart';

class EcartGenerale extends ConsumerStatefulWidget {
  const EcartGenerale({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<EcartGenerale> createState() => EcartGeneraleState();
}

class EcartGeneraleState extends ConsumerState<EcartGenerale> {
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

  var nomcontroller = TextEditingController();
  var descriptioncontroller = TextEditingController();

  bool tablette = false;
  bool modif = false;
  bool ajout = false;
  bool search = false;
  List<User> eleveAssign = [];
  List<User> eleveSearch = [];

  String id = '';
  void filterSearchResults(String query, List<User> eleveAssign) {
    List<User> dummySearchList = [];

    dummySearchList.addAll(eleveAssign);
    if (query.isNotEmpty) {
      List<User> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.firstName!.contains(query) || item.lastName!.contains(query)) {
          dummyListData.add(item);
          //print(dummyListData);
        }
      }
      setState(() {
        search = true;
        eleveSearch.clear();
        eleveSearch.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        search = false;
      });
    }
  }

  bool check = false;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataUserFuture);
    final viewModele = ref.watch(getDataBehaviorFuture);
    if (check == false) {
      for (int i = 0; i < viewModel.listStudent.length; i++) {
        if (viewModel.listStudent[i].behav == true) {
          for (int j = 0; j < viewModele.listBehavior.length; j++) {
            if (viewModel.listStudent[i].behavior!
                .contains(viewModele.listBehavior[j].sId)) {
              if (viewModele.listBehavior[j].validated == false) {
                eleveAssign.add(viewModel.listStudent[i]);
                check = true;
              }
            }
          }
        }
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(
                height(context), width(context), context, eleveAssign);
          } else {
            return verticalView(height(context), width(context), context);
          }
        },
      ),
    );
  }

  Widget horizontalView(
      double height, double width, contextt, List<User> listStudent) {
    return AppLayout(
      content: Container(
        height: height,
        padding: EdgeInsets.all(40),
        color: Palette.backgroundColor,
        child: Column(
          children: [
            Container(
              child: Row(children: [
                Container(
                  width: 30,
                  child: IconButton(
                    icon: Icon(Icons.backspace),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(child: Container()),
                const Text(
                  'Ecart de comportement',
                  style: TextStyle(
                      fontFamily: 'Bevan',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(child: Container())
              ]),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Container(
                width: 350,
                child: TextField(
                  // onChanged: (value) => onSearch(value.toLowerCase()),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  onChanged: (value) {
                    filterSearchResults(value, listStudent);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(0),
                    prefixIcon:
                        const Icon(Icons.search, color: Palette.violetColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                    hintText: "Recherche",
                  ),
                ),
              ),
            ),
            Container(
              height: height - 268,
              padding: const EdgeInsets.all(40),
              child: search == false
                  ? listStudent.isEmpty
                      ? const Center(
                          child: Text(
                            'Aucun élève',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 250,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 50,
                                  mainAxisExtent: 100),
                          itemCount: listStudent.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              color: Colors.white,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                height: 50,
                                child: Row(
                                  children: [
                                    Text(listStudent[index].firstName!),
                                    const Spacer(),
                                    CircleAvatar(
                                      maxRadius: 20,
                                      backgroundColor: Colors.black,
                                      child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EcartAdmin(
                                                          eleve: listStudent[
                                                              index],
                                                          modif: true,
                                                        )));
                                          },
                                          icon: const Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.white,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            );
                          })
                  : eleveSearch.isEmpty
                      ? const Center(
                          child: Text(
                            'Aucun élève trouvé',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 250,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 50,
                                  mainAxisExtent: 100),
                          itemCount: eleveSearch.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              color: Colors.white,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                height: 50,
                                child: Row(
                                  children: [
                                    Text(eleveSearch[index].firstName!),
                                    const Spacer(),
                                    CircleAvatar(
                                      maxRadius: 20,
                                      backgroundColor: Colors.black,
                                      child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EcartAdmin(
                                                          eleve: eleveSearch[
                                                              index],
                                                          modif: true,
                                                        )));
                                          },
                                          icon: const Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.white,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
            ),
          ],
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
    ));
  }
}
