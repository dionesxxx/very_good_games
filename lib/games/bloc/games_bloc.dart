import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:very_good_games_api/very_good_games_api.dart';
import 'package:very_good_games_repository/very_good_games_repository.dart';

part 'games_event.dart';
part 'games_state.dart';

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  GamesBloc({required VeryGoodGamesRepository veryGoodGamesRepository})
      : _veryGoodGamesRepository = veryGoodGamesRepository,
        super(const GamesState()) {
    on<GamesFetched>(_onGameFetched, transformer: droppable());
  }

  final VeryGoodGamesRepository _veryGoodGamesRepository;

  Future<void> _onGameFetched(
    GamesFetched event,
    Emitter<GamesState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == GamesStatus.initial) {
        final gamesResponse = await _veryGoodGamesRepository.getGames();
        return emit(
          state.copyWith(
            status: GamesStatus.success,
            games: gamesResponse.games,
            nextPage: gamesResponse.next,
            hasReachedMax: false,
          ),
        );
      }

      final gamesResponse =
          await _veryGoodGamesRepository.getMoreGames(state.nextPage);
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
