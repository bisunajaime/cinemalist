import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tmdb_tutorial/models/Cast.dart';
import 'package:tmdb_tutorial/repository/tmdb_repository.dart';

abstract class CastEvent extends Equatable {
  const CastEvent();
  @override
  List<Object> get props => [];
}

class FetchCast extends CastEvent {
  final int id;
  const FetchCast({this.id});
  @override
  List<Object> get props => [id];
}

abstract class CastState extends Equatable {
  const CastState();
  @override
  List<Object> get props => [];
}

class CastInitial extends CastState {}

class CastLoading extends CastState {}

class CastError extends CastState {}

class CastLoaded extends CastState {
  final List<Cast> cast;
  CastLoaded({this.cast});
  @override
  List<Object> get props => [cast];
}

class CastBloc extends Bloc<CastEvent, CastState> {
  final TMDBRepository tmdbRepository;

  CastBloc({this.tmdbRepository});

  @override
  CastState get initialState => CastInitial();

  @override
  Stream<CastState> mapEventToState(CastEvent event) async* {
    if (event is FetchCast) {
      yield CastLoading();
      try {
        List<Cast> cast = await tmdbRepository.fetchMovieCast(id: event.id);
        yield CastLoaded(cast: cast);
      } catch (e) {
        yield CastError();
      }
    }
  }
}
