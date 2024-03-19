import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DiscoveryPage1 extends StatefulWidget {
  const DiscoveryPage1({Key? key}) : super(key: key);

  @override
  State<DiscoveryPage1> createState() => _DiscoveryPage1State();
}

class _DiscoveryPage1State extends State<DiscoveryPage1> {
  List<dynamic> users = [];
  int page = 1;
  int limit = 10;
  bool isLoading = false;
  bool hasMore = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getUsers();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discovery Page'),
        backgroundColor: Colors.redAccent.shade100,
      ),
      body: ListView.builder(
        itemCount: users.length + (hasMore ? 1 : 0),
        controller: _scrollController,
        itemBuilder: (context, index) {
          if (index < users.length) {
            return Card(
              elevation: 22,
              child: ListTile(
                title: Text(
                  users[index]['title'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                subtitle: Text(
                  users[index]['description'],
                  style: TextStyle(fontSize: 20),
                ),
                leading: CircleAvatar(
                  radius: 25,
                  child: Image.network(users[index]['image_url']),
                ),
              ),
            );
          } else if (hasMore) {
            return Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  getUsers() async {
    if (!isLoading && hasMore) {
      setState(() {
        isLoading = true;
      });

      final url = 'https://api-stg.together.buzz/mocks/discovery';
      final response =
          await http.get(Uri.parse('$url?page=$page&limit=$limit'));
      final body = response.body;
      final json = jsonDecode(body);

      setState(() {
        users.addAll(json['data']);

        if (json['data'].isEmpty) {
          hasMore = false;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('All user data fetched'),
              duration: Duration(seconds: 2),
            ),
          );
        }
       page++;
        isLoading = false;
      });

      print('Users fetched - Page: $page');
    }
  }

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      getUsers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
