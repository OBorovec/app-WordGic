part of 'wordsets_bloc.dart';

abstract class WordSetsState extends Equatable {
  const WordSetsState();

  @override
  List<Object> get props => [];
}

class WordSetsInitial extends WordSetsState {}

class WordSetsLoaded extends WordSetsState {
  final List<WordSet> wordSets;

  const WordSetsLoaded({
    required this.wordSets,
  });

  WordSetsLoaded copyWith({
    List<WordSet>? wordSets,
  }) {
    return WordSetsLoaded(
      wordSets: wordSets ?? this.wordSets,
    );
  }
}
