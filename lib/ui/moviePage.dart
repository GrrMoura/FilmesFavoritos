import 'package:flutter/material.dart';
import 'package:share/share.dart';


class MoviePage extends StatelessWidget {
  final Map _movieData;

  MoviePage(this._movieData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_movieData["title"]),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(_movieData["results"]["poster_path"]);
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_movieData["results"]["poster_path"]),
      ),
    );
  }
}
