import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_api/game_api.dart';
import 'package:game_repository/game_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:remote_game_api/remote_game_api.dart';
import 'package:very_good_games/games/bloc/games_bloc.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  group('GameBloc', () {
    late GameRepository repository;
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
      repository = MockGameRepository();
    });

    GamesBloc createSubject() => GamesBloc(gameRepository: repository);

    group('constructor', () {
      test('works properly', () {
        expect(createSubject, returnsNormally);
      });
    });

    group('GamesFetched', () {
      blocTest<GamesBloc, GamesState>(
        'emits nothing when posts has reached maximum amount',
        build: createSubject,
        seed: () => const GamesState(hasReachedMax: true),
        act: (bloc) => bloc.add(GamesFetched()),
        expect: () => const <GamesState>[],
      );

      blocTest<GamesBloc, GamesState>(
        'emits successful status when http fetches initial games',
        setUp: () {
          when(() => repository.getGames())
              .thenAnswer((_) async => gamesResponse);
        },
        build: createSubject,
        act: (bloc) => bloc.add(GamesFetched()),
        expect: () => <GamesState>[
          GamesState(
            status: GamesStatus.success,
            games: gamesResponse.games,
          )
        ],
      );

      blocTest<GamesBloc, GamesState>(
        'emits failure status when repository fetches game and throw exception',
        setUp: () {
          when(() => repository.getGames())
              .thenThrow((_) async => GamesRequestFailure());
        },
        build: createSubject,
        act: (bloc) => bloc.add(GamesFetched()),
        expect: () => <GamesState>[
          const GamesState(
            status: GamesStatus.failure,
          )
        ],
      );

      blocTest<GamesBloc, GamesState>(
        'emits successful status and reaches max games when '
        '0 additional games are fetched',
        setUp: () {
          when(() => repository.getMoreGames(any())).thenAnswer(
            (_) async => gamesResponseEmpty,
          );
        },
        build: createSubject,
        seed: () => GamesState(
          status: GamesStatus.success,
          games: gamesResponseEmpty.games,
        ),
        act: (bloc) => bloc.add(GamesFetched()),
        expect: () => <GamesState>[
          GamesState(
            status: GamesStatus.success,
            games: gamesResponseEmpty.games,
            hasReachedMax: true,
          )
        ],
      );

      blocTest<GamesBloc, GamesState>(
        'emits successful status and does not reach max games '
        'when additional games are fetched',
        setUp: () {
          when(() => repository.getMoreGames(any())).thenAnswer(
            (_) async => gamesResponse,
          );
        },
        build: createSubject,
        seed: () => GamesState(
          status: GamesStatus.success,
          games: gamesResponse.games,
        ),
        act: (bloc) => bloc.add(GamesFetched()),
        expect: () => <GamesState>[
          GamesState(
            status: GamesStatus.success,
            games: [...gamesResponse.games, ...gamesResponse.games],
          )
        ],
      );
    });
  });
}
