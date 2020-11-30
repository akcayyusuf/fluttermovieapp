import 'package:flutter/material.dart';

import 'package:movie_app/pages/mainpage.dart';
import 'package:movie_app/pages/infopage.dart';
import 'package:movie_app/pages/mainpagenew.dart';
import 'package:movie_app/pages/wishes.dart';
import 'package:movie_app/pages/watchedpage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //home: Basepage(),
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/home2': (context) => Homenew(),
      '/watched': (context) => Watched(),
      '/wishes': (context) => Wishlist(),
      '/info': (context) => Info(),
    },
  ));
}
