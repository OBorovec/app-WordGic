import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wordgic/bloc/game/game_bloc.dart';
import 'package:wordgic/components/_page/confirm_pop_page.dart';
import 'package:wordgic/constants/game.dart';
import 'package:wordgic/model/word_set.dart';
import 'package:wordgic/utils/toasting.dart';

class GamePage extends StatelessWidget {
  final WordSet wordSet;
  const GamePage({
    Key? key,
    required this.wordSet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(
        wordSet: wordSet,
      )..add(GameLoad()),
      child: Builder(builder: (context) {
        return PopDialogPage(
          body: _buildBody(context),
          popDialogTitle: 'Exit game.',
          popDialogText: 'You sure, you wanna exit the current game?',
          controlButtons: _gameControlIcons(context),
        );
      }),
    );
  }

  List<Widget> _gameControlIcons(BuildContext context) {
    return [
      IconButton(
        onPressed: () => BlocProvider.of<GameBloc>(context).add(GameReset()),
        icon: const Icon(Icons.refresh_outlined),
      ),
      IconButton(
        onPressed: () {
          Toasting.notifyToast(
            context: context,
            message: 'Not implemented yet...',
            gravity: ToastGravity.CENTER,
          );
        },
        icon: const Icon(Icons.help_outline),
      ),
      IconButton(
        onPressed: () => BlocProvider.of<GameBloc>(context).add(SuggestWord()),
        icon: const Icon(Icons.wb_incandescent_outlined),
      ),
    ];
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listenWhen: (previous, current) {
        if (previous is GameRunning && current is GameRunning) {
          return previous.status != current.status;
        }
        return false;
      },
      listener: (context, state) {
        if (state is GameRunning) {
          switch (state.status) {
            case GameRunningStatus.victory:
              _showResultDialog(
                context,
                'Victory',
                'Congratulation, you successfully guessed the word ${state.targetWord.word}.',
              );
              break;
            case GameRunningStatus.lost:
              _showResultDialog(
                context,
                'Victory',
                'Sorry, the hidden word was ${state.targetWord.word}.',
              );
              break;
            case GameRunningStatus.running:
              break;
          }
        }
      },
      builder: (context, state) {
        if (state is GameRunning) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: _buildTargetWord(
                    context,
                    state,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildAttempts(state),
                ),
                Row(
                  children: [
                    Expanded(child: _buildKeyBoard(context, state)),
                    _buildAttemptControl(context, state),
                  ],
                )
              ],
            ),
          );
        }
        if (state is GameLoadingFailed) {
          return Center(
            child: Text(state.message),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<dynamic> _showResultDialog(
    BuildContext rootContext,
    String title,
    String text,
  ) {
    return showDialog(
      context: rootContext,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              BlocProvider.of<GameBloc>(rootContext).add(GameReset());
              Navigator.of(context).pop();
            },
            child: const Text('Another'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(rootContext).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetWord(
    BuildContext context,
    GameRunning state,
  ) {
    return Center(
      child: RevealWord(
        targetWord: state.targetWord.word,
        revealPositions: state.knownPositions,
        textStyle: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  Center _buildAttempts(GameRunning state) {
    return Center(
      child: ListView.builder(
        itemCount: state.maxAttempts,
        itemBuilder: (context, index) {
          if (index < state.pastAttempts.length) {
            return AttemptWord(
              targetWord: state.targetWord.word,
              attemptWord: state.pastAttempts[index],
              useColors: true,
              textStyle: Theme.of(context).textTheme.headline5!,
            );
          } else if (index == state.pastAttempts.length) {
            return AttemptWord(
              targetWord: state.targetWord.word,
              attemptWord: state.currentAttempt,
              textStyle: Theme.of(context).textTheme.headline5!,
            );
          } else {
            return AttemptWord(
              targetWord: state.targetWord.word,
              attemptWord: '',
              textStyle: Theme.of(context).textTheme.headline5!,
            );
          }
        },
      ),
    );
  }

  Widget _buildKeyBoard(BuildContext context, GameRunning state) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      children: [
        ...state.keys.runes.map(
          (int e) {
            final String letter = String.fromCharCode(e);
            return GameKeyBoardButton(
              str: letter,
              isKnown: state.knownLetters.contains(letter),
              onPressed: () {
                BlocProvider.of<GameBloc>(context)
                    .add(LetterInput(letter: letter));
              },
            );
          },
        ).toList(),
      ],
    );
  }

  Widget _buildAttemptControl(BuildContext context, GameRunning state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        GameAttemptControlButton(
          str: 'Delete',
          onPressed: () {
            BlocProvider.of<GameBloc>(context).add(LetterDelete());
          },
          enabled: state.canDelete,
        ),
        GameAttemptControlButton(
          str: 'Submit',
          onPressed: () {
            BlocProvider.of<GameBloc>(context).add(WordSubmit());
          },
          enabled: state.canSubmit,
        ),
      ],
    );
  }
}

class AttemptWord extends StatelessWidget {
  final String targetWord;
  final String attemptWord;
  final bool useColors;
  final TextStyle textStyle;
  const AttemptWord({
    Key? key,
    required this.targetWord,
    required this.attemptWord,
    this.useColors = false,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: Iterable<int>.generate(targetWord.length).map((idx) {
        String wordLetter = targetWord[idx];
        String attemptLetter =
            idx < attemptWord.length ? attemptWord[idx] : '_';
        late final TextStyle? coloredTextStyle;
        if (useColors) {
          if (attemptLetter == wordLetter) {
            coloredTextStyle =
                textStyle.copyWith(color: GameColors.correctPlace);
          } else if (targetWord.contains(attemptLetter)) {
            coloredTextStyle =
                textStyle.copyWith(color: GameColors.correctExistence);
          } else {
            coloredTextStyle = textStyle;
          }
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Text(
            attemptLetter,
            style: useColors ? coloredTextStyle : textStyle,
          ),
        );
      }).toList(),
    );
  }
}

class RevealWord extends StatelessWidget {
  final String targetWord;
  final Set<int>? revealPositions;
  final TextStyle? textStyle;
  const RevealWord({
    Key? key,
    required this.targetWord,
    this.revealPositions,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: Iterable<int>.generate(targetWord.length).map((idx) {
        late final String wordLetter;
        if (revealPositions == null || revealPositions!.contains(idx)) {
          wordLetter = targetWord[idx];
        } else {
          wordLetter = '*';
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Text(
            wordLetter,
            style: textStyle,
          ),
        );
      }).toList(),
    );
  }
}

class GameKeyBoardButton extends StatelessWidget {
  final String str;
  final Function() onPressed;
  final bool enabled;
  final bool isKnown;

  const GameKeyBoardButton({
    Key? key,
    required this.str,
    required this.onPressed,
    this.enabled = true,
    this.isKnown = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ElevatedButton(
        style: isKnown
            ? ElevatedButton.styleFrom(primary: GameColors.correctExistence)
            : null,
        onPressed: enabled ? onPressed : null,
        child: Text(str),
      ),
    );
  }
}

class GameAttemptControlButton extends StatelessWidget {
  final String str;
  final Function() onPressed;
  final bool enabled;

  const GameAttemptControlButton({
    Key? key,
    required this.str,
    required this.onPressed,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          child: Text(
            str,
          ),
        ),
      ),
    );
  }
}

class GamePageArguments {
  final WordSet wordSet;

  GamePageArguments({required this.wordSet});
}
