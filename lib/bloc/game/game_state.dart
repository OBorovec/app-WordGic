part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object> get props => [];
}

class GameLoading extends GameState {}

class GameLoadingFailed extends GameState {
  final String message;

  const GameLoadingFailed({
    required this.message,
  });
}

enum GameRunningStatus { running, victory, lost }

class GameRunning extends GameState {
  // Game settings
  final Word targetWord;
  final String keys;
  final int maxAttempts;
  // Game progress
  final GameRunningStatus status;
  final List<String> pastAttempts;
  final String currentAttempt;
  final Set<int> knownPositions;
  final Set<String> knownLetters;
  final Set<String> disabledLetters;
  // Game flags
  final bool isFinished;
  final bool canDelete;
  final bool canSubmit;

  const GameRunning({
    required this.targetWord,
    required this.keys,
    required this.maxAttempts,
    this.status = GameRunningStatus.running,
    this.pastAttempts = const <String>[],
    this.knownPositions = const <int>{},
    this.knownLetters = const <String>{},
    this.disabledLetters = const <String>{},
    this.currentAttempt = '',
    this.isFinished = false,
    this.canDelete = false,
    this.canSubmit = false,
  });

  @override
  List<Object> get props => [
        isFinished,
        targetWord,
        keys,
        maxAttempts,
        pastAttempts,
        currentAttempt,
      ];

  GameRunning copyWith({
    Word? targetWord,
    String? keys,
    int? maxAttempts,
    GameRunningStatus? status,
    List<String>? pastAttempts,
    String? currentAttempt,
    Set<int>? knownPositions,
    Set<String>? knownLetters,
    Set<String>? disabledLetters,
    bool? isFinished,
    bool? canDelete,
    bool? canSubmit,
  }) {
    return GameRunning(
      targetWord: targetWord ?? this.targetWord,
      keys: keys ?? this.keys,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      status: status ?? this.status,
      pastAttempts: pastAttempts ?? this.pastAttempts,
      currentAttempt: currentAttempt ?? this.currentAttempt,
      knownPositions: knownPositions ?? this.knownPositions,
      knownLetters: knownLetters ?? this.knownLetters,
      disabledLetters: disabledLetters ?? this.disabledLetters,
      isFinished: isFinished ?? this.isFinished,
      canDelete: canDelete ?? this.canDelete,
      canSubmit: canSubmit ?? this.canSubmit,
    );
  }
}
