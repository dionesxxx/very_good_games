// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_storage_user_api/local_storage_user_api.dart';
import 'package:remote_game_api/remote_game_api.dart';
import 'package:very_good_games/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final gameApi = RemoteGameApi(
    httpClient: http.Client(),
  );

  final userApi = LocalStorageUserApi(
    plugin: await SharedPreferences.getInstance(),
  );

  await bootstrap(gameApi: gameApi, userApi: userApi);
}
