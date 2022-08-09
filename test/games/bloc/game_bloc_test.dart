import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_games/games/bloc/game_bloc.dart';
import 'package:very_good_games_api/very_good_games_api.dart';
import 'package:very_good_games_repository/very_good_games_repository.dart';
import 'package:very_good_remote_games_api/very_good_remote_games_api.dart';

class MockVeryGoodGamesRepository extends Mock
    implements VeryGoodGamesRepository {}

void main() {
  group('GameBloc', () {
    late VeryGoodGamesRepository repository;
    const gamesResponse = GameResponse(
      count: 100,
      games: [
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

    const gamesResponseEmpty = GameResponse(
      count: 0,
      games: <Game>[],
      next: '',
      previous: '',
    );

    setUp(() {
      repository = MockVeryGoodGamesRepository();
    });

    GameBloc createSubject() => GameBloc(veryGoodGamesRepository: repository);

    group('constructor', () {
      test('works properly', () {
        expect(createSubject, returnsNormally);
      });
    });

    group('GameFetched', () {
      blocTest<GameBloc, GameState>(
        'emits nothing when posts has reached maximum amount',
        build: createSubject,
        seed: () => const GameState(hasReachedMax: true),
        act: (bloc) => bloc.add(GameFetched()),
        expect: () => const <GameState>[],
      );

      blocTest<GameBloc, GameState>(
        'emits successful status when http fetches initial games',
        setUp: () {
          when(() => repository.getGames())
              .thenAnswer((_) async => gamesResponse);
        },
        build: createSubject,
        act: (bloc) => bloc.add(GameFetched()),
        expect: () => <GameState>[
          GameState(
            status: GameStatus.success,
            games: gamesResponse.games,
          )
        ],
      );

      blocTest<GameBloc, GameState>(
        'emits failure status when repository fetches game and throw exception',
        setUp: () {
          when(() => repository.getGames())
              .thenThrow((_) async => GamesRequestFailure());
        },
        build: createSubject,
        act: (bloc) => bloc.add(GameFetched()),
        expect: () => <GameState>[
          const GameState(
            status: GameStatus.failure,
          )
        ],
      );

      blocTest<GameBloc, GameState>(
        'emits successful status and reaches max games when '
        '0 additional games are fetched',
        setUp: () {
          when(() => repository.getGames()).thenAnswer(
            (_) async => gamesResponseEmpty,
          );
        },
        build: createSubject,
        seed: () => GameState(
          status: GameStatus.success,
          games: gamesResponseEmpty.games,
        ),
        act: (bloc) => bloc.add(GameFetched()),
        expect: () => <GameState>[
          GameState(
            status: GameStatus.success,
            games: gamesResponseEmpty.games,
            hasReachedMax: true,
          )
        ],
      );

      blocTest<GameBloc, GameState>(
        'emits successful status and does not reach max games '
        'when additional games are fetched',
        setUp: () {
          when(() => repository.getGames()).thenAnswer(
            (_) async => gamesResponse,
          );
        },
        build: createSubject,
        seed: () => GameState(
          status: GameStatus.success,
          games: gamesResponse.games,
        ),
        act: (bloc) => bloc.add(GameFetched()),
        expect: () => <GameState>[
          GameState(
            status: GameStatus.success,
            games: [...gamesResponse.games, ...gamesResponse.games],
          )
        ],
      );
    });
  });
}
