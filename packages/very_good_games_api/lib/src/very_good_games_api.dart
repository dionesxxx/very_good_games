import 'package:very_good_games_api/src/models/models.dart';

/// {@template very_good_games_api}
/// The interface and models for an API providing access to games
/// {@endtemplate}
abstract class VeryGoodGamesApi {
  /// {@macro very_good_games_api}
  const VeryGoodGamesApi();

  /// Provides a [Stream] of all games.
  Stream<List<Game>> getGames();
}
