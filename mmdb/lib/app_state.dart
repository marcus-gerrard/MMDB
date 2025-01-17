import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  //API Keys
  static const tmdbKey = "b01ade640e2818e508e96528f7c77e6e";

  //Image URL's
  static const posterURL = 'https://image.tmdb.org/t/p/w500';
  static const backdropURL = 'https://image.tmdb.org/t/p/w1280';
  static const headshotURL = "https://image.tmdb.org/t/p/w500";

  // Common Components
  static Color logoColor = Colors.blue[800]!;

  static const TextStyle headingStyle =
      TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle subheadingStyle = TextStyle(
      color: Colors.grey.shade600, fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle showcaseTitleStyle = const TextStyle(
      color: Colors.white, fontSize: 65, fontWeight: FontWeight.w600);

  static TextStyle showcaseInfoStyle = TextStyle(
      color: Colors.grey[200], fontSize: 15, fontWeight: FontWeight.w600);

  static TextStyle actorNameStyle = const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);

  static TextStyle showcaseHeadingStyle =
      TextStyle(color: logoColor, fontSize: 20, fontWeight: FontWeight.w600);

  static const TextStyle actorHeadingStyle =
      TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
  
  static const TextStyle actorSubheadingStyle =
      TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600);

  static const TextStyle actorInfoStyle =
      TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal);

  //Common Helper Functions
  static String convertDateToReadableFormat(String oldDate) {
    List<String> splitStrings = oldDate.split('-');
    String year = splitStrings[0];
    int month = int.parse(splitStrings[1]);
    int day = int.parse(splitStrings[2]);

    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    String suffix = 'th';
    int temp = day;

    if (temp > 10) {
      while (temp > 10) {
        temp -= 10;
      }
    }
    List<String> suffixes = ['st', 'nd', 'rd'];
    List<int> lowDates = [1, 2, 3];
    if (lowDates.contains(temp)) {
      suffix = suffixes[temp - 1];
    }

    return '${months[month - 1]} $day$suffix, $year';
  }

  static String convertDateToCleanerFormat(String oldDate) {
    List<String> splitStrings = oldDate.split('-');
    int month = int.parse(splitStrings[1]);
    int day = int.parse(splitStrings[2]);

    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    String suffix = 'th';
    int temp = day;

    if (temp > 10) {
      while (temp > 10) {
        temp -= 10;
      }
    }
    List<String> suffixes = ['st', 'nd', 'rd'];
    List<int> lowDates = [1, 2, 3];
    if (lowDates.contains(temp)) {
      suffix = suffixes[temp - 1];
    }

    return '${months[month - 1]} $day$suffix';
  }

  static List<String> getGenres(List<dynamic> oldGenres) {
    return oldGenres.map((genre) => genre['name'].toString()).toList();
  }

  static String getReadableNumber(double budget) {
    if (budget > 1000000) {
      return "\$${(budget / 1000000).toStringAsFixed(0)} million";
    }
    return "\$${(budget / 100000).toStringAsFixed(0)},000";
  }

  static List<String> getProductionCompanies(
      List<dynamic> mappedCompanies) {
    List<String> companies = mappedCompanies.map((item) {
      return item['name'] as String;
    }).toList();
    return companies;
  }
}
