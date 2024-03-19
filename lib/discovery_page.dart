import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({Key? key}) : super(key: key);

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
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
          if (index < users.length && index < 10) {
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
          } else {
            // Loading indicator at the end of the list
            return Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : hasMore
                        ? SizedBox()
                        : Text('No more items'),
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
      // Load more data when reaching the end of the list
      getUsers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
