import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_games/games/widgets/favorited_button.dart';
import 'package:very_good_games/theme/theme.dart';

import '../../helpers/helpers.dart';

void main() {
  final onToggleFavoritedCalls = <bool>[];

  Widget buildSubject({bool? favorited}) {
    return FavoritedButton(
      isFavorited: favorited ?? false,
      onToggleFavorited: onToggleFavoritedCalls.add,
    );
  }

  group('FavoritedButton', () {
    group('constructor', () {
      test('works properly', () {
        expect(
          () => const FavoritedButton(),
          returnsNormally,
        );
      });
    });

    testWidgets('is outlined button when game is not favorited',
        (tester) async {
      await tester.pumpApp(buildSubject(favorited: false));
      final color = (tester
              .widget<AnimatedContainer>(find.byType(AnimatedContainer))
              .decoration! as BoxDecoration)
          .color;

      expect(color, kPrimaryColor);
    });

    testWidgets('is conteined button when game is favorited', (tester) async {
      await tester.pumpApp(buildSubject(favorited: true));

      final outlined = (tester
              .widget<AnimatedContainer>(find.byType(AnimatedContainer))
              .decoration! as BoxDecoration)
          .borderRadius;

      expect(outlined, BorderRadius.circular(40));
    });

    testWidgets('calls onPressed by icon with correct value when tapped',
        (tester) async {
      await tester.pumpApp(buildSubject(favorited: false));

      await tester.tap(find.byIcon(Icons.add));

      expect(onToggleFavoritedCalls, equals([true]));
    });
  });
}
