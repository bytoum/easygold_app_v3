import 'package:dio/dio.dart';
import 'package:easygold_app_v3/core/errors/exceptions.dart';
import 'package:easygold_app_v3/core/models/base_response.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/core/network/rest_client.dart';
import 'package:easygold_app_v3/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthClient extends Mock implements AuthClient {}

DioException _dioError({Object? data, int status = 401}) {
  final options = RequestOptions(path: '/signin');
  return DioException(
    requestOptions: options,
    response: data == null && status == 0
        ? null
        : Response(requestOptions: options, statusCode: status, data: data),
  );
}

void main() {
  late _MockAuthClient client;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    client = _MockAuthClient();
    dataSource = AuthRemoteDataSourceImpl(client);
  });

  void stubClientThrows(Object error) {
    when(() => client.signInWithPassword(any(), any(), any(), any(), any()))
        .thenThrow(error);
  }

  Future<LoginDataModel> signIn() => dataSource.signInWithPassword(
    phoneNumber: '0201234567',
    password: 'hunter2',
    uuid: 'uuid-1',
    code: 'c',
    fmcToken: 'fmc',
    isAllowPushNoti: true,
  );

  test('maps arguments onto the client call and returns the data', () async {
    when(() => client.signInWithPassword(any(), any(), any(), any(), any()))
        .thenAnswer(
          (_) async =>
              BaseResponse(data: const LoginDataModel(accessToken: 'tok')),
        );

    final result = await signIn();

    expect(result.accessToken, 'tok');
    verify(
      () => client.signInWithPassword('c', 'fmc', 'true', 'uuid-1', {
        'username': '0201234567',
        'password': 'hunter2',
      }),
    ).called(1);
  });

  test('isAllowPushNoti defaults to the string "false"', () async {
    when(() => client.signInWithPassword(any(), any(), any(), any(), any()))
        .thenAnswer(
          (_) async =>
              BaseResponse(data: const LoginDataModel(accessToken: 't')),
        );

    await dataSource.signInWithPassword(
      phoneNumber: 'p',
      password: 'w',
      uuid: 'u',
    );

    verify(
      () => client.signInWithPassword(null, null, 'false', 'u', {
        'username': 'p',
        'password': 'w',
      }),
    ).called(1);
  });

  group('server message handling', () {
    Future<void> expectMessage(DioException error, String expected) async {
      stubClientThrows(error);
      await expectLater(signIn(), throwsA(ServerException(expected)));
    }

    test('uses a short backend message', () {
      return expectMessage(
        _dioError(data: {'message': 'Wrong password'}),
        'Wrong password',
      );
    });

    test('trims surrounding whitespace', () {
      return expectMessage(
        _dioError(data: {'message': '  Locked  '}),
        'Locked',
      );
    });

    test('accepts a message of exactly 200 characters', () {
      final msg = 'a' * 200;
      return expectMessage(_dioError(data: {'message': msg}), msg);
    });

    test('drops a message longer than 200 characters', () {
      return expectMessage(_dioError(data: {'message': 'a' * 201}), '');
    });

    for (final (name, data) in <(String, Object?)>[
      ('blank message', {'message': '   '}),
      ('non-string message', {'message': 42}),
      ('missing message key', {'error': 'x'}),
      ('HTML body', '<html>secret stack trace</html>'),
      ('list body', ['a']),
    ]) {
      test('returns an empty message for a $name', () {
        return expectMessage(_dioError(data: data), '');
      });
    }

    test('returns an empty message when there is no response', () {
      return expectMessage(_dioError(status: 0), '');
    });
  });

  test(
    'non-Dio errors become an empty ServerException without leaking',
    () async {
      stubClientThrows(StateError('password=hunter2 leaked'));

      await expectLater(
        signIn(),
        throwsA(
          isA<ServerException>().having((e) => e.message, 'message', isEmpty),
        ),
      );
    },
  );
}
