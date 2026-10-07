import 'package:dio/dio.dart';
import 'package:easygold_app_v3/core/network/rest_client.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_http_adapter.dart';

void main() {
  const baseUrl = 'https://api.example.test';
  late FakeHttpAdapter adapter;
  late AppClient client;

  AppClient build(FakeHttpAdapter a) {
    final dio = Dio()..httpClientAdapter = a;
    return AppClient(dio, baseUrl: baseUrl);
  }

  setUp(() {
    adapter = FakeHttpAdapter(body: {'name': 'v1', 'isOpen': true});
    client = build(adapter);
  });

  test('getVersion sends GET /version with the version query', () async {
    final result = await client.getVersion(version: 'BCEL');

    expect(adapter.last.method, 'GET');
    expect(adapter.last.uri.toString(), '$baseUrl/version?version=BCEL');
    expect(result?.name, 'v1');
    expect(result?.isOpen, isTrue);
  });

  test('getVersion omits the query when version is null', () async {
    await client.getVersion();
    expect(adapter.last.uri.toString(), '$baseUrl/version');
  });

  group('endpoints', () {
    final endpoints =
        <String, ({String path, Future<Object?> Function(AppClient) call})>{
          'getVersionInfo': (path: '/info', call: (c) => c.getVersionInfo()),
          'getBackgroundDetail': (
            path: '/bill-background/detail',
            call: (c) => c.getBackgroundDetail(),
          ),
          'getTitle': (
            path: '/customer-service/title',
            call: (c) => c.getTitle(),
          ),
          'getContact': (
            path: '/customer-service/contact-info/69a001ea749939c4c103a246',
            call: (c) => c.getContact(),
          ),
          'getSocialMedia': (
            path: '/customer-service/social-media/69a00298749939c4c103a24c',
            call: (c) => c.getSocialMedia(),
          ),
          'getLocation': (
            path: '/customer-service/location/699d6d28b5608cc67d18bc44',
            call: (c) => c.getLocation(),
          ),
        };

    endpoints.forEach((name, endpoint) {
      test('$name sends GET ${endpoint.path}', () async {
        await endpoint.call(client);

        expect(adapter.last.method, 'GET');
        expect(adapter.last.uri.toString(), '$baseUrl${endpoint.path}');
      });
    });
  });

  test('a non-2xx response surfaces as DioException', () {
    final failing = build(FakeHttpAdapter(status: 500));
    expect(failing.getTitle(), throwsA(isA<DioException>()));
  });
}
