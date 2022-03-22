import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordgic/constants/game.dart';
import 'package:wordgic/model/word.dart';
import 'package:wordgic/model/word_set.dart';

import 'package:wordgic/services/assets_loader.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final WordSet wordSet;
  late List<Word> availableWords;
  late Set<String> allowedWords;
  GameBloc({
    required this.wordSet,
  }) : super(GameLoading()) {
    on<GameLoad>(_loadGame);
    on<GameReset>(_reset);
    on<LetterInput>(_letterInput);
    on<LetterDelete>(_letterDelete);
    on<WordSubmit>(_wordSubmit);
    on<SuggestWord>(_suggestWord);
  }

  FutureOr<void> _loadGame(
    GameLoad event,
    Emitter<GameState> emit,
  ) async {
    try {
      if (wordSet.wordSetPath.startsWith('assets')) {
        // Load words of Set
        final List<dynamic> wordSetData =
            await parseJsonFromAssets(wordSet.wordSetPath) as List<dynamic>;
        availableWords = wordSetData.map((e) => Word.fromMap(e)).toList();
        // Load allowed words of Set
        allowedWords = <String>{};
        for (var langBaseFile in wordSet.langBase) {
          final List<dynamic> wordSetLangBaseData =
              await parseJsonFromAssets(langBaseFile) as List<dynamic>;
          allowedWords.addAll(
              wordSetLangBaseData.map((e) => e as String).toSet().toList());
        }
        add(GameReset());
      } else {
        emit(
          const GameLoadingFailed(message: 'Something went wrong'),
        );
      }
    } catch (e) {
      emit(GameLoadingFailed(message: e.toString()));
    }
  }

  FutureOr<void> _reset(
    GameReset event,
    Emitter<GameState> emit,
  ) {
    // Load alphabet
    const String keys = 'abcdefghijklmnopqrstuvwxyz-';
    // Select random word
    final Word randomWord =
        availableWords[Random().nextInt(availableWords.length)];
    // Count max attempts
    final int maxAttempts = min(
      GameSettings.maxAttempts,
      max(
        randomWord.word.length,
        GameSettings.minAttempts,
      ),
    );
    // Start a game
    emit(
      GameRunning(
        targetWord: randomWord,
        maxAttempts: maxAttempts,
        keys: keys,
      ),
    );
  }

  FutureOr<void> _letterInput(
    LetterInput event,
    Emitter<GameState> emit,
  ) {
    if (state is GameRunning) {
      GameRunning rs = state as GameRunning;
      final String attemptWord = rs.currentAttempt + event.letter;
      emit(
        rs.copyWith(
          currentAttempt: attemptWord,
          canDelete: attemptWord.isNotEmpty,
          canSubmit: allowedWords.contains(attemptWord) ||
              attemptWord == rs.targetWord.word,
        ),
      );
    }
  }

  FutureOr<void> _letterDelete(
    LetterDelete event,
    Emitter<GameState> emit,
  ) {
    if (state is GameRunning) {
      GameRunning rs = state as GameRunning;
      final String attemptWord = rs.currentAttempt.substring(
        0,
        rs.currentAttempt.length - 1,
      );
      emit(
        rs.copyWith(
          currentAttempt: attemptWord,
          canDelete: attemptWord.isNotEmpty,
          canSubmit: allowedWords.contains(attemptWord) ||
              attemptWord == rs.targetWord.word,
        ),
      );
    }
  }

  FutureOr<void> _wordSubmit(
    WordSubmit event,
    Emitter<GameState> emit,
  ) {
    if (state is GameRunning) {
      GameRunning rs = state as GameRunning;
      List<String> pastAttempts = rs.pastAttempts.toList();
      pastAttempts.add(rs.currentAttempt);
      if (rs.currentAttempt == rs.targetWord.word) {
        emit(
          rs.copyWith(
            status: GameRunningStatus.victory,
            pastAttempts: pastAttempts,
            currentAttempt: '',
            canDelete: false,
            canSubmit: false,
          ),
        );
      } else if (pastAttempts.length >= rs.maxAttempts) {
        emit(
          rs.copyWith(
            status: GameRunningStatus.lost,
            pastAttempts: pastAttempts,
            currentAttempt: '',
            canDelete: false,
            canSubmit: false,
          ),
        );
      } else {
        Set<String> correctLetters = rs.knownLetters.toSet();
        Set<int> correctIndexes = rs.knownPositions.toSet();
        for (int idx in Iterable<int>.generate(rs.currentAttempt.length)) {
          if (rs.currentAttempt[idx] == rs.targetWord.word[idx]) {
            correctIndexes.add(idx);
          }
          if (rs.targetWord.word.contains(rs.currentAttempt[idx])) {
            correctLetters.add(rs.currentAttempt[idx]);
          }
        }

        emit(
          rs.copyWith(
            pastAttempts: pastAttempts,
            currentAttempt: '',
            knownPositions: correctIndexes,
            knownLetters: correctLetters,
            canDelete: false,
            canSubmit: false,
          ),
        );
      }
    }
  }

  FutureOr<void> _suggestWord(
    SuggestWord event,
    Emitter<GameState> emit,
  ) {
    if (state is GameRunning) {
      GameRunning rs = state as GameRunning;
      final List<String> possibleSuggestions = allowedWords
          .where(
            (String word) => word.length == rs.targetWord.word.length,
          )
          .where(
            (String word) => rs.knownLetters.every(
              (String letter) => word.contains(letter),
            ),
          )
          .where(
            (String word) => rs.knownPositions.every(
              (int idx) => word[idx] == rs.targetWord.word[idx],
            ),
          )
          .toList();
      final String attemptWord =
          possibleSuggestions[Random().nextInt(possibleSuggestions.length)];
      emit(
        rs.copyWith(
          currentAttempt: attemptWord,
          canDelete: attemptWord.isNotEmpty,
          canSubmit: allowedWords.contains(attemptWord) ||
              attemptWord == rs.targetWord.word,
        ),
      );
    }
  }
}
