import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Records every request and answers with a canned JSON body, so Dio-based
/// code can be tested without any network.
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter({Object? body, this.status = 200}) : body = body ?? {};

  final Object body;
  final int status;
  final List<RequestOptions> requests = [];
  final List<String> sentBodies = [];

  RequestOptions get last => requests.last;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (requestStream != null) {
      final bytes = await requestStream.expand((chunk) => chunk).toList();
      sentBodies.add(utf8.decode(bytes));
    }
    return ResponseBody.fromString(
      body is String ? body as String : jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
