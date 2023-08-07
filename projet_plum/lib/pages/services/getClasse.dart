import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/services/getUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getDataClasseFuture =
    ChangeNotifierProvider<GetDataClasseFuture>((ref) => GetDataClasseFuture());

class GetDataClasseFuture extends ChangeNotifier {
  List<Classe> listClasse = [];
  List<Classe> listClasseForTeacher = [];
  List<Students> listAssigne = [];

  GetDataClasseFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var idTeacher = prefs.getString('IdUser');

    try {
      http.Response response = await http.get(
        Uri.parse('http://13.39.81.126:7003/api/classes/fetch/all'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.statusCode);
      print(
          '********************************************************get ALL Classe');
      //print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            listClasse.add(Classe.fromJson(data[i]));
            print('+++++++++++++++++++++++++++++++++++++++');

            if (data[i]['teachers'].length != 0) {
              for (int j = 0; j < data[i]['teachers'].length; j++) {
                if (data[i]['teachers'][j]['teacher']['_id'] == idTeacher) {
                  if (listClasseForTeacher.isEmpty) {
                    listClasseForTeacher.add(Classe.fromJson(data[i]));
                  } else {
                    for (int s = 0; s < listClasseForTeacher.length; s++) {
                      if (listClasseForTeacher[s].sId != data[i]['_id']) {
                        listClasseForTeacher.add(Classe.fromJson(data[i]));
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

class Classe {
  String? deletedAt;
  String? sId;
  String? title;
  String? description;
  bool? validated;
  List<Students>? students;
  List<TeacherS>? teachers;
  List<Null>? homeworks;
  List<Courses>? courses;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Creator? creator;
  String? timeTable;
  String? planning;

  Classe(
      {this.deletedAt,
      this.sId,
      this.title,
      this.description,
      this.validated,
      this.students,
      this.teachers,
      this.homeworks,
      this.courses,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.creator,
      this.timeTable,
      this.planning});

  Classe.fromJson(Map<String, dynamic> json) {
    deletedAt = json['deletedAt'];
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    validated = json['validated'];
    if (json['students'] != null) {
      students = <Students>[];
      json['students'].forEach((v) {
        students!.add(new Students.fromJson(v));
      });
    }
    if (json['teachers'] != null) {
      teachers = <TeacherS>[];
      json['teachers'].forEach((v) {
        teachers!.add(new TeacherS.fromJson(v));
      });
    } /*
    if (json['homeworks'] != null) {
      homeworks = <Null>[];
      json['homeworks'].forEach((v) {
        homeworks!.add(new Null.fromJson(v));
      });
    }*/
    if (json['courses'] != null) {
      courses = <Courses>[];
      json['courses'].forEach((v) {
        courses!.add(new Courses.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    creator =
        json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
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
    if (this.students != null) {
      data['students'] = this.students!.map((v) => v.toJson()).toList();
    }
    if (this.teachers != null) {
      data['teachers'] = this.teachers!.map((v) => v.toJson()).toList();
    }
    /*if (this.homeworks != null) {
      data['homeworks'] = this.homeworks!.map((v) => v.toJson()).toList();
    }*/
    if (this.courses != null) {
      data['courses'] = this.courses!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.creator != null) {
      data['creator'] = this.creator!.toJson();
    }
    data['time_table'] = this.timeTable;
    data['planning'] = this.planning;
    return data;
  }
}

class TeacherS {
  Teacher? teacher;
  String? beginDate;
  String? sId;

  TeacherS({this.teacher, this.beginDate, this.sId});

  TeacherS.fromJson(Map<String, dynamic> json) {
    teacher =
        json['teacher'] != null ? new Teacher.fromJson(json['teacher']) : null;
    beginDate = json['beginDate'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teacher != null) {
      data['teacher'] = this.teacher!.toJson();
    }
    data['beginDate'] = this.beginDate;
    data['_id'] = this.sId;
    return data;
  }
}

class Teacher {
  String? sId;
  String? email;
  String? role;
  String? firstName;
  String? lastName;

  Teacher({this.sId, this.email, this.role, this.firstName, this.lastName});

  Teacher.fromJson(Map<String, dynamic> json) {
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

class Courses {
  Course? course;
  String? beginDate;
  String? sId;

  Courses({this.course, this.beginDate, this.sId});

  Courses.fromJson(Map<String, dynamic> json) {
    course =
        json['course'] != null ? new Course.fromJson(json['course']) : null;
    beginDate = json['beginDate'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.course != null) {
      data['course'] = this.course!.toJson();
    }
    data['beginDate'] = this.beginDate;
    data['_id'] = this.sId;
    return data;
  }
}

class Course {
  String? sId;
  String? title;
  String? description;
  String? image;
  List<String>? sections;
  Creator? creator;
  String? subject;
  bool? validated;
  Null deletedAt;
  List<String>? classes;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Course(
      {this.sId,
      this.title,
      this.description,
      this.image,
      this.sections,
      this.creator,
      this.subject,
      this.validated,
      this.deletedAt,
      this.classes,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Course.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    /*if (json['sections'] != null) {
      sections = <String>[];
      json['sections'].forEach((v) {
        sections!.add(new String.fromJson(v));
      });
    }*/
    creator =
        json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
    subject = json['subject'];
    validated = json['validated'];
    deletedAt = json['deletedAt'];
    /*if (json['classes'] != null) {
      classes = <Classes>[];
      json['classes'].forEach((v) {
        classes!.add(new Classes.fromJson(v));
      });
    }*/
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
    /*if (this.sections != null) {
      data['sections'] = this.sections!.map((v) => v.toJson()).toList();
    }*/
    if (this.creator != null) {
      data['creator'] = this.creator!.toJson();
    }
    data['subject'] = this.subject;
    data['validated'] = this.validated;
    data['deletedAt'] = this.deletedAt;
    /*if (this.classes != null) {
      data['classes'] = this.classes!.map((v) => v.toJson()).toList();
    }*/
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

class Students {
  User? user;
  String? beginDate;
  String? sId;

  Students({this.user, this.beginDate, this.sId});

  Students.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    beginDate = json['beginDate'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['beginDate'] = this.beginDate;
    data['_id'] = this.sId;
    return data;
  }
}
