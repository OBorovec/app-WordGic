part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GameLoad extends GameEvent {}

class GameReset extends GameEvent {}

class LetterInput extends GameEvent {
  final String letter;
  const LetterInput({
    required this.letter,
  });
}

class LetterDelete extends GameEvent {}

class WordSubmit extends GameEvent {}

class SuggestWord extends GameEvent {}
