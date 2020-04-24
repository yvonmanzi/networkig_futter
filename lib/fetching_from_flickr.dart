import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:networking1/list_item.dart';

Future<List<GalleryItem>> fetchPhotos() async {
  final String apiKey = "4a1ba2026714d121e55531e3c296e737";
  final response = await http.get(
      "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=$apiKey&format=json&nojsoncallback=1");

  if (response.statusCode == 200) {
    debugPrint("succeded");
    print("$response");
    final jsonResponse = json.decode(response.body);

    //debugPrint(jsonResponse["photo"]);
    //List<Map<String, dynamic>> maps = jsonResponse['photos']['photo'];
    //final galleryItemList =
    //maps.map((element) => GalleryItem.fromJson(element)).toList();
    //return List<GalleryItem>.from(galleryItemList);
    //.map((item) => GalleryItem(
    // id: item["id"],
    //serverId: item['server'],
    // farmId: item['farm'],
    //secret: item['secret']))
    //.toList();
    List<GalleryItem> list = List<GalleryItem>();
    for (dynamic item in jsonResponse['photos']['photo']) {
      GalleryItem gItem = GalleryItem.fromJson(item);
      list.add(gItem);
    }
    return list;
  } else
    throw Exception('failed to feetch data');
}

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
              margin: EdgeInsets.all(16.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: items,
                    builder: (context, snapshot) {
                      if (snapshot.hasData)
                        return ListItem(snapshot.data[index].buildImageUrl(),
                            snapshot.data[index].title);
                      else if (snapshot.hasError)
                        return Text("{$snapshot.error}");
                      else
                        return CircularProgressIndicator();
                    },
                  );
                },
              ),
            ),
          ),
        ));
  }
}

class GalleryItem {
  String id;
  String serverId;
  int farmId;
  String secret;
  String title;
  String url;

  GalleryItem({this.id, this.serverId, this.farmId, this.secret, this.title});

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
        id: json['id'],
        serverId: json['server'],
        farmId: json['farm'],
        secret: json['secrete'],
        title: json['title']);
  }

  String buildImageUrl() {
    return "https://farm$farmId.staticflickr.com/$serverId/$id-$secret.jpg";
  }
}
//https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
