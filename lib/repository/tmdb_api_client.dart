import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tmdb_tutorial/constants/keys.dart';
import 'package:tmdb_tutorial/models/Cast.dart';
import 'package:tmdb_tutorial/models/Movie.dart';
import 'package:tmdb_tutorial/models/MovieDetails.dart';

class TMDBApiClient {
  final baseURL = "https://api.themoviedb.org/3";
  final http.Client httpClient;
  TMDBApiClient({this.httpClient});

  Future<List<Movie>> fetchMovies({int page}) async {
    final List<Movie> movies = [];
    final url =
        "$baseURL/movie/popular?api_key=$API_KEY&language=en-US&page=$page";
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem');
    }
    final decodedJson = jsonDecode(response.body);
    (decodedJson['results'] as List).forEach((element) {
      movies.add(Movie.fromJson(element));
    });
    return movies;
  }

  Future<MovieDetails> fetchMovieDetails({int id}) async {
    final url = '$baseURL/movie/$id?api_key=$API_KEY&language=en-US';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem');
    }
    final decodedJson = jsonDecode(response.body);
    return MovieDetails.fromJson(decodedJson);
  }

  Future<List<Cast>> fetchMovieCast({int id}) async {
    final List<Cast> movieCast = [];
    final url = '$baseURL/movie/$id/credits?api_key=$API_KEY';
    final response = await httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('There was a problem');
    }
    final decodedJson = jsonDecode(response.body);
    (decodedJson['cast'] as List).forEach((element) {
      movieCast.add(Cast.fromJson(element));
    });
    return movieCast;
  }
}
