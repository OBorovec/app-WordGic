part of 'wordsets_bloc.dart';

abstract class WordSetsEvent extends Equatable {
  const WordSetsEvent();

  @override
  List<Object> get props => [];
}

class LoadWordSetsEvent extends WordSetsEvent {}
