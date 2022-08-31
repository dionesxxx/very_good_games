import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_api/src/models/json_map.dart';

part 'user.g.dart';

/// {@template user}
/// A single user item.
///
/// Contains a [favoriteGames]
///
/// [User]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}

@JsonSerializable()
class User extends Equatable {
  /// {@macro user}
  const User({
    this.favoriteGames = const [],
  });

  /// List of favorite games of the user
  ///
  /// Cannot be empty
  final List<int> favoriteGames;

  /// Returns a copy of this user with the given values updated.
  ///
  /// {@macro user}
  User copyWith({
    List<int>? favoriteGames,
  }) {
    return User(
      favoriteGames: favoriteGames ?? this.favoriteGames,
    );
  }

  /// Deserializes the given [JsonMap] into a [User].
  static User fromJson(JsonMap json) => _$UserFromJson(json);

  /// Converts this [User] into a [JsonMap].
  JsonMap toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [favoriteGames];
}
