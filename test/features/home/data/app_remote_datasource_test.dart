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

DioException _dioError({String? message, String? statusMessage}) =>
    DioException(
      requestOptions: RequestOptions(path: '/x'),
      message: message,
      response: statusMessage == null
          ? null
          : Response(
              requestOptions: RequestOptions(path: '/x'),
              statusCode: 500,
              statusMessage: statusMessage,
            ),
    );

void main() {
  late _MockAppClient client;
  late AppRemoteDataSourceImpl dataSource;

  setUp(() {
    client = _MockAppClient();
    dataSource = AppRemoteDataSourceImpl(client);
  });

  group('checkVersionAvailable', () {
    test('sends the enum name and is true only when isOpen is true', () async {
      when(() => client.getVersion(version: 'BCEL'))
          .thenAnswer((_) async => const VersionModel(isOpen: true));

      expect(
        await dataSource.checkVersionAvailable(
          version: VersionAvailableType.BCEL,
        ),
        isTrue,
      );
      verify(() => client.getVersion(version: 'BCEL')).called(1);
    });

    for (final (name, response) in <(String, VersionModel?)>[
      ('isOpen is false', const VersionModel(isOpen: false)),
      ('isOpen is null', const VersionModel()),
      ('the response is null', null),
    ]) {
      test('is false when $name', () async {
        when(() => client.getVersion(version: any(named: 'version')))
            .thenAnswer((_) async => response);

        expect(
          await dataSource.checkVersionAvailable(
            version: VersionAvailableType.JDB,
          ),
          isFalse,
        );
      });
    }
  });

  group('success paths return the client result', () {
    test('getBillBackground', () async {
      const model = BackgroundDetailModel(id: 'bg');
      when(() => client.getBackgroundDetail()).thenAnswer((_) async => model);
      expect(await dataSource.getBillBackground(), model);
    });

    test('getVersionDetail', () async {
      const model = VersionInfoModel(version: VersionModel(name: 'v'));
      when(() => client.getVersionInfo()).thenAnswer((_) async => model);
      expect(await dataSource.getVersionDetail(), model);
    });

    test('getTitle / getContact / getSocialMedia / getLocation', () async {
      const title = TitleModel(title: 't');
      const contact = ContactModel(id: 'c');
      const social = ContactModel(id: 's');
      const location = LocationModel(id: 'l');
      when(() => client.getTitle()).thenAnswer((_) async => title);
      when(() => client.getContact()).thenAnswer((_) async => contact);
      when(() => client.getSocialMedia()).thenAnswer((_) async => social);
      when(() => client.getLocation()).thenAnswer((_) async => location);

      expect(await dataSource.getTitle(), title);
      expect(await dataSource.getContact(), contact);
      expect(await dataSource.getSocialMedia(), social);
      expect(await dataSource.getLocation(), location);
    });
  });

  group('error mapping', () {
    final calls = <String, Future<Object?> Function(AppRemoteDataSourceImpl)>{
      'checkVersionAvailable': (d) =>
          d.checkVersionAvailable(version: VersionAvailableType.BCEL),
      'getBillBackground': (d) => d.getBillBackground(),
      'getVersionDetail': (d) => d.getVersionDetail(),
      'getTitle': (d) => d.getTitle(),
      'getContact': (d) => d.getContact(),
      'getSocialMedia': (d) => d.getSocialMedia(),
      'getLocation': (d) => d.getLocation(),
    };

    void stubAllToThrow(Object error) {
      when(() => client.getVersion(version: any(named: 'version')))
          .thenThrow(error);
      when(() => client.getBackgroundDetail()).thenThrow(error);
      when(() => client.getVersionInfo()).thenThrow(error);
      when(() => client.getTitle()).thenThrow(error);
      when(() => client.getContact()).thenThrow(error);
      when(() => client.getSocialMedia()).thenThrow(error);
      when(() => client.getLocation()).thenThrow(error);
    }

    for (final entry in calls.entries) {
      test('${entry.key}: DioException message becomes ServerException', () {
        stubAllToThrow(_dioError(message: 'timeout'));
        expect(
          entry.value(dataSource),
          throwsA(const ServerException('timeout')),
        );
      });

      test('${entry.key}: unexpected errors become ServerException', () {
        stubAllToThrow(StateError('boom'));
        expect(
          entry.value(dataSource),
          throwsA(
            isA<ServerException>().having(
              (e) => e.message,
              'message',
              contains('boom'),
            ),
          ),
        );
      });
    }
  });
}
