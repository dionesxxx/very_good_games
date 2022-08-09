import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:very_good_games_api/src/models/json_map.dart';

part 'game.g.dart';

/// {@template game}
/// A single game item.
///
/// Contains a [id], [name], [released], [backgroundImage] and [rating]
///
/// [Game]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@JsonSerializable()
class Game extends Equatable {
  /// {@macro game}
  const Game({
    required this.id,
    required this.name,
    required this.released,
    required this.backgroundImage,
    required this.rating,
  });

  /// The id of a game
  ///
  /// Cannot be empty
  final int id;

  /// The name of the game
  ///
  /// Cannot be empty
  final String name;

  /// The date when the game was released
  ///
  /// Cannot be empty
  final String released;

  /// The background image of the game
  ///
  /// Cannot be empty
  @JsonKey(name: 'background_image')
  final String backgroundImage;

  /// The rating of the game
  ///
  /// Cannot be empty
  final double rating;

  /// Returns a copy of this game with the given values updated.
  ///
  /// {@macro game}
  Game copyWith({
    int? id,
    String? name,
    String? released,
    String? backgroundImage,
    double? rating,
  }) {
    return Game(
      id: id ?? this.id,
      name: name ?? this.name,
      released: released ?? this.released,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      rating: rating ?? this.rating,
    );
  }

  /// Deserializes the given [JsonMap] into a [Game].
  static Game fromJson(JsonMap json) => _$GameFromJson(json);

  /// Converts this [Game] into a [JsonMap].
  JsonMap toJson() => _$GameToJson(this);

  @override
  List<Object?> get props => [id, name, released, backgroundImage, rating];
}

/// {@template game response}
/// A single game response item.
///
/// Contains a [count], [next], [previous] and [games]
///
/// [Game]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@JsonSerializable()
class GameResponse extends Equatable {
  /// {@macro game response}
  const GameResponse({
    required this.count,
    this.next,
    this.previous,
    required this.games,
  });

  /// The counter of total games
  ///
  /// Cannot be empty
  final int count;

  /// The next page
  ///
  /// Note that the next may be empty.
  final String? next;

  /// The previous page
  ///
  /// Note that the next may be empty.
  final String? previous;

  /// A list of games
  ///
  /// Cannot be empty
  @JsonKey(name: 'results')
  final List<Game> games;

  /// Returns a copy of this game response with the given values updated.
  ///
  /// {@macro game response}
  GameResponse copyWith({
    int? count,
    String? next,
    String? previous,
    List<Game>? games,
  }) {
    return GameResponse(
      count: count ?? this.count,
      next: next ?? this.next,
      previous: previous ?? this.previous,
      games: games ?? this.games,
    );
  }

  /// Deserializes the given [JsonMap] into a [GameResponse].
  static GameResponse fromJson(JsonMap json) => _$GameResponseFromJson(json);

  /// Converts this [GameResponse] into a [JsonMap].
  JsonMap toJson() => _$GameResponseToJson(this);

  @override
  List<Object?> get props => [count, next, previous, games];
}
