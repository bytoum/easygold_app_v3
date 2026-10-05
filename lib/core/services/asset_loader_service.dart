import 'dart:convert';
import 'dart:ui';

import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class S3AssetLoaderService extends AssetLoader {
  final String bucket;
  final String region;
  final Dio dio;
  final AWSCredentialsProvider credentialsProvider;
  S3AssetLoaderService({
    required this.bucket,
    required this.region,
    required this.credentialsProvider,
    required this.dio,
  });
  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    try {
      final credentials = await credentialsProvider.retrieve();
      if (credentials.accessKeyId.isNotEmpty == true &&
          credentials.secretAccessKey.isNotEmpty == true) {
        final filename = '${locale.toLanguageTag()}.json';
        final signer = AWSSigV4Signer(
          credentialsProvider: credentialsProvider,
        );
        final request = AWSHttpRequest(
          method: AWSHttpMethod.get,
          uri: Uri.https('$bucket.s3.$region.amazonaws.com', '/$filename'),
        );

        final signedUrl = await signer
            .presign(
              request,
              credentialScope: AWSCredentialScope(
                region: region,
                service: AWSService.s3,
              ),
              serviceConfiguration: S3ServiceConfiguration(),
              expiresIn: const Duration(minutes: 1),
            )
            .timeout(const Duration(seconds: 5));

        final response = await dio
            .getUri<String>(
              signedUrl,
              options: Options(
                responseType: ResponseType.plain,
                sendTimeout: const Duration(seconds: 5),
                receiveTimeout: const Duration(seconds: 5),
                followRedirects: false,
                validateStatus: (status) => status == 200,
              ),
            )
            .timeout(const Duration(seconds: 5));
        return jsonDecode(response.data!) as Map<String, dynamic>;
      } else {
        return await fallbackAssetLoader(path, locale);
      }
    } on DioException catch (e) {
      EasyLocalization.logger.error('Failed to load asset from S3: $e');
      EasyLocalization.logger.info(
        'Falling back to local asset loader for locale: ${locale.toLanguageTag()}',
      );
      return await fallbackAssetLoader(path, locale);
    }
  }

  Future<Map<String, dynamic>?> fallbackAssetLoader(
    String path,
    Locale locale,
  ) async {
    final localJson = await rootBundle.loadString(
      '$path/${locale.toLanguageTag()}.json',
    );
    return jsonDecode(localJson) as Map<String, dynamic>;
  }
}
