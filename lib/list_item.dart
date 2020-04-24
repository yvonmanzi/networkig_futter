// TODO Implement this library.

import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  ListItem(this.imageUrl, this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.network(imageUrl),
          Text(title),
        ],
      ),
    );
  }
}
