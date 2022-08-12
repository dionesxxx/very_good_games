// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_games/games/bloc/games_bloc.dart';

void main() {
  group('GameState', () {
    test('supports value comparison', () {
      expect(GamesState(), GamesState());
    });
  });
}
