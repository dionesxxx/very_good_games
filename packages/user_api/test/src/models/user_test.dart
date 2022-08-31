// ignore_for_file: avoid_redundant_argument_values
import 'package:test/test.dart';
import 'package:user_api/src/models/models.dart';

void main() {
  group('User', () {
    User createSubject({
      List<int> favoriteGames = const [1, 2, 3],
    }) {
      return User(
        favoriteGames: favoriteGames,
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
            favoriteGames: null,
          ),
          equals(createSubject()),
        );
      });
    });

    group('fromJson', () {
      test('works correctly', () {
        expect(
          User.fromJson(<String, dynamic>{
            'favoriteGames': [1, 2, 3],
          }),
          equals(createSubject()),
        );
      });
    });

    group('toJson', () {
      test('works correctly', () {
        expect(
          createSubject().toJson(),
          equals(<String, dynamic>{
            'favoriteGames': [1, 2, 3],
          }),
        );
      });
    });
  });
}
