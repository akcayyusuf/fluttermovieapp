import 'package:flutter/material.dart';
import 'package:movie_app/pages/mainpage.dart';
import 'package:movie_app/veritabani/dbhelper.dart';
import 'package:movie_app/veritabani/wmovie.dart';

import 'infopage.dart';

class Watched extends StatefulWidget {
  @override
  _WatchedState createState() => _WatchedState();
}

class _WatchedState extends State<Watched> {
  Color icon = Color.fromRGBO(244, 165, 33, 1);
  VTyardimcisi vTyardimcisi = new VTyardimcisi();
  Home home = new Home();
  List<Mymovies> ifilmler = new List();
  int sayi;

  @override
  void initState() {
    listeyenile();
    super.initState();
    moviegetir2().then((gelen) {
      ifilmler = gelen;
      sayi = ifilmler.length;
    });
  }

  msil(Mymovies movie) {
    vTyardimcisi.moviesil(movie, "wmovie").then((cvp) {
      if (cvp > 0) {
        setState(() => listeyenile());
      }
    });
  }

  listeyenile() {
    moviegetir2().then((gelen) {
      ifilmler = gelen;
      sayi = ifilmler.length;
    });
  }

  Future<List<Mymovies>> moviegetir2() async {
    var veritab = await vTyardimcisi.veritabani;
    List<Map> liste = await veritab.rawQuery("SELECT* FROM wmovie");
    List<Mymovies> izlenenler = new List();

    for (int i = 0; i < liste.length; i++) {
      if (this.mounted) {
        setState(() {
          var ifilm = new Mymovies(liste[i]["isim"], liste[i]["yil"],
              liste[i]["tarih"], liste[i]["image"], liste[i]["Imdb"]);
          ifilm.numaraver(liste[i]["id"]);
          izlenenler.add(ifilm);
        });
      }
    }
    return izlenenler;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.search),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(Icons.filter_list),
          ),
        ],
        elevation: 15,
        shadowColor: Colors.grey[900],
        iconTheme: new IconThemeData(color: icon),
        backgroundColor: Color.fromRGBO(11, 28, 39, 1),
        title: Text(
          "İzlediklerim",
          style: TextStyle(color: Color.fromRGBO(244, 165, 33, 1)),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color.fromRGBO(38, 48, 54, 1),
      body: ListView.builder(
        itemCount: ifilmler.length,
        itemBuilder: (BuildContext contex, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Info(value: ifilmler[index].imdb)));
            },
            // child: Card(
            //   elevation: 1,
            //   color: Colors.grey[900],
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
            //       ListTile(
            //         isThreeLine: true,
            //         leading: SizedBox(
            //             width: 50,
            //             height: 150,
            //             child: Container(
            //               height: 200,
            //               width: 10,
            //               child: Image.network(
            //                 '${ifilmler[index].url}',
            //                 fit: BoxFit.cover,
            //                 errorBuilder: (context, error, stackTrace) {
            //                   return Icon(
            //                     Icons.movie,
            //                     size: 50,
            //                     color: Colors.amber,
            //                   );
            //                 },
            //                 loadingBuilder: (BuildContext context, Widget child,
            //                     ImageChunkEvent loadingProgress) {
            //                   if (loadingProgress == null) return child;
            //                   return Center(
            //                     child: CircularProgressIndicator(
            //                       valueColor: AlwaysStoppedAnimation<Color>(
            //                           Colors.amber),
            //                     ),
            //                   );
            //                 },
            //               ),
            //             )),
            //         title: Text(
            //           '${ifilmler[index].isim}',
            //           style: TextStyle(color: Colors.amber, fontSize: 18),
            //         ),
            //         subtitle: Text(
            //           '${ifilmler[index].date}',
            //           style: TextStyle(color: Colors.grey[600], fontSize: 14),
            //         ),
            //         trailing: IconButton(
            //             icon: Icon(
            //               Icons.grade,
            //               color: Colors.amber,
            //             ),
            //             onPressed: () {}),
            //       ),
            //       ButtonBar(
            //         children: <Widget>[
            //           RaisedButton(
            //               color: Colors.amber,
            //               child: const Text(
            //                 'SİL',
            //                 style: TextStyle(color: Colors.black),
            //               ),
            //               onPressed: () {
            //                 msil(ifilmler[index]);
            //               }),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

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
                            '${ifilmler[index].url}',
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
                            '${ifilmler[index].isim}',
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
                            '${ifilmler[index].date}',
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
                                    Icons.star,
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
                                  onPressed: () => msil(ifilmler[index]),
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
