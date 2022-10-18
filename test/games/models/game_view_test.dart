import 'package:flutter_test/flutter_test.dart';
import 'package:game_api/game_api.dart';
import 'package:very_good_games/games/models/game_view.dart';

void main() {
  group('GameView', () {
    const games = [
      Game(
        id: 2,
        name: 'Horizon Zero Down',
        released: '-',
        backgroundImage: 'https://',
        rating: 4.92,
      )
    ];
    final favoritedGameView = GameView(isFavorite: true, game: games.first);
    final gameView = GameView(game: games.first);

    GameView createSubject({
      bool isFavorite = false,
      Game? game,
    }) {
      return GameView(
        isFavorite: isFavorite,
        game: game ?? games.first,
      );
    }

    group('apply', () {
      test('always returns true when filter is .all', () {
        expect(
          GameViewFilter.all.apply(favoritedGameView),
          isTrue,
        );
        expect(
          GameViewFilter.all.apply(gameView),
          isTrue,
        );
      });

      test(
        'returns true when filter is .favoriteOnly',
        () {
          expect(
            GameViewFilter.favoriteOnly.apply(favoritedGameView),
            isTrue,
          );
          expect(
            GameViewFilter.favoriteOnly.apply(gameView),
            isFalse,
          );
        },
      );
    });

    group('applyAll', () {
      test('correctly filters provided iterable based on selected filter', () {
        final allGames = [favoritedGameView, gameView];

        expect(
          GameViewFilter.all.applyAll(allGames),
          equals(allGames),
        );
        expect(
          GameViewFilter.favoriteOnly.applyAll(allGames),
          equals([favoritedGameView]),
        );
      });
    });

    group('copyWith', () {
      test('return the same object if not arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });
    });
  });
}
