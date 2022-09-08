import 'dart:convert';

import 'dart:ui';

import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/pages/infopage.dart';
import 'package:movie_app/pages/watchedpage.dart';
import 'package:movie_app/pages/wishes.dart';
import 'package:movie_app/veritabani/dbhelper.dart';
import 'package:movie_app/veritabani/wmovie.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final FirebaseMessaging messaging = FirebaseMessaging();
  GlobalKey bottomNavigationKey = GlobalKey();

  Color bg = Color.fromRGBO(38, 48, 54, 1);

  Color card = Color.fromRGBO(14, 25, 32, 1);
  Color appbar = Color.fromRGBO(11, 28, 39, 1);

  Color main = Color.fromRGBO(190, 195, 215, 1);
  Color butt = Color.fromRGBO(48, 95, 214, 1);
  Color icon = Color.fromRGBO(244, 165, 33, 1);
  Color sub;

  VTyardimcisi vTyardimcisi = new VTyardimcisi();
  final GlobalKey<State> _listKey = GlobalKey();

  GlobalKey<RefreshIndicatorState> refreshkey;
  var data;
  int result = 0;
  final controller = TextEditingController();
  final generalcontroller = GlobalKey<FormState>();
  final pagectrl = PageController(initialPage: 0);
  List<Movie> tagObjs = [];
  List<Mymovies> izlenenler = [];
  List<Mymovies> later = [];
  List<String> name = [];
  List<String> url = [];
  List<String> year = [];
  int _selectedIndex = 0;
  var now = new DateTime.now();
  movieekle(int index, String table) {
    vTyardimcisi.moviegetir("wmovie").then((value) => izlenenler = value);
    vTyardimcisi
        .moviekaydet(
            new Mymovies(
                (tagObjs[index].ad).toString(),
                (tagObjs[index].yil).toString(),
                "${now.day}/" + "${now.month}/" + "${now.year}",
                (tagObjs[index].img).toString(),
                tagObjs[index].imdb),
            table)
        .then((deger) {
      debugPrint(deger.toString());
    });
  }

  listeyenile() {
    vTyardimcisi.moviegetir("wmovie").then((gelen) {
      setState(() {
        izlenenler = gelen;
      });
    });
    vTyardimcisi.moviegetir("uwmovie").then((value) {
      setState(() {
        later = value;
      });
    });
  }

  RaisedButton getbutton(int numara) {
    for (int i = 0; i < izlenenler.length; i++) {
      if (tagObjs[numara].imdb == izlenenler[i].imdb) {
        return RaisedButton(
          color: Colors.blueGrey[900],
          child: Icon(
            Icons.done,
            color: Colors.black,
          ),
          onPressed: () {},
        );
      }
    }

    return RaisedButton(
      padding: EdgeInsets.all(3),
      color: butt,
      child: Text(
        'İZLEDİM',
        style: TextStyle(color: main),
      ),
      onPressed: () {
        movieekle(numara, "wmovie");
        listeyenile();

        Fluttertoast.showToast(
            msg: "İzleneler Listesine Eklendi.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey[700],
            textColor: Colors.white,
            fontSize: 16.0);
      },
    );
  }

  IconButton geticon(int numara) {
    for (int i = 0; i < later.length; i++) {
      if (tagObjs[numara].imdb == later[i].imdb) {
        return IconButton(
            icon: Icon(
              Icons.done,
              color: main,
            ),
            onPressed: () {});
      }
    }

    return IconButton(
        icon: Icon(
          Icons.alarm,
          color: main,
        ),
        onPressed: () {
          movieekle(numara, "uwmovie");
          listeyenile();

          Fluttertoast.showToast(
              msg: "Daha Sonra İzle Listesine Eklendi.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey[700],
              textColor: Colors.white,
              fontSize: 16.0);
        });
  }

  @override
  void initState() {
    super.initState();

    refreshkey = GlobalKey<RefreshIndicatorState>();

    listeyenile();
  }

  void _onItemTapped(int index) {
    setState(() {
      pagectrl.animateToPage(index,
          duration: Duration(milliseconds: 250), curve: Curves.ease);
      _selectedIndex = index;

      print(pagectrl.page);
      print(index);
    });
    if (_selectedIndex == 0) {
      listeyenile();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void getdata(String ara) async {
    http
        .get("http://www.omdbapi.com/?s=${ara.trimRight()}&apikey=SECRET API KEY")
        .then((answer) {
      var data = jsonDecode(answer.body)['Search'] as List;
      tagObjs = data.map((tagJson) => Movie.fromJson(tagJson)).toList();
      setState(() {
        listeyenile();
        result = tagObjs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      bottomNavigationBar: FancyBottomNavigation(
        activeIconColor: appbar,
        key: bottomNavigationKey,
        inactiveIconColor: main,
        circleColor: icon,
        barBackgroundColor: appbar,
        textColor: icon,
        initialSelection: 0,
        tabs: [
          TabData(
              iconData: Icons.home,
              title: "Anasayfa",
              onclick: (number) {
                _selectedIndex = number;
                _onItemTapped(_selectedIndex);
              }),
          TabData(
              iconData: Icons.bookmark,
              title: "Listelerin",
              onclick: (number) {
                _selectedIndex = number;
                _onItemTapped(_selectedIndex);
              }),
          TabData(
              iconData: Icons.person,
              title: "Profil",
              onclick: (number) {
                _selectedIndex = number;
                _onItemTapped(_selectedIndex);
              })
        ],
        onTabChangedListener: (position) {
          setState(() {
            _selectedIndex = position;

            _onItemTapped(_selectedIndex);
          });
        },
      ),
      body: PageView(
        controller: pagectrl,
        children: <Widget>[
          Column(
            children: [
              AppBar(
                title: Form(
                  key: generalcontroller,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          onFieldSubmitted: (value) {
                            String ara = controller.text;

                            getdata(ara);

                            result = tagObjs.length;
                            return value;
                          },
                          validator: (search) {
                            return search;
                          },
                          controller: controller,
                          style: TextStyle(color: icon, fontSize: 16),
                          decoration: InputDecoration(
                              hintText: "Hoşgeldin Başkan",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              border: InputBorder.none),
                        )
                      ],
                    ),
                  ),
                ),
                backgroundColor: appbar,
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.search),
                      color: icon,
                      onPressed: () {
                        String ara = controller.text;

                        getdata(ara);

                        result = tagObjs.length;
                      }),
                ],
                iconTheme: new IconThemeData(color: icon),
                elevation: 15,
                shadowColor: Colors.grey[900],
              ),
              Flexible(
                child: RefreshIndicator(
                  key: refreshkey,
                  onRefresh: () async {
                    await Future.delayed(Duration(seconds: 1));
                    listeyenile();
                  },
                  color: main,
                  backgroundColor: Colors.grey[800],
                  strokeWidth: 2.5,
                  child: new ListView.builder(
                    padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
                    key: _listKey,
                    itemCount: result,
                    itemBuilder: (BuildContext cntx, int index) {
                      return new GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  Info(value: tagObjs[index].imdb)));
                        },
                        child: Card(
                          elevation: 1,
                          color: card,
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        '${tagObjs[index].img}',
                                        fit: BoxFit.cover,
                                        height: 150,
                                        width: 100,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 100,
                                            padding: EdgeInsets.only(top: 20),
                                            child: Icon(
                                              Icons.movie,
                                              size: 60,
                                              color: main,
                                            ),
                                          );
                                        },
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      butt),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Column(children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(top: 12),
                                    width: 180,
                                    child: Wrap(children: [
                                      Text(
                                        '${tagObjs[index].ad}',
                                        style: TextStyle(
                                            color: main, fontSize: 18),
                                      ),
                                    ]),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 12),
                                    width: 180,
                                    child: Wrap(children: [
                                      Text(
                                        '${tagObjs[index].yil}',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14),
                                      ),
                                    ]),
                                  ),
                                ]),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 12),
                                          child: geticon(index),
                                          // IconButton(
                                          //     icon: Icon(
                                          //       Icons.alarm,
                                          //       color: main,
                                          //     ),
                                          //     onPressed: () {
                                          //       movieekle(index, "uwmovie");
                                          //       Fluttertoast.showToast(
                                          //           msg:
                                          //               "Daha Sonra İzle Listesine Eklendi.",
                                          //           toastLength:
                                          //               Toast.LENGTH_SHORT,
                                          //           gravity:
                                          //               ToastGravity.BOTTOM,
                                          //           timeInSecForIosWeb: 1,
                                          //           backgroundColor:
                                          //               Colors.grey[700],
                                          //           textColor: Colors.white,
                                          //           fontSize: 16.0);
                                          //     }),
                                        ),
                                        SizedBox(height: 40),
                                        ButtonBar(
                                          buttonMinWidth: 70,
                                          children: [
                                            getbutton(index),
                                          ],
                                        )
                                      ]),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Watched(),
          Wishlist(),
        ],
        onPageChanged: (value) {
          setState(() {
            final FancyBottomNavigationState fState =
                bottomNavigationKey.currentState;

            _selectedIndex = value;

            fState.setPage(value);

            if (value == 0) {
              listeyenile();
            }
          });
        },
      ),
      drawer: Drawer(
        child: Container(
          color: bg,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'Buraya ne olacağı belli değil',
                  style: TextStyle(fontSize: 30, color: appbar),
                ),
                decoration: BoxDecoration(color: icon),
              ),
              ListTile(
                leading: Icon(
                  Icons.check,
                  color: main,
                ),
                title: Text(
                  'İzlediklerin',
                  style: TextStyle(color: main),
                ),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/watched');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.alarm,
                  color: main,
                ),
                title: Text(
                  'İstek listen',
                  style: TextStyle(color: main),
                ),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/wishes');
                },
              ),
              ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: main,
                  ),
                  title: Text(
                    "Yusuf Akçay",
                    style: TextStyle(color: main),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class Movie {
  String ad;
  String yil;
  String img;
  String imdb;
  Movie(this.ad, this.yil, this.img, this.imdb);

  factory Movie.fromJson(dynamic json) {
    return Movie(json['Title'] as String, json['Year'] as String,
        json['Poster'], json["imdbID"] as String);
  }

  @override
  String toString() {
    return '{ ${this.ad}, ${this.yil},${this.img} ,${this.imdb}}';
  }
}
