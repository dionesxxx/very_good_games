import 'package:equatable/equatable.dart';
import 'package:game_api/game_api.dart';

enum GameViewFilter { all, favoriteOnly }

extension GameViewFilterX on GameViewFilter {
  bool apply(GameView game) {
    switch (this) {
      case GameViewFilter.all:
        return true;
      case GameViewFilter.favoriteOnly:
        return game.isFavorite;
    }
  }

  Iterable<GameView> applyAll(Iterable<GameView> games) {
    return games.where(apply);
  }
}

class GameView extends Equatable {
  const GameView({required this.game, this.isFavorite = false});

  final bool isFavorite;
  final Game game;

  GameView copyWith({
    bool? isFavorite,
    Game? game,
  }) {
    return GameView(
      isFavorite: isFavorite ?? this.isFavorite,
      game: game ?? this.game,
    );
  }

  @override
  List<Object?> get props => [isFavorite, game];
}
