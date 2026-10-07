import 'package:dio/dio.dart';
import 'package:easygold_app_v3/core/services/dio_interceptor_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_http_adapter.dart';

void main() {
  late List<String> logs;
  late DebugPrintCallback originalDebugPrint;

  setUp(() {
    logs = [];
    originalDebugPrint = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) logs.add(message);
    };
  });

  tearDown(() => debugPrint = originalDebugPrint);

  Dio build(FakeHttpAdapter adapter) =>
      Dio(BaseOptions(baseUrl: 'https://api.example.test'))
        ..httpClientAdapter = adapter
        ..interceptors.add(DioInterceptorService());

  test(
    'logs method and path on request and status and path on response',
    () async {
      await build(FakeHttpAdapter()).get<dynamic>('/ping');

      expect(logs, ['Request: GET /ping', 'Response: 200 /ping']);
    },
  );

  test('never logs headers, bodies or query values', () async {
    const secrets = [
      'secret-token',
      'secret-password',
      'secret-query',
      'secret-response',
    ];
    final dio = build(FakeHttpAdapter(body: {'token': 'secret-response'}));

    await dio.post<dynamic>(
      '/signin',
      queryParameters: {'code': 'secret-query'},
      data: {'password': 'secret-password'},
      options: Options(headers: {'Authorization': 'Bearer secret-token'}),
    );

    expect(logs, isNotEmpty);
    for (final line in logs) {
      for (final secret in secrets) {
        expect(line, isNot(contains(secret)));
      }
    }
  });

  test(
    'logs the error message and path, and still propagates the error',
    () async {
      final dio = build(FakeHttpAdapter(status: 500));

      await expectLater(
        dio.get<dynamic>('/boom'),
        throwsA(isA<DioException>()),
      );

      expect(logs.first, 'Request: GET /boom');
      expect(logs.last, startsWith('Error: '));
      expect(logs.last, endsWith('/boom'));
    },
  );
}
