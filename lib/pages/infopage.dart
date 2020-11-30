import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;

class Info extends StatefulWidget {
  String value;
  Info({this.value});

  @override
  _InfoState createState() => _InfoState(value);
}

class _InfoState extends State<Info> {
  String value;
  _InfoState(this.value);
  List<MovieInfo> intel = [];

  MovieInfo mvi;

  String isim = "yusuf";
  String year = "null";
  String poster = "null";

  String imdbid = "null";
  String actors = "null";

  String genre = "null";
  String summary = "null";
  String mscore = "0";
  String iscore = "0";
  String tomato = "0";
  List<Rating> rating = [];
  void getinfo(String ara) {
    http
        .get("http://www.omdbapi.com/?i=$ara&plot=full&apikey=9792ea93")
        .then((answer) {
      var info = jsonDecode(answer.body);
      var data = jsonDecode(answer.body)['Ratings'] as List;
      rating = data.map((rating) => Rating.fromJson(rating)).toList();
      mvi = new MovieInfo.fromJson(info);
      setState(() {
        isim = mvi.name;
        year = mvi.year;
        poster = mvi.poster;
        actors = mvi.actors;
        genre = mvi.genre;
        summary = mvi.summary;
        mscore = mvi.metacritic;
        iscore = mvi.imdbscore;
        try {
          tomato = rating[1].value;
        } catch (hata) {
          tomato = "N/A";
        }
      });

      // intel = info.map((tagJson) => MovieInfo.fromJson(tagJson)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getinfo(value);
  }

  String sendinfo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.amber),
          backgroundColor: Color.fromRGBO(11, 28, 39, 1),
          title: Text(
            "Bilgi",
            style: TextStyle(color: Color.fromRGBO(244, 165, 33, 1)),
          ),
        ),
        backgroundColor: Color.fromRGBO(38, 48, 54, 1),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  poster != "null"
                      ? Image.network(
                          poster,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromRGBO(244, 165, 33, 1)),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.movie,
                              size: 50,
                              color: Color.fromRGBO(244, 165, 33, 1),
                            );
                          },
                          height: 150,
                          width: 100,
                          fit: BoxFit.fill,
                        )
                      : CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromRGBO(244, 165, 33, 1)),
                        ),
                  SizedBox(width: 20),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isim,
                        style: TextStyle(
                            color: Color.fromRGBO(244, 165, 33, 1),
                            fontSize: 22),
                      ),
                      Divider(
                        color: Color.fromRGBO(244, 165, 33, 1),
                        thickness: 2,
                      ),
                      Text(
                        genre,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                      Divider(color: Colors.grey[850]),
                      Text(
                        year,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      )
                    ],
                  ))
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                            child: Text(
                              tomato,
                              style: TextStyle(
                                  color: Color.fromRGBO(190, 195, 215, 1),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            radius: 30,
                            backgroundColor: Color.fromRGBO(11, 28, 39, 1)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "R. Tomatoes",
                          style: TextStyle(
                              color: Color.fromRGBO(190, 195, 215, 1)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                            child: Text(
                              iscore,
                              style: TextStyle(
                                  color: Color.fromRGBO(190, 195, 215, 1),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            radius: 30,
                            backgroundColor: Color.fromRGBO(11, 28, 39, 1)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Imdb",
                          style: TextStyle(
                              color: Color.fromRGBO(190, 195, 215, 1)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Text(
                            mscore.toString(),
                            style: TextStyle(
                                color: Color.fromRGBO(190, 195, 215, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          radius: 30,
                          backgroundColor: Color.fromRGBO(11, 28, 39, 1),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Metacritic",
                          style: TextStyle(
                              color: Color.fromRGBO(190, 195, 215, 1)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Kısa Özet",
                style: TextStyle(
                    color: Color.fromRGBO(244, 165, 33, 1), fontSize: 16),
              ),
              Divider(
                color: Color.fromRGBO(244, 165, 33, 1),
                thickness: 2,
              ),
              Text(
                summary,
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              SizedBox(height: 30),
              Text(
                "Oyuncular",
                style: TextStyle(
                    color: Color.fromRGBO(244, 165, 33, 1), fontSize: 16),
              ),
              Divider(
                color: Color.fromRGBO(244, 165, 33, 1),
                thickness: 2,
              ),
              Text(
                actors,
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              SizedBox(height: 30),
              Center(
                  child: SmoothStarRating(
                color: Color.fromRGBO(244, 165, 33, 1),
                isReadOnly: false,
                size: 40,
                filledIconData: Icons.star,
                halfFilledIconData: Icons.star_half,
                defaultIconData: Icons.star,
                borderColor: Colors.grey[400],
                starCount: 5,
                allowHalfRating: false,
                spacing: 2.0,
                onRated: (value) {
                  print("rating value -> $value");
                  // print("rating value dd -> ${value.truncate()}");
                },
              )),
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
            closeManually: false,
            backgroundColor: Color.fromRGBO(48, 95, 214, 1),
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme:
                new IconThemeData(color: Color.fromRGBO(190, 195, 215, 1)),
            overlayOpacity: 0,
            children: [
              SpeedDialChild(
                backgroundColor: Colors.grey[900],
                child: Icon(
                  Icons.done,
                  color: Color.fromRGBO(48, 95, 214, 1),
                ),
                onTap: () {},
              ),
              SpeedDialChild(
                backgroundColor: Colors.grey[900],
                child: Icon(
                  Icons.alarm,
                  color: Color.fromRGBO(48, 95, 214, 1),
                ),
                onTap: () {
                  setState(() {
                    print("yenile");
                  });
                },
              )
            ]));
  }
}

class MovieInfo {
  String name;
  String year;
  String poster;
  String imdbscore;
  String imdbid;
  String actors;
  String tomato;
  String metacritic;
  String genre;
  String summary;
  MovieInfo(this.name, this.year, this.poster, this.imdbscore, this.imdbid,
      this.actors, this.tomato, this.genre, this.metacritic, this.summary);

  factory MovieInfo.fromJson(dynamic json) {
    return MovieInfo(
        json['Title'] as String,
        json['Year'] as String,
        json['Poster'] as String,
        json["imdbRating"] as String,
        json["imdbID"] as String,
        json["Actors"] as String,
        "json[] as String",
        json["Genre"] as String,
        json["Metascore"] as String,
        json["Plot"] as String);
  }

  @override
  String toString() {
    return '{ ${this.name}, ${this.year},${this.poster} ,${this.imdbscore}, ${this.imdbid}, ${this.actors},${this.tomato} ,${this.genre} ${this.metacritic}, ${this.summary}}';
  }
}

class Rating {
  String source;
  String value;
  Rating(this.source, this.value);
  factory Rating.fromJson(dynamic json) {
    return Rating(json["Source"] as String, json["Value"] as String);
  }

  @override
  String toString() {
    return '{ ${this.source}, ${this.value}}';
  }
}

//{"Title":"Ford v Ferrari","Year":"2019","Rated":"PG-13","Released":"15 Nov 2019","Runtime":"152 min","Genre":"Action, Biography, Drama, Sport","Director":"James Mangold","Writer":"Jez Butterworth, John-Henry Butterworth, Jason Keller","Actors":"Matt Damon, Christian Bale, Jon Bernthal, Caitriona Balfe","Plot":"American car designer Carroll Shelby and driver Ken Miles battle corporate interference and the laws of physics to build a revolutionary race car for Ford in order to defeat Ferrari at the 24 Hours of Le Mans in 1966.","Language":"English, Italian, French, Japanese","Country":"USA","Awards":"Won 2 Oscars. Another 21 wins & 74 nominations.","Poster":"https://m.media-amazon.com/images/M/MV5BM2UwMDVmMDItM2I2Yi00NGZmLTk4ZTUtY2JjNTQ3OGQ5ZjM2XkEyXkFqcGdeQXVyMTA1OTYzOTUx._V1_SX300.jpg","Ratings":[{"Source":"Internet Movie Database","Value":"8.1/10"},{"Source":"Rotten Tomatoes","Value":"92%"},{"Source":"Metacritic","Value":"81/100"}],"Metascore":"81","imdbRating":"8.1","imdbVotes":"252,538","imdbID":"tt1950186","Type":"movie","DVD":"N/A","BoxOffice":"N/A","Production":"20th Century Fox","Website":"N/A","Response":"True"}
