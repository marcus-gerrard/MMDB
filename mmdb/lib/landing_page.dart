import 'package:flutter/material.dart';
import 'mobile_landing_page.dart';
import 'movie_showcase.dart';
import 'actor_showcase.dart';

double topBarHeight = 0.25;

bool firstLoad = true;

class LandingPage extends StatefulWidget {
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 575) {
            // Use a more mobile-friendly layout on narrow screens
            return MobileLandingPage();
          } else {
            // Less mobile-friendly layout for wider screens
            return DesktopLandingPage();
          }
        },
      ),
    );
  }
}

class DesktopLandingPage extends StatefulWidget {
  @override
  State<DesktopLandingPage> createState() => _DesktopLandingPageState();
}

class _DesktopLandingPageState extends State<DesktopLandingPage> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final double lrPadding = screenWidth * 0.08;
    const double tbPadding = 20;

    double fontSize = screenHeight * 0.04;
    TextStyle logoStyle = TextStyle(
        color: colorScheme.primary.withOpacity(0.8), fontSize: fontSize);

    TextStyle buttonStyle = TextStyle(
        color: Colors.white.withOpacity(0.75), fontSize: fontSize * 0.7);

    const double paddingAmount = 15.0;

    return Scaffold(
        backgroundColor: colorScheme.surface,
        body: Column(
          children: [
            SizedBox(
              height: screenHeight * topBarHeight,
              child: TopBarIcons(
                  colorScheme: colorScheme,
                  screenHeight: screenHeight,
                  logoStyle: logoStyle,
                  paddingAmount: paddingAmount,
                  buttonStyle: buttonStyle),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: lrPadding,
                  right: lrPadding,
                  top: tbPadding,
                  bottom: tbPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: MovieShowcase(
                        colorScheme: colorScheme,
                      ),
                    ),
                    const SizedBox(width: 75),
                    Expanded(
                      flex: 1,
                      child: ActorShowcase(colorScheme: colorScheme),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class TopBarIcons extends StatelessWidget {
  const TopBarIcons({
    super.key,
    required this.colorScheme,
    required this.screenHeight,
    required this.logoStyle,
    required this.paddingAmount,
    required this.buttonStyle,
  });

  final ColorScheme colorScheme;
  final double screenHeight;
  final TextStyle logoStyle;
  final double paddingAmount;
  final TextStyle buttonStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorScheme.onSurface,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TopLeftIcons(
                    logoStyle: logoStyle,
                    paddingAmount: paddingAmount,
                    buttonStyle: buttonStyle),
                TopRightIcons(
                    paddingAmount: paddingAmount, screenHeight: screenHeight)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SearchBar(),
          )
        ],
      ),
    );
  }
}

class TopLeftIcons extends StatelessWidget {
  const TopLeftIcons({
    super.key,
    required this.logoStyle,
    required this.paddingAmount,
    required this.buttonStyle,
  });

  final TextStyle logoStyle;
  final double paddingAmount;
  final TextStyle buttonStyle;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text('MMDB', style: logoStyle),
      SizedBox(width: paddingAmount * 3),
      TextButton(
        onPressed: () {},
        child: Text("Home", style: buttonStyle),
      ),
      SizedBox(width: paddingAmount),
      TextButton(
        onPressed: () {},
        child: Text("Movies", style: buttonStyle),
      ),
      SizedBox(width: paddingAmount),
      TextButton(
        onPressed: () {},
        child: Text("TV Shows", style: buttonStyle),
      ),
    ]);
  }
}

class TopRightIcons extends StatelessWidget {
  const TopRightIcons({
    super.key,
    required this.paddingAmount,
    required this.screenHeight,
  });

  final double paddingAmount;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const WatchListIcon(),
        SizedBox(width: paddingAmount),
        UserProfilePicture(screenHeight: screenHeight),
        SizedBox(width: paddingAmount),
      ],
    );
  }
}

class WatchListIcon extends StatelessWidget {
  const WatchListIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Watch List",
      child: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.remove_red_eye_outlined,
            color: Colors.white.withOpacity(0.75),
          )),
    );
  }
}

class UserProfilePicture extends StatelessWidget {
  const UserProfilePicture({
    super.key,
    required this.screenHeight,
  });

  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.055,
      width: screenHeight * 0.055,
      child: const Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController searchController = TextEditingController();
  String searchText = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    TextStyle hintStyle = TextStyle(
        color: Colors.grey.withOpacity(0.6), fontSize: screenHeight * 0.03);

    TextStyle enteredStyle = TextStyle(
        color: Colors.white.withOpacity(0.7), fontSize: screenHeight * 0.03);

    double leftRightPadding = 10;

    void performSearch() {
      setState(() {
        searchText = searchController.text;
        // Search Functionality Below
      });
    }

    return Container(
      decoration: const BoxDecoration(
          border: Border(
              left: BorderSide(
        color: Colors.white,
        width: 2,
      ))),
      height: (screenHeight * topBarHeight) * 0.275,
      width: screenWidth * 0.75,
      padding: EdgeInsets.only(left: leftRightPadding),
      child: TextField(
        controller: searchController,
        style: enteredStyle,
        decoration: InputDecoration(
          hintText: 'Find Movies, TV Shows, Actors, and More...',
          border: InputBorder.none,
          hintStyle: hintStyle,
        ),
        onSubmitted: ((String value) => performSearch()),
        onChanged: (String value) {
          setState(() {
            searchText = value;
          });
        },
      ),
    );
  }
}
