import 'package:very_good_games_api/very_good_games_api.dart';

/// {@template very_good_games_repository}
/// The interface and models for an API providing access to games
/// {@endtemplate}
class VeryGoodGamesRepository {
  /// {@macro very_good_games_repository}
  const VeryGoodGamesRepository({
    required VeryGoodGamesApi veryGoodGamesApi,
  }) : _veryGoodGamesApi = veryGoodGamesApi;

  final VeryGoodGamesApi _veryGoodGamesApi;

  ///Provide a [Stream] of all games
  Stream<List<Game>> getGames() => _veryGoodGamesApi.getGames();
}
