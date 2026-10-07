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
  late _MockDataSource dataSource;
  late AppRepositoryImpl repository;

  setUp(() {
    dataSource = _MockDataSource();
    repository = AppRepositoryImpl(dataSource);
  });

  const failure = ServerFailure('boom');
  const exception = ServerException('boom');

  /// Every repository method must return Right(value) on success and
  /// Left(ServerFailure(message)) when the data source throws ServerException.
  void checkContract<T>(
    String name, {
    required Future<T> Function() remote,
    required Future<Either<Failure, T>> Function() call,
    required T value,
  }) {
    group(name, () {
      test('returns Right with the data source result', () async {
        when(remote).thenAnswer((_) async => value);
        expect(await call(), Right<Failure, T>(value));
      });

      test('maps ServerException to Left(ServerFailure)', () async {
        when(remote).thenThrow(exception);
        expect(await call(), const Left<Failure, Never>(failure));
      });
    });
  }

  checkContract<bool>(
    'checkVersionAvailable',
    remote: () =>
        dataSource.checkVersionAvailable(version: VersionAvailableType.BCEL),
    call: () =>
        repository.checkVersionAvailable(version: VersionAvailableType.BCEL),
    value: true,
  );
  checkContract<BackgroundDetailModel?>(
    'getBillBackground',
    remote: () => dataSource.getBillBackground(),
    call: () => repository.getBillBackground(),
    value: const BackgroundDetailModel(id: 'bg'),
  );
  checkContract<ContactModel>(
    'getContact',
    remote: () => dataSource.getContact(),
    call: () => repository.getContact(),
    value: const ContactModel(id: 'c'),
  );
  checkContract<ContactModel>(
    'getSocialMedia',
    remote: () => dataSource.getSocialMedia(),
    call: () => repository.getSocialMedia(),
    value: const ContactModel(id: 's'),
  );
  checkContract<LocationModel>(
    'getLocation',
    remote: () => dataSource.getLocation(),
    call: () => repository.getLocation(),
    value: const LocationModel(id: 'l'),
  );
  checkContract<TitleModel>(
    'getTitle',
    remote: () => dataSource.getTitle(),
    call: () => repository.getTitle(),
    value: const TitleModel(id: 't'),
  );
  checkContract<VersionInfoModel?>(
    'getVersionDetail',
    remote: () => dataSource.getVersionDetail(),
    call: () => repository.getVersionDetail(),
    value: const VersionInfoModel(),
  );

  test('nullable results are still wrapped in Right', () async {
    when(() => dataSource.getBillBackground()).thenAnswer((_) async => null);
    expect(
      await repository.getBillBackground(),
      const Right<Failure, BackgroundDetailModel?>(null),
    );
  });
}
