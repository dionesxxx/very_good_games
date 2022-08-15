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

    group('fromJson', () {
      test('works correctly', () {
        expect(
          Game.fromJson(<String, dynamic>{
            'id': 1,
            'name': 'God of War Ragnarok',
            'released': '-',
            'background_image': 'https://',
            'rating': 4.97,
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
            'id': 1,
            'name': 'God of War Ragnarok',
            'released': '-',
            'background_image': 'https://',
            'rating': 4.97,
          }),
        );
      });
    });
  });

  group('GameResponse', () {
    GameResponse createSubject({
      int count = 1,
      String next = '',
      String previous = '',
      List<Game> games = const <Game>[],
    }) {
      return GameResponse(
        count: count,
        next: next,
        previous: previous,
        games: games,
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
            count: null,
            games: null,
            next: null,
            previous: null,
          ),
          equals(createSubject()),
        );
      });
    });

    group('fromJson', () {
      test('works correctly', () {
        expect(
          GameResponse.fromJson(<String, dynamic>{
            'count': 1,
            'results': const <Game>[],
            'next': '',
            'previous': ''
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
            'count': 1,
            'results': const <Game>[],
            'next': '',
            'previous': ''
          }),
        );
      });
    });
  });
}
