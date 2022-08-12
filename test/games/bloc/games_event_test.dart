import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_games/games/bloc/games_bloc.dart';

void main() {
  group('GameEvent', () {
    group('GameFetched', () {
      test('supports value comparison', () {
        expect(GamesFetched(), GamesFetched());
      });
    });
  });
}
