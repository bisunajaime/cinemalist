import 'package:tmdb_tutorial/models/Cast.dart';
import 'package:tmdb_tutorial/models/Movie.dart';
import 'package:tmdb_tutorial/models/MovieDetails.dart';
import 'package:tmdb_tutorial/repository/tmdb_api_client.dart';

class TMDBRepository {
  final TMDBApiClient tmdbApiClient;
  TMDBRepository({this.tmdbApiClient});

  Future<List<Movie>> fetchMovies({int page}) async {
    return await tmdbApiClient.fetchMovies(page: page);
  }

  Future<MovieDetails> fetchMovieDetails({int id}) async {
    return await tmdbApiClient.fetchMovieDetails(id: id);
  }

  Future<List<Cast>> fetchMovieCast({int id}) async {
    return await tmdbApiClient.fetchMovieCast(id: id);
  }
}
