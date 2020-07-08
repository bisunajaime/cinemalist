// EVENT

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tmdb_tutorial/models/Movie.dart';
import 'package:tmdb_tutorial/repository/tmdb_repository.dart';

abstract class MovieEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMovies extends MovieEvent {}

// STATES

abstract class MovieState extends Equatable {
  const MovieState();
  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieState {}

class MovieFailed extends MovieState {}

class MovieSuccess extends MovieState {
  final List<Movie> movies;
  final bool hasReachedMax;
  MovieSuccess({
    this.movies,
    this.hasReachedMax,
  });

  MovieSuccess copyWith({
    List<Movie> movies,
    bool hasReachedMax,
  }) {
    return MovieSuccess(
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      movies: movies ?? this.movies,
    );
  }

  @override
  List<Object> get props => [movies, hasReachedMax];

  @override
  String toString() =>
      "{ MovieSuccess: { movies: ${movies.length}, hasReachedMax: $hasReachedMax } }";
}

// BLOC

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final TMDBRepository tmdbRepository;
  int page = 1;

  MovieBloc({this.tmdbRepository});

  @override
  MovieState get initialState => MovieInitial();

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    final currentState = state;
    if (event is FetchMovies && !_hasReachedMax(currentState)) {
      try {
        if (currentState is MovieInitial) {
          final movies = await tmdbRepository.fetchMovies(page: page);
          yield MovieSuccess(movies: movies, hasReachedMax: false);
          return;
        }

        if (currentState is MovieSuccess) {
          final movies = await tmdbRepository.fetchMovies(page: ++page);
          yield movies.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : MovieSuccess(
                  hasReachedMax: false,
                  movies: currentState.movies + movies,
                );
        }
      } catch (_) {
        yield MovieFailed();
      }
    }
  }

  bool _hasReachedMax(MovieState state) =>
      state is MovieSuccess && state.hasReachedMax;
}
