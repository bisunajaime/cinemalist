import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tmdb_tutorial/constants/keys.dart';
import 'package:tmdb_tutorial/models/Movie.dart';

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
}
