import 'package:wordgic/model/word_set.dart';

class WordSets {
  static WordSet enNouns1000 = const WordSet(
    wordSetPath: 'assets/wordsets/en_nouns_1000.json',
    name: 'Nouns 1000',
    langBase: [
      'assets/langbase/en_adjective.json',
      'assets/langbase/en_adverb.json',
      'assets/langbase/en_noun.json',
      'assets/langbase/en_verb.json',
    ],
    wordSetLang: WordSetLang.en,
  );

  static WordSet enCrops100 = const WordSet(
    wordSetPath: 'assets/wordsets/en_crops_100.json',
    name: 'Crops 100',
    langBase: [
      'assets/langbase/en_adjective.json',
      'assets/langbase/en_adverb.json',
      'assets/langbase/en_noun.json',
      'assets/langbase/en_verb.json',
    ],
    wordSetLang: WordSetLang.en,
  );

  static WordSet enAnimals100 = const WordSet(
    wordSetPath: 'assets/wordsets/en_animals_100.json',
    name: 'Animals 100',
    langBase: [
      'assets/langbase/en_adjective.json',
      'assets/langbase/en_adverb.json',
      'assets/langbase/en_noun.json',
      'assets/langbase/en_verb.json',
    ],
    wordSetLang: WordSetLang.en,
  );

  static WordSet enCountries100 = const WordSet(
    wordSetPath: 'assets/wordsets/en_countries_100.json',
    name: 'Countries 100',
    langBase: [
      'assets/langbase/en_adjective.json',
      'assets/langbase/en_adverb.json',
      'assets/langbase/en_noun.json',
      'assets/langbase/en_verb.json',
    ],
    wordSetLang: WordSetLang.en,
  );
}
