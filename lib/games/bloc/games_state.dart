part of 'games_bloc.dart';

enum GamesStatus { initial, success, failure }

class GamesState extends Equatable {
  const GamesState({
    this.status = GamesStatus.initial,
    this.games = const <GameView>[],
    this.favorites = const [],
    this.nextPage = '',
    this.hasReachedMax = false,
  });

  final GamesStatus status;
  final List<GameView> games;
  final List<int> favorites;
  final String nextPage;
  final bool hasReachedMax;

  GamesState copyWith({
    GamesStatus? status,
    List<GameView>? games,
    List<int>? favorites,
    String? nextPage,
    bool? hasReachedMax,
  }) {
    return GamesState(
      status: status ?? this.status,
      games: games ?? this.games,
      favorites: favorites ?? this.favorites,
      nextPage: nextPage ?? this.nextPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props =>
      [status, games, favorites, nextPage, hasReachedMax];
}
