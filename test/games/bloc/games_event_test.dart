import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_games/games/bloc/games_bloc.dart';
import 'package:very_good_games/games/models/game_view.dart';

class FakeGameView extends Fake implements GameView {}

void main() {
  group('GameEvent', () {
    group('GameFetched', () {
      test('supports value comparison', () {
        expect(GamesFetched(), GamesFetched());
      });
    });
    group('GamesFavoitedSubscriptionRequested', () {
      test('supports value comparison', () {
        expect(
          const GamesFavoitedSubscriptionRequested(),
          const GamesFavoitedSubscriptionRequested(),
        );
      });
    });
    group('GamesFavoitedSubscriptionRequested', () {
      final gameView = FakeGameView();
      test('supports value comparison', () {
        expect(
          GamesFavoriteToggle(
            game: gameView,
            isFavorited: true,
          ),
          GamesFavoriteToggle(
            game: gameView,
            isFavorited: true,
          ),
        );
      });
    });

    group('GamesFilterChanged', () {
      test('supports values comparison', () {
        expect(
          const GamesFilterChanged(GameViewFilter.all),
          equals(const GamesFilterChanged(GameViewFilter.all)),
        );
      });
      test('props are correct', () {
        expect(
          const GamesFilterChanged(GameViewFilter.all).props,
          equals(<Object>[GameViewFilter.all]),
        );
      });
    });
  });
}
