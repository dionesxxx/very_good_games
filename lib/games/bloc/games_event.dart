part of 'games_bloc.dart';

@immutable
abstract class GamesEvent extends Equatable {
  const GamesEvent();

  @override
  List<Object> get props => [];
}

class GamesFavoitedSubscriptionRequested extends GamesEvent {
  const GamesFavoitedSubscriptionRequested();
}

class GamesFetched extends GamesEvent {}

class GamesFavoriteToggle extends GamesEvent {
  const GamesFavoriteToggle({
    required this.game,
    required this.isFavorited,
  });

  final GameView game;
  final bool isFavorited;

  @override
  List<Object> get props => [game, isFavorited];
}
