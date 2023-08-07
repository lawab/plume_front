import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getDataUserFuture =
    ChangeNotifierProvider<GetDataUserFuture>((ref) => GetDataUserFuture());

class GetDataUserFuture extends ChangeNotifier {
  List<User> listAllUsers = [];
  List<User> listStudent = [];
  List<User> listParent = [];
  /*List<User> listEmploye = [];
  List<User> listComptable = [];*/

  GetDataUserFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    try {
      http.Response response = await http.get(
        Uri.parse('http://13.39.81.126:7001/api/users/fetch/all'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print('**************************************************** get user');
      print(response.statusCode);

      //print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            if (data[i]['role'] != 'SUDO') {
              listAllUsers.add(User.fromJson(data[i]));
              if (data[i]['role'] == 'STUDENT') {
                listStudent.add(User.fromJson(data[i]));
              } else if (data[i]['role'] == 'PARENT') {
                listParent.add(User.fromJson(data[i]));
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

class User {
  String? sId;
  String? email;
  String? role;
  String? password;
  String? fullName;
  String? firstName;
  String? lastName;
  String? image;
  List<Children>? children;
  int? kind;
  List<Null>? lessonProgressions;
  int? numberOfSessions;
  bool? gender;
  Null deletedAt;
  List<Null>? courses;
  List<String>? reports;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? parent;
  List<String>? behavior;
  bool? behav;
  bool? repo;
  Class? classe;

  User({
    this.sId,
    this.email,
    this.role,
    this.password,
    this.fullName,
    this.firstName,
    this.lastName,
    this.image,
    this.children,
    this.kind,
    this.lessonProgressions,
    this.numberOfSessions,
    this.gender,
    this.deletedAt,
    this.courses,
    this.reports,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.parent,
    this.behavior,
    this.behav,
    this.repo,
    this.classe,
  });

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    role = json['role'];
    password = json['password'];
    fullName = json['fullName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    image = json['image'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children!.add(new Children.fromJson(v));
      });
    }
    kind = json['kind'];
    /*if (json['lessonProgressions'] != null) {
      lessonProgressions = <Null>[];
      json['lessonProgressions'].forEach((v) {
        lessonProgressions!.add(new Null.fromJson(v));
      });
    }*/
    numberOfSessions = json['numberOfSessions'];
    gender = json['gender'];
    deletedAt = json['deletedAt'];
    /*if (json['courses'] != null) {
      courses = <Null>[];
      json['courses'].forEach((v) {
        courses!.add(new Null.fromJson(v));
      });
    }*/
    reports = json['reports'].cast<String>();

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    parent = false;
    behavior = json['behaviors'].cast<String>();

    behav = json['behavior'];
    repo = json['report'];
    classe = json['class'] != null ? new Class.fromJson(json['class']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['role'] = this.role;
    data['password'] = this.password;
    data['fullName'] = this.fullName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['image'] = this.image;
    /*if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }*/
    data['kind'] = this.kind;
    /*if (this.lessonProgressions != null) {
      data['lessonProgressions'] =
          this.lessonProgressions!.map((v) => v.toJson()).toList();
    }*/
    data['numberOfSessions'] = this.numberOfSessions;
    data['gender'] = this.gender;
    data['deletedAt'] = this.deletedAt;
    /*if (this.courses != null) {
      data['courses'] = this.courses!.map((v) => v.toJson()).toList();
    }*/
    data['reports'] = this.reports;

    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    parent = this.parent;
    data['behaviors'] = this.behavior;

    data['behavior'] = this.behav;
    data['report'] = this.repo;
    if (this.classe != null) {
      data['class'] = this.classe!.toJson();
    }
    return data;
  }
}

////////////////////////////////////////////////////
class ParentOfStudent {
  String? sId;
  String? email;
  String? role;
  String? image;
  String? password;
  String? firstName;
  String? lastName;
  List<String>? children;
  String? creator;
  List<Null>? lessonProgressions;
  int? numberOfSessions;
  List<Null>? reports;
  List<Null>? behaviors;
  bool? report;
  bool? behavior;
  bool? gender;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ParentOfStudent(
      {this.sId,
      this.email,
      this.role,
      this.image,
      this.password,
      this.firstName,
      this.lastName,
      this.children,
      this.creator,
      this.lessonProgressions,
      this.numberOfSessions,
      this.reports,
      this.behaviors,
      this.report,
      this.behavior,
      this.gender,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ParentOfStudent.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email '];
    role = json['role'];
    image = json['image'];
    password = json['password'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    children = json['children'].cast<String>();
    creator = json['creator'];
    /*if (json['lessonProgressions'] != null) {
      lessonProgressions = <Null>[];
      json['lessonProgressions'].forEach((v) {
        lessonProgressions!.add(new Null.fromJson(v));
      });
    }
    numberOfSessions = json['numberOfSessions'];
    if (json['reports'] != null) {
      reports = <Null>[];
      json['reports'].forEach((v) {
        reports!.add(new Null.fromJson(v));
      });
    }
    if (json['behaviors'] != null) {
      behaviors = <Null>[];
      json['behaviors'].forEach((v) {
        behaviors!.add(new Null.fromJson(v));
      });
    }*/
    report = json['report'];
    behavior = json['behavior'];
    gender = json['gender'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email '] = this.email;
    data['role'] = this.role;
    data['image'] = this.image;
    data['password'] = this.password;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['children'] = this.children;
    data['creator'] = this.creator;
    /*if (this.lessonProgressions != null) {
      data['lessonProgressions'] =
          this.lessonProgressions!.map((v) => v.toJson()).toList();
    }
    data['numberOfSessions'] = this.numberOfSessions;
    if (this.reports != null) {
      data['reports'] = this.reports!.map((v) => v.toJson()).toList();
    }
    if (this.behaviors != null) {
      data['behaviors'] = this.behaviors!.map((v) => v.toJson()).toList();
    }*/
    data['report'] = this.report;
    data['behavior'] = this.behavior;
    data['gender'] = this.gender;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

////////////////////////////////////////////////////

class Creator {
  String? sId;
  String? email;
  String? role;
  String? firstName;
  String? lastName;

  Creator({this.sId, this.email, this.role, this.firstName, this.lastName});

  Creator.fromJson(Map<String, dynamic> json) {
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

class Classes {
  String? classe;
  String? beginDate;
  String? sId;

  Classes({this.classe, this.beginDate, this.sId});

  Classes.fromJson(Map<String, dynamic> json) {
    classe = json['classe'];
    beginDate = json['beginDate'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classe'] = this.classe;
    data['beginDate'] = this.beginDate;
    data['_id'] = this.sId;
    return data;
  }
}

////////////////////////////////////////////////////
class Children {
  String? sId;
  String? email;
  String? role;
  String? image;
  String? password;
  String? firstName;
  String? lastName;
  List<Null>? children;
  String? creator;
  List<Null>? lessonProgressions;
  int? numberOfSessions;
  List<Null>? reports;
  bool? gender;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Class? classe;
  String? parentOfStudent;

  Children(
      {this.sId,
      this.email,
      this.role,
      this.image,
      this.password,
      this.firstName,
      this.lastName,
      this.children,
      this.creator,
      this.lessonProgressions,
      this.numberOfSessions,
      this.reports,
      this.gender,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.classe,
      this.parentOfStudent});

  Children.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    role = json['role'];
    image = json['image'];
    password = json['password'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    /*if (json['children'] != null) {
			children = <Null>[];
			json['children'].forEach((v) { children!.add(new Null.fromJson(v)); });
		}*/
    creator = json['creator'];
    /*if (json['lessonProgressions'] != null) {
			lessonProgressions = <Null>[];
			json['lessonProgressions'].forEach((v) { lessonProgressions!.add(new Null.fromJson(v)); });
		}*/
    numberOfSessions = json['numberOfSessions'];
    /*if (json['reports'] != null) {
			reports = <Null>[];
			json['reports'].forEach((v) { reports!.add(new Null.fromJson(v)); });
		}*/
    gender = json['gender'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    classe = json['class'] != null ? new Class.fromJson(json['class']) : null;

    parentOfStudent = json['parentOfStudent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['role'] = this.role;
    data['image'] = this.image;
    data['password'] = this.password;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    /*if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }*/
    data['creator'] = this.creator;
    /*if (this.lessonProgressions != null) {
      data['lessonProgressions'] = this.lessonProgressions!.map((v) => v.toJson()).toList();
    }*/
    data['numberOfSessions'] = this.numberOfSessions;
    /*if (this.reports != null) {
      data['reports'] = this.reports!.map((v) => v.toJson()).toList();
    }*/
    data['gender'] = this.gender;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.classe != null) {
      data['class'] = this.classe!.toJson();
    }
    data['parentOfStudent'] = this.parentOfStudent;
    return data;
  }
}

class Class {
  Body? body;

  Class({this.body});

  Class.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Body {
  Null? deletedAt;
  String? sId;
  String? title;
  String? description;
  bool? validated;
  //List<Students>? students;
  List<Null>? teachers;
  List<Null>? homeworks;
  //List<Courses>? courses;
  String? createdAt;
  String? updatedAt;
  int? v;

  Body(
      {this.deletedAt,
      this.sId,
      this.title,
      this.description,
      this.validated,
      this.teachers,
      this.homeworks,
      this.createdAt,
      this.updatedAt,
      this.v});

  Body.fromJson(Map<String, dynamic> json) {
    deletedAt = json['deletedAt'];
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    validated = json['validated'];
    /*if (json['students'] != null) {
			students = <Students>[];
			json['students'].forEach((v) { students!.add(new Students.fromJson(v)); });
		}
		if (json['teachers'] != null) {
			teachers = <Null>[];
			json['teachers'].forEach((v) { teachers!.add(new Null.fromJson(v)); });
		}
		if (json['homeworks'] != null) {
			homeworks = <Null>[];
			json['homeworks'].forEach((v) { homeworks!.add(new Null.fromJson(v)); });
		}
		if (json['courses'] != null) {
			courses = <Courses>[];
			json['courses'].forEach((v) { courses!.add(new Courses.fromJson(v)); });
		}*/
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json[' __v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deletedAt'] = this.deletedAt;
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['validated'] = this.validated;
    /*if (this.students != null) {
      data['students'] = this.students!.map((v) => v.toJson()).toList();
    }
		if (this.teachers != null) {
      data['teachers'] = this.teachers!.map((v) => v.toJson()).toList();
    }
		if (this.homeworks != null) {
      data['homeworks'] = this.homeworks!.map((v) => v.toJson()).toList();
    }
		if (this.courses != null) {
      data['courses'] = this.courses!.map((v) => v.toJson()).toList();
    }*/
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data[' __v'] = this.v;
    return data;
  }
}
