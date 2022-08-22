// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:game_repository/game_repository.dart';
import 'package:very_good_games/games/view/games_page.dart';
import 'package:very_good_games/l10n/l10n.dart';
import 'package:very_good_games/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key, required this.gameRepository});

  final GameRepository gameRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: gameRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const GamesPage(),
    );
  }
}
