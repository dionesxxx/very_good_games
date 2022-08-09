// ignore_for_file: prefer_const_constructors
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:very_good_games_api/very_good_games_api.dart';
import 'package:very_good_games_repository/very_good_games_repository.dart';

class MockVeryGoodApi extends Mock implements VeryGoodGamesApi {}

void main() {
  group('VeryGoodGamesRepository', () {
    late VeryGoodGamesApi api;

    final gamesResponse = GameResponse(
      count: 100,
      games: const [
        Game(
          id: 2,
          name: 'Horizon Zero Down',
          released: '-',
          backgroundImage: 'https://',
          rating: 4.92,
        )
      ],
      next: '',
      previous: '',
    );

    setUp(() {
      api = MockVeryGoodApi();
      when(
        () => api.getGames(),
      ).thenAnswer((_) async => gamesResponse);
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

      test('returns GameResponse of current list games', () {
        expect(
          createSubject().getGames(),
          emits(gamesResponse),
        );
      });
    });
  });
}
