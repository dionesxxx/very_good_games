import 'package:game_api/src/models/models.dart';

/// {@template game_api}
/// The interface and models for an API providing access to games
/// {@endtemplate}
abstract class GameApi {
  /// {@macro game_api}
  const GameApi();

  /// Provides a [Future<GameResponse>] of all games.
  Future<GameResponse> getGames();

  /// Provides a [Future<GameResponse>] for nextPage of all games.
  Future<GameResponse> getMoreGames(String nextPage);
}
