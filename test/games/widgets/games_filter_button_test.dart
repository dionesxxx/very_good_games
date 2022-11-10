// ignore_for_file: avoid_redundant_argument_values

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_games/games/bloc/games_bloc.dart';
import 'package:very_good_games/games/models/game_view.dart';
import 'package:very_good_games/games/widgets/widgets.dart';

import '../../helpers/helpers.dart';

class MockGamesBloc extends MockBloc<GamesEvent, GamesState>
    implements GamesBloc {}

extension on CommonFinders {
  Finder filterMenuItem({
    required GameViewFilter filter,
    required String title,
  }) {
    return find.descendant(
      of: find.byWidgetPredicate(
        (widget) => widget is PopupMenuItem && widget.value == filter,
      ),
      matching: find.text(title),
    );
  }
}

extension on WidgetTester {
  Future<void> openPopup() async {
    await tap(find.byType(GamesFilterButton));
    await pumpAndSettle();
  }
}

void main() {
  group('GamesFilterButton', () {
    late GamesBloc gamesBloc;

    setUp(() {
      gamesBloc = MockGamesBloc();
      when(() => gamesBloc.state).thenReturn(
        const GamesState(
          status: GamesStatus.success,
          games: [],
        ),
      );
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: gamesBloc,
        child: const GamesFilterButton(),
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(
          () => const GamesFilterButton(),
          returnsNormally,
        );
      });
    });

    testWidgets('renders filter list icon', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(
        find.byIcon(Icons.filter_list_rounded),
        findsOneWidget,
      );
    });

    group('internal PopupMenuButton', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.bySpecificType<PopupMenuButton<GameViewFilter>>(),
          findsOneWidget,
        );
      });

      testWidgets('has initial value set to active filter', (tester) async {
        when(() => gamesBloc.state).thenReturn(
          const GamesState(filter: GameViewFilter.all),
        );

        await tester.pumpApp(buildSubject());

        final popupMenuButton = tester.widget<PopupMenuButton<GameViewFilter>>(
          find.bySpecificType<PopupMenuButton<GameViewFilter>>(),
        );

        expect(popupMenuButton.initialValue, equals(GameViewFilter.all));
      });

      testWidgets(
        'renders items for each filter type when pressed',
        (tester) async {
          await tester.pumpApp(buildSubject());
          await tester.openPopup();

          expect(
            find.filterMenuItem(
              filter: GameViewFilter.all,
              title: l10n.gamesFilterAll,
            ),
            findsOneWidget,
          );
          expect(
            find.filterMenuItem(
              filter: GameViewFilter.favoriteOnly,
              title: l10n.gamesFilterFavoriteOnly,
            ),
            findsOneWidget,
          );
        },
      );
      testWidgets(
        'adds GamesFilterChanged '
        'to GamesBloc '
        'when new filter is pressed',
        (tester) async {
          when(() => gamesBloc.state).thenReturn(
            const GamesState(
              filter: GameViewFilter.all,
            ),
          );

          await tester.pumpApp(buildSubject());
          await tester.openPopup();

          await tester.tap(find.text(l10n.gamesFilterFavoriteOnly));
          await tester.pumpAndSettle();

          verify(
            () => gamesBloc.add(
              const GamesFilterChanged(GameViewFilter.favoriteOnly),
            ),
          ).called(1);
        },
      );
    });
  });
}
