import 'package:dio/dio.dart';
import 'package:easygold_app_v3/core/errors/exceptions.dart';
import 'package:easygold_app_v3/core/models/base_response.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/core/network/rest_client.dart';
import 'package:easygold_app_v3/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthClient implements AuthClient {
  _FakeAuthClient(this._error);
  final Object _error;

  @override
  Future<BaseResponse<LoginDataModel>> signInWithPassword(
    String? code,
    String? fmcToken,
    String isAllowPushNoti,
    String uuid,
    Map<String, dynamic> body,
  ) async => throw _error;
}

class _RecordingAuthClient implements AuthClient {
  final calls = <List<Object?>>[];

  @override
  Future<BaseResponse<LoginDataModel>> signInWithPassword(
    String? code,
    String? fmcToken,
    String isAllowPushNoti,
    String uuid,
    Map<String, dynamic> body,
  ) async {
    calls.add([code, fmcToken, isAllowPushNoti, uuid, body]);
    return BaseResponse(data: const LoginDataModel(accessToken: 'token'));
  }
}

DioException _dioError(Object? data, {int status = 401}) {
  final options = RequestOptions(path: '/signin');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    message: 'status code $status',
    response: Response(requestOptions: options, statusCode: status, data: data),
  );
}

Future<ServerException> _signInError(Object error) async {
  final dataSource = AuthRemoteDataSourceImpl(_FakeAuthClient(error));
  try {
    await dataSource.signInWithPassword(
      phoneNumber: '000',
      password: 'test-password',
      uuid: 'test-uuid',
    );
  } on ServerException catch (e) {
    return e;
  }
  fail('Expected a ServerException');
}

void main() {
  group('AuthRemoteDataSourceImpl.signInWithPassword errors', () {
    test('uses the backend message when it is a short string', () async {
      final e = await _signInError(_dioError({'message': ' Wrong password '}));
      expect(e.message, 'Wrong password');
    });

    test('returns an empty message when the body has no message', () async {
      final e = await _signInError(_dioError({'error': true, 'detail': 'x'}));
      expect(e.message, '');
    });

    test('ignores a message that is not a string', () async {
      final e = await _signInError(_dioError({'message': 123}));
      expect(e.message, '');
    });

    test('ignores an over-long message', () async {
      final e = await _signInError(_dioError({'message': 'a' * 201}));
      expect(e.message, '');
    });

    test('does not expose a non-JSON response body', () async {
      final e = await _signInError(_dioError('<html>internal error</html>'));
      expect(e.message, '');
    });

    test(
      'does not expose the Dio error text when there is no response',
      () async {
        final e = await _signInError(
          DioException(
            requestOptions: RequestOptions(path: '/signin'),
            type: DioExceptionType.connectionError,
            message: 'connection error to https://internal.example',
          ),
        );
        expect(e.message, '');
      },
    );

    test('does not expose unexpected exception text', () async {
      final e = await _signInError(StateError('secret detail'));
      expect(e.message, '');
    });
  });

  group('AuthRemoteDataSourceImpl.signInWithPassword success', () {
    test('returns the response data', () async {
      final dataSource = AuthRemoteDataSourceImpl(_RecordingAuthClient());

      final result = await dataSource.signInWithPassword(
        phoneNumber: '000',
        password: 'test-password',
        uuid: 'test-uuid',
      );

      expect(result, const LoginDataModel(accessToken: 'token'));
    });

    test('maps arguments onto the client call', () async {
      final client = _RecordingAuthClient();

      await AuthRemoteDataSourceImpl(client).signInWithPassword(
        phoneNumber: '000',
        password: 'test-password',
        uuid: 'test-uuid',
        code: 'test-code',
        fmcToken: 'test-fmc',
        isAllowPushNoti: true,
      );

      expect(client.calls.single, [
        'test-code',
        'test-fmc',
        'true',
        'test-uuid',
        {'username': '000', 'password': 'test-password'},
      ]);
    });

    test('isAllowPushNoti defaults to the string false', () async {
      final client = _RecordingAuthClient();

      await AuthRemoteDataSourceImpl(client).signInWithPassword(
        phoneNumber: '000',
        password: 'test-password',
        uuid: 'test-uuid',
      );

      expect(client.calls.single[2], 'false');
    });
  });
}
