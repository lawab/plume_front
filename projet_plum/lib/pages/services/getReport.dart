import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getDataReportsFuture = ChangeNotifierProvider<GetDataReportsFuture>(
    (ref) => GetDataReportsFuture());

class GetDataReportsFuture extends ChangeNotifier {
  List<Reports> listReports = [];

  GetDataReportsFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    try {
      http.Response response = await http.get(
        Uri.parse('http://13.39.81.126:7001/api/reports/fetch/all'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print('**************************************************** get Reports');
      print(response.statusCode);

      //print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            listReports.add(Reports.fromJson(data[i]));
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

class Reports {
  String? sId;
  String? creator;
  String? report;
  bool? validated;
  String? date;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Reports(
      {this.sId,
      this.creator,
      this.report,
      this.validated,
      this.date,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Reports.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    creator = json['creator'];
    report = json['report'];
    validated = json['validated'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['creator'] = this.creator;
    data['report'] = this.report;
    data['validated'] = this.validated;
    data['date'] = this.date;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
