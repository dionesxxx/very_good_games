import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:game_repository/game_repository.dart';
import 'package:meta/meta.dart';
import 'package:user_api/user_api.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_games/games/models/game_view.dart';

part 'games_event.dart';
part 'games_state.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  GamesBloc({
    required GameRepository gameRepository,
    required UserRepository userRepository,
  })  : _gameRepository = gameRepository,
        _userRepository = userRepository,
        super(const GamesState()) {
    on<GamesFavoitedSubscriptionRequested>(
      _onGamesFavoitedSubscriptionRequested,
    );
    on<GamesFetched>(_onGameFetched, transformer: droppable());
    on<GamesFavoriteToggle>(_onGameFavoriteToggle);
    on<GamesFilterChanged>(_onFilterChanged);
  }

  final GameRepository _gameRepository;
  final UserRepository _userRepository;

  Future<void> _onGamesFavoitedSubscriptionRequested(
    GamesFavoitedSubscriptionRequested event,
    Emitter<GamesState> emit,
  ) async {
    await emit.forEach<User>(
      _userRepository.getUser(),
      onData: (user) => state.copyWith(
        favorites: [...user.favoriteGames],
      ),
      onError: (error, _) {
        return state;
      },
    );
  }

  Future<void> _onGameFetched(
    GamesFetched event,
    Emitter<GamesState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == GamesStatus.initial) {
        final gamesResponse = await _gameRepository.getGames();
        final games = gamesResponse.games.map(
          (game) {
            if (state.favorites.contains(game.id)) {
              return GameView(isFavorite: true, game: game);
            }
            return GameView(game: game);
          },
        );

        return emit(
          state.copyWith(
            status: GamesStatus.success,
            games: games.toList(),
            nextPage: gamesResponse.next,
            hasReachedMax: false,
          ),
        );
      }

      final gamesResponse = await _gameRepository.getMoreGames(state.nextPage);
      gamesResponse.games.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: GamesStatus.success,
                games: List.of(state.games)
                  ..addAll(
                    gamesResponse.games.map((game) {
                      if (state.favorites.contains(game.id)) {
                        return GameView(isFavorite: true, game: game);
                      }
                      return GameView(game: game);
                    }),
                  ),
                hasReachedMax: false,
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: GamesStatus.failure));
    }
  }

  Future<void> _onGameFavoriteToggle(
    GamesFavoriteToggle event,
    Emitter<GamesState> emit,
  ) async {
    final newFavoriteGame = event.game.copyWith(isFavorite: event.isFavorited);
    state.games[state.games
            .indexWhere((game) => game.game.id == newFavoriteGame.game.id)] =
        newFavoriteGame;

    await _userRepository.saveFavoriteGames(
      User(
        favoriteGames: [
          ...state.games
              .where((gameView) => gameView.isFavorite)
              .map((game) => game.game.id)
        ],
      ),
    );
  }

  void _onFilterChanged(
    GamesFilterChanged event,
    Emitter<GamesState> emit,
  ) {
    emit(state.copyWith(filter: event.filter));
  }
}
