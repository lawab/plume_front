import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/services/getClasse.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getDataPresenceFuture = ChangeNotifierProvider<GetDataPresenceFuture>(
    (ref) => GetDataPresenceFuture());

class GetDataPresenceFuture extends ChangeNotifier {
  // List<Presences>
  PresenceS listPresence = PresenceS(presences: []);

  List<Presences> presence = [];
  List<Presences> presenceList = [];
  GetDataPresenceFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var idClasse = prefs.getString('idClasse');
    var idCours = prefs.getString('idCours');
    List eleve = jsonDecode(prefs.getString('lesElèves').toString());
    List<Students> listEleve = [];
    for (int i = 0; i < eleve.length; i++) {
      listEleve.add(Students.fromJson(eleve[i]));
    }

    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://13.39.81.126:7003/api/presences/fetch/all/$idClasse/$idCours'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print(idClasse);
      print(idCours);
      //print(response.statusCode);
      print(
          '********************************************************get ALL Presence');
      //print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('listPresence.length  BD');
        print(data.length);

        var taille = data.length;
        if (taille != 0) {
          for (int i = 0; i < data[taille - 1]["presences"].length; i++) {
            presence.add(Presences.fromJson(data[taille - 1]["presences"][i]));
            presenceList
                .add(Presences.fromJson(data[taille - 1]["presences"][i]));
          }
          List<Presences> listP = [];
          if (presence.isNotEmpty) {
            if (data[taille - 1]['deletedAt'] == null) {
              // listPresence.add(PresenceS.fromJson(data[i]));
              print(data[taille - 1]["presences"]);
              print(data[taille - 1]["courseId"]);
              print(data[taille - 1]["week"]);

              ///////////////////////////////////////////////////

              for (int i = 0; i < presence.length; i++) {
                for (int j = 0; j < listEleve.length; j++) {
                  if (presence[i].student!.sId != listEleve[j].user!.sId) {
                    if (presence[i].student!.sId != listEleve[j].user!.sId) {
                      //Si l'id d'un élève de la classe != id d'un élève dans liste de presence alors gg(l'élève de la classe) esst créé
                      bool verif = false;

                      var aa = Student(
                          sId: listEleve[j].user!.sId,
                          email: listEleve[j].user!.email,
                          role: listEleve[j].user!.role,
                          firstName: listEleve[j].user!.firstName,
                          lastName: listEleve[j].user!.lastName);
                      var bb = Lundi(date: '1', presence: false, holiday: true);
                      var cc = Mardi(date: '1', presence: false, holiday: true);
                      var dd =
                          Mercredi(date: '1', presence: false, holiday: true);
                      var ee = Jeudi(date: '1', presence: false, holiday: true);
                      var ff =
                          Vendredi(date: '1', presence: false, holiday: true);
                      var gg = Presences(
                        student: aa,
                        lundi: bb,
                        mardi: cc,
                        mercredi: dd,
                        jeudi: ee,
                        vendredi: ff,
                      );
                      ///////////////////////////////////

                      //Lorsque gg est créer on verifie s'il n'est vraiment pas dans la liste de présence
                      for (int s = 0; s < presence.length; s++) {
                        //Cette verification se fait avec le student de gg qui est aa
                        if (presence[s].student!.sId == aa.sId) {
                          //Si c'est = alors il n'est pas ajouté puisqu'il existe déja
                          print(' exist');
                          verif = true;
                        } else {
                          //s'il n'est pas dans la liste de presence, on verifie encore dans la liste listP
                          for (int u = 0; u < listP.length; u++) {
                            if (listP[u].student!.sId == aa.sId) {
                              //Si c'est = alors il n'est pas ajouté puisqu'il existe déja
                              print(' exist listP');
                              verif = true;
                            } else {
                              print(' NOTexist listP');
                            }
                          }
                        }
                      }
                      //Lorsque toute les verification sont faites et "verif" est toujour false,alors il est a jouté a listP
                      if (verif == false) {
                        print(
                            'DANS LA LISTEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE exist');
                        listP.add(gg);
                      }
                    }
                  }
                }
              }
              presence.addAll(listP);
            }
          } else {
            ///////////////////////////////////////////////////PRESENCE EST VIDE
            Student? aa;
            Presences? gg;
            for (int j = 0; j < listEleve.length; j++) {
              aa = Student(
                  sId: listEleve[j].user!.sId,
                  email: listEleve[j].user!.email,
                  role: listEleve[j].user!.role,
                  firstName: listEleve[j].user!.firstName,
                  lastName: listEleve[j].user!.lastName);
              var bb = Lundi(date: '1', presence: false, holiday: true);
              var cc = Mardi(date: '1', presence: false, holiday: true);
              var dd = Mercredi(date: '1', presence: false, holiday: true);
              var ee = Jeudi(date: '1', presence: false, holiday: true);
              var ff = Vendredi(date: '1', presence: false, holiday: true);
              gg = Presences(
                student: aa,
                lundi: bb,
                mardi: cc,
                mercredi: dd,
                jeudi: ee,
                vendredi: ff,
              );

              print(
                  'DANS LA LISTEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE exist');
              listP.add(gg);
              //check1 = true;
            }
            presence.addAll(listP);
            print(presence.length);
            //////////////////////////////////////////////////
          }

          //////////////////////////////////////////////////
          listPresence = PresenceS(
            week: data[taille - 1]["week"],
            coursesId: data[taille - 1]["courseId"],
            presences: presence,
          );
        } else {
          ///////////////////////////////////////////////////PRESENCE COMPLETEMENT VIDE
          Student? aa;
          Presences? gg;
          for (int j = 0; j < listEleve.length; j++) {
            aa = Student(
                sId: listEleve[j].user!.sId,
                email: listEleve[j].user!.email,
                role: listEleve[j].user!.role,
                firstName: listEleve[j].user!.firstName,
                lastName: listEleve[j].user!.lastName);
            var bb = Lundi(date: '1', presence: false, holiday: true);
            var cc = Mardi(date: '1', presence: false, holiday: true);
            var dd = Mercredi(date: '1', presence: false, holiday: true);
            var ee = Jeudi(date: '1', presence: false, holiday: true);
            var ff = Vendredi(date: '1', presence: false, holiday: true);
            gg = Presences(
              student: aa,
              lundi: bb,
              mardi: cc,
              mercredi: dd,
              jeudi: ee,
              vendredi: ff,
            );

            print(
                'DANS LA LISTEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE exist');
            presence.add(gg);
            //check1 = true;
          }
          //////////////////////////////////////////////////
          listPresence = PresenceS(
            presences: presence,
          );
        }
      } else {
        return Future.error(" server erreur");
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
}

class PresenceS {
  String? week;
  ClasseId? classeId;
  String? coursesId;
  List<Presences>? presences;

  PresenceS({this.week, this.classeId, this.coursesId, this.presences});

  PresenceS.fromJson(Map<String, dynamic> json) {
    week = json['week'];
    classeId = json['classeId'] != null
        ? new ClasseId.fromJson(json['classeId'])
        : null;
    coursesId = json['coursesId'];
    if (json['presences'] != null) {
      presences = <Presences>[];
      json['presences'].forEach((v) {
        presences!.add(new Presences.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['week'] = this.week;
    if (this.classeId != null) {
      data['classeId'] = this.classeId!.toJson();
    }
    data['coursesId'] = this.coursesId;
    if (this.presences != null) {
      data['presences'] = this.presences!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Presences {
  Student? student;
  Lundi? lundi;
  Mardi? mardi;
  Mercredi? mercredi;
  Jeudi? jeudi;
  Vendredi? vendredi;

  Presences(
      {this.student,
      this.lundi,
      this.mardi,
      this.mercredi,
      this.jeudi,
      this.vendredi});

  Presences.fromJson(Map<String, dynamic> json) {
    student =
        json['student'] != null ? new Student.fromJson(json['student']) : null;
    lundi = json['lundi'] != null
        ? Lundi.fromJson(json['lundi'])
        : Lundi.fromJson(
            {"date": "eepppeeee", "presence": false, "holiday": true});
    mardi = json['mardi'] != null
        ? Mardi.fromJson(json['mardi'])
        : Mardi.fromJson(
            {"date": "eepppeeee", "presence": false, "holiday": true});
    mercredi = json['mercredi'] != null
        ? Mercredi.fromJson(json['mercredi'])
        : Mercredi.fromJson(
            {"date": "eepppeeee", "presence": false, "holiday": true});
    jeudi = json['jeudi'] != null
        ? Jeudi.fromJson(json['jeudi'])
        : Jeudi.fromJson(
            {"date": "eepppeeee", "presence": false, "holiday": true});
    vendredi = json['vendredi'] != null
        ? Vendredi.fromJson(json['vendredi'])
        : Vendredi.fromJson(
            {"date": "eepppeeee", "presence": false, "holiday": true});
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.student != null) {
      data['student'] = this.student!.toJson();
    }
    if (this.lundi != null) {
      data['lundi'] = this.lundi!.toJson();
    }
    if (this.mardi != null) {
      data['mardi'] = this.mardi!.toJson();
    }
    if (this.mercredi != null) {
      data['mercredi'] = this.mercredi!.toJson();
    }
    if (this.jeudi != null) {
      data['jeudi'] = this.jeudi!.toJson();
    }
    if (this.vendredi != null) {
      data['vendredi'] = this.vendredi!.toJson();
    }
    return data;
  }
}

class Student {
  String? sId;
  String? email;
  String? role;
  String? firstName;
  String? lastName;

  Student({this.sId, this.email, this.role, this.firstName, this.lastName});

  Student.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    role = json['role'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['role'] = this.role;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    return data;
  }
}

class Lundi {
  String? date;
  bool? presence;
  bool? holiday;

  Lundi({this.date, this.presence, this.holiday});

  Lundi.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    presence = json['presence'];
    holiday = json['holiday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['presence'] = this.presence;
    data['holiday'] = this.holiday;
    return data;
  }
}

class Mardi {
  String? date;
  bool? presence;
  bool? holiday;

  Mardi({this.date, this.presence, this.holiday});

  Mardi.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    presence = json['presence'];
    holiday = json['holiday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['presence'] = this.presence;
    data['holiday'] = this.holiday;
    return data;
  }
}

class Mercredi {
  String? date;
  bool? presence;
  bool? holiday;

  Mercredi({this.date, this.presence, this.holiday});

  Mercredi.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    presence = json['presence'];
    holiday = json['holiday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['presence'] = this.presence;
    data['holiday'] = this.holiday;
    return data;
  }
}

class Jeudi {
  String? date;
  bool? presence;
  bool? holiday;

  Jeudi({this.date, this.presence, this.holiday});

  Jeudi.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    presence = json['presence'];
    holiday = json['holiday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['presence'] = this.presence;
    data['holiday'] = this.holiday;
    return data;
  }
}

class Vendredi {
  String? date;
  bool? presence;
  bool? holiday;

  Vendredi({this.date, this.presence, this.holiday});

  Vendredi.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    presence = json['presence'];
    holiday = json['holiday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['presence'] = this.presence;
    data['holiday'] = this.holiday;
    return data;
  }
}

class ClasseId {
  Null deletedAt;
  String? sId;
  String? title;
  String? description;
  bool? validated;

  List<Null>? homeworks;

  String? createdAt;
  String? updatedAt;
  int? iV;

  String? timeTable;
  String? planning;

  ClasseId(
      {this.deletedAt,
      this.sId,
      this.title,
      this.description,
      this.validated,
      this.homeworks,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.timeTable,
      this.planning});

  ClasseId.fromJson(Map<String, dynamic> json) {
    deletedAt = json['deletedAt'];
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    validated = json['validated'];

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    ;
    timeTable = json['time_table'];
    planning = json['planning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deletedAt'] = this.deletedAt;
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['validated'] = this.validated;

    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;

    data['time_table'] = this.timeTable;
    data['planning'] = this.planning;
    return data;
  }
}
