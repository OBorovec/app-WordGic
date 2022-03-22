import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wordgic/components/_page/root_page.dart';
import 'package:wordgic/constants/data.dart';
import 'package:wordgic/route_generator.dart';
import 'package:wordgic/utils/toasting.dart';
import 'package:wordgic/views/game.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RootPage(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.game,
                  arguments: GamePageArguments(
                    wordSet: WordSets.enNouns1000,
                  ),
                );
              },
              child: const Text('Quick game'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.wordSets,
                );
              },
              child: const Text('Word sets'),
            ),
            ElevatedButton(
              onPressed: () {
                Toasting.notifyToast(
                  context: context,
                  message: 'Not implemented yet...',
                );
              },
              child: const Text('Challenge'),
            ),
            ElevatedButton(
              onPressed: () {
                Toasting.notifyToast(
                  context: context,
                  message: 'Not implemented yet...',
                );
              },
              child: const Text('Host game'),
            ),
            ElevatedButton(
              onPressed: () {
                exit(0);
              },
              child: const Text('Exit'),
            )
          ],
        ),
      ),
    );
  }
}
