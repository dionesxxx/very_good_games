import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:very_good_games_api/very_good_games_api.dart';
import 'package:very_good_games_repository/very_good_games_repository.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({required VeryGoodGamesRepository veryGoodGamesRepository})
      : _veryGoodGamesRepository = veryGoodGamesRepository,
        super(const GameState()) {
    on<GameFetched>(_onGameFetched);
  }

  final VeryGoodGamesRepository _veryGoodGamesRepository;

  Future<void> _onGameFetched(
    GameFetched event,
    Emitter<GameState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == GameStatus.initial) {
        final gamesResponse = await _veryGoodGamesRepository.getGames();
        return emit(
          state.copyWith(
            status: GameStatus.success,
            games: gamesResponse.games,
            hasReachedMax: false,
          ),
        );
      }

      final gamesResponse = await _veryGoodGamesRepository.getGames();
      gamesResponse.games.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: GameStatus.success,
                games: List.of(state.games)..addAll(gamesResponse.games),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: GameStatus.failure));
    }
  }
}
