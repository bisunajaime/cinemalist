import 'package:tmdb_tutorial/models/Movie.dart';
import 'package:tmdb_tutorial/repository/tmdb_api_client.dart';

class TMDBRepository {
  final TMDBApiClient tmdbApiClient;
  TMDBRepository({this.tmdbApiClient});

  Future<List<Movie>> fetchMovies({int page}) async {
    return await tmdbApiClient.fetchMovies(page: page);
  }
}
