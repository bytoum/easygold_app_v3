import 'package:dio/dio.dart';
import 'package:easygold_app_v3/core/constants/enums/version_type.dart';
import 'package:easygold_app_v3/core/errors/exceptions.dart';
import 'package:easygold_app_v3/core/models/background_detail_model.dart';
import 'package:easygold_app_v3/core/models/contact_model.dart';
import 'package:easygold_app_v3/core/models/version_info_model.dart';
import 'package:easygold_app_v3/core/models/version_model.dart';
import 'package:easygold_app_v3/core/network/rest_client.dart';
import 'package:easygold_app_v3/features/home/data/datasources/app_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAppClient extends Mock implements AppClient {}

DioException _dioError({String? message, String? statusMessage}) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    message: message,
    response: Response(
      requestOptions: options,
      statusCode: 500,
      statusMessage: statusMessage,
    ),
  );
}

void main() {
  late _MockAppClient client;
  late AppRemoteDataSourceImpl dataSource;

  setUp(() {
    client = _MockAppClient();
    dataSource = AppRemoteDataSourceImpl(client);
  });

  group('checkVersionAvailable', () {
    test(
      'requests the version by enum name and returns true when open',
      () async {
        when(() => client.getVersion(version: 'BCEL'))
            .thenAnswer((_) async => const VersionModel(isOpen: true));

        expect(
          await dataSource.checkVersionAvailable(
            version: VersionAvailableType.BCEL,
          ),
          isTrue,
        );
        verify(() => client.getVersion(version: 'BCEL')).called(1);
      },
    );

    test(
      'returns false when closed, isOpen is null, or response is null',
      () async {
        for (final response in [
          const VersionModel(isOpen: false),
          const VersionModel(),
          null,
        ]) {
          when(() => client.getVersion(version: any(named: 'version')))
              .thenAnswer((_) async => response);
          expect(
            await dataSource.checkVersionAvailable(
              version: VersionAvailableType.JDB,
            ),
            isFalse,
            reason: '$response',
          );
        }
      },
    );

    test('maps DioException to ServerException', () {
      when(() => client.getVersion(version: any(named: 'version')))
          .thenThrow(_dioError(message: 'timeout'));

      expect(
        dataSource.checkVersionAvailable(version: VersionAvailableType.STB),
        throwsA(const ServerException('timeout')),
      );
    });
  });

  // The remaining methods pass the client result through unchanged.
  const background = BackgroundDetailModel(id: 'bg');
  const contact = ContactModel(id: 'c', label: 'Phone', value: '123');
  const social = ContactModel(id: 's', label: 'FB');
  const title = TitleModel(id: 't', title: 'Help');
  const location = LocationModel(id: 'l', name: 'Shop');
  const versionInfo = VersionInfoModel();

  group('pass-through methods', () {
    test('getBillBackground returns the client result', () async {
      when(() => client.getBackgroundDetail())
          .thenAnswer((_) async => background);
      expect(await dataSource.getBillBackground(), background);
    });

    test('getContact returns the client result', () async {
      when(() => client.getContact()).thenAnswer((_) async => contact);
      expect(await dataSource.getContact(), contact);
    });

    test('getSocialMedia returns the client result', () async {
      when(() => client.getSocialMedia()).thenAnswer((_) async => social);
      expect(await dataSource.getSocialMedia(), social);
    });

    test('getTitle returns the client result', () async {
      when(() => client.getTitle()).thenAnswer((_) async => title);
      expect(await dataSource.getTitle(), title);
    });

    test('getLocation returns the client result', () async {
      when(() => client.getLocation()).thenAnswer((_) async => location);
      expect(await dataSource.getLocation(), location);
    });

    test('getVersionDetail returns the client result', () async {
      when(() => client.getVersionInfo()).thenAnswer((_) async => versionInfo);
      expect(await dataSource.getVersionDetail(), versionInfo);
    });
  });

  group('error mapping', () {
    test('prefers the DioException message', () {
      when(() => client.getTitle())
          .thenThrow(_dioError(message: 'no network', statusMessage: 'ISE'));
      expect(
        dataSource.getTitle(),
        throwsA(const ServerException('no network')),
      );
    });

    test('falls back to the response status message', () {
      when(() => client.getTitle())
          .thenThrow(_dioError(statusMessage: 'Server Error'));
      expect(
        dataSource.getTitle(),
        throwsA(const ServerException('Server Error')),
      );
    });

    test("falls back to 'Unknown error'", () {
      when(() => client.getTitle()).thenThrow(_dioError());
      expect(
        dataSource.getTitle(),
        throwsA(const ServerException('Unknown error')),
      );
    });

    test('wraps non-Dio errors using toString', () {
      when(() => client.getLocation()).thenThrow(StateError('bad'));
      expect(
        dataSource.getLocation(),
        throwsA(ServerException(StateError('bad').toString())),
      );
    });
  });

  // Every method wraps its client call the same way, so run the same checks
  // against each one (Dio errors keep their message, anything else is
  // stringified), instead of only against getTitle/getLocation above.
  group('every method maps client failures to ServerException', () {
    final methods =
        <
          String,
          ({
            Future<Object?> Function() clientCall,
            Future<Object?> Function() call,
          })
        >{
          'checkVersionAvailable': (
            clientCall: () => client.getVersion(version: any(named: 'version')),
            call: () => dataSource.checkVersionAvailable(
              version: VersionAvailableType.BCEL,
            ),
          ),
          'getBillBackground': (
            clientCall: () => client.getBackgroundDetail(),
            call: () => dataSource.getBillBackground(),
          ),
          'getContact': (
            clientCall: () => client.getContact(),
            call: () => dataSource.getContact(),
          ),
          'getSocialMedia': (
            clientCall: () => client.getSocialMedia(),
            call: () => dataSource.getSocialMedia(),
          ),
          'getTitle': (
            clientCall: () => client.getTitle(),
            call: () => dataSource.getTitle(),
          ),
          'getLocation': (
            clientCall: () => client.getLocation(),
            call: () => dataSource.getLocation(),
          ),
          'getVersionDetail': (
            clientCall: () => client.getVersionInfo(),
            call: () => dataSource.getVersionDetail(),
          ),
        };

    methods.forEach((name, m) {
      test('$name: DioException keeps its message', () {
        when(m.clientCall).thenThrow(_dioError(message: 'no network'));
        expect(m.call(), throwsA(const ServerException('no network')));
      });

      test('$name: DioException without message uses the status message', () {
        when(m.clientCall).thenThrow(_dioError(statusMessage: 'Bad Gateway'));
        expect(m.call(), throwsA(const ServerException('Bad Gateway')));
      });

      test("$name: DioException with neither says 'Unknown error'", () {
        when(m.clientCall).thenThrow(_dioError());
        expect(m.call(), throwsA(const ServerException('Unknown error')));
      });

      test('$name: other errors are wrapped via toString', () {
        when(m.clientCall).thenThrow(StateError('bad'));
        expect(
          m.call(),
          throwsA(ServerException(StateError('bad').toString())),
        );
      });
    });
  });
}
