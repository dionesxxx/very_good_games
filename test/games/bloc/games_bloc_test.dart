import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_api/game_api.dart';
import 'package:game_repository/game_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:remote_game_api/remote_game_api.dart';
import 'package:user_api/user_api.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_games/games/bloc/games_bloc.dart';
import 'package:very_good_games/games/models/game_view.dart';

class MockGameRepository extends Mock implements GameRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class FakeUser extends Fake implements User {}

void main() {
  group('GameBloc', () {
    late GameRepository gameRepository;
    late UserRepository userRepository;

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

    final gamesView = [
      GameView(
        game: gamesResponse.games.first,
      ),
    ];

    final favoritesGames = User(favoriteGames: [gamesResponse.games.first.id]);

    const gamesResponseEmpty = GameResponse(
      count: 0,
      games: <Game>[],
      next: '',
      previous: '',
    );

    setUpAll(() {
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      gameRepository = MockGameRepository();
      userRepository = MockUserRepository();
    });

    GamesBloc createSubject() => GamesBloc(
          gameRepository: gameRepository,
          userRepository: userRepository,
        );

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
          when(() => gameRepository.getGames())
              .thenAnswer((_) async => gamesResponse);
        },
        build: createSubject,
        act: (bloc) => bloc.add(GamesFetched()),
        expect: () => <GamesState>[
          GamesState(
            status: GamesStatus.success,
            games: gamesView,
          )
        ],
      );

      blocTest<GamesBloc, GamesState>(
        'emits failure status when repository fetches game and throw exception',
        setUp: () {
          when(() => gameRepository.getGames())
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
          when(() => gameRepository.getMoreGames(any())).thenAnswer(
            (_) async => gamesResponseEmpty,
          );
        },
        build: createSubject,
        seed: () => const GamesState(
          status: GamesStatus.success,
        ),
        act: (bloc) => bloc.add(GamesFetched()),
        expect: () => <GamesState>[
          const GamesState(
            status: GamesStatus.success,
            hasReachedMax: true,
          )
        ],
      );

      blocTest<GamesBloc, GamesState>(
        'emits successful status and does not reach max games '
        'when additional games are fetched',
        setUp: () {
          when(() => gameRepository.getMoreGames(any())).thenAnswer(
            (_) async => gamesResponse,
          );
        },
        build: createSubject,
        seed: () => GamesState(
          status: GamesStatus.success,
          games: gamesView,
        ),
        act: (bloc) => bloc.add(GamesFetched()),
        expect: () => <GamesState>[
          GamesState(
            status: GamesStatus.success,
            games: [...gamesView, ...gamesView],
          )
        ],
      );

      blocTest<GamesBloc, GamesState>(
        'emits successful status and does not reach max games '
        'when initial games are fetched and there are favorites',
        setUp: () {
          when(() => gameRepository.getGames()).thenAnswer(
            (_) async => gamesResponse,
          );
        },
        build: createSubject,
        seed: () => GamesState(
          favorites: favoritesGames.favoriteGames,
          games: [gamesView.first],
        ),
        act: (bloc) => bloc.add(GamesFetched()),
        expect: () => <GamesState>[
          GamesState(
            favorites: favoritesGames.favoriteGames,
            status: GamesStatus.success,
            games: [
              ...[gamesView.first.copyWith(isFavorite: true)],
            ],
          )
        ],
      );

      blocTest<GamesBloc, GamesState>(
        'emits successful status and does not reach max games '
        'when additional games are fetched and there are favorites',
        setUp: () {
          when(() => gameRepository.getMoreGames(any())).thenAnswer(
            (_) async => gamesResponse,
          );
        },
        build: createSubject,
        seed: () => GamesState(
          status: GamesStatus.success,
          favorites: favoritesGames.favoriteGames,
          games: [gamesView.first],
        ),
        act: (bloc) => bloc.add(GamesFetched()),
        expect: () => <GamesState>[
          GamesState(
            favorites: favoritesGames.favoriteGames,
            status: GamesStatus.success,
            games: [
              ...gamesView,
              ...[gamesView.first.copyWith(isFavorite: true)],
            ],
          )
        ],
      );
    });

    group('GamesFavoriteToggle', () {
      blocTest<GamesBloc, GamesState>(
        'saves favorites games',
        build: createSubject,
        seed: () => GamesState(games: gamesView),
        setUp: () {
          when(() => userRepository.saveFavoriteGames(any()))
              .thenAnswer((_) async {});
        },
        act: (bloc) => bloc.add(
          GamesFavoriteToggle(
            game: gamesView.first,
            isFavorited: true,
          ),
        ),
        verify: (_) {
          verify(
            () => userRepository.saveFavoriteGames(
              favoritesGames,
            ),
          ).called(1);
        },
      );
    });

    group('GamesFavoitedSubscriptionRequested', () {
      blocTest<GamesBloc, GamesState>(
        'starts listening to user repository getUser stream',
        setUp: () => when(() => userRepository.getUser()).thenAnswer(
          (_) => Stream.value(favoritesGames),
        ),
        build: createSubject,
        act: (bloc) => bloc.add(const GamesFavoitedSubscriptionRequested()),
        verify: (_) {
          verify(() => userRepository.getUser()).called(1);
        },
      );
      blocTest<GamesBloc, GamesState>(
        'emits state with failure status',
        setUp: () => when(() => userRepository.getUser()).thenAnswer(
          (_) => Stream.error(Exception('opss')),
        ),
        build: createSubject,
        act: (bloc) => bloc.add(const GamesFavoitedSubscriptionRequested()),
        expect: () => [const GamesState()],
        verify: (_) {
          verify(() => userRepository.getUser()).called(1);
        },
      );
    });

    group('GamesFilterChanged', () {
      blocTest<GamesBloc, GamesState>(
        'emits state with favoriteOnly filter',
        setUp: () => when(() => userRepository.getUser()).thenAnswer(
          (_) => Stream.value(favoritesGames),
        ),
        build: createSubject,
        act: (bloc) => bloc.add(
          const GamesFilterChanged(GameViewFilter.favoriteOnly),
        ),
        expect: () => const [
          GamesState(filter: GameViewFilter.favoriteOnly),
        ],
      );
    });
  });
}
