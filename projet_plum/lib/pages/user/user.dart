import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';
import 'package:projet_plum/pages/services/getUser.dart';
import 'package:projet_plum/pages/services/getUserOne.dart';
import 'package:projet_plum/pages/user/parentAssigne.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum SingingCharacter { homme, femme }

enum SampleItem { itemOne, itemTwo, itemThree }

class Users extends ConsumerStatefulWidget {
  const Users({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<Users> createState() => UserState();
}

class UserState extends ConsumerState<Users> {
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

  SampleItem? selectedMenu;
  var nomcontroller = TextEditingController(text: 'Archad');
  var prenomcontroller = TextEditingController(text: 'Archad');
  var emailcontroller = TextEditingController(text: 'archad@gmail.com');
  var passwordcontroller = TextEditingController(text: 'eeee');
  var password2controller = TextEditingController(text: 'eeee');
  void modification(nom, prenom, email, role, imagee, idd, genre) {
    print(genre);
    setState(() {
      nomcontroller.text = nom;
      prenomcontroller.text = prenom;
      emailcontroller.text = email;
      _role = listOfRole[1];
      image = imagee;
      id = idd;
      genre == true
          ? _character = SingingCharacter.homme
          : _character = SingingCharacter.femme;
      ajout = true;
      modif = true;
    });
  }

  SingingCharacter? _character = SingingCharacter.homme;
  bool modif = false;

  List<String> listOfRole = [
    "Role *",
    "ADMIN",
    "TEACHER",
    "PARENT",
    "STUDENT",
  ];
  String? _role;
  bool _selectFile = false;
  List<int> _selectedFile = [];
  FilePickerResult? result;
  PlatformFile? file;
  Uint8List? selectedImageInBytes;
  bool ajout = false;
  bool search = false;
  List<User> UserSearch = [];
  String image = '';
  String id = '';
  void filterSearchResults(String query) {
    final viewModel = ref.watch(getDataUserFuture);
    List<User> dummySearchList = [];
    dummySearchList.addAll(viewModel.listAllUsers);
    if (query.isNotEmpty) {
      List<User> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.lastName!.contains(query) ||
            item.firstName!.contains(query) ||
            item.email!.contains(query)) {
          dummyListData.add(item);
          //print(dummyListData);
        }
      }
      setState(() {
        search = true;
        UserSearch.clear();
        UserSearch.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        search = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataUserFuture);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listAllUsers);
          } else {
            return verticalView(height(context), width(context), context,
                viewModel.listAllUsers);
          }
        },
      ),
    );
  }

  Widget horizontalView(
      double height, double width, context, List<User> listUsers) {
    return AppLayout(
        content: ajout == true
            ? Container(
                height: MediaQuery.of(context).size.height,
                padding:
                    EdgeInsets.only(right: 40, left: 40, bottom: 5, top: 5),
                color: Palette.backgroundColor,
                child: creation(image, id),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(40),
                color: Palette.backgroundColor,
                child: Column(
                  children: [
                    Container(
                      child: Row(children: const [
                        Icon(
                          Icons.person,
                          size: 40,
                        ),
                        Text(
                          'Utilisateurs',
                          style: TextStyle(
                              color: Palette.violetColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        )
                      ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 100,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Text('Tout'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Text('Administration'),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 350,
                            child: TextField(
                              // onChanged: (value) => onSearch(value.toLowerCase()),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              onChanged: (value) {
                                filterSearchResults(value);
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(0),
                                prefixIcon: const Icon(Icons.search,
                                    color: Palette.violetColor),
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
                          Spacer(),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                minimumSize: (Size(100, 60)),
                                backgroundColor: Palette.violetColor),
                            label: Text('Ajouter'),
                            icon: Icon(Icons.add),
                            onPressed: () async {
                              setState(() {
                                ajout = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    search == false
                        ? Container(
                            height: MediaQuery.of(context).size.height - 360,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 300,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 50,
                                      mainAxisExtent: 100),
                              itemCount: listUsers.length,
                              itemBuilder: ((context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      /* Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    'http://13.39.81.126:7001${listUsers[index].image}'),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Palette.barColor),
                                        height: 50,
                                        width: 50,
                                        child: Text(index.toString()),
                                      ),*/
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor:
                                            Palette.backgroundColor,
                                        child: ImageNetwork(
                                          image:
                                              'http://13.39.81.126:7001${listUsers[index].image}',
                                          /* imageCache:
                                                CachedNetworkImageProvider(
                                                    imageUrl),*/
                                          height: 50,
                                          width: 50,
                                          duration: 1500,
                                          curve: Curves.easeIn,
                                          onPointer: true,
                                          debugPrint: false,
                                          fullScreen: false,
                                          fitAndroidIos: BoxFit.cover,
                                          fitWeb: BoxFitWeb.cover,
                                          borderRadius:
                                              BorderRadius.circular(70),
                                          onLoading:
                                              const CircularProgressIndicator(
                                            color: Colors.indigoAccent,
                                          ),
                                          onError: const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                height: 50,
                                                child: Row(children: [
                                                  Text(listUsers[index]
                                                      .firstName!),
                                                  Spacer(),
                                                  more(
                                                      listUsers[index].sId!,
                                                      listUsers[index]
                                                          .lastName!,
                                                      listUsers[index]
                                                          .firstName!,
                                                      listUsers[index].email!,
                                                      listUsers[index].role!,
                                                      listUsers[index].image!,
                                                      listUsers[index],
                                                      listUsers[index].gender!),
                                                ]),
                                              ),
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    right: 30, left: 30),
                                                child: Row(children: [
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: Palette.barColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Text(
                                                        listUsers[index].role!),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: Palette.barColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: listUsers[index]
                                                                .gender ==
                                                            true
                                                        ? const Icon(Icons.male)
                                                        : const Icon(
                                                            Icons.female),
                                                  ),
                                                  Spacer(),
                                                  GestureDetector(
                                                    child: Text('Détails'),
                                                    onTap: () {
                                                      dialogDetails(
                                                          listUsers[index]
                                                              .lastName!,
                                                          listUsers[index]
                                                              .firstName!,
                                                          listUsers[index]
                                                              .email!,
                                                          listUsers[index]
                                                              .role!);
                                                    },
                                                  )
                                                ]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height - 360,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 300,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 50,
                                      mainAxisExtent: 100),
                              itemCount: UserSearch.length,
                              itemBuilder: ((context, indexx) {
                                print(
                                    'http://13.39.81.126:7001${UserSearch[indexx].image}');
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor:
                                            Palette.backgroundColor,
                                        child: ImageNetwork(
                                          image:
                                              'http://13.39.81.126:7001${UserSearch[indexx].image}',
                                          height: 50,
                                          width: 50,
                                          duration: 1500,
                                          curve: Curves.easeIn,
                                          onPointer: false,
                                          debugPrint: false,
                                          fullScreen: false,
                                          fitAndroidIos: BoxFit.cover,
                                          fitWeb: BoxFitWeb.cover,
                                          borderRadius:
                                              BorderRadius.circular(70),
                                          onLoading:
                                              const CircularProgressIndicator(
                                            color: Colors.indigoAccent,
                                          ),
                                          onError: const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                height: 50,
                                                child: Row(children: [
                                                  Text(UserSearch[indexx]
                                                      .firstName!),
                                                  Spacer(),
                                                  more(
                                                      UserSearch[indexx].sId!,
                                                      UserSearch[indexx]
                                                          .lastName!,
                                                      UserSearch[indexx]
                                                          .firstName!,
                                                      UserSearch[indexx].email!,
                                                      UserSearch[indexx].role!,
                                                      UserSearch[indexx].image!,
                                                      UserSearch[indexx],
                                                      UserSearch[indexx]
                                                          .gender!),
                                                ]),
                                              ),
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    right: 30, left: 30),
                                                child: Row(children: [
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: Palette.barColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Text(
                                                        UserSearch[indexx]
                                                            .role!),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: Palette.barColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: UserSearch[indexx]
                                                                .gender ==
                                                            true
                                                        ? const Icon(Icons.male)
                                                        : const Icon(
                                                            Icons.female),
                                                  ),
                                                  Spacer(),
                                                  GestureDetector(
                                                    child: Text('Détails'),
                                                    onTap: () {
                                                      dialogDetails(
                                                          UserSearch[indexx]
                                                              .lastName!,
                                                          UserSearch[indexx]
                                                              .firstName!,
                                                          UserSearch[indexx]
                                                              .email!,
                                                          UserSearch[indexx]
                                                              .role!);
                                                    },
                                                  )
                                                ]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                  ],
                ),
              ));
  }

  Widget verticalView(
      double height, double width, context, List<User> listUsers) {
    return AppLayout(
        content: ajout == true
            ? Container(
                height: MediaQuery.of(context).size.height,
                padding:
                    EdgeInsets.only(right: 40, left: 40, bottom: 5, top: 5),
                color: Palette.backgroundColor,
                child: creation(image, id),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(10),
                color: Palette.backgroundColor,
                child: Column(
                  children: [
                    Container(
                      child: Row(children: const [
                        Icon(
                          Icons.person,
                          size: 30,
                        ),
                        Text(
                          'Utilisateurs',
                          style: TextStyle(
                              color: Palette.violetColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )
                      ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 100,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Text(
                              'Tout',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Text(
                              'Administration',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 180,
                            child: TextField(
                              // onChanged: (value) => onSearch(value.toLowerCase()),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              onChanged: (value) {
                                filterSearchResults(value);
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(0),
                                prefixIcon: const Icon(Icons.search,
                                    color: Palette.violetColor),
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
                          Spacer(),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                minimumSize: (Size(100, 60)),
                                backgroundColor: Palette.violetColor),
                            label: Text('Ajouter'),
                            icon: Icon(Icons.add),
                            onPressed: () async {
                              setState(() {
                                ajout = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    search == false
                        ? Container(
                            height: MediaQuery.of(context).size.height - 370,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 280,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 50,
                                      mainAxisExtent: 100),
                              itemCount: listUsers.length,
                              itemBuilder: ((context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor:
                                            Palette.backgroundColor,
                                        child: ImageNetwork(
                                          image:
                                              'http://13.39.81.126:7001${listUsers[index].image}',
                                          /* imageCache:
                                                CachedNetworkImageProvider(
                                                    imageUrl),*/
                                          height: 50,
                                          width: 50,
                                          duration: 1500,
                                          curve: Curves.easeIn,
                                          onPointer: true,
                                          debugPrint: false,
                                          fullScreen: false,
                                          fitAndroidIos: BoxFit.cover,
                                          fitWeb: BoxFitWeb.cover,
                                          borderRadius:
                                              BorderRadius.circular(70),
                                          onLoading:
                                              const CircularProgressIndicator(
                                            color: Colors.indigoAccent,
                                          ),
                                          onError: const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                height: 50,
                                                child: Row(children: [
                                                  Text(listUsers[index]
                                                      .firstName!),
                                                  Spacer(),
                                                  more(
                                                      listUsers[index].sId!,
                                                      listUsers[index]
                                                          .lastName!,
                                                      listUsers[index]
                                                          .firstName!,
                                                      listUsers[index].email!,
                                                      listUsers[index].role!,
                                                      listUsers[index].image!,
                                                      listUsers[index],
                                                      listUsers[index].gender!),
                                                ]),
                                              ),
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    right: 25, left: 25),
                                                child: Row(children: [
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: Palette.barColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Text(
                                                      listUsers[index].role!,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: Palette.barColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: listUsers[index]
                                                                .gender ==
                                                            true
                                                        ? const Icon(Icons.male)
                                                        : const Icon(
                                                            Icons.female),
                                                  ),
                                                  Spacer(),
                                                  GestureDetector(
                                                    child: Text(
                                                      'Détails',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    onTap: () {
                                                      dialogDetails(
                                                          listUsers[index]
                                                              .lastName!,
                                                          listUsers[index]
                                                              .firstName!,
                                                          listUsers[index]
                                                              .email!,
                                                          listUsers[index]
                                                              .role!);
                                                    },
                                                  )
                                                ]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height - 360,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 280,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 50,
                                      mainAxisExtent: 100),
                              itemCount: UserSearch.length,
                              itemBuilder: ((context, indexx) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor:
                                            Palette.backgroundColor,
                                        child: ImageNetwork(
                                          image:
                                              'http://13.39.81.126:7001${UserSearch[indexx].image}',
                                          imageCache: CachedNetworkImageProvider(
                                              'http://13.39.81.126:7001${UserSearch[indexx].image}'),
                                          height: 50,
                                          width: 50,
                                          duration: 1500,
                                          curve: Curves.easeIn,
                                          onPointer: true,
                                          debugPrint: false,
                                          fullScreen: false,
                                          fitAndroidIos: BoxFit.cover,
                                          fitWeb: BoxFitWeb.cover,
                                          borderRadius:
                                              BorderRadius.circular(70),
                                          onLoading:
                                              const CircularProgressIndicator(
                                            color: Colors.indigoAccent,
                                          ),
                                          onError: const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                height: 50,
                                                child: Row(children: [
                                                  Text(UserSearch[indexx]
                                                      .firstName!),
                                                  Spacer(),
                                                  more(
                                                      UserSearch[indexx].sId!,
                                                      UserSearch[indexx]
                                                          .lastName!,
                                                      UserSearch[indexx]
                                                          .firstName!,
                                                      UserSearch[indexx].email!,
                                                      UserSearch[indexx].role!,
                                                      UserSearch[indexx].image!,
                                                      UserSearch[indexx],
                                                      UserSearch[indexx]
                                                          .gender!),
                                                ]),
                                              ),
                                              Container(
                                                height: 50,
                                                padding: EdgeInsets.only(
                                                    right: 30, left: 30),
                                                child: Row(children: [
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: Palette.barColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Text(
                                                      UserSearch[indexx].role!,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: Palette.barColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: UserSearch[indexx]
                                                                .gender ==
                                                            true
                                                        ? const Icon(Icons.male)
                                                        : const Icon(
                                                            Icons.female),
                                                  ),
                                                  Spacer(),
                                                  GestureDetector(
                                                    child: Text(
                                                      'Détails',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    onTap: () {
                                                      dialogDetails(
                                                          UserSearch[indexx]
                                                              .lastName!,
                                                          UserSearch[indexx]
                                                              .firstName!,
                                                          UserSearch[indexx]
                                                              .email!,
                                                          UserSearch[indexx]
                                                              .role!);
                                                    },
                                                  )
                                                ]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                  ],
                ),
              ));
  }

  Widget creation(image, id) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Row(children: [
              const Icon(
                Icons.person,
                size: 40,
              ),
              const SizedBox(
                width: 10,
              ),
              modif == true
                  ? const Text(
                      "Modification d'utilisateurs",
                      style: TextStyle(
                          color: Palette.violetColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )
                  : const Text(
                      "Ajout d'utilisateurs",
                      style: TextStyle(
                          color: Palette.violetColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: TextFormField(
              controller: nomcontroller,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {},
              decoration: InputDecoration(
                  hoverColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.violetColor),
                    gapPadding: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.violetColor),
                    gapPadding: 10,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.violetColor),
                    gapPadding: 10,
                  ),
                  labelText: "Nom",
                  hintText: "Entrer le nom ",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(Icons.person)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: TextFormField(
              controller: prenomcontroller,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {},
              decoration: InputDecoration(
                  hoverColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.violetColor),
                    gapPadding: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.violetColor),
                    gapPadding: 10,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.violetColor),
                    gapPadding: 10,
                  ),
                  labelText: "Prenom",
                  hintText: "Entrer le prenom",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(Icons.person)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: TextFormField(
              controller: emailcontroller,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {},
              decoration: InputDecoration(
                  hoverColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.violetColor),
                    gapPadding: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.violetColor),
                    gapPadding: 10,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Palette.violetColor),
                    gapPadding: 10,
                  ),
                  labelText: "Email",
                  hintText: "Entrer l'email",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(Icons.email)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          modif == true
              ? Container()
              : SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    controller: passwordcontroller,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        hoverColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 42, vertical: 20),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Palette.violetColor),
                          gapPadding: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Palette.violetColor),
                          gapPadding: 10,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Palette.violetColor),
                          gapPadding: 10,
                        ),
                        labelText: "Mot de passe",
                        hintText: "*************",
                        // If  you are using latest version of flutter then lable text and hint text shown like this
                        // if you r using flutter less then 1.20.* then maybe this is not working properly
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: const Icon(Icons.key)),
                  ),
                ),
          modif == true
              ? Container()
              : const SizedBox(
                  height: 20,
                ),
          modif == true
              ? Container()
              : SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    controller: password2controller,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        hoverColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 42, vertical: 20),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Palette.violetColor),
                          gapPadding: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Palette.violetColor),
                          gapPadding: 10,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Palette.violetColor),
                          gapPadding: 10,
                        ),
                        labelText: "Confirmation",
                        hintText: "***********",
                        // If  you are using latest version of flutter then lable text and hint text shown like this
                        // if you r using flutter less then 1.20.* then maybe this is not working properly
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: const Icon(Icons.key)),
                  ),
                ),
          const SizedBox(
            height: 20,
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              hoverColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Palette.violetColor),
                gapPadding: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Palette.violetColor),
                gapPadding: 10,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Palette.violetColor),
                gapPadding: 10,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            value: _role,
            hint: const Text(
              'Rôle*',
            ),
            isExpanded: true,
            onChanged: (value) {
              setState(() {
                _role = value;
              });
            },
            onSaved: (value) {
              setState(() {
                _role = value;
              });
            },
            validator: (String? value) {
              if (value == null) {
                return "Le rôle de l'utilisateur est obligatoire.";
              } else {
                return null;
              }
            },
            items: listOfRole.map((String val) {
              return DropdownMenuItem(
                value: val,
                child: Text(
                  val,
                ),
              );
            }).toList(),
          ),
          Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: const Text('Masculin'),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.homme,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Feminin'),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.femme,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          modif == false
              ? Container(
                  padding: EdgeInsets.only(right: 70),
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async {
                      result = await FilePicker.platform
                          .pickFiles(type: FileType.custom, allowedExtensions: [
                        "png",
                        "jpg",
                        "jpeg",
                      ]);
                      if (result != null) {
                        setState(() {
                          file = result!.files.single;

                          Uint8List fileBytes =
                              result!.files.single.bytes as Uint8List;

                          _selectedFile = fileBytes;

                          selectedImageInBytes = result!.files.first.bytes;
                          _selectFile = true;
                        });
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 3,
                          color: Palette.violetColor,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _selectFile == false
                            ? const Icon(
                                Icons.camera_alt_outlined,
                                color: Palette.violetColor,
                                size: 40,
                              )
                            : Image.memory(
                                selectedImageInBytes!,
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    onTap: () async {
                      /////////////////////
                      result = await FilePicker.platform
                          .pickFiles(type: FileType.custom, allowedExtensions: [
                        "png",
                        "jpg",
                        "jpeg",
                      ]);
                      if (result != null) {
                        file = result!.files.single;

                        Uint8List fileBytes =
                            result!.files.single.bytes as Uint8List;
                        //print(base64Encode(fileBytes));
                        //List<int>
                        _selectedFile = fileBytes;
                        setState(() {
                          _selectFile = true;
                          selectedImageInBytes = result!.files.first.bytes;
                        });
                      } else {
                        setState(() {
                          _selectFile = false;
                        });
                      }
                      ////////////////////
                    },
                    //splashColor: Colors.brown.withOpacity(0.5),
                    child: _selectFile == true
                        ? Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Palette.violetColor,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.white,
                                image: DecorationImage(
                                  image: MemoryImage(
                                    selectedImageInBytes!,
                                    //fit: BoxFit.fill,
                                  ),
                                )),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Palette.violetColor,
                              size: 40,
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Palette.violetColor,
                              ),
                            ),
                            child: ImageNetwork(
                              image: 'http://13.39.81.126:7001$image',
                              height: 100,
                              width: 100,
                              duration: 1500,
                              curve: Curves.easeIn,
                              onPointer: true,
                              debugPrint: false,
                              fullScreen: false,
                              fitAndroidIos: BoxFit.cover,
                              fitWeb: BoxFitWeb.cover,
                              borderRadius: BorderRadius.circular(70),
                              onLoading: const CircularProgressIndicator(
                                color: Colors.indigoAccent,
                              ),
                              onError: const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ),
                          ),
                  ),
                ),
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Container(
              width: 370,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: Size(150, 60),
                          backgroundColor: Palette.violetColor),
                      child: const Text('Continuer'),
                      onPressed: () {
                        if (modif == false) {
                          if (password2controller != passwordcontroller) {
                            creationUser(
                                context,
                                _selectedFile,
                                result,
                                prenomcontroller.text,
                                nomcontroller.text,
                                emailcontroller.text,
                                _role,
                                passwordcontroller.text,
                                _character == SingingCharacter.femme
                                    ? false
                                    : true);
                          } else {
                            showTopSnackBar(
                              Overlay.of(context),
                              const CustomSnackBar.info(
                                backgroundColor: Colors.red,
                                message: "Veillez verifier vos mots de passe",
                              ),
                            );
                          }
                        } else {
                          modificationUser(
                              context,
                              _selectedFile,
                              result,
                              prenomcontroller.text,
                              nomcontroller.text,
                              emailcontroller.text,
                              _role,
                              id,
                              _character == SingingCharacter.femme
                                  ? false
                                  : true);
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: Size(150, 60),
                          backgroundColor: Colors.white),
                      child: Text(
                        'Annuler',
                        style: TextStyle(color: Palette.violetColor),
                      ),
                      onPressed: () {
                        setState(() {
                          ajout = false;
                          modif = false;
                          nomcontroller.clear();
                          prenomcontroller.clear();
                          emailcontroller.clear();
                          _role = listOfRole.first;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),

          /*Container(
          height: MediaQuery.of(context).size.height - 360,
          child: ,
        )*/
        ],
      ),
    );
  }

  Future dialogDetails(
    String nom,
    String prenom,
    String email,
    String role,
  ) {
    return showDialog(
        context: context,
        builder: (con) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Container(
              child: Row(children: [
                Expanded(child: Container()),
                const Text(
                  "Details",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'HelveticaNeue',
                  ),
                ),
                Expanded(child: Container()),
                IconButton(
                    onPressed: (() {
                      Navigator.pop(con);
                    }),
                    icon: Icon(Icons.close))
              ]),
            ),
            content: Container(
                alignment: Alignment.center,
                color: Colors.white,
                height: 150,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Nom: $nom'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Nom: $prenom'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Nom: $email'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Nom: $role'),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )),
          );
        });
  }

  Future dialogDelete(id, nom) {
    return showDialog(
        context: context,
        builder: (con) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                "Confirmez la suppression",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'HelveticaNeue',
                ),
              ),
            ),
            actions: [
              ElevatedButton.icon(
                  icon: const Icon(
                    Icons.close,
                    size: 14,
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  label: const Text("Quitter   ")),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.delete,
                  size: 14,
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  deleteUser(context, id);
                  Navigator.pop(con);
                },
                label: const Text("Supprimer."),
              ),
            ],
            content: Container(
              alignment: Alignment.center,
              color: Colors.white,
              height: 150,
              child: Text(
                "Voulez vous supprimer le user $nom ?",
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'HelveticaNeue',
                ),
              ),
            ),
          );
        });
  }

  Widget more(String id, String nom, String premnom, String email, String role,
      String image, User apprenant, bool genre) {
    return PopupMenuButton(
      tooltip: 'Menu',
      initialValue: selectedMenu,
      // Callback that sets the selected popup menu item.
      onSelected: (SampleItem item) async {
        setState(() {
          selectedMenu = item;
        });

        if (item == SampleItem.itemOne) {
          modification(nom, premnom, email, role, image, id, genre);
        } else if (item == SampleItem.itemTwo) {
          dialogDelete(id, nom);
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('idSudent', id);
          ref.refresh(getDataUserbyOneFuture);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ParentAssigne(
                        apprenant: apprenant,
                      )));
        }
      },
      child: const Icon(
        Icons.menu,
        size: 20,
        color: Colors.black,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        if (role == 'STUDENT')
          const PopupMenuItem<SampleItem>(
            value: SampleItem.itemThree,
            child: Text('Ajouter un parent'),
          ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          child: Text('Modifier'),
        ),
        const PopupMenuItem<SampleItem>(
            value: SampleItem.itemTwo, child: Text('Supprimer')),
      ],
    );
  }

//////////////////////////////////////////////////////////////////////////////////////////  SERVICES
  Future<void> creationUser(
      BuildContext context,
      List<int> selectedFile,
      FilePickerResult? result,
      firstName,
      lastName,
      email,
      role,
      password,
      genre) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    print(id);
    print(token);

    var url = Uri.parse("http://13.39.81.126:7001/api/users/create");
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    var json = {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "role": role,
      "password": password,
      "gender": genre,
      "creator": id
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    request.files.add(http.MultipartFile.fromBytes('file', selectedFile,
        contentType: MediaType('application', 'octet-stream'),
        filename: result!.files.first.name));

    print("RESPENSE SEND STEAM FILE REQ");

    var response = await request.send();
    print("Upload Response$response");
    print(response.statusCode);
    print(request.headers);
    print(request.fields);
    print(response.request);

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });

        setState(() {
          ajout = false;
          modif = false;
          nomcontroller.clear();
          prenomcontroller.clear();
          emailcontroller.clear();
          password2controller.clear();
          passwordcontroller.clear();
          _role = listOfRole.first;
          //result.files.clear();
          selectedFile = [];
        });
        // ignore: unused_result
        ref.refresh(getDataUserFuture);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Utilisateur créé avec succès",
          ),
        );
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de création",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> modificationUser(
      BuildContext context,
      List<int> selectedFile,
      FilePickerResult? result,
      firstName,
      lastName,
      email,
      role,
      idUpdate,
      genre) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');

    print(id);
    print(token);

    var url = Uri.parse("http://13.39.81.126:7001/api/users/update/$idUpdate");
    final request = MultipartRequest(
      'PATCH',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    print(url);
    var json = {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "role": role,
      "gender": genre,
      "creator": id
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });
    request.headers['authorization'] = 'Bearer $token';
    if (result != null) {
      request.fields['form_key'] = 'form_value';

      request.files.add(http.MultipartFile.fromBytes('file', selectedFile,
          contentType: MediaType('application', 'octet-stream'),
          filename: result.files.first.name));
    }

    print("RESPENSE SEND STEAM FILE REQ");
    var response = await request.send();
    print("Upload Response$response");
    print(response.statusCode);
    print(request.headers);

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });
        // ignore: unused_result
        ref.refresh(getDataUserFuture);
        setState(() {
          ajout = false;
          modif = false;
          nomcontroller.clear();
          prenomcontroller.clear();
          emailcontroller.clear();
          _role = listOfRole.first;
          //result!.files.clear();
          selectedFile = [];
        });
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Utilisateur modifié avec succès",
          ),
        );
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de modification",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> deleteUser(contextt, String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      //String adress_url = prefs.getString('ipport').toString();
      String urlDelete = "http://13.39.81.126:7001/api/users/delete/$id";
      print(urlDelete);
      final http.Response response = await http.patch(
        Uri.parse(urlDelete),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "User supprimé",
          ),
        );
        // ignore: unused_result
        ref.refresh(getDataUserFuture);
        return response;
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de suppression",
          ),
        );
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
