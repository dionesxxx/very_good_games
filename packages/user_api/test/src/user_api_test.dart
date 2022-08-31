// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:user_api/user_api.dart';

class TestUserApi extends UserApi {
  TestUserApi() : super();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('UserApi', () {
    test('can be instantiated', () {
      expect(TestUserApi.new, returnsNormally);
    });
  });
}
