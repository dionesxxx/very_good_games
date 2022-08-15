// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:very_good_games/bootstrap.dart';
import 'package:very_good_remote_games_api/very_good_remote_games_api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final veryGoodGamesApi = VeryGoodRemoteGamesApi(
    httpClient: http.Client(),
  );

  bootstrap(veryGoodGamesApi: veryGoodGamesApi);
}
