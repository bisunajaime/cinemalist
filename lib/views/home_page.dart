import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_tutorial/bloc/movies_bloc.dart';
import 'package:tmdb_tutorial/models/Movie.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController bottomController = PageController(
    initialPage: 0,
    viewportFraction: .2,
  );
  PageController pageController = PageController(
    initialPage: 0,
  );
  int index = 0;
  final scrollThreshold = 200;
  MovieBloc movieBloc;

  @override
  void initState() {
    super.initState();
    bottomController.addListener(_onScroll);
    movieBloc = BlocProvider.of<MovieBloc>(context);
  }

  void _onScroll() {
    final maxScroll = bottomController.position.maxScrollExtent;
    final currentScroll = bottomController.position.pixels;

    if (maxScroll - currentScroll <= scrollThreshold) {
      movieBloc.add(FetchMovies());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0e0e0e),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is MovieFailed) {
              return Center(
                child: Text('There was a problem..'),
              );
            }

            if (state is MovieSuccess) {
              if (state.movies.isEmpty) {
                return Center(
                  child: Text('No Movies'),
                );
              }

              return _buildMovies(state);
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildMovies(MovieSuccess state) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: pageController,
              itemCount: state.hasReachedMax
                  ? state.movies.length
                  : state.movies.length + 1,
              itemBuilder: (context, i) {
                if (i >= state.movies.length) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Stack(
                    children: <Widget>[
                      ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black,
                              Colors.transparent,
                            ],
                          ).createShader(
                            Rect.fromLTRB(
                              0,
                              0,
                              rect.width,
                              rect.height,
                            ),
                          );
                        },
                        blendMode: BlendMode.dstIn,
                        child: Image(
                          height: double.infinity,
                          width: double.infinity,
                          image: NetworkImage(
                              'https://image.tmdb.org/t/p/w500${state.movies[i].poster_path}'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 10,
                        right: 10,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                state.movies[i].title,
                                style: TextStyle(
                                  color: Colors.pinkAccent[100],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                state.movies[i].overview,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          height: 100,
          width: double.infinity,
          margin: EdgeInsets.only(top: 5),
          child: PageView.builder(
            onPageChanged: (i) {
              pageController.animateToPage(i,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
              setState(() {
                index = i;
              });
            },
            scrollDirection: Axis.horizontal,
            controller: bottomController,
            itemCount: state.hasReachedMax
                ? state.movies.length
                : state.movies.length + 1,
            itemBuilder: (context, i) {
              if (i >= state.movies.length) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              Movie movie = state.movies[i];
              return Container(
                height: double.infinity,
                width: 70,
                margin: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${movie.poster_path}',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: index == i
                        ? null
                        : ColorFilter.mode(
                            Colors.black54,
                            BlendMode.darken,
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
