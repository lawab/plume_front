import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_plum/pages/services/getUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getDataUserbyOneFuture = ChangeNotifierProvider<GetDataUserbyOneFuture>(
    (ref) => GetDataUserbyOneFuture());

class GetDataUserbyOneFuture extends ChangeNotifier {
  List<Children> listStudent = [];
  ParentOfStudent? parent;

  GetDataUserbyOneFuture() {
    getData();
  }

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var role = prefs.getString('Role');
    var idUser = prefs.getString('IdUser');
    //var idStu = prefs.getString('IdStudent');

    var idStu = prefs.getString('idSudent');
    var id = '';
    if (role == 'PARENT') {
      id = idUser!;
    } else {
      id = idStu!;
    }

    //print('http://13.39.81.126:7001/api/users/fetch/one/$id');
    try {
      http.Response response = await http.get(
        Uri.parse('http://13.39.81.126:7001/api/users/fetch/one/$id'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );
      print(response.statusCode);
      print('***************************************************Get fetch one');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (role == 'PARENT') {
          if (data['parentOfStudent'] != null) {
            parent = ParentOfStudent.fromJson(data['parentOfStudent']);
          } else {
            parent = null;
          }

          for (int i = 0; i < data['children'].length; i++) {
            if (data['children'][i]['deletedAt'] == null) {
              listStudent.add(Children.fromJson(data['children'][i]));
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
