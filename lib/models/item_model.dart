class ItemModel {
  int page;
  int totalpage;
  int totalresults;
  List<Result> results = [];

  ItemModel.fromJson(Map<String, dynamic> parsedJson) {
    page = parsedJson['Page'];
    totalresults = parsedJson[' total_result'];
    totalpage = parsedJson[' total_page'];
    List<Result> temp = [];
    for (var i = 0; i < parsedJson['result'].length; i++) {
      Result result = Result(parsedJson['results'][i]);
      temp.add(result);
    }

    results = temp;
  }
}

class Result {
  String vote_count;
  int id;
  bool video;
  var vote_avarege;
  String title;
  double popularity;
  String poster_path;
  List<int> genre_ids = [];
  String backdrop_path;
  bool adult;
  String overview;
  String release_date;

  Result(result) {
    vote_count = result['vote_count'].toString();
    id = result['id'];
    video = result['video'];

    vote_avarege = result['vote_avarege'];
    title = result['title'].toString();
    popularity = result['popularity'];
    poster_path = result['poster_path'].toString();

    for (int i = 0; i < result['genre_ids'].length; i++) {
      genre_ids.add(result['genre_ids'][i]);
    }

    backdrop_path = result['backdrop_path'].toString();
    adult = result['adult'];
    overview = result['overview'];
    release_date = result['release_date'].toString();
  }

  String get get_release_date => release_date;
  String get get_overview => overview;
  bool get get_adult => adult;
  String get get_backdrop_path => backdrop_path;
  List<int> get get_genre_ids => genre_ids;
  String get get_poster_path => poster_path;
  double get get_popularity => popularity;
  String get get_title => title;
  String get get_vote_avarege => vote_avarege;
  bool get is_video => video;
  String get get_vote_count => vote_count;
  int get get_id => id;
}
