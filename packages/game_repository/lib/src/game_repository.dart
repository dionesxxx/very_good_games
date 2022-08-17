import 'package:game_api/game_api.dart';

/// {@template game_repository}
/// The interface and models for an API providing access to game
/// {@endtemplate}
class GameRepository {
  /// {@macro game_repository}
  const GameRepository({
    required GameApi gameApi,
  }) : _gameApi = gameApi;

  final GameApi _gameApi;

  ///Provide a [GameResponse] of all games
  Future<GameResponse> getGames() => _gameApi.getGames();

  ///Provide a nextPage for [GameResponse] of all games
  Future<GameResponse> getMoreGames(String nextPage) =>
      _gameApi.getMoreGames(nextPage);
}
