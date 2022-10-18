// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_repository/game_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_games/l10n/l10n.dart';

class MockGameRepository extends Mock implements GameRepository {}

class MockUserRepository extends Mock implements UserRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    GameRepository? gameRepository,
    UserRepository? userRepository,
  }) {
    return pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: gameRepository ?? MockGameRepository(),
          ),
          RepositoryProvider.value(
            value: userRepository ?? MockUserRepository(),
          )
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}
