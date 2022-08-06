// ignore_for_file: avoid_redundant_argument_values
import 'package:test/test.dart';
import 'package:very_good_games_api/src/models/models.dart';

void main() {
  group('Game', () {
    Game createSubject({
      int id = 1,
      String name = 'God of War Ragnarok',
      String released = '-',
      String backgroundImage = 'https://',
      double rating = 4.97,
    }) {
      return Game(
        id: id,
        name: name,
        released: released,
        backgroundImage: backgroundImage,
        rating: rating,
      );
    }

    group('constructor', () {
      test('works correctly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });

      test('supports value equality', () {
        expect(
          createSubject(),
          equals(createSubject()),
        );
      });
    });
    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            id: null,
            name: null,
            released: null,
            backgroundImage: null,
            rating: null,
          ),
          equals(createSubject()),
        );
      });
    });
  });
}
