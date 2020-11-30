import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:movie_app/models/item_model.dart';

class MovieApiProvider {
  Client client = Client();

  final apikey = "11d50f5b518377fbd8bca8303b79be01";
  final baseURL = "https://developers.themoviedb.org/3/movies";

  Future<ItemModel> fetchMovielist() async {
    print("entered");
    final response = await client.get(
        "https://api.themoviedb.org/3/movie/popular?api_key=$apikey&language=tr&page=1");
    print(response.body.toString());
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Yükleme Başarısız');
    }
  }
}
