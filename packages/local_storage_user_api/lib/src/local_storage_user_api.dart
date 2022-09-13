import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_api/user_api.dart';

/// {@template local_storage_user_api}
/// A Flutter implementation of the [UserApi] that uses local storage.
/// {@endtemplate}
class LocalStorageUserApi extends UserApi {
  /// {@macro local_storage_user_api}
  LocalStorageUserApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _streamController = StreamController<User>();

  /// The key used for storing the games locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kFavoriteGamesCollectionKey =
      '__favorite_games_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final userJson = _getValue(kFavoriteGamesCollectionKey);
    if (userJson != null) {
      final user = User.fromJson(json.decode(userJson) as Map<String, dynamic>);
      _streamController.add(user);
    } else {
      _streamController.add(const User());
    }
  }

  @override
  Stream<User> getUser() => _streamController.stream.asBroadcastStream();

  @override
  Future<void> saveFavoriteGames(User user) {
    return _setValue(kFavoriteGamesCollectionKey, json.encode(user));
  }
}
