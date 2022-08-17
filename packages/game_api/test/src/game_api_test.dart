// ignore_for_file: prefer_const_constructors
import 'package:game_api/src/game_api.dart';
import 'package:test/test.dart';

class TestGameApi extends GameApi {
  TestGameApi() : super();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('VeryGoodGamesApi', () {
    test('can be instantiated', () {
      expect(TestGameApi.new, returnsNormally);
    });
  });
}
