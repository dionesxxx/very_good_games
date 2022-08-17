import 'dart:convert';
import 'dart:developer';

import 'package:game_api/game_api.dart';
import 'package:http/http.dart' as http;
import 'package:remote_game_api/constants/constants.dart';

/// Exception thrown when getGames fails.
class GamesRequestFailure implements Exception {}

/// Exception thrown when the provided list of game is not found.
class GamesNotFoundFailure implements Exception {}

/// {@template very_good_remote_games_api}
/// A Flutter implementation of the VeryGoodGamesApi that uses a remote http
/// {@endtemplate}
class RemoteGameApi extends GameApi {
  /// {@macro very_good_remote_games_api}
  RemoteGameApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'api.rawg.io';
  final http.Client _httpClient;

  @override
  Future<GameResponse> getGames() async {
    final gamesRequest = Uri.https(
      _baseUrl,
      '/api/games',
      {'key': Constants.apiKey, 'page_size': '20'},
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

  @override
  Future<GameResponse> getMoreGames(String nextPage) async {
    final gamesRequest = Uri.parse(nextPage);
    log(gamesRequest.toString());
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
