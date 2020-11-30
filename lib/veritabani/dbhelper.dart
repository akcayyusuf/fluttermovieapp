import 'package:movie_app/veritabani/wmovie.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class VTyardimcisi {
  static final VTyardimcisi _yardimci = new VTyardimcisi.icislem();

  factory VTyardimcisi() {
    return _yardimci;
  }
  VTyardimcisi.icislem();

  static Database _vt;

  Future<Database> get veritabani async {
    if (_vt != null) return _vt;
    _vt = await olusturVt();
    return _vt;
  }

  olusturVt() async {
    io.Directory konumu = await getApplicationDocumentsDirectory();
    String yol = join(konumu.path, "database.db");
    var veritabani = await openDatabase(yol, version: 1, onCreate: _ilkacilis);
    print("oluştu");
    return veritabani;
  }

  _ilkacilis(Database vt, int versiyon) async {
    await vt.execute(
        "CREATE TABLE wmovie(id INTEGER PRIMARY KEY AUTOINCREMENT,isim TEXT,yil TEXT,tarih TEXT,image TEXT,Imdb TEXT)");
    await vt.execute(
        "CREATE TABLE uwmovie(id INTEGER PRIMARY KEY AUTOINCREMENT,isim TEXT,yil TEXT,tarih TEXT,image TEXT,Imdb TEXT)");
  }

  Future<int> moviekaydet(Mymovies imovie, String table) async {
    var veritab = await veritabani;
    int cvp = await veritab.insert(table, imovie.haritala());
    return cvp;
  }

  Future<List<Mymovies>> moviegetir(String table) async {
    var veritab = await veritabani;
    List<Map> liste = await veritab.rawQuery("SELECT* FROM $table");
    List<Mymovies> izlenenler = new List();

    for (int i = 0; i < liste.length; i++) {
      var ifilm = new Mymovies(liste[i]["isim"], liste[i]["yil"],
          liste[i]["tarih"], liste[i]["image"], liste[i]["Imdb"]);
      ifilm.numaraver(liste[i]["id"]);
      izlenenler.add(ifilm);
    }
    return izlenenler;
  }

  Future<int> moviesil(Mymovies imovie, String table) async {
    var veritab = await veritabani;
    int cvp =
        await veritab.rawDelete("DELETE FROM $table WHERE id=?", [imovie.id]);
    return cvp;
  }
}
