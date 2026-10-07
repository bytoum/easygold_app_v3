import 'dart:convert';
import 'dart:ui';

import 'package:aws_common/aws_common.dart';
import 'package:dio/dio.dart';
import 'package:easygold_app_v3/core/services/asset_loader_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_http_adapter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const locale = Locale('en', 'US');
  const path = 'assets/translations';

  S3AssetLoaderService build({
    required FakeHttpAdapter adapter,
    String accessKey = 'AKIDEXAMPLE',
    String secretKey = 'example-secret-key',
  }) => S3AssetLoaderService(
    bucket: 'test-bucket',
    region: 'ap-southeast-1',
    credentialsProvider: AWSCredentialsProvider(
      AWSCredentials(accessKey, secretKey),
    ),
    dio: Dio()..httpClientAdapter = adapter,
  );

  test(
    'fetches a presigned S3 URL for the locale file and parses the JSON',
    () async {
      final adapter = FakeHttpAdapter(body: {'hello': 'from s3'});

      final result = await build(adapter: adapter).load(path, locale);

      expect(result, {'hello': 'from s3'});
      final uri = adapter.last.uri;
      expect(uri.scheme, 'https');
      expect(uri.host, 'test-bucket.s3.ap-southeast-1.amazonaws.com');
      expect(uri.path, '/en-US.json');
      expect(uri.queryParameters['X-Amz-Signature'], isNotEmpty);
      expect(uri.queryParameters['X-Amz-Expires'], '60');
      expect(adapter.last.followRedirects, isFalse);
    },
  );

  test('never puts the secret key in the request URL', () async {
    final adapter = FakeHttpAdapter(body: {});

    await build(adapter: adapter).load(path, locale);

    expect(adapter.last.uri.toString(), isNot(contains('example-secret-key')));
  });

  test('falls back to the bundled asset when credentials are empty', () async {
    final adapter = FakeHttpAdapter(body: {'hello': 'from s3'});

    final result = await build(
      adapter: adapter,
      accessKey: '',
      secretKey: '',
    ).load(path, locale);

    expect(adapter.requests, isEmpty);
    expect(result, isNotNull);
    expect(result, isNotEmpty);
  });

  test('falls back to the bundled asset when S3 answers non-200', () async {
    final adapter = FakeHttpAdapter(body: {'x': 1}, status: 403);

    final result = await build(adapter: adapter).load(path, locale);

    expect(adapter.requests, hasLength(1));
    expect(result, isNot({'x': 1}));
    expect(result, isNotEmpty);
  });

  test('fallback loads the locale file from the bundle', () async {
    final result = await build(adapter: FakeHttpAdapter())
        .fallbackAssetLoader(path, locale);

    expect(jsonEncode(result), isNotEmpty);
    expect(result, isA<Map<String, dynamic>>());
  });
}
