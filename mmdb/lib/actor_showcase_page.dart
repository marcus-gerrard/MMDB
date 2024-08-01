import 'package:flutter/material.dart';
import 'package:mmdb/models/full_actor.dart';
import 'package:mmdb/services/tmdb_api_service.dart';

import 'app_state.dart';

const double radius = 15;

class ActorShowcasePage extends StatefulWidget {
  const ActorShowcasePage({
    super.key,
    required this.actorID,
  });

  final int actorID;

  @override
  State<ActorShowcasePage> createState() => _ActorShowcasePageState();
}

class _ActorShowcasePageState extends State<ActorShowcasePage> {
  late final Future<FullActor> futureActor;

  @override
  void initState() {
    super.initState();
    futureActor = TMDBApiService().fetchActor(widget.actorID);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('MMDB'),
        backgroundColor: colorScheme.onSurface,
        foregroundColor: AppState.logoColor,
      ),
      body: FutureBuilder(
          future: futureActor,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              FullActor actor = snapshot.data!;
              return MainView(actor: actor);
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

class MainView extends StatelessWidget {
  const MainView({
    super.key,
    required this.actor,
  });

  final FullActor actor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: ActorDetails(actor: actor)),
        Expanded(
            flex: 7,
            child: Column(
              children: [
                Container(
                  height: 200,
                  color: Colors.blueAccent,
                ),
              ],
            ))
      ],
    );
  }
}

class ActorDetails extends StatelessWidget {
  const ActorDetails({
    super.key,
    required this.actor,
  });

  final FullActor actor;
  final double itemSpacing = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: 400,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                image: DecorationImage(
                    image:
                        NetworkImage(AppState.headshotURL + actor.profilePath),
                    fit: BoxFit.fitHeight)),
          ),
        ),
        SizedBox(height: itemSpacing),
        const Text('Personal Info', style: AppState.actorHeadingStyle),
        SizedBox(height: itemSpacing),
        const Text('Known For', style: AppState.actorSubheadingStyle),
        const Text('Acting', style: AppState.actorInfoStyle),
      ],
    );
  }
}
