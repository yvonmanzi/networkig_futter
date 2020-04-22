import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'list_item.dart';

class PhotoList extends StatefulWidget {
  @override
  _PhotoListState createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  String _title = "PhotoGallery";
  Future<List<GalleryItem>> items;

  @override
  void initState() {
    super.initState();
    items = fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "PhotoGallery",
        home: Scaffold(
          appBar: AppBar(
            title: Text(_title),
            backgroundColor: Colors.deepOrange,
          ),
          body: SafeArea(
            child: Container(
              child: ListView.builder(itemBuilder: (context, index) {
                // go construct the looks of the item.
                return FutureBuilder(
                  future: items,
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return ListItem(snapshot.data[index].buildImageUrl());
                    else if (snapshot.hasError)
                      return Text("{$snapshot.error}");
                    else
                      return CircularProgressIndicator();
                  },
                );
              }),
            ),
          ),
        ));
  }
}

Future<List<GalleryItem>> fetchPhotos() async {
  final String apiKey = "4a1ba2026714d121e55531e3c296e737";
  final response = await http.get(
      "https://www.flickr.com/services/rest/?method=flickr.getRecent & api_key= $apiKey ");

  if (response.statusCode == 200) {
    debugPrint("succeded");
    return json
        .decode(response.body)
        .map((photo) => GalleryItem(
            id: photo["id"],
            serverId: photo['server'],
            farmId: photo['farm'],
            secret: photo['secret']))
        .toList();
  } else
    throw Exception('failed to feetch data');
}

class GalleryItem {
  String id;
  String serverId;
  int farmId;
  String secret;

  GalleryItem({this.id, this.serverId, this.farmId, this.secret});

  factory GalleryItem.fromJson(json) {
    return GalleryItem(
      id: json['id'],
      serverId: json['server'],
      farmId: json['farm'],
      secret: json['secrete'],
    );
  }

  String buildImageUrl() {
    return "https://farm{$farmId}.staticflickr.com/{$serverId}/{$id}_{$secret}.jpg";
  }
}
