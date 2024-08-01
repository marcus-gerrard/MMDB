import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mmdb/app_state.dart';
import 'package:mmdb/models/full_movie.dart';
import 'package:mmdb/models/movie.dart';
import 'package:mmdb/models/movie_credits.dart';
import 'package:mmdb/services/tmdb_api_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  late final Future<MovieCredits> futureCredits;

  @override
  void initState() {
    super.initState();
    futureMovie = TMDBApiService().fetchFullMovieByID(widget.movie.id);
    futureCredits = TMDBApiService().fetchCredits(widget.movie.id);
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
          future: Future.wait([futureMovie, futureCredits]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              FullMovie fullMovie = snapshot.data![0] as FullMovie;
              MovieCredits credits = snapshot.data![1] as MovieCredits;
              return ViewStack(fullMovie: fullMovie, credits: credits);
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
    required this.credits,
  });

  final FullMovie fullMovie;
  final MovieCredits credits;

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
        RaisedElement(fullMovie: fullMovie, credits: credits),
      ],
    );
  }
}

class RaisedElement extends StatelessWidget {
  const RaisedElement({
    super.key,
    required this.fullMovie,
    required this.credits,
  });

  final FullMovie fullMovie;
  final MovieCredits credits;

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
          child: PageContent(fullMovie: fullMovie, credits: credits),
        ),
      ),
    );
  }
}

class PageContent extends StatelessWidget {
  const PageContent({
    super.key,
    required this.fullMovie,
    required this.credits,
  });

  final FullMovie fullMovie;
  final MovieCredits credits;
  final double detailSpacing = 30;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black,
                Colors.black,
                Colors.transparent,
              ],
              stops: [0.0, 0.1, 0.9, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight / 3),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MovieDetails(fullMovie: fullMovie),
                        SizedBox(height: detailSpacing),
                        CastDetails(credits: credits),
                        SizedBox(height: detailSpacing),
                        WriterDirectorDetails(credits: credits),
                        SizedBox(height: detailSpacing),
                        BugdetProfitDetails(movie: fullMovie),
                        SizedBox(height: detailSpacing),
                        ProductionDetails(movie: fullMovie),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight / 8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WriterDirectorDetails extends StatelessWidget {
  const WriterDirectorDetails({
    super.key,
    required this.credits,
  });

  final MovieCredits credits;

  @override
  Widget build(BuildContext context) {
    List<CrewMember> directors =
        credits.crew['Director'] == null ? [] : credits.crew['Director']!;

    List<Widget> directorWidgets = directors.isEmpty
        ? [
            OutlinedText(
                text: 'No Listed Director', style: AppState.actorNameStyle)
          ]
        : [
            OutlinedText(
                text: 'Directed BY', style: AppState.showcaseHeadingStyle)
          ];

    for (var director in directors) {
      directorWidgets.add(Text(
        director.name,
        style: AppState.actorNameStyle,
      ));
    }

    //Appending all jobs that should be considered Writers
    List<CrewMember> writers = [];

    for (var jobTitle in ['Writer', 'Screenplay', 'Novel']) {
      if (credits.crew[jobTitle] != null) {
        writers.addAll(credits.crew[jobTitle]!);
      }
    }

    List<Widget> writerWidgets = writers.isEmpty
        ? [
            OutlinedText(
                text: 'No Listed Writer', style: AppState.actorNameStyle)
          ]
        : [
            OutlinedText(
                text: 'Written By', style: AppState.showcaseHeadingStyle)
          ];

    for (var writer in writers) {
      writerWidgets.add(Text(
        writer.name,
        style: AppState.actorNameStyle,
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Icon(Icons.square_rounded, color: AppState.logoColor, size: 45),
            const Padding(
              padding: EdgeInsets.all(10),
              child:
                  FaIcon(FontAwesomeIcons.film, color: Colors.black, size: 25),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: directorWidgets,
        ),
        const SizedBox(width: 50),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: writerWidgets,
        )
      ],
    );
  }
}

class BugdetProfitDetails extends StatelessWidget {
  const BugdetProfitDetails({
    super.key,
    required this.movie,
  });

  final FullMovie movie;

  @override
  Widget build(BuildContext context) {
    final double budget = movie.budget;
    final double revenue = movie.revenue;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Icon(Icons.square_rounded, color: AppState.logoColor, size: 45),
            const Padding(
              padding: EdgeInsets.all(8.5),
              child: FaIcon(FontAwesomeIcons.moneyBill1,
                  color: Colors.black, size: 25),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedText(text: 'Budget', style: AppState.showcaseHeadingStyle),
            OutlinedText(
                text: AppState.getReadableNumber(budget),
                style: AppState.actorNameStyle),
          ],
        ),
        const SizedBox(width: 50),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedText(
                text: 'Box Office', style: AppState.showcaseHeadingStyle),
            OutlinedText(
                text: AppState.getReadableNumber(revenue),
                style: AppState.actorNameStyle),
          ],
        )
      ],
    );
  }
}

class ProductionDetails extends StatelessWidget {
  const ProductionDetails({
    super.key,
    required this.movie,
  });

  final FullMovie movie;

  @override
  Widget build(BuildContext context) {
    List<String> prodCompanies =
        AppState.getProductionCompanies(movie.productionCompanies);

    List<Widget> companyWidgets = prodCompanies.map((item) {
      return OutlinedText(text: item, style: AppState.actorNameStyle);
    }).toList();
    List<Widget> shownCompanies = [];
    if (companyWidgets.isEmpty) {
      shownCompanies.add(OutlinedText(
        text: 'No Listed Production Companies',
        style: AppState.actorNameStyle,
      ));
    } else {
      shownCompanies.add(OutlinedText(
          text: 'Produced By', style: AppState.showcaseHeadingStyle));
      shownCompanies.addAll(companyWidgets);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Icon(Icons.square_rounded, color: AppState.logoColor, size: 45),
            const Padding(
              padding: EdgeInsets.all(10),
              child: FaIcon(FontAwesomeIcons.productHunt,
                  color: Colors.black, size: 25),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: shownCompanies,
        ),
      ],
    );
  }
}

class CastDetails extends StatelessWidget {
  const CastDetails({
    super.key,
    required this.credits,
  });

  final MovieCredits credits;

  @override
  Widget build(BuildContext context) {
    final List<CastMember> actors = credits.cast['Acting']!;

    final List<CastMember> topBilled =
        actors.length > 3 ? actors.sublist(0, 3) : actors;

    List<Widget> rowChildren = [];

    if (actors.isEmpty) {
      rowChildren.add(const Text('This Film Contains No Actors'));
    } else {
      rowChildren.add(IndividualActorShowcase(actor: topBilled[0]));
    }

    for (var i = 1; i < topBilled.length; i++) {
      rowChildren.add(const SizedBox(width: 30));
      rowChildren.add(IndividualActorShowcase(actor: topBilled[i]));
    }

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
        Row(
          children: rowChildren,
        )
      ],
    );
  }
}

class IndividualActorShowcase extends StatelessWidget {
  const IndividualActorShowcase({
    super.key,
    required this.actor,
  });

  final CastMember actor;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    List<String> firstAndLast = actor.name.split(' ');
    List<Widget> nameWidgets = [
      Text(firstAndLast[0], style: AppState.actorNameStyle)
    ];
    for (var i = 1; i < firstAndLast.length; i++) {
      nameWidgets.add(Text(firstAndLast[i], style: AppState.actorNameStyle));
    }

    return Row(
      children: [
        ClipOval(
          child: Image.network(
            AppState.headshotURL + actor.profilePath!,
            height: height * 0.10,
            width: height * 0.10,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          children: nameWidgets,
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

    List<Widget> ratingValues = [];

    if (fullMovie.voteAverage == 0.0) {
      ratingValues.add(
        Column(
          children: [
            Text(
              'Coming',
              style: AppState.showcaseTitleStyle,
            ),
            Text(
              'Soon',
              style: AppState.showcaseTitleStyle,
            ),
          ],
        ),
      );
    } else {
      ratingValues.add(const Icon(Icons.star, color: Colors.amber, size: 45));
      ratingValues.add(OutlinedText(
          text: fullMovie.voteAverage.toStringAsFixed(1),
          style: AppState.showcaseTitleStyle));
    }

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
        SizedBox(
          width: screenWidth / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutlinedText(
                  text: fullMovie.title,
                  style: AppState.showcaseTitleStyle,
                  overflow: TextOverflow.ellipsis,
                  maxlines: 1),
              DateAndGenre(
                  fullMovie: fullMovie, padding: padding, genres: genres),
              const SizedBox(height: 5),
              OutlinedText(
                text: fullMovie.overview,
                style: AppState.showcaseInfoStyle,
                maxlines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(width: screenWidth / 5),
        Row(
          children: ratingValues,
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
        const Icon(Icons.av_timer, color: Colors.white, size: 18),
        const SizedBox(width: 5),
        OutlinedText(
          text: '${fullMovie.runtime.ceil()} Minutes',
          style: AppState.showcaseInfoStyle,
        ),
      ],
    );
  }
}
