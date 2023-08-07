import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getDataCourssFuture =
    ChangeNotifierProvider<GetDataCoursFuture>((ref) => GetDataCoursFuture());

class GetDataCoursFuture extends ChangeNotifier {
  List<Courses> listcoursvalide = [];
  List<Courses> listcoursvalideTeacher = [];
  List<Courses> listcoursNonvalide = [];
  List<Courses> listcoursNonvalideTeacher = [];

  GetDataCoursFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var idCat = prefs.getString('idCategorie');
    var idTeacher = prefs.getString('IdUser');

    try {
      http.Response response = await http.get(
        Uri.parse('http://13.39.81.126:7002/api/courses/fetch/subjects/$idCat'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print(response.statusCode);
      print(
          '********************************************************Cours by Categorie');
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            if (data[i]['validated'] == false) {
              listcoursNonvalide.add(Courses.fromJson(data[i]));

              if (data[i]['creator']['_id'] == idTeacher) {
                listcoursNonvalideTeacher.add(Courses.fromJson(data[i]));
              }
            } else {
              listcoursvalide.add(Courses.fromJson(data[i]));
              if (data[i]['creator']['_id'] == idTeacher) {
                listcoursvalideTeacher.add(Courses.fromJson(data[i]));
              }
            }
          }
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

final getDataCoursAllFuture = ChangeNotifierProvider<GetDataCoursAllFuture>(
    (ref) => GetDataCoursAllFuture());

class GetDataCoursAllFuture extends ChangeNotifier {
  List<Courses> listcoursTotale = [];
  List<Courses> listcoursvalide = [];
  List<Courses> listcoursNonvalide = [];
  List<Courses> listcoursvalideTeacher = [];
  List<Courses> listcoursNonvalideTeacher = [];
  List<Homework> listDevoir = [];
  List<Homework> listDevoirTeacher = [];

  GetDataCoursAllFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var idTeacher = prefs.getString('IdUser');
    try {
      http.Response response = await http.get(
        Uri.parse('http://13.39.81.126:7002/api/courses/fetch/all'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print(response.statusCode);
      print(
          '********************************************************get ALL cours');
      //print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            listcoursTotale.add(Courses.fromJson(data[i]));
            if (data[i]['validated'] == true) {
              listcoursvalide.add(Courses.fromJson(data[i]));
            } else {
              //lui
              listcoursNonvalide.add(Courses.fromJson(data[i]));
              if (data[i]['creator']['_id'] == idTeacher) {
                listcoursNonvalideTeacher.add(Courses.fromJson(data[i]));
              }
            }
            if (data[i]['creator']['_id'] == idTeacher) {
              listcoursvalideTeacher.add(Courses.fromJson(data[i]));
            }
          }
        }
        /////////////////////////////////////////DEVOIR Admin
        for (int i = 0; i < listcoursvalide.length; i++) {
          if (listcoursvalide[i].deletedAt == null) {
            for (int j = 0; j < listcoursvalide[i].sections!.length; j++) {
              if (listcoursvalide[i].sections![j].deletedAt == null) {
                for (int s = 0;
                    s < listcoursvalide[i].sections![j].modules!.length;
                    s++) {
                  if (listcoursvalide[i].sections![j].modules![s].deletedAt ==
                      null) {
                    if (listcoursvalide[i]
                        .sections![j]
                        .modules![s]
                        .homework!
                        .isNotEmpty) {
                      for (int o = 0;
                          o <
                              listcoursvalide[i]
                                  .sections![j]
                                  .modules![s]
                                  .homework!
                                  .length;
                          o++) {
                        if (listcoursvalide[i]
                                .sections![j]
                                .modules![s]
                                .homework![o]
                                .deletedAt ==
                            null) {
                          listDevoir.add(listcoursvalide[i]
                              .sections![j]
                              .modules![s]
                              .homework![o]);
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        /////////////////////////////////////////
        ////////////////////////////////////////////DEVOIR Teacher
        for (int i = 0; i < listcoursvalideTeacher.length; i++) {
          if (listcoursvalideTeacher[i].deletedAt == null) {
            for (int j = 0;
                j < listcoursvalideTeacher[i].sections!.length;
                j++) {
              if (listcoursvalideTeacher[i].sections![j].deletedAt == null) {
                for (int s = 0;
                    s < listcoursvalideTeacher[i].sections![j].modules!.length;
                    s++) {
                  if (listcoursvalideTeacher[i]
                          .sections![j]
                          .modules![s]
                          .deletedAt ==
                      null) {
                    if (listcoursvalideTeacher[i]
                        .sections![j]
                        .modules![s]
                        .homework!
                        .isNotEmpty) {
                      for (int o = 0;
                          o <
                              listcoursvalideTeacher[i]
                                  .sections![j]
                                  .modules![s]
                                  .homework!
                                  .length;
                          o++) {
                        if (listcoursvalideTeacher[i]
                                .sections![j]
                                .modules![s]
                                .homework![o]
                                .deletedAt ==
                            null) {
                          listDevoirTeacher.add(listcoursvalideTeacher[i]
                              .sections![j]
                              .modules![s]
                              .homework![o]);
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        /////////////////////////////////////////
      } else {
        return Future.error(" server erreur");
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
}

////////////////////////
final getDataCoursByAppFuture = ChangeNotifierProvider<GetDataCoursByAppFuture>(
    (ref) => GetDataCoursByAppFuture());

class GetDataCoursByAppFuture extends ChangeNotifier {
  List<Courses> listcoursvalide = [];
  List<Homework> listDevoir = [];

  GetDataCoursByAppFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var role = prefs.getString('Role');

    var idUser = role == 'PARENT'
        ? prefs.getString('IdStudent')
        : prefs.getString('IdUser');
    print(token);
    print(idUser);
    print('http://13.39.81.126:7002/api/courses/user/$idUser');
    try {
      http.Response response = await http.get(
        Uri.parse('http://13.39.81.126:7002/api/courses/user/$idUser'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print(response.statusCode);
      print(
          '********************************************************get cours by User');
      //print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            if (data[i]['validated'] == true) {
              listcoursvalide.add(Courses.fromJson(data[i]));
            }
          }
        }

        for (int i = 0; i < listcoursvalide.length; i++) {
          if (listcoursvalide[i].deletedAt == null) {
            for (int j = 0; j < listcoursvalide[i].sections!.length; j++) {
              if (listcoursvalide[i].sections![j].deletedAt == null) {
                for (int s = 0;
                    s < listcoursvalide[i].sections![j].modules!.length;
                    s++) {
                  if (listcoursvalide[i].sections![j].modules![s].deletedAt ==
                      null) {
                    if (listcoursvalide[i]
                        .sections![j]
                        .modules![s]
                        .homework!
                        .isNotEmpty) {
                      for (int o = 0;
                          o <
                              listcoursvalide[i]
                                  .sections![j]
                                  .modules![s]
                                  .homework!
                                  .length;
                          o++) {
                        if (listcoursvalide[i]
                                .sections![j]
                                .modules![s]
                                .homework![o]
                                .deletedAt ==
                            null) {
                          listDevoir.add(listcoursvalide[i]
                              .sections![j]
                              .modules![s]
                              .homework![o]);
                        }
                      }
                    }
                  }
                }
              }
            }
          }
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

////////////////////////
class CoursCategorie {
  String? sid;
  String? title;
  List<Courses>? courses;

  CoursCategorie({
    this.title,
    this.courses,
    this.sid,
  });

  CoursCategorie.fromJson(Map<String, dynamic> json) {
    sid = json['sid'];
    title = json['title'];

    if (json['courses'] != null) {
      courses = <Courses>[];
      json['courses'].forEach((v) {
        courses!.add(new Courses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sid'] = this.sid;
    data['title'] = this.title;

    if (this.courses != null) {
      data['courses'] = this.courses!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Courses {
  String? sId;
  String? title;
  String? description;
  String? image;
  List<Sections>? sections;
  Creator? creator;
  String? subject;
  List<Null>? studentClasses;
  bool? validated;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;
  //List<Null>? assignments;

  Courses({
    this.sId,
    this.title,
    this.description,
    this.image,
    this.sections,
    this.creator,
    this.subject,
    this.studentClasses,
    this.validated,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.iV,
    //this.assignments,
  });

  Courses.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    if (json['sections'] != null) {
      sections = <Sections>[];
      json['sections'].forEach((v) {
        sections!.add(new Sections.fromJson(v));
      });
    }
    creator =
        json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
    subject = json['subject'];
    /*if (json['studentClasses'] != null) {
      studentClasses = <Null>[];
      json['studentClasses'].forEach((v) {
        studentClasses!.add(new Null.fromJson(v));
      });
    }*/
    validated = json['validated'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    /*if (json['assignments'] != null) {
      assignments = <Null>[];
      json['assignments'].forEach((v) {
        assignments!.add(new Null.fromJson(v));
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    if (this.sections != null) {
      data['sections'] = this.sections!.map((v) => v.toJson()).toList();
    }
    if (this.creator != null) {
      data['creator'] = this.creator!.toJson();
    }
    data['subject'] = this.subject;
    /*if (this.studentClasses != null) {
      data['studentClasses'] =
          this.studentClasses!.map((v) => v.toJson()).toList();
    }*/
    data['validated'] = this.validated;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    /*if (this.assignments != null) {
      data['assignments'] = this.assignments!.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}

class Sections {
  String? sId;
  String? title;
  String? description;
  String? image;
  List<Modules>? modules;
  String? course;
  Creator? creator;
  bool? validated;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Sections(
      {this.sId,
      this.title,
      this.description,
      this.image,
      this.modules,
      this.course,
      this.creator,
      this.validated,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Sections.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    if (json['modules'] != null) {
      modules = <Modules>[];
      json['modules'].forEach((v) {
        modules!.add(new Modules.fromJson(v));
      });
    }
    course = json['course'];
    creator =
        json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
    validated = json['validated'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    if (this.modules != null) {
      data['modules'] = this.modules!.map((v) => v.toJson()).toList();
    }
    data['course'] = this.course;
    if (this.creator != null) {
      data['creator'] = this.creator!.toJson();
    }
    data['validated'] = this.validated;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Modules {
  String? sId;
  String? title;
  String? description;
  String? file;
  String? typeModule;
  String? section;
  List<Homework>? homework;
  List<Null>? lessonProgressions;
  List<Null>? lessonComments;
  bool? validated;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? content;

  Modules(
      {this.sId,
      this.title,
      this.description,
      this.file,
      this.typeModule,
      this.section,
      this.homework,
      this.lessonProgressions,
      this.lessonComments,
      this.validated,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.content});

  Modules.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    file = json['file'];
    typeModule = json['typeModule'];
    section = json['section'];
    //print(json['homeworks'].runtimeType);
    if (json['homeworks'] != List<String>) {
      homework = <Homework>[];
      json['homeworks'].forEach((v) {
        homework!.add(new Homework.fromJson(v));
      });
    }

    /*if (json['lessonProgressions'] != null) {
      lessonProgressions = <Null>[];
      json['lessonProgressions'].forEach((v) {
        lessonProgressions!.add(new Null.fromJson(v));
      });
    }
    if (json['lessonComments'] != null) {
      lessonComments = <Null>[];
      json['lessonComments'].forEach((v) {
        lessonComments!.add(new Null.fromJson(v));
      });
    }*/
    validated = json['validated'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['file'] = this.file;
    data['typeModule'] = this.typeModule;
    data['section'] = this.section;
    if (this.homework != null) {
      data['homeworks'] = this.homework!.map((v) => v.toJson()).toList();
    }
    /*if (this.lessonProgressions != null) {
      data['lessonProgressions'] =
          this.lessonProgressions!.map((v) => v.toJson()).toList();
    }
    if (this.lessonComments != null) {
      data['lessonComments'] =
          this.lessonComments!.map((v) => v.toJson()).toList();
    }*/
    data['validated'] = this.validated;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['content'] = this.content;
    return data;
  }
}

class Homework {
  String? sId;
  String? title;
  String? description;
  String? file;
  String? typeHomework;
  String? limitDate;
  String? content;
  String? module;
  bool? validated;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Homework(
      {this.sId,
      this.title,
      this.description,
      this.file,
      this.typeHomework,
      this.limitDate,
      this.content,
      this.module,
      this.validated,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Homework.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    file = json['file'];
    typeHomework = json['typeHomwork'];
    content = json['content'];
    limitDate = json['limitDate'];
    module = json['module'];
    validated = json['validated'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['file'] = this.file;
    data['typeHomwork'] = this.typeHomework;
    data['content'] = this.content;
    data['limitDate'] = this.limitDate;
    data['module'] = this.module;
    data['validated'] = this.validated;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Creator {
  String? sId;
  String? email;
  String? role;
  String? fullName;
  String? firstName;
  String? lastName;

  Creator(
      {this.sId,
      this.email,
      this.role,
      this.fullName,
      this.firstName,
      this.lastName});

  Creator.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    role = json['role'];
    fullName = json['fullName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['role'] = this.role;
    data['fullName'] = this.fullName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    return data;
  }
}
