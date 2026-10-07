import 'dart:convert';

import 'package:aws_common/aws_common.dart';
import 'package:dio/dio.dart';
import 'package:easygold_app_v3/core/services/asset_loader_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../support/fake_http_adapter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const locale = Locale('en');
  final requestedAssets = <String>[];

  setUp(() {
    requestedAssets.clear();
    (rootBundle as CachingAssetBundle).clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
          final key = utf8.decode(message!.buffer.asUint8List());
          requestedAssets.add(key);
          final bytes = utf8.encode(jsonEncode({'source': 'bundle'}));
          return ByteData.sublistView(Uint8List.fromList(bytes));
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  });

  S3AssetLoaderService loader(
    FakeHttpAdapter adapter, {
    String accessKey = 'AKIDTEST',
    String secretKey = 'secret',
  }) => S3AssetLoaderService(
    bucket: 'bkt',
    region: 'ap-southeast-1',
    credentialsProvider: AWSCredentialsProvider(
      AWSCredentials(accessKey, secretKey),
    ),
    dio: Dio()..httpClientAdapter = adapter,
  );

  test('loads the signed S3 JSON when credentials are present', () async {
    final adapter = FakeHttpAdapter(body: {'source': 's3'});

    final result = await loader(adapter).load('assets/translations', locale);

    expect(result, {'source': 's3'});
    final uri = adapter.requests.single.uri;
    expect(uri.host, 'bkt.s3.ap-southeast-1.amazonaws.com');
    expect(uri.path, '/en.json');
    expect(uri.queryParameters, contains('X-Amz-Signature'));
    expect(requestedAssets, isEmpty);
  });

  test('uses the local bundle when credentials are empty', () async {
    final adapter = FakeHttpAdapter();

    final result = await loader(
      adapter,
      accessKey: '',
      secretKey: '',
    ).load('assets/translations', locale);

    expect(result, {'source': 'bundle'});
    expect(adapter.requests, isEmpty);
    expect(requestedAssets, ['assets/translations/en.json']);
  });

  test('falls back to the local bundle when S3 responds non-200', () async {
    final adapter = FakeHttpAdapter(status: 403);

    final result = await loader(adapter).load('assets/translations', locale);

    expect(result, {'source': 'bundle'});
    expect(adapter.requests, hasLength(1));
    expect(requestedAssets, ['assets/translations/en.json']);
  });

  for (final (name, payload) in [
    ('is not valid JSON', '<html>oops</html>'),
    ('is JSON but not an object', '[1, 2]'),
  ]) {
    test('falls back to the local bundle when the S3 body $name', () async {
      final adapter = FakeHttpAdapter.raw(payload);

      final result = await loader(adapter).load('assets/translations', locale);

      expect(result, {'source': 'bundle'});
      expect(requestedAssets, ['assets/translations/en.json']);
    });
  }

  testWidgets(
    'falls back to the local bundle when S3 stalls past the timeout',
    (tester) async {
      final loader = S3AssetLoaderService(
        bucket: 'bkt',
        region: 'ap-southeast-1',
        credentialsProvider: AWSCredentialsProvider(
          AWSCredentials('AKIDTEST', 'secret'),
        ),
        dio: Dio()..httpClientAdapter = HangingHttpAdapter(),
      );

      final result = loader.load('assets/translations', locale);
      await tester.pump(const Duration(seconds: 6));

      expect(await result, {'source': 'bundle'});
      expect(requestedAssets, ['assets/translations/en.json']);
    },
  );
}
