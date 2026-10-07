import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easygold_app_v3/core/network/rest_client.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_http_adapter.dart';

void main() {
  const baseUrl = 'https://api.example.test/auth';

  AuthClient build(FakeHttpAdapter adapter) =>
      AuthClient(Dio()..httpClientAdapter = adapter, baseUrl: baseUrl);

  test(
    'signInWithPassword POSTs /signin with query, headers and JSON body',
    () async {
      final adapter = FakeHttpAdapter(
        body: {
          'data': {
            'accessToken': 'access-token',
            'refreshToken': 'refresh-token',
          },
        },
      );

      final response = await build(adapter).signInWithPassword(
        'the-code',
        'the-fmc',
        'true',
        'the-uuid',
        {'phone': '000', 'password': 'pw'},
      );

      final request = adapter.last;
      expect(request.method, 'POST');
      expect(request.uri.path, '/auth/signin');
      expect(request.uri.queryParameters, {'code': 'the-code'});
      expect(request.headers['EasyGoldToken'], 'the-fmc');
      expect(request.headers['IsAllowPushNotification'], 'true');
      expect(request.headers['UUID'], 'the-uuid');
      expect(jsonDecode(adapter.sentBodies.single), {
        'phone': '000',
        'password': 'pw',
      });

      expect(response.error, isFalse);
      expect(response.data.accessToken, 'access-token');
      expect(response.data.refreshToken, 'refresh-token');
    },
  );

  test(
    'omits the code query and EasyGoldToken header when they are null',
    () async {
      final adapter = FakeHttpAdapter(
        body: {
          'data': {'accessToken': 'a'},
        },
      );

      await build(adapter).signInWithPassword(null, null, 'false', 'u', {});

      expect(adapter.last.uri.queryParameters, isEmpty);
      expect(adapter.last.headers.containsKey('EasyGoldToken'), isFalse);
    },
  );

  test(
    'a 401 response surfaces as DioException with the status code',
    () async {
      final client = build(
        FakeHttpAdapter(body: {'message': 'no'}, status: 401),
      );

      await expectLater(
        client.signInWithPassword(null, null, 'false', 'u', {}),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            401,
          ),
        ),
      );
    },
  );
}
