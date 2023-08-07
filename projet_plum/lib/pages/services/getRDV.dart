import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getDataRDVFuture =
    ChangeNotifierProvider<GetDataRDVFuture>((ref) => GetDataRDVFuture());

class GetDataRDVFuture extends ChangeNotifier {
  List<Appointment> listAppointment = [];

  GetDataRDVFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    try {
      http.Response response = await http.get(
        Uri.parse('http://13.39.81.126:7001/api/appointments/fetch/all'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print(
          '**************************************************** get appointment');
      print(response.statusCode);

      //print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            if (data[i]['validated'] == false) {
              listAppointment.add(Appointment.fromJson(data[i]));
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

class Appointment {
  String? sId;
  Creator? creator;
  String? time;
  String? date;
  String? motif;
  bool? validated;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Appointment(
      {this.sId,
      this.creator,
      this.time,
      this.date,
      this.motif,
      this.validated,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Appointment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    creator =
        json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
    time = json['time'];
    date = json['date'];
    motif = json['motif'];
    validated = json['validated'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.creator != null) {
      data['creator'] = this.creator!.toJson();
    }
    data['time'] = this.time;
    data['date'] = this.date;
    data['motif'] = this.motif;
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
  String? image;
  String? password;
  String? firstName;
  String? lastName;
  List<String>? children;
  String? creator;
  List<Null>? lessonProgressions;
  int? numberOfSessions;
  bool? gender;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? behavior;
  List<Null>? behaviors;
  bool? report;
  List<Null>? reports;

  Creator(
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
      this.gender,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.behavior,
      this.behaviors,
      this.report,
      this.reports});

  Creator.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
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
    }*/
    numberOfSessions = json['numberOfSessions'];
    gender = json['gender'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    behavior = json['behavior'];
    /*if (json['behaviors'] != null) {
      behaviors = <Null>[];
      json['behaviors'].forEach((v) {
        behaviors!.add(new Null.fromJson(v));
      });
    }
    report = json['report'];
    if (json['reports'] != null) {
      reports = <Null>[];
      json['reports'].forEach((v) {
        reports!.add(new Null.fromJson(v));
      });
    }*/
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
    data['children'] = this.children;
    data['creator'] = this.creator;
    /*if (this.lessonProgressions != null) {
      data['lessonProgressions'] =
          this.lessonProgressions!.map((v) => v.toJson()).toList();
    }*/
    data['numberOfSessions'] = this.numberOfSessions;
    data['gender'] = this.gender;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['behavior'] = this.behavior;
    /*if (this.behaviors != null) {
      data['behaviors'] = this.behaviors!.map((v) => v.toJson()).toList();
    }
    data['report'] = this.report;
    if (this.reports != null) {
      data['reports'] = this.reports!.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}
