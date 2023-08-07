import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getDataBehaviorFuture = ChangeNotifierProvider<GetDataBehaviorFuture>(
    (ref) => GetDataBehaviorFuture());

class GetDataBehaviorFuture extends ChangeNotifier {
  List<Behavior> listBehavior = [];

  GetDataBehaviorFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    try {
      http.Response response = await http.get(
        Uri.parse('http://13.39.81.126:7001/api/behaviors/fetch/all'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print(
          '**************************************************** get Behavior');
      print(response.statusCode);

      //print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            listBehavior.add(Behavior.fromJson(data[i]));
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

class Behavior {
  String? sId;
  String? creator;
  String? gravity;
  String? motif;
  bool? validated;
  Course? course;
  String? date;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Behavior(
      {this.sId,
      this.creator,
      this.gravity,
      this.motif,
      this.validated,
      this.course,
      this.date,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Behavior.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    creator = json['creator'];
    gravity = json['gravity'];
    motif = json['motif'];
    validated = json['validated'];
    course =
        json['course'] != null ? new Course.fromJson(json['course']) : null;
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['creator'] = this.creator;
    data['gravity'] = this.gravity;
    data['motif'] = this.motif;
    data['validated'] = this.validated;
    if (this.course != null) {
      data['course'] = this.course!.toJson();
    }
    data['date'] = this.date;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Course {
  String? sId;
  String? title;
  String? description;
  String? image;
  List<Null>? sections;
  Creator? creator;
  String? subject;
  bool? validated;
  Null deletedAt;
  //List<Classes>? classes;
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
      //this.classes,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Course.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    /*if (json['sections'] != null) {
      sections = <Null>[];
      json['sections'].forEach((v) {
        sections!.add(new Null.fromJson(v));
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
