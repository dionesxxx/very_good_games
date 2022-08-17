// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:remote_game_api/remote_games_api.dart';
import 'package:very_good_games/bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final veryGoodGamesApi = RemoteGameApi(
    httpClient: http.Client(),
  );

  bootstrap(veryGoodGamesApi: veryGoodGamesApi);
}
