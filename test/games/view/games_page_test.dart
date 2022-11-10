import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_api/game_api.dart';
import 'package:game_repository/game_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_api/user_api.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_games/games/bloc/games_bloc.dart';
import 'package:very_good_games/games/models/models.dart';
import 'package:very_good_games/games/view/view.dart';
import 'package:very_good_games/games/widgets/widgets.dart';

import '../../helpers/helpers.dart';

class MockGamesBloc extends MockBloc<GamesEvent, GamesState>
    implements GamesBloc {}

void main() {
  late GameRepository gameRepository;
  late UserRepository userRepository;

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

  final gamesView = [
    GameView(
      game: gameResponse.games.first,
    ),
  ];

  group('GamesPage', () {
    setUp(() {
      gameRepository = MockGameRepository();
      userRepository = MockUserRepository();
      when(() => gameRepository.getGames())
          .thenAnswer((_) async => gameResponse);
      when(() => gameRepository.getMoreGames(any()))
          .thenAnswer((_) async => gameResponse);
      when(() => userRepository.getUser())
          .thenAnswer((_) => Stream.value(const User()));
    });

    testWidgets('renders GamesView', (tester) async {
      await tester.pumpApp(
        const GamesPage(),
        gameRepository: gameRepository,
        userRepository: userRepository,
      );
    });
  });

  group('GamesView', () {
    late GamesBloc gamesBloc;
    setUp(() {
      gameRepository = MockGameRepository();
      userRepository = MockUserRepository();
      when(() => gameRepository.getGames())
          .thenAnswer((_) async => gameResponse);
      when(() => gameRepository.getMoreGames(any()))
          .thenAnswer((_) async => gameResponse);
      when(() => userRepository.getUser())
          .thenAnswer((_) => Stream.value(const User()));

      gamesBloc = MockGamesBloc();
      when(() => gamesBloc.state).thenReturn(
        GamesState(
          status: GamesStatus.success,
          games: [...gamesView],
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
        userRepository: userRepository,
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(
        find.byType(GamesListItem),
        findsNWidgets(gameResponse.games.length),
      );
    });

    testWidgets('fetches more games when scrolled to the bottom',
        (tester) async {
      when(() => gamesBloc.state).thenReturn(
        GamesState(
          status: GamesStatus.success,
          games: List.generate(
            12,
            (i) => GameView(
              game: gameResponse.games.first,
            ),
          ),
        ),
      );

      await tester.pumpApp(
        buildSubject(),
        gameRepository: gameRepository,
        userRepository: userRepository,
      );

      await tester.drag(find.byType(GamesView), const Offset(0, -3000));
      verify(() => gamesBloc.add(GamesFetched())).called(1);
    });

    testWidgets('does not render bottom loader when game max is reached',
        (tester) async {
      when(() => gamesBloc.state).thenReturn(
        GamesState(
          status: GamesStatus.success,
          games: gamesView,
          hasReachedMax: true,
        ),
      );
      await tester.pumpApp(
        buildSubject(),
        gameRepository: gameRepository,
      );
      expect(find.byType(BottomLoader), findsNothing);
    });

    testWidgets(
        'adds GamesFavoriteToggle '
        'to GamesBloc '
        'when onToggleFavorited is called', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        gameRepository: gameRepository,
        userRepository: userRepository,
      );

      final gamesList =
          tester.widget<GamesListItem>(find.byType(GamesListItem).first);
      gamesList.onToggleFavorited!(!gamesView.first.isFavorite);

      verify(
        () => gamesBloc.add(
          GamesFavoriteToggle(
            game: gamesView.first,
            isFavorited: !gamesView.first.isFavorite,
          ),
        ),
      );
    });
  });
}
