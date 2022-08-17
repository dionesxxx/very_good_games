import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:game_api/game_api.dart';
import 'package:game_repository/game_repository.dart';
import 'package:meta/meta.dart';

part 'games_event.dart';
part 'games_state.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  GamesBloc({required GameRepository gameRepository})
      : _gameRepository = gameRepository,
        super(const GamesState()) {
    on<GamesFetched>(_onGameFetched, transformer: droppable());
  }

  final GameRepository _gameRepository;

  Future<void> _onGameFetched(
    GamesFetched event,
    Emitter<GamesState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == GamesStatus.initial) {
        final gamesResponse = await _gameRepository.getGames();
        return emit(
          state.copyWith(
            status: GamesStatus.success,
            games: gamesResponse.games,
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
                games: List.of(state.games)..addAll(gamesResponse.games),
                hasReachedMax: false,
              ),
            );
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: GamesStatus.failure));
    }
  }
}
