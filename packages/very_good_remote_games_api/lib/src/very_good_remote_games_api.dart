import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:very_good_games_api/very_good_games_api.dart';
import 'package:very_good_remote_games_api/constants/constants.dart';

/// Exception thrown when getGames fails.
class GamesRequestFailure implements Exception {}

/// Exception thrown when the provided list of game is not found.
class GamesNotFoundFailure implements Exception {}

/// {@template very_good_remote_games_api}
/// A Flutter implementation of the VeryGoodGamesApi that uses a remote http
/// {@endtemplate}
class VeryGoodRemoteGamesApi extends VeryGoodGamesApi {
  /// {@macro very_good_remote_games_api}
  VeryGoodRemoteGamesApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'www.api.rawg.io';
  final http.Client _httpClient;

  @override
  Future<GameResponse> getGames() async {
    final gamesRequest = Uri.https(
      _baseUrl,
      '/api/games?key=${Constants.apiKey}',
    );
    final gamesResponse = await _httpClient.get(gamesRequest);

    if (gamesResponse.statusCode != 200) {
      throw GamesRequestFailure();
    }

    final gameMap = jsonDecode(gamesResponse.body) as Map<String, dynamic>;

    if (gameMap.isEmpty) {
      throw GamesNotFoundFailure();
    }

    final game = GameResponse.fromJson(gameMap);

    return game;
  }
}
