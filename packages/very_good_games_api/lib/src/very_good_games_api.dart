import 'package:very_good_games_api/src/models/models.dart';

/// {@template very_good_games_api}
/// The interface and models for an API providing access to games
/// {@endtemplate}
abstract class VeryGoodGamesApi {
  /// {@macro very_good_games_api}
  const VeryGoodGamesApi();

  /// Provides a [Future<GameResponse>] of all games.
  Future<GameResponse> getGames();

  /// Provides a [Future<GameResponse>] for nextPage of all games.
  Future<GameResponse> getMoreGames(String nextPage);
}
