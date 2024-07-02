import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mmdb/app_state.dart';
import 'package:mmdb/models/full_movie.dart';
import 'package:mmdb/models/movie.dart';
import 'package:mmdb/services/tmdb_api_service.dart';

const double radius = 15;

class ShowcasePageCopy extends StatefulWidget {
  const ShowcasePageCopy({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  State<ShowcasePageCopy> createState() => _ShowcasePageCopyState();
}

class _ShowcasePageCopyState extends State<ShowcasePageCopy> {
  late final Future<FullMovie> futureMovie;

  @override
  void initState() {
    super.initState();
    futureMovie = TMDBApiService().fetchFullMovieByID(widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: const Text('MMDB'),
        backgroundColor: colorScheme.onSurface,
        foregroundColor: AppState.logoColor,
      ),
      body: FutureBuilder(
          future: futureMovie,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              FullMovie? fullMovie = snapshot.data;
              return ViewStack(fullMovie: fullMovie!);
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

class ViewStack extends StatelessWidget {
  const ViewStack({
    super.key,
    required this.fullMovie,
  });

  final FullMovie fullMovie;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      AppState.backdropURL + fullMovie.backdropPath),
                  fit: BoxFit.fitHeight)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.white.withOpacity(0),
            ),
          ),
        ),
        RaisedElement(fullMovie: fullMovie),
      ],
    );
  }
}

class RaisedElement extends StatelessWidget {
  const RaisedElement({
    super.key,
    required this.fullMovie,
  });

  final FullMovie fullMovie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
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
                image:
                    NetworkImage(AppState.backdropURL + fullMovie.backdropPath),
                fit: BoxFit.fitHeight)),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: Colors.black.withOpacity(0.1)),
          child: PageContent(fullMovie: fullMovie),
        ),
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
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          children: [
            const Expanded(
              flex: 3,
              child: SizedBox(),
            ),
            Expanded(
              flex: 5,
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MovieDetails(fullMovie: fullMovie!),
                      const SizedBox(height: 20),
                      CastDetails(fullMovie: fullMovie!)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CastDetails extends StatelessWidget {
  const CastDetails({
    super.key,
    required this.fullMovie,
  });

  final FullMovie fullMovie;

  @override
  Widget build(BuildContext context) {
    // final List<String> bigThree = AppState.getTopCast(fullMovie);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Icon(Icons.square_rounded, color: AppState.logoColor, size: 45),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.star, color: Colors.black, size: 25),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              color: Colors.white.withOpacity(0),
              border: Border.all(width: 2, color: Colors.white)),
          child: const Icon(
            Icons.person,
            size: 50,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

class MovieDetails extends StatelessWidget {
  const MovieDetails({
    super.key,
    required this.fullMovie,
  });

  final FullMovie fullMovie;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<String> genres = AppState.getGenres(fullMovie.genres);

    const double padding = 4;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Icon(Icons.square_rounded, color: AppState.logoColor, size: 45),
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: Icon(Icons.add, color: Colors.black, size: 35),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedText(
                text: fullMovie.title, style: AppState.showcaseTitleStyle),
            DateAndGenre(
                fullMovie: fullMovie, padding: padding, genres: genres),
            const SizedBox(height: 5),
            SizedBox(
              width: screenWidth / 2,
              child: OutlinedText(
                text: fullMovie.overview,
                style: AppState.showcaseInfoStyle,
                maxlines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(width: 180),
        Row(
          children: [
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 45,
            ),
            OutlinedText(
                text: fullMovie.voteAverage.toStringAsFixed(1),
                style: AppState.showcaseTitleStyle)
          ],
        )
      ],
    );
  }
}

class OutlinedText extends StatelessWidget {
  const OutlinedText({
    super.key,
    required this.text,
    this.outlineSize = 1,
    required this.style,
    this.overflow = TextOverflow.clip,
    this.maxlines,
  });

  final String text;
  final double outlineSize;
  final TextStyle style;
  final TextOverflow overflow;
  final int? maxlines;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          maxLines: maxlines,
          overflow: overflow,
          style: style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = outlineSize
              ..color = Colors.black,
          ),
        ),
        Text(
          text,
          style: style,
          overflow: overflow,
          maxLines: maxlines,
        ),
      ],
    );
  }
}

class DateAndGenre extends StatelessWidget {
  const DateAndGenre({
    super.key,
    required this.fullMovie,
    required this.padding,
    required this.genres,
  });

  final FullMovie fullMovie;
  final double padding;
  final List<String> genres;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedText(
          text: AppState.convertDateToReadableFormat(fullMovie.releaseDate),
          style: AppState.showcaseInfoStyle,
        ),
        Padding(
          padding: EdgeInsets.only(left: padding, right: padding),
          child: Icon(Icons.circle, size: 10, color: AppState.logoColor),
        ),
        OutlinedText(
          text: genres.join(', '),
          style: AppState.showcaseInfoStyle,
        ),
        Padding(
          padding: EdgeInsets.only(left: padding, right: padding),
          child: Icon(Icons.circle, size: 10, color: AppState.logoColor),
        ),
        OutlinedText(
          text: '${fullMovie.runtime.ceil()} Minutes',
          style: AppState.showcaseInfoStyle,
        ),
      ],
    );
  }
}
