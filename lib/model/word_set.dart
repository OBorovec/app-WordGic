import 'package:equatable/equatable.dart';

enum WordSetLang { en }

class WordSet extends Equatable {
  final String wordSetPath;
  final String name;
  final List<String> langBase;
  final WordSetLang wordSetLang;

  const WordSet({
    required this.wordSetPath,
    required this.name,
    required this.langBase,
    required this.wordSetLang,
  });

  @override
  List<Object?> get props => [wordSetPath];
}
