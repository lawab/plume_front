import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:projet_plum/utils/applout.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RendezVous extends ConsumerStatefulWidget {
  const RendezVous({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RendezVous> createState() => RendezVousState();
}

class RendezVousState extends ConsumerState<RendezVous> {
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

  var dateinput = TextEditingController();
  var heureinput = TextEditingController();
  bool annuel = false;
  var motifController = TextEditingController();
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
        color: Palette.backgroundColor,
        height: height,
        width: width,
        child: Column(children: [
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
          Container(
            padding: EdgeInsets.all(50),
            height: height - 222,
            child: Row(children: [
              Expanded(
                child: Container(
                  height: height / 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Card(
                          color: Palette.violetColor,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            height: height / 4 - 10,
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
                                    lastDate: DateTime(2101),
                                    //locale: const Locale("fr", "FR"),
                                    builder: (BuildContext context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: Palette.violetColor,
                                            onPrimary: Colors.white,
                                            onSurface: Colors.black,
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors
                                                  .white, // button text color
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    });

                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);

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
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Card(
                          color: Colors.amber,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            height: height / 4 - 10,
                            child: TextFormField(
                              controller: heureinput,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {},
                              readOnly: true,
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context, //context of current state
                                );

                                if (pickedTime != null) {
                                  print(pickedTime
                                      .format(context)); //output 10:51 PM
                                  DateTime parsedTime = DateFormat.jm().parse(
                                      pickedTime.format(context).toString());
                                  //converting to DateTime so that we can further format on different pattern.
                                  print(
                                      parsedTime); //output 1970-01-01 22:53:00.000
                                  String formattedTime =
                                      DateFormat('HH:mm:ss').format(parsedTime);
                                  print(formattedTime);
                                  setState(() {
                                    heureinput.text =
                                        formattedTime; //set output date to TextField value.
                                  }); //output 14:59:00
                                  //DateFormat() is from intl package, you can format the time on any pattern you need.
                                } else {
                                  print("Time is not selected");
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
                                labelText: "Heure",
                                hintText: "Entrer une heure",

                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: const Icon(Icons.watch_later),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    height: height / 2,
                    child: Column(
                      children: [
                        const Text('Motif'),
                        const Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 50,
                          child: TextFormField(
                            maxLength: 10,
                            maxLines: 10,
                            controller: motifController,
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
                                labelText: "Motif",
                                hintText: "",
                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: const Icon(Icons.border_all)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minimumSize: Size(150, 60),
                backgroundColor: Colors.green),
            child: const Text('Validé'),
            onPressed: () {
              if (dateinput.text != '' &&
                  heureinput.text != '' &&
                  motifController.text != '') {
                serviceRDV(context, dateinput.text, heureinput.text,
                    motifController.text);
              } else {
                showTopSnackBar(
                  Overlay.of(context),
                  const CustomSnackBar.info(
                    backgroundColor: Colors.amber,
                    message: "Veuillez remplir tous les champs",
                  ),
                );
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
        ]),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    return AppLayout(content: Container());
  }

  Future<void> serviceRDV(BuildContext contextT, date, time, motif) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');

    print(id);
    print(token);

    var url = Uri.parse("http://13.39.81.126:7001/api/appointments/create");
    print(url);
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
// "creator": id,
    var json = {
      "date": date,
      "creator": id,
      "time": time,
      "motif": motif,
    };
    var body = jsonEncode(json);
    print(body);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';
    request.headers['authorization'] = 'Bearer $token';
    print("RESPENSE SEND STEAM FILE REQ");

    var response = await request.send();
    print("Upload Response$response");
    print(response.statusCode);

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });

        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            backgroundColor: Colors.green,
            message:
                "Demande de rendez-vous envoyé. Vous recevrez la reponse sur votre mail",
          ),
        );
        Navigator.pop(context);
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de service",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}
