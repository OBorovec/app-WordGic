import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wordgic/constants/data.dart';
import 'package:wordgic/model/word_set.dart';

part 'wordsets_event.dart';
part 'wordsets_state.dart';

class WordSetsBloc extends Bloc<WordSetsEvent, WordSetsState> {
  WordSetsBloc() : super(WordSetsInitial()) {
    on<LoadWordSetsEvent>(_loadWordSets);
  }

  FutureOr<void> _loadWordSets(
      LoadWordSetsEvent event, Emitter<WordSetsState> emit) {
    emit(
      WordSetsLoaded(
        wordSets: [
          WordSets.enNouns1000,
          WordSets.enAnimals100,
          WordSets.enCrops100,
          WordSets.enCountries100,
        ],
      ),
    );
  }
}
