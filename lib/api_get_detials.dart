import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiGetUsers extends StatefulWidget {
  const ApiGetUsers({super.key});

  @override
  State<ApiGetUsers> createState() => _ApiGetUsersState();
}

class _ApiGetUsersState extends State<ApiGetUsers> {
  List<dynamic> users = [];

  //List<dynamic> idUsers = [];
  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rest API Call'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          // final user = users[index];
          // final email =user['email'];
          // final name = user['name']['first'];
          // final picture = user['picture']['thumbnail'];
          return SizedBox(
            height: 85,
            child: Card(
              elevation: 15,
              child: ListTile(
                title: Text(users[index]['title']),
                subtitle: Text(users[index]['description']),
                leading: CircleAvatar(
                  radius: 15,
                  child: Image.network(users[index]['image_url']),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getUsers();
          //postUsers();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  getUsers() async {
    final url = 'https://api-stg.together.buzz/mocks/discovery?page=1&limit=10';
    // final url = 'https://jsonplaceholder.typicode.com/posts';
    final response = await http.get(Uri.parse(url));
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json['data'];
    });
    print('Users fetched');
  }

  postUsers() async {
    final url = 'https://jsonplaceholder.typicode.com/posts';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: {'userId': '5', 'title': 'Nature', 'body': 'Hello Earth'});
    final body = response.body;
    final json = jsonDecode(body);
    print(response.body);
  }
}
