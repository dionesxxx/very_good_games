// ignore_for_file: prefer_const_constructors
import 'package:game_api/game_api.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:remote_game_api/remote_game_api.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('RemoteGameApi', () {
    late http.Client httpClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
    });

    RemoteGameApi createSubject() {
      return RemoteGameApi(
        httpClient: httpClient,
      );
    }

    test('can be instantiated', () {
      expect(RemoteGameApi(), isNotNull);
    });

    test('throws GamesRequestFailure on non-200 response', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(400);
      when(() => httpClient.get(any())).thenAnswer((_) async => response);
      expect(
        () async => createSubject().getGames(),
        throwsA(isA<GamesRequestFailure>()),
      );
    });

    test('throws GamesNotFoundFailure on empty response', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('{}');
      when(() => httpClient.get(any())).thenAnswer((_) async => response);
      expect(
        () async => createSubject().getGames(),
        throwsA(isA<GamesNotFoundFailure>()),
      );
    });

    test('makes correct http request', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn(
        '''
{
    "count": 3,
    "next": "http://example.com",
    "previous": "http://example.com",
    "results": [
        {
            "id": 0,
            "slug": "string",
            "name": "string",
            "released": "2022-08-06",
            "tba": true,
            "background_image": "http://example.com",
            "rating": 0,
            "rating_top": 0,
            "ratings": {},
            "ratings_count": 0,
            "reviews_text_count": "string",
            "added": 0,
            "added_by_status": {},
            "metacritic": 0,
            "playtime": 0,
            "suggestions_count": 0,
            "updated": "2022-08-06T01:50:21Z",
            "esrb_rating": {
                "id": 0,
                "slug": "everyone",
                "name": "Everyone"
            },
            "platforms": [
                {
                    "platform": {
                        "id": 0,
                        "slug": "string",
                        "name": "string"
                    },
                    "released_at": "string",
                    "requirements": {
                        "minimum": "string",
                        "recommended": "string"
                    }
                }
            ]
        }
    ]
}''',
      );
      when(() => httpClient.get(any())).thenAnswer((_) async => response);

      final actual = await createSubject().getGames();

      expect(actual, isA<GameResponse>());
    });

    test('throws GamesRequestFailure on non-200 response for getMoreGames',
        () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(400);
      when(() => httpClient.get(any())).thenAnswer((_) async => response);
      expect(
        () async => createSubject().getMoreGames(''),
        throwsA(isA<GamesRequestFailure>()),
      );
    });

    test('throws GamesNotFoundFailure on empty response for getMoreGames',
        () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('{}');
      when(() => httpClient.get(any())).thenAnswer((_) async => response);
      expect(
        () async => createSubject().getMoreGames(''),
        throwsA(isA<GamesNotFoundFailure>()),
      );
    });

    test('makes correct http request for getMoreGames', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn(
        '''
{
    "count": 3,
    "next": "http://example.com",
    "previous": "http://example.com",
    "results": [
        {
            "id": 0,
            "slug": "string",
            "name": "string",
            "released": "2022-08-06",
            "tba": true,
            "background_image": "http://example.com",
            "rating": 0,
            "rating_top": 0,
            "ratings": {},
            "ratings_count": 0,
            "reviews_text_count": "string",
            "added": 0,
            "added_by_status": {},
            "metacritic": 0,
            "playtime": 0,
            "suggestions_count": 0,
            "updated": "2022-08-06T01:50:21Z",
            "esrb_rating": {
                "id": 0,
                "slug": "everyone",
                "name": "Everyone"
            },
            "platforms": [
                {
                    "platform": {
                        "id": 0,
                        "slug": "string",
                        "name": "string"
                    },
                    "released_at": "string",
                    "requirements": {
                        "minimum": "string",
                        "recommended": "string"
                    }
                }
            ]
        }
    ]
}''',
      );
      when(() => httpClient.get(any())).thenAnswer((_) async => response);

      final actual = await createSubject().getMoreGames('');

      expect(actual, isA<GameResponse>());
    });
  });
}
