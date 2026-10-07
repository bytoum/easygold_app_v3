import 'package:dio/dio.dart';
import 'package:easygold_app_v3/core/network/rest_client.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_http_adapter.dart';

void main() {
  const base = 'https://api.test';

  Dio dioWith(FakeHttpAdapter adapter) =>
      Dio(BaseOptions(baseUrl: base))..httpClientAdapter = adapter;

  group('AppClient', () {
    test('getVersion sends GET /version with the version query', () async {
      final adapter = FakeHttpAdapter(body: {'name': 'v1', 'isOpen': true});
      final res = await AppClient(
        dioWith(adapter),
        baseUrl: base,
      ).getVersion(version: '1.2.3');

      final req = adapter.requests.single;
      expect(req.method, 'GET');
      expect(req.uri.path, '/version');
      expect(req.uri.queryParameters, {'version': '1.2.3'});
      expect(res?.name, 'v1');
      expect(res?.isOpen, isTrue);
    });

    test('getVersionInfo parses nested models', () async {
      final adapter = FakeHttpAdapter(
        body: {
          'version': {'name': 'v2'},
          'background': {'_id': 'bg'},
        },
      );
      final res = await AppClient(
        dioWith(adapter),
        baseUrl: base,
      ).getVersionInfo();

      expect(adapter.requests.single.uri.path, '/info');
      expect(res?.version?.name, 'v2');
      expect(res?.background?.id, 'bg');
    });

    test('customer-service endpoints hit their paths and parse', () async {
      final adapter = FakeHttpAdapter(body: {'_id': 'x', 'title': 't'});
      final client = AppClient(dioWith(adapter), baseUrl: base);

      expect((await client.getTitle()).title, 't');
      await client.getContact();
      await client.getSocialMedia();
      await client.getLocation();
      await client.getBackgroundDetail();

      expect(adapter.requests.map((r) => r.uri.path), [
        '/customer-service/title',
        '/customer-service/contact-info/69a001ea749939c4c103a246',
        '/customer-service/social-media/69a00298749939c4c103a24c',
        '/customer-service/location/699d6d28b5608cc67d18bc44',
        '/bill-background/detail',
      ]);
    });

    test('surfaces HTTP errors as DioException', () async {
      final client = AppClient(
        dioWith(FakeHttpAdapter(status: 500)),
        baseUrl: base,
      );
      await expectLater(client.getVersion(), throwsA(isA<DioException>()));
    });
  });

  group('AuthClient', () {
    test('signInWithPassword maps query, headers and body', () async {
      final adapter = FakeHttpAdapter(
        body: {
          'data': {'accessToken': 'tok'},
          'error': false,
        },
      );
      final res = await AuthClient(dioWith(adapter), baseUrl: '$base/auth')
          .signInWithPassword('c', 'fmc', 'true', 'uuid-1', {
            'username': 'u',
            'password': 'p',
          });

      final req = adapter.requests.single;
      expect(req.method, 'POST');
      expect(req.uri.path, '/auth/signin');
      expect(req.uri.queryParameters, {'code': 'c'});
      expect(req.headers['EasyGoldToken'], 'fmc');
      expect(req.headers['IsAllowPushNotification'], 'true');
      expect(req.headers['UUID'], 'uuid-1');
      expect(req.data, {'username': 'u', 'password': 'p'});
      expect(res.data.accessToken, 'tok');
      expect(res.error, isFalse);
    });
  });
}
