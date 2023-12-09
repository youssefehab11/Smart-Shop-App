import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class test2 extends StatelessWidget{

  Future<List> testtt(String itemName)async{
    List x = [];
    List y = [];
    //var url = Uri.http("https://smartapplication.pythonanywhere.com/recommend/10/cimun");
    var url = Uri.https('smartapplication.pythonanywhere.com', '/recommend/10/${itemName}');
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body);
    x.addAll(responseBody);
    y.add(x);
    print(x);
    //print(y);
    return x;
  }

  @override
  Widget build(BuildContext context) {
    List y = ["Cumin","Shrimp"];
    List x = [];
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () async{
            for(int i = 0; i< y.length; i++){
              x.add(await testtt(y[i])) ;
            }
            print(x);
          },
          child: const Text("Get data"),
        ),
      ),
    );
  }

}