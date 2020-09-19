import 'dart:ui';

import 'package:filmesFavoritos/ui/moviePage.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:transparent_image/transparent_image.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _search;
  int _offSet = 1;
  String url = "https://image.tmdb.org/t/p/w500";

  Future<Map> getMovie() async {
    http.Response response;
    if (_search == null) {
      response = await http.get(
          "https://api.themoviedb.org/3/trending/movie/week?api_key=2a9d95460bb797267bbb8c1f5fb5528b");
    } else {
      response = await http.get(
          "https://api.themoviedb.org/3/search/company?api_key=2a9d95460bb797267bbb8c1f5fb5528b&query=$_search&page=$_offSet");
    }

    return json.decode(response.body);
  }

  Future<Map> creatUrl() async {
    http.Response url;
    url = await http.get(
        "https://api.themoviedb.org/3/configuration?api_key=2a9d95460bb797267bbb8c1f5fb5528b");

    return jsonDecode(url.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Search"),
          leading: IconButton(
              color: Colors.white,
              icon: Icon(Icons.search),
              iconSize: 20,
              onPressed: () {}),
          backgroundColor: Colors.blue,
        ),
        backgroundColor: Colors.black,
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  labelText: "Pesquise Aqqqqui !",
                  labelStyle: TextStyle(color: Colors.white)),
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getMovie(),
              builder: (context, snappShot) {
                switch (snappShot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 6, // --> leia stroke
                      ),
                    );

                  default:
                    if (snappShot.hasError) {
                      return Container(
                        child: SizedBox(
                          height: 200,
                          width: 300,
                        ),
                      );
                    } else
                      return _createMovieTable(context,
                          snappShot); //_createGifTable(context, snappShot);
                }
              },
            ),
          ),
        ]));
  }

  int _getCount(List results) {
    if (_search == null) {
      return results.length;
    } else
      return results.length + 1;
  }

  Widget _createMovieTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemCount: _getCount(snapshot.data["results"]),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data["results"].length)
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["images"][index]["base_url"]["poster_sizes"]
                      ["3"] +
                  snapshot.data["results"][index]["poster_path"],
              width: 342.0,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MoviePage(snapshot.data["results"][index])));
            },
          );
        else
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70.0,
                  ),
                  Text(
                    "Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  _offSet += 19;
                });
              },
            ),
          );
      },
    );
  }
}
