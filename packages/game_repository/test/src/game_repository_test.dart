// ignore_for_file: prefer_const_constructors
import 'package:game_api/game_api.dart';
import 'package:game_repository/game_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGameApi extends Mock implements GameApi {}

void main() {
  group('GameRepository', () {
    late GameApi api;

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
      api = MockGameApi();
      when(
        () => api.getGames(),
      ).thenAnswer((_) async => gamesResponse);
      when(
        () => api.getMoreGames(any()),
      ).thenAnswer((_) async => gamesResponse);
    });

    GameRepository createSubject() => GameRepository(gameApi: api);

    group('constructor', () {
      test('works properly', () {
        expect(createSubject, returnsNormally);
      });
    });

    group('getGames', () {
      test('makes correct api request', () async {
        final subject = createSubject();

        expect(
          await subject.getGames(),
          gamesResponse,
        );

        verify(() => api.getGames()).called(1);
      });
    });

    group('getMoreGames', () {
      test('makes correct api request', () async {
        final subject = createSubject();

        expect(
          await subject.getMoreGames(gamesResponse.next!),
          gamesResponse,
        );

        verify(() => api.getMoreGames(gamesResponse.next!)).called(1);
      });
    });
  });
}
