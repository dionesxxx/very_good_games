// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:game_api/game_api.dart';
import 'package:game_repository/game_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_games/app/app.dart';
import 'package:very_good_games/games/view/games_page.dart';

import '../../helpers/helpers.dart';

void main() {
  late GameRepository gameRepository;
  group('App', () {
    setUp(() {
      gameRepository = MockGameRepository();
      when(() => gameRepository.getGames()).thenAnswer(
        (_) async => const GameResponse(count: 0, games: <Game>[]),
      );
    });

    testWidgets('renders GamesPage', (tester) async {
      await tester.pumpWidget(
        App(gameRepository: gameRepository),
      );
      expect(find.byType(GamesPage), findsOneWidget);
    });
  });
}
