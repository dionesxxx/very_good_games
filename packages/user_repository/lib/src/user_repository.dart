import 'package:user_api/user_api.dart';

/// {@template user_repository}
/// A repository that handles user related requests
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  const UserRepository({
    required UserApi userApi,
  }) : _userApi = userApi;

  final UserApi _userApi;

  /// Provides a [Stream] of user.
  Stream<User> getUser() => _userApi.getUser();

  /// Saves a favorite game.
  ///
  /// If a [User] already exists, it will be replaced.
  Future<void> saveFavoriteGames(User user) => _userApi.saveFavoriteGames(user);
}
