import 'package:flutter/material.dart';
import 'package:mmdb/app_state.dart';
import 'package:mmdb/models/full_movie.dart';
import 'package:mmdb/models/movie.dart';
import 'package:mmdb/services/tmdb_api_service.dart';

const double radius = 15;

class ShowcasePage extends StatefulWidget {
  const ShowcasePage({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  late final Future<FullMovie> futureMovie;

  @override
  void initState() {
    super.initState();
    futureMovie = TMDBApiService().fetchFullMovieByID(widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    HSLColor hsl = HSLColor.fromColor(colorScheme.primary);
    HSLColor lighterHsl =
        hsl.withLightness((hsl.lightness + 0.4).clamp(0.0, 1.0));
    Color lighter = lighterHsl.toColor();

    return Scaffold(
      backgroundColor: lighter,
      body: FutureBuilder(
          future: futureMovie,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              FullMovie? fullMovie = snapshot.data;
              return RaisedElement(fullMovie: fullMovie);
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class RaisedElement extends StatelessWidget {
  const RaisedElement({
    super.key,
    required this.fullMovie,
  });

  final FullMovie? fullMovie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 5,
            )
          ],
        ),
        child: PageContent(fullMovie: fullMovie),
      ),
    );
  }
}

class PageContent extends StatelessWidget {
  const PageContent({
    super.key,
    required this.fullMovie,
  });

  final FullMovie? fullMovie;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius)),
            ),
            child: LeftSideContent(fullMovie: fullMovie!),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(radius),
                  bottomRight: Radius.circular(radius)),
            ),
          ),
        ),
      ],
    );
  }
}

class LeftSideContent extends StatelessWidget {
  const LeftSideContent({
    super.key,
    required this.fullMovie,
  });

  final FullMovie fullMovie;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopBar(),
        Expanded(
            flex: 3,
            child: LayoutBuilder(
              builder: (context, constraints) {
                double expandedHeight = constraints.maxHeight;
                return Container(
                  width: expandedHeight * (2 / 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 5,
                        )
                      ],
                      image: DecorationImage(
                          image: NetworkImage(
                              AppState.posterURL + fullMovie.posterPath),
                          fit: BoxFit.fitHeight)),
                );
              },
            )),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  '${fullMovie.runtime.ceil()} Minutes',
                  style: AppState.filmInformationStyle,
                ),
                const SizedBox(height: 5),
                Text(
                  AppState.convertDateToReadableFormat(fullMovie.releaseDate),
                  style: AppState.filmInformationStyle,
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double expandedHeight = constraints.maxHeight;
                      return GenreListView(
                        genres: AppState.getGenres(fullMovie.genres),
                        height: expandedHeight,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GenreListView extends StatelessWidget {
  const GenreListView({
    super.key,
    required this.genres,
    required this.height,
  });

  final List<String> genres;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
          itemCount: (genres.length / 2).ceil(),
          itemBuilder: ((context, index) {
            return GenreRow(genres: genres, index: index);
          })),
    );
  }
}

class GenreRow extends StatelessWidget {
  const GenreRow({
    super.key,
    required this.genres,
    required this.index,
  });

  final List<String> genres;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (genres.length >= 2 * (index + 1)) {
      List<String> rowGenres = genres.sublist(2 * index, 2 * (index + 1));
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowGenres.map((item) => GenreTile(genre: item)).toList(),
      );
    } else {
      List<String> rowGenres = genres.sublist(2 * index);
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowGenres.map((item) => GenreTile(genre: item)).toList(),
      );
    }
  }
}

class GenreTile extends StatelessWidget {
  const GenreTile({
    super.key,
    required this.genre,
  });

  final String genre;

  @override
  Widget build(BuildContext context) {
    const double leftRightPadding = 6;
    const double topBottomPadding = 4;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
          padding: const EdgeInsets.only(
              left: leftRightPadding,
              right: leftRightPadding,
              top: topBottomPadding,
              bottom: topBottomPadding),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.black87),
          child: Center(
              child: Text(genre, style: AppState.genreInformationStyle))),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.blue[400],
              )),
        ],
      ),
    );
  }
}

class BackgroundLayer extends StatelessWidget {
  const BackgroundLayer({
    super.key,
    required this.fullMovie,
  });

  final FullMovie fullMovie;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(radius),
                  topLeft: Radius.circular(radius),
                ),
                color: Colors.black.withOpacity(0.8)),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius))),
          ),
        )
      ],
    );
  }
}
