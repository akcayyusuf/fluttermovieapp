import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/veritabani/dbhelper.dart';
import 'package:movie_app/veritabani/wmovie.dart';

import 'infopage.dart';

class Wishlist extends StatefulWidget {
  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  VTyardimcisi vTyardimcisi = new VTyardimcisi();
  List<Mymovies> wfilmler = new List();
  int sayi;
  @override
  void initState() {
    listeyenile();
    super.initState();
    moviegetir2().then((gelen) {
      wfilmler = gelen;
      sayi = wfilmler.length;
    });
  }

  listeyenile() {
    moviegetir2().then((gelen) {
      wfilmler = gelen;
      sayi = wfilmler.length;
    });
  }

  Future<List<Mymovies>> moviegetir2() async {
    var veritab = await vTyardimcisi.veritabani;
    List<Map> liste = await veritab.rawQuery("SELECT* FROM uwmovie");
    List<Mymovies> izlenenler = new List();

    for (int i = 0; i < liste.length; i++) {
      setState(() {
        var ifilm = new Mymovies(liste[i]["isim"], liste[i]["yil"],
            liste[i]["tarih"], liste[i]["image"], liste[i]["Imdb"]);
        ifilm.numaraver(liste[i]["id"]);
        izlenenler.add(ifilm);
      });
    }
    return izlenenler;
  }

  imsil(Mymovies movie) {
    vTyardimcisi.moviesil(movie, "uwmovie").then((cvp) {
      if (cvp > 0) {
        setState(() => listeyenile());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 15,
        shadowColor: Colors.grey[900],
        iconTheme: new IconThemeData(color: Colors.amber),
        backgroundColor: Color.fromRGBO(11, 28, 39, 1),
        title: Text("İzlemek istediklerim",
            style: TextStyle(color: Color.fromRGBO(244, 165, 33, 1))),
        centerTitle: true,
      ),
      backgroundColor: Color.fromRGBO(38, 48, 54, 1),
      body: ListView.builder(
        itemCount: wfilmler.length,
        itemBuilder: (BuildContext contex, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Info(value: wfilmler[index].imdb)));
            },
            child: Card(
              elevation: 1,
              color: Color.fromRGBO(14, 25, 32, 1),
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            '${wfilmler[index].url}',
                            fit: BoxFit.cover,
                            height: 150,
                            width: 100,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                padding: EdgeInsets.only(top: 20),
                                child: Icon(
                                  Icons.movie,
                                  size: 60,
                                  color: Color.fromRGBO(190, 195, 215, 1),
                                ),
                              );
                            },
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.amber),
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
                            '${wfilmler[index].isim}',
                            style: TextStyle(
                                color: Color.fromRGBO(190, 195, 215, 1),
                                fontSize: 18),
                          ),
                        ]),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 12),
                        width: 180,
                        child: Wrap(children: [
                          Text(
                            '${wfilmler[index].date}',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                          ),
                        ]),
                      ),
                    ]),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.all(3),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.alarm,
                                    color: Color.fromRGBO(190, 195, 215, 1),
                                  ),
                                  onPressed: () {}),
                            ),
                            SizedBox(height: 40),
                            ButtonBar(
                              buttonMinWidth: 70,
                              children: [
                                RaisedButton(
                                  padding: EdgeInsets.all(0),
                                  color: Color.fromRGBO(48, 95, 214, 1),
                                  child: Text(
                                    'SİL',
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(190, 195, 215, 1)),
                                  ),
                                  onPressed: () => imsil(wfilmler[index]),
                                ),
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
    );
  }
}
