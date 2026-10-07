import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Records every request and answers with a canned JSON body, so no test
/// ever touches the network.
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter({this.status = 200, Object? body = const {}})
    : body = jsonEncode(body);

  /// Answers with [body] verbatim, e.g. to simulate a malformed payload.
  FakeHttpAdapter.raw(this.body, {this.status = 200});

  final int status;
  final String body;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// Never answers, to simulate a stalled connection.
class HangingHttpAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => Completer<ResponseBody>().future;

  @override
  void close({bool force = false}) {}
}
