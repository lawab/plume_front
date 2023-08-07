import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet_plum/pages/Teacher/accueilTeacher.dart';
import 'package:projet_plum/pages/accueil.dart';
import 'package:projet_plum/pages/apprenant/accueilparentApprenant.dart';
import 'package:projet_plum/utils/multipart.dart';
import 'package:projet_plum/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Authentification extends StatefulWidget {
  const Authentification({Key? key}) : super(key: key);

  @override
  AuthentificationState createState() => AuthentificationState();
}

class AuthentificationState extends State<Authentification> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final recupController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool light = false;
  bool oublie = false;
  bool notVisible = true;
  @override
  void initState() {
    _loadSettings();
    // TODO: implement initState
    super.initState();
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getBool('login') == true) {
        light = true;
        usernameController.text = prefs.getString('emailLogin').toString();
        passwordController.text = prefs.getString('passLogin').toString();
      } else {
        light = false;
        usernameController.text = '';
        passwordController.text = '';
      }
    });
  }

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
          } else if (constraints.maxWidth >= 400) {
            return verticalView(height(context), width(context), context);
          } else {
            return mobile(height(context), width(context), context);
          }
        },
      ),
    );
  }

  Widget horizontalView(double height, double width, context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Row(
              children: [
                oublie == true
                    ? Expanded(
                        child: Container(
                        padding: EdgeInsets.all(90),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              //color: Colors.white,
                              height: 150,
                              width: 150,
                              child: Image.asset(
                                'assets/logo_plum.png',
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Récupération de mot de passe',
                              style: TextStyle(
                                  color: Palette.violetColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                                'Entrer votre email pour récupérer votre mot de passe'),
                            const SizedBox(
                              height: 50,
                            ),
                            const Text('E-mail'),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 60,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: Palette.backgroundColor,
                              ),
                              child: TextFormField(
                                controller: recupController,
                                style: GoogleFonts.raleway().copyWith(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '    Ne laissez pas vide';
                                  } else if (RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                    return null;
                                  } else {
                                    return '    Entrer un email valide';
                                  }
                                },
                                decoration: InputDecoration(
                                  label: const Text(
                                    "Nom d'utlisateur",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.person)),
                                  contentPadding:
                                      const EdgeInsets.only(top: 16),
                                  hintText: "Entrer votre nom d'utilisateur",
                                  hintStyle: GoogleFonts.raleway().copyWith(
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.5),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Container(
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
                                            backgroundColor:
                                                Palette.violetColor),
                                        child: const Text('Soumettre'),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            serviceRecuperation(
                                                context, recupController.text);
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
                                            backgroundColor:
                                                Palette.backgroundColor),
                                        child: const Text(
                                          'Annuler',
                                          style: TextStyle(
                                              color: Palette.violetColor),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            oublie = false;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ))
                    : Expanded(
                        child: Container(
                          padding: EdgeInsets.all(90),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                //color: Colors.white,
                                height: 150,
                                width: 150,
                                child: Image.asset(
                                  'assets/logo_plum.png',
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Welcome',
                                style: TextStyle(
                                    color: Palette.violetColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                  'Entrer votre email et mot de passe pour vous connecter'),
                              const SizedBox(
                                height: 50,
                              ),
                              const Text('E-mail'),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 60,
                                width: width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Palette.backgroundColor,
                                ),
                                child: TextFormField(
                                  controller: usernameController,
                                  style: GoogleFonts.raleway().copyWith(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '    Ne laissez pas vide';
                                    } else if (RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                      return null;
                                    } else {
                                      return '    Entrer un email valide';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    label: const Text(
                                      "Nom d'utlisateur",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.person)),
                                    contentPadding:
                                        const EdgeInsets.only(top: 16),
                                    hintText: "Entrer votre nom d'utilisateur",
                                    hintStyle: GoogleFonts.raleway().copyWith(
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(0.5),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text('Mot de passe'),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 60,
                                width: width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Palette.backgroundColor,
                                ),
                                child: TextFormField(
                                  controller: passwordController,
                                  style: GoogleFonts.raleway().copyWith(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  obscureText: notVisible,
                                  validator: (valuep) {
                                    if (valuep!.isEmpty) {
                                      return '    Ne laissez pas vide';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    label: const Text(
                                      "Mot de passe",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.password),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          notVisible = !notVisible;
                                        });
                                      },
                                      icon: Icon(
                                          notVisible == true
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.black12),
                                    ),
                                    hintText: "Entrer votre mot de passe",
                                    hintStyle: GoogleFonts.raleway().copyWith(
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(0.5),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 135,
                                      child: Row(children: [
                                        Container(
                                          child: Switch(
                                            // This bool value toggles the switch.
                                            value: light,
                                            activeColor: Colors.blue,
                                            onChanged: (bool value) {
                                              // This is called when the user toggles the switch.
                                              setState(() {
                                                light = value;
                                              });
                                            },
                                          ),
                                        ),
                                        const Expanded(
                                          child: Text('Se souvenir'),
                                        ),
                                      ]),
                                    ),
                                    Expanded(child: Container()),
                                    InkWell(
                                      child: Text('Mode passe oublié ?'),
                                      onTap: () {
                                        setState(() {
                                          oublie = true;
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 70,
                                alignment: Alignment.center,
                                child: Container(
                                  height: 70,
                                  width: 150,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Palette.violetColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(150, 70),
                                        backgroundColor: Palette.violetColor),
                                    child: Text('Continuer'),
                                    onPressed: () async {
                                      /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Accueil()));*/
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      if (_formKey.currentState!.validate()) {
                                        if (light == true) {
                                          prefs.setBool('login', light);
                                          prefs.setString('emailLogin',
                                              usernameController.text);
                                          prefs.setString('passLogin',
                                              passwordController.text);
                                        } else {
                                          prefs.setBool('login', light);
                                          prefs.setString('emailLogin', 'non');
                                          prefs.setString('passLogin', 'non');
                                        }
                                        login(context, usernameController.text,
                                            passwordController.text);
                                      }
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(50),
                    child: Image.asset(
                      'assets/Image_plume1.png',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget verticalView(double height, double width, context) {
    print(height);
    print(width);
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: SvgPicture.asset(
                            'assets/logo-navmobile.svg',
                            semanticsLabel: 'Acme Logo',
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Welcome',
                          style: TextStyle(
                              color: Palette.violetColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                            'Entrer votre email et mot de passe pour vous connecter'),
                        const SizedBox(
                          height: 50,
                        ),
                        const Text('E-mail'),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 60,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: usernameController,
                            style: GoogleFonts.raleway().copyWith(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '    Ne laissez pas vide';
                              } else if (RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return null;
                              } else {
                                return '    Entrer un email valide';
                              }
                            },
                            decoration: InputDecoration(
                              label: const Text(
                                "Nom d'utlisateur",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              border: InputBorder.none,
                              prefixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.person)),
                              contentPadding: const EdgeInsets.only(top: 16),
                              hintText: "Entrer votre nom d'utilisateur",
                              hintStyle: GoogleFonts.raleway().copyWith(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text('Mot de passe'),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 60,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            style: GoogleFonts.raleway().copyWith(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            obscureText: notVisible,
                            validator: (valuep) {
                              if (valuep!.isEmpty) {
                                return '    Ne laissez pas vide';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text(
                                "Mot de passe",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              border: InputBorder.none,
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.password),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    notVisible = !notVisible;
                                  });
                                },
                                icon: Icon(
                                    notVisible == true
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.black12),
                              ),
                              hintText: "Entrer votre mot de passe",
                              hintStyle: GoogleFonts.raleway().copyWith(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Row(
                            children: [
                              width > 611
                                  ? Container(
                                      width: 135,
                                      child: Row(children: [
                                        Container(
                                          child: Switch(
                                            // This bool value toggles the switch.
                                            value: light,
                                            activeColor: Colors.blue,
                                            onChanged: (bool value) {
                                              // This is called when the user toggles the switch.
                                              setState(() {
                                                light = value;
                                              });
                                            },
                                          ),
                                        ),
                                        const Expanded(
                                          child: Text('Se souvenir',
                                              style: TextStyle(fontSize: 14)),
                                        ),
                                      ]),
                                    )
                                  : Container(
                                      width: 100,
                                      height: 60,
                                      child: Column(children: [
                                        Container(
                                          child: Switch(
                                            // This bool value toggles the switch.
                                            value: light,
                                            activeColor: Colors.blue,
                                            onChanged: (bool value) {
                                              // This is called when the user toggles the switch.
                                              setState(() {
                                                light = value;
                                              });
                                            },
                                          ),
                                        ),
                                        const Expanded(
                                          child: Text(
                                            'Se souvenir',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ]),
                                    ),
                              Expanded(child: Container()),
                              InkWell(
                                child: Text(
                                  'Mode passe oublié ?',
                                  style: width > 611
                                      ? TextStyle(fontSize: 14)
                                      : TextStyle(fontSize: 12),
                                ),
                                onTap: () {},
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 70,
                          alignment: Alignment.center,
                          child: Container(
                            height: 70,
                            width: 150,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Palette.violetColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(150, 70),
                                  backgroundColor: Palette.violetColor),
                              child: Text('Continuer'),
                              onPressed: () async {
                                /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Accueil()));*/
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                if (_formKey.currentState!.validate()) {
                                  if (light == true) {
                                    prefs.setBool('login', light);
                                    prefs.setString(
                                        'emailLogin', usernameController.text);
                                    prefs.setString(
                                        'passLogin', passwordController.text);
                                  } else {
                                    prefs.setBool('login', light);
                                    prefs.setString('emailLogin', 'non');
                                    prefs.setString('passLogin', 'non');
                                  }
                                  login(context, usernameController.text,
                                      passwordController.text);
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: SvgPicture.asset(
                      'assets/welcomeImage.svg',
                      semanticsLabel: 'Acme Logo',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mobile(double height, double width, context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                opacity: 150,
                image: AssetImage('assets/plum.png'),
                fit: BoxFit.cover),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: 100,
                child: SvgPicture.asset(
                  'assets/logo-navmobile.svg',
                  semanticsLabel: 'Acme Logo',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Welcome',
                style: TextStyle(
                    color: Palette.violetColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                  'Entrer votre email et mot de passe pour vous connecter'),
              const SizedBox(
                height: 50,
              ),
              const Text('E-mail'),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 60,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Palette.backgroundColor,
                ),
                child: TextFormField(
                  controller: usernameController,
                  style: GoogleFonts.raleway().copyWith(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '    Ne laissez pas vide';
                    } else if (RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return null;
                    } else {
                      return '    Entrer un email valide';
                    }
                  },
                  decoration: InputDecoration(
                    label: const Text(
                      "Nom d'utlisateur",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    border: InputBorder.none,
                    prefixIcon: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.person)),
                    contentPadding: const EdgeInsets.only(top: 16),
                    hintText: "Entrer votre nom d'utilisateur",
                    hintStyle: GoogleFonts.raleway().copyWith(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Mot de passe'),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 60,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Palette.backgroundColor,
                ),
                child: TextFormField(
                  controller: passwordController,
                  style: GoogleFonts.raleway().copyWith(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  obscureText: notVisible,
                  validator: (valuep) {
                    if (valuep!.isEmpty) {
                      return '    Ne laissez pas vide';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    label: const Text(
                      "Mot de passe",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    border: InputBorder.none,
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.password),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          notVisible = !notVisible;
                        });
                      },
                      icon: Icon(
                          notVisible == true
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black12),
                    ),
                    hintText: "Entrer votre mot de passe",
                    hintStyle: GoogleFonts.raleway().copyWith(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      width: 200,
                      child: Row(children: [
                        Container(
                          child: Switch(
                            // This bool value toggles the switch.
                            value: light,
                            activeColor: Colors.blue,
                            onChanged: (bool value) {
                              // This is called when the user toggles the switch.
                              setState(() {
                                light = value;
                              });
                            },
                          ),
                        ),
                        const Expanded(
                          child: Text('Se souvenir'),
                        ),
                      ]),
                    ),
                    Expanded(child: Container()),
                    InkWell(
                      child: const Text('Mode passe oublié ?'),
                      onTap: () {},
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 70,
                alignment: Alignment.center,
                child: Container(
                  height: 70,
                  width: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Palette.violetColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 70),
                        backgroundColor: Palette.violetColor),
                    child: Text('Continuer'),
                    onPressed: () async {
                      /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Accueil()));*/
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      if (_formKey.currentState!.validate()) {
                        if (light == true) {
                          prefs.setBool('login', light);
                          prefs.setString(
                              'emailLogin', usernameController.text);
                          prefs.setString('passLogin', passwordController.text);
                        } else {
                          prefs.setBool('login', light);
                          prefs.setString('emailLogin', 'non');
                          prefs.setString('passLogin', 'non');
                        }
                        login(context, usernameController.text,
                            passwordController.text);
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context, email, pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String responses = await rootBundle.loadString('assets/server.json');
    final dataa = await json.decode(responses);

    String url_user = dataa['adresse'] + dataa['port'][0]['user'];
    String url_Categorie = dataa['adresse'] + dataa['port'][1]['categorie'];
    String url_Classes = dataa['adresse'] + dataa['port'][2]['classes'];
    String url_Cours = dataa['adresse'] + dataa['port'][3]['cours'];
    prefs.setString('url_User', url_user);
    prefs.setString('url_Categorie', url_Categorie);
    prefs.setString('url_Classes', url_Classes);
    prefs.setString('url_Cours', url_Cours);
    String url = "$url_user/api/users/login";
    print(url);
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': pass,
      }),
    );
    //print(response.statusCode);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      //print(data);
      prefs.setString('IdUser', data['user']['_id']);
      prefs.setString('EmailUser', data['user']['email']);
      prefs.setString('token', data['accessToken']);
      prefs.setString('Role', data['user']['role']);

      if (data['user']['role'] == 'PARENT') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ParentApprenant()));
      } else if (data['user']['role'] == 'TEACHER') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AccueilTeacher()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Accueil()));
      }

      print("Vous êtes connecté");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email ou Mot de passe incorrect."),
      ));

      print("Vous n'êtes pas connecté");
    }
  }

  Future<void> serviceRecuperation(BuildContext contextT, mail) async {
    var url = Uri.parse("http://13.39.81.126:7001/api/users/recover");
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
      "email": mail,
    };
    var body = jsonEncode(json);
    print(body);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';

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
            message: "Vous recevrez un email avec votre mot de passe",
          ),
        );
        setState(() {
          oublie = false;
        });
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            backgroundColor: Colors.red,
            message: "Erreur de récupération",
          ),
        );
        print("Error Erreur de récupération !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}
