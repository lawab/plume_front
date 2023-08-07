import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getDataSectionFuture = ChangeNotifierProvider<GetDataSectionFuture>(
    (ref) => GetDataSectionFuture());

class GetDataSectionFuture extends ChangeNotifier {
  List<Section> listSection = [];

  GetDataSectionFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var idCours = prefs.getString('idCours');
    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://13.39.81.126:7002/api/sections/fetch/courses/$idCours'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print(response.statusCode);
      print(
          '********************************************************get Sections by Cours');
      //print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            listSection.add(Section.fromJson(data[i]));
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

class Section {
  String? sId;
  String? title;
  String? description;
  String? image;
  List<Null>? modules;
  String? course;
  Creator? creator;
  bool? validated;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Section(
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

  Section.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    /* if (json['modules'] != null) {
      modules = <Null>[];
      json['modules'].forEach((v) {
        modules!.add(new Null.fromJson(v));
      });
    }*/
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
    /* if (this.modules != null) {
      data['modules'] = this.modules!.map((v) => v.toJson()).toList();
    }*/
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
