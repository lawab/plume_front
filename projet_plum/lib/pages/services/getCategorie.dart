import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getDataCategorieFuture = ChangeNotifierProvider<GetDataCategorieFuture>(
    (ref) => GetDataCategorieFuture());

class GetDataCategorieFuture extends ChangeNotifier {
  List<Categorie> listCategorie = [];

  GetDataCategorieFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var url_Categorie = prefs.getString('url_Categorie');

    try {
      http.Response response = await http.get(
        Uri.parse('$url_Categorie/api/subjects/fetch/all'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print(response.statusCode);
      print(
          '********************************************************get Categorie');
      //print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            // if (data[i]['role'] != 'SUDO') {
            listCategorie.add(Categorie.fromJson(data[i]));
            // }
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

class Categorie {
  String? sId;
  String? title;
  String? description;
  String? image;
  List<String>? courses;
  Creator? creator;
  bool? validated;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Categorie(
      {this.sId,
      this.title,
      this.description,
      this.image,
      this.courses,
      this.creator,
      this.validated,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Categorie.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    courses = json['courses'].cast<String>();
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
    data['courses'] = this.courses;
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
