part of 'game_bloc.dart';

enum GameStatus { initial, success, failure }

class GameState extends Equatable {
  const GameState({
    this.status = GameStatus.initial,
    this.games = const <Game>[],
    this.hasReachedMax = false,
  });

  final GameStatus status;
  final List<Game> games;
  final bool hasReachedMax;

  GameState copyWith({
    GameStatus? status,
    List<Game>? games,
    bool? hasReachedMax,
  }) {
    return GameState(
      status: status ?? this.status,
      games: games ?? this.games,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [status, games, hasReachedMax];
}
