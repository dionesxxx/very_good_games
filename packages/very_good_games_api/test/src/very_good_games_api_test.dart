// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:very_good_games_api/very_good_games_api.dart';

class TestVeryGoodGamesApi extends VeryGoodGamesApi {
  TestVeryGoodGamesApi() : super();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('VeryGoodGamesApi', () {
    test('can be instantiated', () {
      expect(TestVeryGoodGamesApi.new, returnsNormally);
    });
  });
}
