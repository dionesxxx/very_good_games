part of 'games_bloc.dart';

@immutable
abstract class GamesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GamesFetched extends GamesEvent {}
