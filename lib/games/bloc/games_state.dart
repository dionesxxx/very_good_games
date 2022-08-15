part of 'games_bloc.dart';

enum GamesStatus { initial, success, failure }

class GamesState extends Equatable {
  const GamesState({
    this.status = GamesStatus.initial,
    this.games = const <Game>[],
    this.nextPage = '',
    this.hasReachedMax = false,
  });

  final GamesStatus status;
  final List<Game> games;
  final String nextPage;
  final bool hasReachedMax;

  GamesState copyWith({
    GamesStatus? status,
    List<Game>? games,
    String? nextPage,
    bool? hasReachedMax,
  }) {
    return GamesState(
      status: status ?? this.status,
      games: games ?? this.games,
      nextPage: nextPage ?? this.nextPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [status, games, nextPage, hasReachedMax];
}
