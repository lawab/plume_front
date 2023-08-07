import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projet_plum/pages/classe/classe.dart';
import 'package:projet_plum/pages/devoir/docDevoir.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:projet_plum/pages/services/getCourss.dart' as c;
import 'package:projet_plum/pages/services/getModule.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum SampleItem { itemOne, itemTwo }

class DevoirCreation extends ConsumerStatefulWidget {
  final List<Courses> list;
  const DevoirCreation({Key? key, required this.list}) : super(key: key);

  @override
  DevoirCreationState createState() => DevoirCreationState();
}

class DevoirCreationState extends ConsumerState<DevoirCreation> {
  var titlecontroller = TextEditingController();
  var descriptioncontroller = TextEditingController();
  var dateinput = TextEditingController();
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

  bool doc = false;
  bool quiz = false;
  var id = '';
  var type = '';
  bool _selectFile = false;
  List<int> _selectedFile = [];
  FilePickerResult? result;
  PlatformFile? file;
  Uint8List? selectedImageInBytes;
  bool ok = false;
  List<Modules> listmodule = [];
  SampleItem? selectedMenu;
  var content = '';
  ///////////
  var titleecontroller = TextEditingController();
  var durecontroller = TextEditingController();
  int _counter = 1;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  List<CocheTotal> listCocheTotale = [];
  final questionController = TextEditingController();
  final rep1Controller = TextEditingController();
  final rep2Controller = TextEditingController();
  final rep3Controller = TextEditingController();
  final rep4Controller = TextEditingController();
  bool bonne1 = false;
  bool bonne2 = false;
  bool bonne3 = false;
  bool bonne4 = false;
  List<String> bonneReponse = [];
  ///////////

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context);
          } else if (constraints.maxWidth >= 400) {
            return verticalView(height(context), width(context), context);
          } else {
            return mobile(height(context), width(context), context);
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                width: width / 2,
                padding: EdgeInsets.all(10),
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Devoir de maison',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ////////////////////////////////////////// Premiere ligne
              Container(
                width: width / 2,
                child: Row(children: [
                  Expanded(
                      child: Container(
                    height: 420,
                    child: Column(
                      children: [
                        Text(
                          'Titre',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: width / 4 - 50,
                          child: TextFormField(
                            controller: titlecontroller,
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
                                  borderSide: const BorderSide(
                                      color: Palette.violetColor),
                                  gapPadding: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Palette.violetColor),
                                  gapPadding: 10,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Palette.violetColor),
                                  gapPadding: 10,
                                ),
                                labelText: "Titre",
                                hintText: "Entrer le titre ",
                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: const Icon(Icons.title)),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Description',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: width / 4 - 50,
                          child: TextFormField(
                            controller: descriptioncontroller,
                            keyboardType: TextInputType.emailAddress,
                            maxLines: 4,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hoverColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 42, vertical: 20),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.violetColor),
                                gapPadding: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.violetColor),
                                gapPadding: 10,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.violetColor),
                                gapPadding: 10,
                              ),
                              /*labelText: "Description",
                              hintText: "Entrer une description ",*/
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              //suffixIcon: const Icon(Icons.food_bank),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Date limite',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: width / 4 - 50,
                          child: TextFormField(
                            controller: dateinput,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {},
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(
                                      2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101));

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);

                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                                  dateinput.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {
                                print("Date non selectionnée");
                              }
                            },
                            decoration: InputDecoration(
                              hoverColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 42, vertical: 20),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.violetColor),
                                gapPadding: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.violetColor),
                                gapPadding: 10,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: Palette.violetColor),
                                gapPadding: 10,
                              ),
                              labelText: "Date",
                              hintText: "Entrer une date ",

                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: const Icon(Icons.date_range),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 69,
                          //width: 150,

                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 69,
                                  color: Colors.white,
                                  /**/
                                  child: more(),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const SizedBox(
                                width: 20,
                                child: Text('OU'),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: InkWell(
                                  child: Container(
                                    /*decoration: const BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/Formats.jpg'))),*/
                                    height: 69,
                                    color: Colors.white,
                                    child: _selectFile == false
                                        ? Image.asset(
                                            'assets/Formats.jpg',
                                          )
                                        : Center(
                                            child: Text(file!.name),
                                          ),
                                  ),
                                  onTap: () async {
                                    result = await FilePicker.platform
                                        .pickFiles(
                                            type: FileType.custom,
                                            allowedExtensions: [
                                          "png",
                                          "jpg",
                                          "jpeg",
                                          "pdf"
                                        ]);
                                    if (result != null) {
                                      setState(() {
                                        file = result!.files.single;

                                        Uint8List fileBytes = result!
                                            .files.single.bytes as Uint8List;

                                        _selectedFile = fileBytes;

                                        selectedImageInBytes =
                                            result!.files.first.bytes;
                                        _selectFile = true;
                                        type = "file";
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      height: 420,
                      child: Column(
                        children: [
                          const Text(
                            'Cours',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 365,
                            color: Colors.white,
                            child: ListView.builder(
                              itemCount: widget.list.length,
                              itemBuilder: (context, index) {
                                return ExpansionTile(
                                  title: Text(
                                    widget.list[index].course!.title!,
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  onExpansionChanged: (value) {
                                    setState(() {
                                      ok = !ok;
                                    });
                                    module(context,
                                        widget.list[index].course!.sId!);
                                  },
                                  trailing: Icon(
                                    Icons.work,
                                    color: Color.fromARGB(255, 0, 170, 255),
                                  ),
                                  children: <Widget>[
                                    ok == true
                                        ? Container(
                                            height: 50 *
                                                listmodule.length.toDouble(),
                                            child: ListView.builder(
                                                itemCount: listmodule.length,
                                                itemBuilder: (context, indexx) {
                                                  return ListTile(
                                                    title: Text(
                                                      listmodule[indexx]
                                                          .title
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 18.0),
                                                    ),
                                                    leading: Icon(Icons
                                                        .attach_file_sharp),
                                                    trailing: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          if (listmodule[indexx]
                                                                  .isselect ==
                                                              false) {
                                                            listmodule[indexx]
                                                                    .isselect =
                                                                true;
                                                            id = listmodule[
                                                                    indexx]
                                                                .sId!;
                                                          } else {
                                                            listmodule[indexx]
                                                                    .isselect =
                                                                false;
                                                          }
                                                        });
                                                      },
                                                      icon: listmodule[indexx]
                                                                  .isselect ==
                                                              true
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
                                                    onTap: () {
                                                      print(
                                                          'eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
                                                    },
                                                  );
                                                }),
                                          )
                                        : Container(),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              quiz == true
                  ? Container(
                      padding: EdgeInsets.all(20),
                      height: height / 2 + 206,
                      width: width,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.white,
                        child: Quizz(),
                      ))
                  : Container(),
              doc == true
                  ? Container(
                      padding: EdgeInsets.all(20),
                      height: 820, //height / 2 + 206,
                      width: width,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.white,
                        child: document(),
                      ))
                  : Container(),
              ////////////////////////////////////////// Deuxième ligne
              const SizedBox(
                height: 80,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: Size(150, 60),
                    backgroundColor: Palette.violetColor),
                child: const Text('Enregistrer'),
                onPressed: () async {
                  var jsonDocument = '';
                  if (doc == true) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    print(
                        'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbZZZZZZZZZZZ');
                    jsonDocument = prefs.getString('document')!;
                  }

                  if (id.isNotEmpty && type.isNotEmpty) {
                    print(
                        'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb');
                    print(jsonDocument);
                    // ignore: use_build_context_synchronously
                    creationDevoir(
                      context,
                      id,
                      _selectedFile,
                      result,
                      titlecontroller.text,
                      descriptioncontroller.text,
                      dateinput.text,
                      type,
                      quiz == true
                          ? content
                          : doc == true
                              ? jsonDocument
                              : '',
                    );
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.info(
                        backgroundColor: Colors.amber,
                        message: quiz == true
                            ? "Enregistrer le quiz avant de pour créer le devoir de maison"
                            : doc == true
                                ? 'Enregistrer le document avant de pour créer le devoir de maison'
                                : 'Veuillez remplir le devoir de maison',
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    return AppLayout(
      content: Container(),
    );
  }

  Widget mobile(double height, double width, context) {
    return AppLayout(
      content: Container(),
    );
  }

  Widget more() {
    return PopupMenuButton(
      tooltip: 'Création de documents',
      initialValue: selectedMenu,
      onSelected: (SampleItem item) async {
        setState(() {
          selectedMenu = item;
        });

        if (item == SampleItem.itemOne) {
          setState(() {
            doc = true;
            type = "document";
          });
        } else {
          setState(() {
            quiz = true;
            type = "quiz";
          });
        }
      },
      child: const Icon(
        Icons.more_vert,
        size: 20,
        color: Colors.black,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('doc.png'))),
              ),
              const Expanded(
                child: Text('Créer un document'),
              )
            ],
          ),
        ),
        PopupMenuItem<SampleItem>(
          value: SampleItem.itemTwo,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('quiz.png')),
                ),
              ),
              const Expanded(
                child: Text('Créer un quiz'),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget document() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(
              Icons.close,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                doc = false;
              });
            },
          ),
        ),
        Container(
          height: 700, //MediaQuery.of(context).size.height / 2 + 100, //206,
          child: const DocumentDevoir(),
        )
      ],
    );
  }

  Widget Quizz() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(
              Icons.close,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                quiz = false;
                type = '';
              });
            },
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            controller: titleecontroller,
            onChanged: (val) {},
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 5),
              labelText: 'Titre Quiz :',
              labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 21),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: 'Ecrire le Titre Quiz... *',
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width - 200,
          child: TextField(
            controller: durecontroller,
            onChanged: (val) {},
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 5),
              labelText: 'Durée du quiz',
              labelStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 21),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: 'Saisir la durée en seconde *',
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          child: Column(
            children: [
              Container(
                width: 300,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 83, 151),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Ajouter une question'),
                  onPressed: () {
                    if (questionController.text != '' ||
                        rep1Controller.text != '' ||
                        rep2Controller.text != '' ||
                        rep3Controller.text != '' ||
                        rep4Controller.text != '') {
                      if (bonne1 == true) {
                        bonneReponse.add(rep1Controller.text);
                      }
                      if (bonne2 == true) {
                        bonneReponse.add(rep2Controller.text);
                      }
                      if (bonne3 == true) {
                        bonneReponse.add(rep3Controller.text);
                      }
                      if (bonne4 == true) {
                        bonneReponse.add(rep4Controller.text);
                      }
                      List<Reponses> rep = [];
                      var jj1 = Reponses(
                        reponsee: rep1Controller.text,
                        coche: false,
                      );
                      rep.add(jj1);
                      var jj2 = Reponses(
                        reponsee: rep2Controller.text,
                        coche: false,
                      );
                      rep.add(jj2);
                      var jj3 = Reponses(
                        reponsee: rep3Controller.text,
                        coche: false,
                      );
                      rep.add(jj3);
                      var jj4 = Reponses(
                        reponsee: rep4Controller.text,
                        coche: false,
                      );
                      rep.add(jj4);
                      var ee = CocheTotal(
                          correct_answer: bonneReponse,
                          responses: rep,
                          question: questionController.text);
                      listCocheTotale.add(ee);
                      // _addinputText(Context, context);

                      setState(() {
                        bonneReponse = [];
                        rep1Controller.clear();
                        rep2Controller.clear();
                        rep3Controller.clear();
                        rep4Controller.clear();
                        questionController.clear();
                        bonne1 = false;
                        bonne2 = false;
                        bonne3 = false;
                        bonne4 = false;
                      });

                      _incrementCounter();
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                //height: MediaQuery.of(context).size.height ,
                width: MediaQuery.of(context).size.width - 200,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      child: TextField(
                        controller: questionController,
                        decoration: const InputDecoration(
                          label: Text('Question'),
                          hintText: '',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          const Text('Reponse 1:'),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              controller: rep1Controller,
                              decoration: const InputDecoration(
                                label: Text('Ecrire le reponse 1'),
                                hintText: '',
                              ),
                            ),
                          ),
                          Text("Cocher si c'est une bonne reponse"),
                          IconButton(
                            onPressed: (() {
                              setState(() {
                                bonne1 = !bonne1;
                              });
                            }),
                            icon: bonne1 == true
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green[700],
                                  )
                                : const Icon(
                                    Icons.check_circle_outline,
                                    color: Color.fromARGB(255, 139, 32, 32),
                                  ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Text('Reponse 2:'),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              controller: rep2Controller,
                              decoration: const InputDecoration(
                                label: Text('Ecrire le reponse 2'),
                                hintText: '',
                              ),
                            ),
                          ),
                          Text("Cocher si c'est une bonne reponse"),
                          IconButton(
                            onPressed: (() {
                              setState(() {
                                bonne2 = !bonne2;
                              });
                            }),
                            icon: bonne2 == true
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green[700],
                                  )
                                : const Icon(
                                    Icons.check_circle_outline,
                                    color: Color.fromARGB(255, 139, 32, 32),
                                  ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Text('Reponse 3:'),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              controller: rep3Controller,
                              decoration: const InputDecoration(
                                label: Text('Ecrire le reponse 3'),
                                hintText: '',
                              ),
                            ),
                          ),
                          Text("Cocher si c'est une bonne reponse"),
                          IconButton(
                            onPressed: (() {
                              setState(() {
                                bonne3 = !bonne3;
                              });
                            }),
                            icon: bonne3 == true
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green[700],
                                  )
                                : const Icon(
                                    Icons.check_circle_outline,
                                    color: Color.fromARGB(255, 139, 32, 32),
                                  ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Text('Reponse 4:'),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              controller: rep4Controller,
                              decoration: const InputDecoration(
                                label: Text('Ecrire le reponse 4'),
                                hintText: '',
                              ),
                            ),
                          ),
                          Text("Cocher si c'est une bonne reponse"),
                          IconButton(
                            onPressed: (() {
                              setState(() {
                                bonne4 = !bonne4;
                              });
                            }),
                            icon: bonne4 == true
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green[700],
                                  )
                                : const Icon(
                                    Icons.check_circle_outline,
                                    color: Color.fromARGB(255, 139, 32, 32),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 40,
                child: ElevatedButton(
                  child: Text('Créer le quiz à $_counter questions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 83, 151),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (questionController.text != '' ||
                        rep1Controller.text != '' ||
                        rep2Controller.text != '' ||
                        rep3Controller.text != '' ||
                        rep4Controller.text != '' ||
                        durecontroller.text != '' ||
                        titlecontroller.text != '') {
                      if (listCocheTotale.length < _counter) {
                        if (bonne1 == true) {
                          bonneReponse.add(rep1Controller.text);
                        }
                        if (bonne2 == true) {
                          bonneReponse.add(rep2Controller.text);
                        }
                        if (bonne3 == true) {
                          bonneReponse.add(rep3Controller.text);
                        }
                        if (bonne4 == true) {
                          bonneReponse.add(rep4Controller.text);
                        }
                        List<Reponses> rep = [];
                        var jj1 = Reponses(
                          reponsee: rep1Controller.text,
                          coche: false,
                        );
                        rep.add(jj1);
                        var jj2 = Reponses(
                          reponsee: rep2Controller.text,
                          coche: false,
                        );
                        rep.add(jj2);
                        var jj3 = Reponses(
                          reponsee: rep3Controller.text,
                          coche: false,
                        );
                        rep.add(jj3);
                        var jj4 = Reponses(
                          reponsee: rep4Controller.text,
                          coche: false,
                        );
                        rep.add(jj4);
                        var ee = CocheTotal(
                            correct_answer: bonneReponse,
                            responses: rep,
                            question: questionController.text);
                        listCocheTotale.add(ee);

                        // _addinputText(Context, context);
                        setState(() {
                          bonneReponse = [];
                          rep1Controller.clear();
                          rep2Controller.clear();
                          rep3Controller.clear();
                          rep4Controller.clear();
                          questionController.clear();
                          bonne1 = false;
                          bonne2 = false;
                          bonne3 = false;
                          bonne4 = false;
                        });
                      }
                      var jj = QuizTotal(
                          corps: listCocheTotale,
                          title: titleecontroller.text,
                          dure: durecontroller.text);
                      print(jsonEncode(jj));
                      setState(() {
                        quiz = true;
                        type = 'quiz';
                        content = jsonEncode(jj);
                      });
                      showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.info(
                            backgroundColor: Colors.amber,
                            message:
                                " Veuillez enregistrer maintenant le devoir de maison plus bas"),
                      );
                      /*createQuiz(titlecontroller.text, durecontroller.text,
                              jsonEncode(listCocheTotale));*/
                    } else {
                      print('Une donnée est nulle et doit etre remplie');
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> creationDevoir(
    BuildContext contextt,
    idModule,
    List<int> selectedFile,
    FilePickerResult? result,
    titre,
    description,
    dateLimite,
    type,
    content,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');
    print(id);
    print(token);

    var url = Uri.parse("http://13.39.81.126:7002/api/homeworks/create");
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    var json = {
      "title": titre,
      "description": description,
      "limitDate": dateLimite,
      "typeHomwork": type,
      "content": content,
      "creator": id,
      "moduleId": idModule
    };
    var body = jsonEncode(json);
    print(body);

    request.headers.addAll({
      "body": body,
    });

    //request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    if (result != null) {
      request.files.add(http.MultipartFile.fromBytes('file', selectedFile,
          contentType: MediaType('application', 'octet-stream'),
          filename: result.files.first.name));
    }

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
        ref.refresh(c.getDataCoursAllFuture);
        // ignore: unused_result

        Navigator.pop(context);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message: "Devoir créé avec succès",
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

  Future<http.Response> module(contextt, String idCours) async {
    try {
      listmodule = [];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      //String adress_url = prefs.getString('ipport').toString();
      String urlAssign =
          "http://13.39.81.126:7002/api/courses/modules/$idCours";
      print(urlAssign);
      final http.Response response = await http.get(
        Uri.parse(urlAssign),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Accept': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        //ref.refresh(getDataSectionFuture);
        var data = jsonDecode(response.body);
        print(data);
        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            setState(() {
              listmodule.add(Modules.fromJson(data[i]));
            });
          }
        }
        return response;
      } else {
        return Future.error("Server Error");
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}

class QuizTotal {
  String? dure;
  String? title;
  List<CocheTotal>? corps;

  QuizTotal({this.corps, this.dure, this.title});

  QuizTotal.fromJson(Map<String, dynamic> json) {
    dure = json['dure'];
    title = json['title'];

    if (json['corps'] != null) {
      corps = <CocheTotal>[];
      json['corps'].forEach((v) {
        corps!.add(CocheTotal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dure'] = this.dure;
    data['title'] = this.title;

    if (this.corps != null) {
      data['corps'] = this.corps!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class CocheTotal {
  List<String>? correct_answer;
  List<Reponses>? responses;
  String? question;

  CocheTotal({
    this.correct_answer,
    this.responses,
    this.question,
  });

  CocheTotal.fromJson(Map<String, dynamic> json) {
    correct_answer = json['correct_answer'].cast<String>();
    if (json['responses'] != null) {
      responses = <Reponses>[];
      json['responses'].forEach((v) {
        responses!.add(new Reponses.fromJson(v));
      });
    }
    question = json['question'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['correct_answer'] = this.correct_answer;
    if (this.responses != null) {
      data['responses'] = this.responses!.map((v) => v.toJson()).toList();
    }
    data['question'] = this.question;

    return data;
  }
}

class Reponses {
  String? reponsee;
  bool? coche;

  Reponses({
    this.reponsee,
    this.coche,
  });

  Reponses.fromJson(Map<String, dynamic> json) {
    reponsee = json['reponsee'];
    coche = json['coche'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['reponsee'] = this.reponsee;
    data['coche'] = this.coche;

    return data;
  }
}
