// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_user_api/local_storage_user_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_api/user_api.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('LocalStorageUserApi', () {
    late SharedPreferences plugin;

    final user = User(
      favoriteGames: const [1, 3, 7],
    );

    setUp(() {
      plugin = MockSharedPreferences();
      when(() => plugin.getString(any())).thenReturn(json.encode(user));
      when(() => plugin.setString(any(), any())).thenAnswer((_) async => true);
    });

    LocalStorageUserApi createSubject() {
      return LocalStorageUserApi(
        plugin: plugin,
      );
    }

    group('constructor', () {
      test('works propely', () {
        expect(createSubject, returnsNormally);
      });

      group('initializes the user stream', () {
        test('with existing user if present', () {
          final subject = createSubject();

          expect(subject.getUser(), emits(user));
          verify(
            () => plugin.getString(
              LocalStorageUserApi.kFavoriteGamesCollectionKey,
            ),
          ).called(1);
        });

        test('with empty object if no user present', () {
          when(() => plugin.getString(any())).thenReturn(null);

          final subject = createSubject();

          expect(subject.getUser(), emits(const User()));
          verify(
            () => plugin.getString(
              LocalStorageUserApi.kFavoriteGamesCollectionKey,
            ),
          ).called(1);
        });
      });
    });

    test('getUser returns stream of current user', () {
      expect(
        createSubject().getUser(),
        emits(user),
      );
    });

    group('saveFavoriteGames', () {
      test('saves users favorite games', () {
        final subject = createSubject();

        expect(subject.saveFavoriteGames(user), completes);
        expect(subject.getUser(), emits(user));

        verify(
          () => plugin.setString(
            LocalStorageUserApi.kFavoriteGamesCollectionKey,
            json.encode(user),
          ),
        ).called(1);
      });
    });
  });
}
