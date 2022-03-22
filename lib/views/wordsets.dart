import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordgic/bloc/wordsets/wordsets_bloc.dart';
import 'package:wordgic/components/_page/side_page.dart';
import 'package:wordgic/model/word_set.dart';
import 'package:wordgic/route_generator.dart';
import 'package:wordgic/views/game.dart';

class WordSetsPage extends StatelessWidget {
  const WordSetsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WordSetsBloc()
        ..add(
          LoadWordSetsEvent(),
        ),
      child: SidePage(
        body: BlocConsumer<WordSetsBloc, WordSetsState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is WordSetsLoaded) {
              return ListView.builder(
                itemCount: state.wordSets.length,
                itemBuilder: (context, index) {
                  return WordSetCard(
                    wordSet: state.wordSets[index],
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class WordSetCard extends StatelessWidget {
  final WordSet wordSet;
  const WordSetCard({
    Key? key,
    required this.wordSet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          RoutePaths.game,
          arguments: GamePageArguments(
            wordSet: wordSet,
          ),
        ),
        child: ListTile(
          title: Text(wordSet.name),
        ),
      ),
    );
  }
}
