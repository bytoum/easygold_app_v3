import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easygold_app_v3/core/services/dio_interceptor_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart' show DebugPrintCallback, debugPrint;

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.status);
  final int status;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    jsonEncode({'secret': 'response-body'}),
    status,
    headers: {
      Headers.contentTypeHeader: ['application/json'],
    },
  );

  @override
  void close({bool force = false}) {}
}

void main() {
  late List<String> logs;
  late DebugPrintCallback original;

  setUp(() {
    logs = [];
    original = debugPrint;
    debugPrint = (String? m, {int? wrapWidth}) => logs.add(m ?? '');
  });

  tearDown(() => debugPrint = original);

  Dio dioWith(int status) => Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = _FakeAdapter(status)
    ..interceptors.add(DioInterceptorService());

  test('logs method, path and status only for a successful call', () async {
    await dioWith(200).post(
      '/login',
      data: {'password': 'hunter2'},
      options: Options(headers: {'Authorization': 'Bearer tok'}),
    );

    expect(logs, ['Request: POST /login', 'Response: 200 /login']);
    final all = logs.join();
    for (final leaked in ['hunter2', 'Bearer', 'tok', 'response-body']) {
      expect(all, isNot(contains(leaked)));
    }
  });

  test('logs an error line and still propagates the DioException', () async {
    await expectLater(dioWith(500).get('/boom'), throwsA(isA<DioException>()));
    expect(logs.first, 'Request: GET /boom');
    expect(logs.last, startsWith('Error: '));
    expect(logs.last, endsWith('/boom'));
    expect(logs.join(), isNot(contains('response-body')));
  });
}
