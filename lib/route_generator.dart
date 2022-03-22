import 'package:flutter/material.dart';
import 'package:wordgic/views/game.dart';
import 'package:wordgic/views/home.dart';
import 'package:wordgic/views/wordsets.dart';

class RoutePaths {
  static const String home = '/';
  static const String game = '/game';
  static const String wordSets = '/wordsets';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    // final args = settings.arguments;
    switch (settings.name) {
      case RoutePaths.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case RoutePaths.game:
        final args = settings.arguments! as GamePageArguments;
        return MaterialPageRoute(
          builder: (_) => GamePage(wordSet: args.wordSet),
        );
      case RoutePaths.wordSets:
        return MaterialPageRoute(builder: (_) => const WordSetsPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR 404'),
        ),
      );
    });
  }
}
