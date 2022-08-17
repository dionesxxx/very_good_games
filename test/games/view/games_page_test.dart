import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_api/game_api.dart';
import 'package:game_repository/game_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_games/games/bloc/games_bloc.dart';
import 'package:very_good_games/games/view/view.dart';
import 'package:very_good_games/games/widgets/widgets.dart';

import '../../helpers/helpers.dart';

class MockGamesBloc extends MockBloc<GamesEvent, GamesState>
    implements GamesBloc {}

void main() {
  late GameRepository gameRepository;
  const gameResponse = GameResponse(
    count: 1,
    games: [
      Game(
        id: 1,
        name: 'Mario',
        released: '-',
        backgroundImage: '',
        rating: 4.66,
      )
    ],
    next: '',
    previous: '',
  );

  group('GamesPage', () {
    setUp(() {
      gameRepository = MockGameRepository();
      when(() => gameRepository.getGames())
          .thenAnswer((_) async => gameResponse);
      when(() => gameRepository.getMoreGames(any()))
          .thenAnswer((_) async => gameResponse);
    });

    testWidgets('renders GamesView', (tester) async {
      await tester.pumpApp(
        const GamesPage(),
        gameRepository: gameRepository,
      );
    });
  });

  group('GamesView', () {
    late GamesBloc gamesBloc;
    setUp(() {
      gameRepository = MockGameRepository();
      when(() => gameRepository.getGames())
          .thenAnswer((_) async => gameResponse);
      when(() => gameRepository.getMoreGames(any()))
          .thenAnswer((_) async => gameResponse);

      gamesBloc = MockGamesBloc();
      when(() => gamesBloc.state).thenReturn(
        GamesState(
          status: GamesStatus.success,
          games: [...gameResponse.games],
        ),
      );

      gameRepository = MockGameRepository();
      when(() => gameRepository.getGames())
          .thenAnswer((_) async => gameResponse);
      when(() => gameRepository.getMoreGames(any()))
          .thenAnswer((_) async => gameResponse);
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: gamesBloc,
        child: const GamesView(),
      );
    }

    testWidgets('renders AppBar with title text', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        gameRepository: gameRepository,
      );

      expect(find.byType(AppBar), findsOneWidget);

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text(l10n.gamesAppBarTitle),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'renders error snackbar '
      'when status changes to failure',
      (tester) async {
        whenListen<GamesState>(
          gamesBloc,
          Stream.fromIterable([
            const GamesState(),
            const GamesState(
              status: GamesStatus.failure,
            ),
          ]),
        );

        await tester.pumpApp(
          buildSubject(),
          gameRepository: gameRepository,
        );
        await tester.pumpAndSettle();

        expect(find.byType(Center), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(Center),
            matching: find.text(l10n.failedFetchGames),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('renders ListView with GamesListTiles', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        gameRepository: gameRepository,
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(
        find.byType(GamesListItem),
        findsNWidgets(gameResponse.games.length),
      );
    });

    testWidgets('fetches more posts when scrolled to the bottom',
        (tester) async {
      when(() => gamesBloc.state).thenReturn(
        GamesState(
          status: GamesStatus.success,
          games: List.generate(
            12,
            (i) => Game(
              id: i,
              name: 'Game name',
              released: '-',
              backgroundImage: '',
              rating: 4.44,
            ),
          ),
        ),
      );

      await tester.pumpApp(
        buildSubject(),
        gameRepository: gameRepository,
      );

      await tester.drag(find.byType(GamesView), const Offset(0, -500));
      verify(() => gamesBloc.add(GamesFetched())).called(1);
    });

    testWidgets('does not render bottom loader when post max is reached',
        (tester) async {
      when(() => gamesBloc.state).thenReturn(
        GamesState(
          status: GamesStatus.success,
          games: gameResponse.games,
          hasReachedMax: true,
        ),
      );
      await tester.pumpApp(
        buildSubject(),
        gameRepository: gameRepository,
      );
      expect(find.byType(BottomLoader), findsNothing);
    });
  });
}
