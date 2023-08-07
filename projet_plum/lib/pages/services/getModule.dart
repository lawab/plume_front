import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getDataModulesFuture = ChangeNotifierProvider<GetDataModulesFuture>(
    (ref) => GetDataModulesFuture());

class GetDataModulesFuture extends ChangeNotifier {
  List<Modules> listModules = [];

  GetDataModulesFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var idSection = prefs.getString('idSection');
    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://13.39.81.126:7002/api/modules/fetch/sections/$idSection'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print(response.statusCode);
      print(
          '********************************************************get Module by section');
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            listModules.add(Modules.fromJson(data[i]));
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

class Modules {
  String? sId;
  String? title;
  String? description;
  String? file;
  String? typeModule;
  String? section;
  List<Null>? lessonProgressions;
  List<Null>? lessonComments;
  bool? validated;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isselect;
  String? content;

  Modules(
      {this.sId,
      this.title,
      this.description,
      this.file,
      this.typeModule,
      this.section,
      this.lessonProgressions,
      this.lessonComments,
      this.validated,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.isselect,
      this.content});

  Modules.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    file = json['file'];
    typeModule = json['typeModule'];
    section = json['section'];
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
    isselect = false;
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
    isselect = this.isselect;
    data['content'] = this.content;
    return data;
  }
}
