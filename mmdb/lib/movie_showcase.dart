import 'package:flutter/material.dart';

// import 'showcase_page.dart';
import 'showcase_page_copy.dart';
import 'package:mmdb/app_state.dart';
import 'package:mmdb/services/tmdb_api_service.dart';
import 'models/movie.dart';

class MovieShowcase extends StatelessWidget {
  const MovieShowcase({
    super.key,
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(
                          color: colorScheme.primary.withOpacity(0.8),
                          width: 2))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text("Trending Films",
                        style: AppState.headingStyle.copyWith(fontSize: 20)),
                  ),
                  const SortingOptions(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 10,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: Colors.grey.withOpacity(0.6), width: 2))),
              child: const MovieList(),
            ),
          )
        ],
      ),
    );
  }
}

class MovieList extends StatefulWidget {
  const MovieList({
    super.key,
  });

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = TMDBApiService().fetchTrendingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: futureMovies,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Movie>? movies = snapshot.data;
          return ListView.builder(
            itemCount: (movies!.length / 4).ceil(),
            itemBuilder: (context, index) {
              return MovieRow(movies: movies, index: index);
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MovieRow extends StatelessWidget {
  const MovieRow({
    super.key,
    required this.movies,
    required this.index,
  });

  final List<Movie>? movies;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (movies!.length >= 4 * (index + 1)) {
      List<Movie> rowMovies = movies!.sublist(4 * index, 4 * (index + 1));
      return Row(
        children: rowMovies.map((item) => MovieTile(movie: item)).toList(),
      );
    } else {
      List<Movie> rowMovies = movies!.sublist(4 * index);
      return Row(
        children: rowMovies.map((item) => MovieTile(movie: item)).toList(),
      );
    }
  }
}

class MovieTile extends StatelessWidget {
  const MovieTile({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.width;

    const double heightPercent = 0.17;
    const double widthPercent = heightPercent * (2 / 3);

    double rating = movie.voteAverage;

    List<Widget> values;
    if (rating == 0.0) {
      values = [const Text('Coming Soon', style: AppState.headingStyle)];
    } else {
      values = [
        const Icon(Icons.star, color: Colors.amber),
        const SizedBox(width: 5),
        Text(
          rating.toStringAsFixed(1),
          style: AppState.headingStyle,
        )
      ];
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ShowcasePageCopy(movie: movie)));
            },
            child: Container(
              color: Colors.grey,
              width: width * widthPercent,
              height: height * heightPercent,
              child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}'),
            ),
          ),
          SizedBox(
              width: width * widthPercent,
              child: Center(
                  child: Text(
                movie.title,
                style: AppState.headingStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ))),
          SizedBox(
            width: width * widthPercent,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center, children: values),
          )
        ],
      ),
    );
  }
}

class SortingOptions extends StatelessWidget {
  const SortingOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        WhichToRankButton(),
        WhatToRankByButton(),
      ],
    );
  }
}

class WhatToRankByButton extends StatefulWidget {
  const WhatToRankByButton({
    super.key,
  });

  @override
  State<WhatToRankByButton> createState() => _WhatToRankByButtonState();
}

class _WhatToRankByButtonState extends State<WhatToRankByButton> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {},
        child: Row(
          children: [
            Text(
              'Ranking',
              style: AppState.subheadingStyle,
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade600,
              size: 25,
            ),
          ],
        ));
  }
}

class WhichToRankButton extends StatefulWidget {
  const WhichToRankButton({
    super.key,
  });

  @override
  State<WhichToRankButton> createState() => _WhichToRankButtonState();
}

class _WhichToRankButtonState extends State<WhichToRankButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {},
        child: Row(
          children: [
            Text(
              'All Genres',
              style: AppState.subheadingStyle,
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade600,
              size: 25,
            ),
          ],
        ));
  }
}
