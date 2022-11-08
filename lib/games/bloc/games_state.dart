part of 'games_bloc.dart';

enum GamesStatus { initial, success, failure }

class GamesState extends Equatable {
  const GamesState({
    this.status = GamesStatus.initial,
    this.games = const <GameView>[],
    this.favorites = const [],
    this.filter = GameViewFilter.all,
    this.nextPage = '',
    this.hasReachedMax = false,
  });

  final GamesStatus status;
  final List<GameView> games;
  final List<int> favorites;
  final GameViewFilter filter;
  final String nextPage;
  final bool hasReachedMax;

  Iterable<GameView> get filteredGames => filter.applyAll(games);

  GamesState copyWith({
    GamesStatus? status,
    List<GameView>? games,
    List<int>? favorites,
    GameViewFilter? filter,
    String? nextPage,
    bool? hasReachedMax,
  }) {
    return GamesState(
      status: status ?? this.status,
      games: games ?? this.games,
      favorites: favorites ?? this.favorites,
      filter: filter ?? this.filter,
      nextPage: nextPage ?? this.nextPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props =>
      [status, games, favorites, filter, nextPage, hasReachedMax];
}
