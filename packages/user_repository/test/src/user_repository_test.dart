// ignore_for_file: prefer_const_constructors
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:user_api/user_api.dart';
import 'package:user_repository/user_repository.dart';

class MockUserApi extends Mock implements UserApi {}

class FakeUser extends Mock implements User {}

void main() {
  group('UserRepository', () {
    late UserApi api;

    final user = User();

    setUpAll(() {
      registerFallbackValue(FakeUser());
    });

    setUp(() {
      api = MockUserApi();
      when(() => api.getUser()).thenAnswer((_) => Stream.value(user));
      when(() => api.saveFavoriteGames(any())).thenAnswer((_) async {});
    });

    UserRepository createSubject() => UserRepository(userApi: api);

    test('works properly', () {
      expect(createSubject, returnsNormally);
    });

    group('getUser', () {
      test('makes correct api request', () async {
        final subject = createSubject();

        expect(
          subject.getUser(),
          isNot(throwsA(anything)),
        );

        verify(() => api.getUser()).called(1);
      });

      test('returns stream of current user', () {
        expect(
          createSubject().getUser(),
          emits(user),
        );
      });
    });

    group('saveFavoriteGames', () {
      test('makes correct api request', () {
        final newUser = User(favoriteGames: const [1, 4, 7, 9]);

        final subject = createSubject();

        expect(subject.saveFavoriteGames(newUser), completes);

        verify(() => api.saveFavoriteGames(newUser)).called(1);
      });
    });
  });
}
