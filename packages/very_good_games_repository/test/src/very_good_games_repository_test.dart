// ignore_for_file: prefer_const_constructors
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:very_good_games_api/very_good_games_api.dart';
import 'package:very_good_games_repository/very_good_games_repository.dart';

class MockVeryGoodApi extends Mock implements VeryGoodGamesApi {}

void main() {
  group('VeryGoodGamesRepository', () {
    late VeryGoodGamesApi api;

    final games = [
      Game(
        id: 1,
        name: 'God of War',
        released: '-',
        backgroundImage: 'https://',
        rating: 4.98,
      ),
      Game(
        id: 2,
        name: 'Horizon Zero Down',
        released: '-',
        backgroundImage: 'https://',
        rating: 4.92,
      ),
    ];

    setUp(() {
      api = MockVeryGoodApi();
      when(
        () => api.getGames(),
      ).thenAnswer((_) => Stream.value(games));
    });

    VeryGoodGamesRepository createSubject() =>
        VeryGoodGamesRepository(veryGoodGamesApi: api);

    group('constructor', () {
      test('works properly', () {
        expect(createSubject, returnsNormally);
      });
    });

    group('getGames', () {
      test('makes correct api request', () {
        final subject = createSubject();

        expect(
          subject.getGames(),
          isNot(throwsA(anything)),
        );

        verify(() => api.getGames()).called(1);
      });

      test('returns stream of current list games', () {
        expect(
          createSubject().getGames(),
          emits(games),
        );
      });
    });
  });
}
