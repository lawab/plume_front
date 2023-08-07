import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:image_network/image_network.dart';
import 'package:projet_plum/pages/services/getUser.dart';
import 'package:projet_plum/pages/services/getUserOne.dart' as o;
import 'package:projet_plum/pages/user/user.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ParentAssigne extends ConsumerStatefulWidget {
  final User apprenant;
  const ParentAssigne({Key? key, required this.apprenant}) : super(key: key);

  @override
  ParentAssigneState createState() => ParentAssigneState();
}

class ParentAssigneState extends ConsumerState<ParentAssigne> {
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

  var idParent = '';
  var nomcontroller = TextEditingController();
  var prenomcontroller = TextEditingController();
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var password2controller = TextEditingController();
  bool ajout = false;
  List<String> listOfRole = [
    "Role *",
    "PARENT",
  ];
  String? _role;
  bool _selectFile = false;
  List<int> _selectedFile = [];
  FilePickerResult? result;
  PlatformFile? file;
  Uint8List? selectedImageInBytes;
  bool check = false;
  ParentOfStudent? parent;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataUserFuture);
    final viewModele = ref.watch(o.getDataUserbyOneFuture);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listParent, viewModele.parent);
          } else if (constraints.maxWidth >= 400) {
            return verticalView(height(context), width(context), context,
                viewModel.listParent, viewModele.parent!);
          } else {
            return mobile(height(context), width(context), context,
                viewModel.listParent, viewModele.parent!);
          }
        },
      ),
    );
  }

  Widget horizontalView(double height, double width, contextt,
      List<User> listParent, ParentOfStudent? parent) {
    return AppLayout(
      content: Container(
          padding: const EdgeInsets.all(30),
          color: Palette.backgroundColor,
          child: Column(
            children: [
              Container(
                width: width,
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.backspace,
                    color: Palette.violetColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: height - 218,
                child: Row(
                  children: [
                    Expanded(
                      flex: ajout == true ? 6 : 9,
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              height: 110,
                              width: width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Palette.backgroundColor,
                                    child: ImageNetwork(
                                      image:
                                          'http://13.39.81.126:7001${widget.apprenant.image}',
                                      height: 50,
                                      width: 50,
                                      duration: 1500,
                                      curve: Curves.easeIn,
                                      onPointer: true,
                                      debugPrint: false,
                                      fullScreen: false,
                                      fitAndroidIos: BoxFit.cover,
                                      fitWeb: BoxFitWeb.cover,
                                      borderRadius: BorderRadius.circular(70),
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
                                    height: 10,
                                  ),
                                  Text(widget.apprenant.firstName!),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: height - 400,
                              child: Row(
                                children: [
                                  /////////////////////////////////////////////////////////Parent affilié
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 50,
                                            child: Text('Parent affilié'),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          parent == null
                                              ? Container(
                                                  child: const Center(
                                                  child: Text(
                                                    'Aucun parent',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ))
                                              : Container(
                                                  height: 100,
                                                  child: Container(
                                                    padding: EdgeInsets.all(20),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.white,
                                                    ),
                                                    child: Row(children: [
                                                      Expanded(
                                                        child: Text(
                                                            parent.firstName!),
                                                      ),
                                                      Expanded(
                                                          child: CircleAvatar(
                                                              maxRadius: 20,
                                                              backgroundColor:
                                                                  Colors.black,
                                                              child:
                                                                  Container() /*IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                      )),*/
                                                              )),
                                                    ]),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const VerticalDivider(
                                    color: Colors.white,
                                    width: 10,
                                  ),
                                  /////////////////////////////////////////////////////////Liste des parents
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 50,
                                            child: Text('Liste des parents'),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            height: height - 472,
                                            child: GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                                      maxCrossAxisExtent: 300,
                                                      childAspectRatio: 3 / 2,
                                                      crossAxisSpacing: 20,
                                                      mainAxisSpacing: 50,
                                                      mainAxisExtent: 100),
                                              itemCount: listParent.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  child: Container(
                                                    padding: EdgeInsets.all(20),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.white,
                                                    ),
                                                    child: Row(children: [
                                                      Expanded(
                                                        child: Text(
                                                            listParent[index]
                                                                .firstName!),
                                                      ),
                                                      Expanded(
                                                        child: listParent[index]
                                                                .parent!
                                                            ? Icon(
                                                                Icons.check_box,
                                                                color: Colors
                                                                    .green[700],
                                                              )
                                                            : const Icon(
                                                                Icons
                                                                    .check_box_outline_blank_outlined,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        139,
                                                                        32,
                                                                        32),
                                                              ),
                                                      ),
                                                    ]),
                                                  ),
                                                  onTap: () {
                                                    if (listParent[index]
                                                            .parent ==
                                                        false) {
                                                      setState(() {
                                                        listParent[index]
                                                            .parent = true;
                                                        idParent =
                                                            listParent[index]
                                                                .sId!;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        listParent[index]
                                                            .parent = false;
                                                      });
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 370,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          minimumSize: Size(150, 60),
                                          backgroundColor: Palette.violetColor),
                                      child: Text('Continuer'),
                                      onPressed: () {
                                        int nombre = 0;
                                        for (int i = 0;
                                            i < listParent.length;
                                            i++) {
                                          if (listParent[i].parent == true) {
                                            nombre++;
                                          }
                                        }
                                        if (nombre == 1) {
                                          assignation(context, idParent,
                                              widget.apprenant.sId!);
                                        } else {
                                          showTopSnackBar(
                                            Overlay.of(contextt),
                                            const CustomSnackBar.info(
                                              backgroundColor: Colors.amber,
                                              message:
                                                  "vous ne pouvez assigner qu'un seul parent",
                                            ),
                                          );
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
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          minimumSize: Size(150, 60),
                                          backgroundColor: Colors.white),
                                      child: Text(
                                        'Créer le parent',
                                        style: TextStyle(
                                            color: Palette.violetColor),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          ajout = true;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ajout == true
                        ? const SizedBox(
                            width: 20,
                          )
                        : const SizedBox(
                            width: 0,
                          ),
                    ajout == true
                        ? Expanded(
                            flex: 3,
                            child: Container(
                              //padding: EdgeInsets.all(100),
                              child: creation(),
                            ))
                        : Container(),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget verticalView(double height, double width, context,
      List<User> listParent, ParentOfStudent parent) {
    return Scaffold();
  }

  Widget mobile(double height, double width, context, List<User> listParent,
      ParentOfStudent parent) {
    return Scaffold();
  }

  Widget creation() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: const Row(children: [
              Icon(
                Icons.person,
                size: 40,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Ajout de parent",
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
                suffixIcon: const Icon(Icons.person),
              ),
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
          SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: TextFormField(
              controller: passwordcontroller,
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
                  labelText: "Mot de passe",
                  hintText: "*************",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: const Icon(Icons.key)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: TextFormField(
              controller: password2controller,
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
          const SizedBox(
            height: 20,
          ),
          Container(
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
                      child: Text('Continuer'),
                      onPressed: () {
                        if (password2controller != passwordcontroller) {
                          creationUser(
                              context,
                              _selectedFile,
                              result,
                              prenomcontroller.text,
                              nomcontroller.text,
                              emailcontroller.text,
                              _role,
                              passwordcontroller.text);
                        } else {
                          showTopSnackBar(
                            Overlay.of(context),
                            const CustomSnackBar.info(
                              backgroundColor: Colors.red,
                              message: "Veillez verifier vos mots de passe",
                            ),
                          );
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
  ) async {
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

  Future<http.Response> assignation(
      contextt, String idParent, String idStu) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      //String adress_url = prefs.getString('ipport').toString();
      String urlAssign =
          "http://13.39.81.126:7001/api/users/assignParent/$idParent/$idStu";
      print(urlAssign);
      final http.Response response = await http.patch(
        Uri.parse(urlAssign),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      print(response.statusCode);
      //ref.refresh(p.getDataClasseFuture);

      if (response.statusCode == 200) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Users()));
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Parent assigné avec succès",
          ),
        );
        //ref.refresh(getDataSectionFuture);
        return response;
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur d'assignation",
          ),
        );
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
