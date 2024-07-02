import 'package:flutter/material.dart';
import 'package:mmdb/app_state.dart';
import 'package:mmdb/services/tmdb_api_service.dart';
import 'models/actor.dart';

BoxDecoration greyTop = BoxDecoration(
    border:
        Border(top: BorderSide(color: Colors.grey.withOpacity(0.6), width: 2)));

BoxDecoration greyBottom = BoxDecoration(
    border: Border(bottom: BorderSide(color: Colors.grey.shade400, width: 2)));

class ActorShowcase extends StatelessWidget {
  const ActorShowcase({
    super.key,
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
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
                  child: Text("Trending Actors",
                      style: AppState.headingStyle.copyWith(fontSize: 20)),
                ),
                const SeeMoreButton(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          flex: 10,
          child: Container(
            decoration: greyTop,
            child: const ActorList(),
          ),
        )
      ],
    );
  }
}

class ActorList extends StatefulWidget {
  const ActorList({
    super.key,
  });

  @override
  State<ActorList> createState() => _ActorListState();
}

class _ActorListState extends State<ActorList> {
  late Future<List<Actor>> trendingActors;

  @override
  void initState() {
    super.initState();
    trendingActors = TMDBApiService().fetchTrendingActors();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Actor>>(
        future: trendingActors,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Actor>? actors = snapshot.data;

            return ListView.builder(
                itemCount: actors!.length,
                itemBuilder: ((context, index) {
                  return ActorRow(
                    actor: actors[index],
                  );
                }));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

class ActorRow extends StatelessWidget {
  const ActorRow({super.key, required this.actor});

  final Actor actor;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.width;

    const double heightPercent = 0.07;
    const double widthPercent = heightPercent * (2 / 3);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: Colors.grey.withOpacity(0.6), width: 1))),
        padding: const EdgeInsets.all(8),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(actor.name, style: AppState.headingStyle.copyWith(fontSize: 16)),
          SizedBox(
              height: height * heightPercent,
              width: width * widthPercent,
              child: Image.network(
                  'https://image.tmdb.org/t/p/w500${actor.profilePath}')),
        ]),
      ),
    );
  }
}

class SeeMoreButton extends StatelessWidget {
  const SeeMoreButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {},
        child: Row(
          children: [
            Text("See More", style: AppState.subheadingStyle),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade600,
            ),
          ],
        ));
  }
}
