// EVENTS

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_tutorial/models/MovieDetails.dart';
import 'package:tmdb_tutorial/repository/tmdb_repository.dart';

abstract class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();
  @override
  List<Object> get props => [];
}

class FetchMovieDetails extends MovieDetailsEvent {
  final int id;
  const FetchMovieDetails({this.id});
  @override
  List<Object> get props => [id];
}

// STATE

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();
  @override
  List<Object> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsError extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieDetails movieDetails;
  MovieDetailsLoaded({this.movieDetails});

  @override
  List<Object> get props => [movieDetails];
}

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final TMDBRepository tmdbRepository;

  MovieDetailsBloc({this.tmdbRepository});

  @override
  MovieDetailsState get initialState => MovieDetailsInitial();

  @override
  Stream<MovieDetailsState> mapEventToState(MovieDetailsEvent event) async* {
    if (event is FetchMovieDetails) {
      yield MovieDetailsLoading();
      try {
        MovieDetails movieDetails =
            await tmdbRepository.fetchMovieDetails(id: event.id);
        yield MovieDetailsLoaded(movieDetails: movieDetails);
        return;
      } catch (e) {
        yield MovieDetailsError();
      }
    }
  }
}
