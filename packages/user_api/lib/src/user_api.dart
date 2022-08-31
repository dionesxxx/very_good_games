import 'package:user_api/src/models/user.dart';

/// {@template user_api}
/// The interface and models for an API providing to access to user
/// {@endtemplate}
abstract class UserApi {
  /// {@macro user_api}
  const UserApi();

  /// Provides a [Stream] of user.
  Stream<User> getUser();

  /// Saves a favorite game.
  ///
  /// If a [gameId] already exists, it will be replaced.
  Future<void> saveFavoriteGames(int gameId);
}
