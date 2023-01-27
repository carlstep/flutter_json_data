// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<Album> parseAlbums(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Album>((json) => Album.fromJson(json)).toList();
}

Future<List<Album>> fetchAlbum(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

  return compute(parseAlbums, response.body);
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        userId: json["userId"] as int,
        id: json["id"] as int,
        title: json["title"] as String,
      );

  // Map<String, dynamic> toJson() => {
  //       "userId": userId,
  //       "id": id,
  //       "title": title,
  //     };
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String appTitle = ' JSON ListView';
    return MaterialApp(
      home: MyPage1(title: appTitle),
    );
  }
}

class MyPage1 extends StatelessWidget {
  const MyPage1({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Album>>(
        future: fetchAlbum(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('has error'),
            );
          } else if (snapshot.hasData) {
            return AlbumList(albums: snapshot.data!);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class AlbumList extends StatelessWidget {
  const AlbumList({
    Key? key,
    required this.albums,
  }) : super(key: key);

  final List<Album> albums;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: albums.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      leading: Text(albums[index].userId.toString()),
                      title: Text(albums[index].title.toString()),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
