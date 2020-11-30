import 'package:movie_app/models/item_model.dart';
import 'package:movie_app/services/movie_api_provider.dart';

class Repository {
  final movieApiProvider = MovieApiProvider();

  Future<ItemModel> fetchAllMovies() => movieApiProvider.fetchMovielist();
}
