import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/constants/enums/version_type.dart';
import 'package:easygold_app_v3/core/errors/exceptions.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/background_detail_model.dart';
import 'package:easygold_app_v3/core/models/contact_model.dart';
import 'package:easygold_app_v3/core/models/version_info_model.dart';
import 'package:easygold_app_v3/features/home/data/datasources/app_remote_datasource.dart';
import 'package:easygold_app_v3/features/home/data/repositories/app_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataSource extends Mock implements AppRemoteDataSource {}

void main() {
  setUpAll(() => registerFallbackValue(VersionAvailableType.BCEL));

  late _MockDataSource dataSource;
  late AppRepositoryImpl repository;

  setUp(() {
    dataSource = _MockDataSource();
    repository = AppRepositoryImpl(dataSource);
  });

  const failure = Left<Failure, Never>(ServerFailure('down'));
  const exception = ServerException('down');

  group('wraps data source results in Right', () {
    test('checkVersionAvailable', () async {
      when(
        () =>
            dataSource.checkVersionAvailable(version: VersionAvailableType.STB),
      ).thenAnswer((_) async => true);
      expect(
        await repository.checkVersionAvailable(
          version: VersionAvailableType.STB,
        ),
        const Right<Failure, bool>(true),
      );
    });

    test('getBillBackground (including null)', () async {
      when(() => dataSource.getBillBackground()).thenAnswer((_) async => null);
      expect(
        await repository.getBillBackground(),
        const Right<Failure, BackgroundDetailModel?>(null),
      );
    });

    test('getVersionDetail', () async {
      const model = VersionInfoModel();
      when(() => dataSource.getVersionDetail()).thenAnswer((_) async => model);
      expect(
        await repository.getVersionDetail(),
        const Right<Failure, VersionInfoModel?>(model),
      );
    });

    test('customer service getters', () async {
      const title = TitleModel(title: 't');
      const contact = ContactModel(id: 'c');
      const location = LocationModel(id: 'l');
      when(() => dataSource.getTitle()).thenAnswer((_) async => title);
      when(() => dataSource.getContact()).thenAnswer((_) async => contact);
      when(() => dataSource.getSocialMedia()).thenAnswer((_) async => contact);
      when(() => dataSource.getLocation()).thenAnswer((_) async => location);

      expect(
        await repository.getTitle(),
        const Right<Failure, TitleModel>(title),
      );
      expect(
        await repository.getContact(),
        const Right<Failure, ContactModel>(contact),
      );
      expect(
        await repository.getSocialMedia(),
        const Right<Failure, ContactModel>(contact),
      );
      expect(
        await repository.getLocation(),
        const Right<Failure, LocationModel>(location),
      );
    });
  });

  group('maps ServerException to Left(ServerFailure)', () {
    setUp(() {
      when(
        () => dataSource.checkVersionAvailable(version: any(named: 'version')),
      ).thenThrow(exception);
      when(() => dataSource.getBillBackground()).thenThrow(exception);
      when(() => dataSource.getVersionDetail()).thenThrow(exception);
      when(() => dataSource.getTitle()).thenThrow(exception);
      when(() => dataSource.getContact()).thenThrow(exception);
      when(() => dataSource.getSocialMedia()).thenThrow(exception);
      when(() => dataSource.getLocation()).thenThrow(exception);
    });

    test('every operation', () async {
      expect(
        await repository.checkVersionAvailable(
          version: VersionAvailableType.LDB,
        ),
        failure,
      );
      expect(await repository.getBillBackground(), failure);
      expect(await repository.getVersionDetail(), failure);
      expect(await repository.getTitle(), failure);
      expect(await repository.getContact(), failure);
      expect(await repository.getSocialMedia(), failure);
      expect(await repository.getLocation(), failure);
    });
  });

  test('does not swallow non-ServerException errors', () {
    when(() => dataSource.getTitle()).thenThrow(StateError('bug'));
    expect(repository.getTitle(), throwsStateError);
  });
}
