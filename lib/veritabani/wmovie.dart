class Mymovies {
  int id;
  String _isim;
  String _year;
  String _date;
  String _url;
  String _imdb;

  Mymovies(this._isim, this._year, this._date, this._url, this._imdb);

  Mymovies.hrt(dynamic nesne) {
    this._isim = nesne["isim"];
    this._year = nesne["yil"];
    this._date = nesne["tarih"];
    this._url = nesne["image"];
    this._imdb = nesne["Imdb"];
  }

  String get isim => _isim;
  String get year => _year;
  String get date => _date;
  String get url => _url;
  String get imdb => _imdb;

  Map<String, dynamic> haritala() {
    var map = new Map<String, dynamic>();

    map["isim"] = _isim;
    map["yil"] = _year;
    map["tarih"] = _date;
    map["image"] = _url;
    map["Imdb"] = _imdb;

    return map;
  }

  void numaraver(int id) {
    this.id = id;
  }
}
