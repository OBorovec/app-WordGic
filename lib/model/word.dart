import 'dart:convert';

import 'package:equatable/equatable.dart';

class Word extends Equatable {
  final String word;
  final String desc;

  const Word({
    required this.word,
    required this.desc,
  });
  @override
  List<Object?> get props => [word];

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'desc': desc,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      word: map['word'] ?? '',
      desc: map['desc'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Word.fromJson(String source) => Word.fromMap(json.decode(source));
}
