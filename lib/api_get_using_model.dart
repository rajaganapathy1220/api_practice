import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'model_class.dart';

class ApiGetUsingModel extends StatefulWidget {
  const ApiGetUsingModel({super.key});

  @override
  State<ApiGetUsingModel> createState() => _ApiGetUsingModelState();
}

class _ApiGetUsingModelState extends State<ApiGetUsingModel> {
  List<GetUsers> datas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api Get Users Using Model'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: datas.length,
          itemBuilder: (context, index) {
            final value = datas[index];
            return ListTile(
            // leading: Image.network(value.image),
              title: Text(value.title),
          //   subtitle: Text(value.description),
            );
          },
        ),
      ),
    );
  }

  fetchUsers() async {
    final url = 'https://api-stg.together.buzz/mocks/discovery?page=1&limit=20';
    Response response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> fetchedDatas = responseData['data'];
        final List<GetUsers> data = fetchedDatas
            .map((postJson) => GetUsers.fromJson(postJson))
            .toList();
        setState(() {
          datas = data;
        });
      }else{
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }
}
