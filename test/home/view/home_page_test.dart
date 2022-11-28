import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_api/game_api.dart';
import 'package:game_repository/game_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_api/user_api.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_games/games/games.dart';
import 'package:very_good_games/home/home.dart';

import '../../helpers/helpers.dart';

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

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
  group('HomePage', () {
    setUp(() {
      gameRepository = MockGameRepository();
      userRepository = MockUserRepository();

      when(gameRepository.getGames).thenAnswer((_) async => gameResponse);
      when(userRepository.getUser)
          .thenAnswer((_) => Stream.value(const User()));
    });

    testWidgets('renders HomeView', (tester) async {
      await tester.pumpApp(
        const HomePage(),
        gameRepository: gameRepository,
        userRepository: userRepository,
      );

      expect(find.byType(HomeView), findsOneWidget);
    });
  });

  group('HomeView', () {
    late HomeCubit homeCubit;

    setUp(() {
      homeCubit = MockHomeCubit();
      when(() => homeCubit.state).thenReturn(const HomeState());

      gameRepository = MockGameRepository();
      userRepository = MockUserRepository();

      when(gameRepository.getGames).thenAnswer((_) async => gameResponse);
      when(userRepository.getUser)
          .thenAnswer((_) => Stream.value(const User()));
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: homeCubit,
        child: const HomeView(),
      );
    }

    testWidgets(
      'renders GamesPage '
      'when tab is set to HomeTab.games',
      (tester) async {
        when(() => homeCubit.state).thenReturn(const HomeState());

        await tester.pumpApp(
          buildSubject(),
          gameRepository: gameRepository,
          userRepository: userRepository,
        );

        expect(find.byType(GamesPage), findsOneWidget);
      },
    );

    testWidgets(
      'renders GamesPage '
      'when tab is set to HomeTab.releaseCalendar',
      (tester) async {
        when(() => homeCubit.state).thenReturn(
          const HomeState(tab: HomeTab.releaseCalendar),
        );

        await tester.pumpApp(
          buildSubject(),
          gameRepository: gameRepository,
          userRepository: userRepository,
        );

        expect(find.byType(SizedBox).first, findsOneWidget);
      },
    );

    testWidgets(
        'calls setTab with HomeTab.games on HomeCubit '
        'when todos navigation button is pressed', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        gameRepository: gameRepository,
        userRepository: userRepository,
      );

      await tester.tap(find.byIcon(Icons.home_rounded));

      verify(() => homeCubit.setTab(HomeTab.games)).called(1);
    });

    testWidgets(
        'calls setTab with HomeTab.releaseCalendar on HomeCubit '
        'when todos navigation button is pressed', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        gameRepository: gameRepository,
        userRepository: userRepository,
      );

      await tester.tap(find.byIcon(Icons.calendar_month_rounded));

      verify(() => homeCubit.setTab(HomeTab.releaseCalendar)).called(1);
    });
  });
}
