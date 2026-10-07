import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/constants/enums/version_type.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/background_detail_model.dart';
import 'package:easygold_app_v3/core/models/contact_model.dart';
import 'package:easygold_app_v3/core/models/version_info_model.dart';
import 'package:easygold_app_v3/core/usecases/no_params.dart';
import 'package:easygold_app_v3/features/home/domain/repositories/app_repository.dart';
import 'package:easygold_app_v3/features/home/domain/usecases/check_version_available_usecase.dart';
import 'package:easygold_app_v3/features/home/domain/usecases/get_bill_background_usecase.dart';
import 'package:easygold_app_v3/features/home/domain/usecases/get_contact_usecase.dart';
import 'package:easygold_app_v3/features/home/domain/usecases/get_location_usecase.dart';
import 'package:easygold_app_v3/features/home/domain/usecases/get_social_media_usecase.dart';
import 'package:easygold_app_v3/features/home/domain/usecases/get_title_usecase.dart';
import 'package:easygold_app_v3/features/home/domain/usecases/get_version_detail_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements AppRepository {}

void main() {
  late _MockRepository repository;
  setUp(() => repository = _MockRepository());

  final params = NoParams();
  const failure = ServerFailure('nope');

  /// Each use case must return exactly what its repository method returns,
  /// for both Right and Left, and call it once.
  void checkDelegation<T>(
    String name, {
    required Future<Either<Failure, T>> Function(AppRepository) repoCall,
    required Future<Either<Failure, T>> Function(AppRepository) run,
    required T value,
  }) {
    group(name, () {
      test('returns the repository Right', () async {
        when(() => repoCall(repository)).thenAnswer((_) async => Right(value));
        expect(await run(repository), Right<Failure, T>(value));
        verify(() => repoCall(repository)).called(1);
      });

      test('returns the repository Left', () async {
        when(() => repoCall(repository))
            .thenAnswer((_) async => const Left(failure));
        expect(await run(repository), const Left<Failure, Never>(failure));
      });
    });
  }

  checkDelegation<BackgroundDetailModel?>(
    'GetBillBackgroundUseCase',
    repoCall: (r) => r.getBillBackground(),
    run: (r) => GetBillBackgroundUseCase(r)(params),
    value: const BackgroundDetailModel(id: 'bg'),
  );
  checkDelegation<ContactModel>(
    'GetContactUseCase',
    repoCall: (r) => r.getContact(),
    run: (r) => GetContactUseCase(r)(params),
    value: const ContactModel(id: 'c'),
  );
  checkDelegation<ContactModel>(
    'GetSocialMediaUseCase',
    repoCall: (r) => r.getSocialMedia(),
    run: (r) => GetSocialMediaUseCase(r)(params),
    value: const ContactModel(id: 's'),
  );
  checkDelegation<LocationModel>(
    'GetLocationUseCase',
    repoCall: (r) => r.getLocation(),
    run: (r) => GetLocationUseCase(r)(params),
    value: const LocationModel(id: 'l'),
  );
  checkDelegation<TitleModel>(
    'GetTitleUseCase',
    repoCall: (r) => r.getTitle(),
    run: (r) => GetTitleUseCase(r)(params),
    value: const TitleModel(id: 't'),
  );
  checkDelegation<VersionInfoModel?>(
    'GetVersionDetailUseCase',
    repoCall: (r) => r.getVersionDetail(),
    run: (r) => GetVersionDetailUseCase(repository: r)(params),
    value: const VersionInfoModel(),
  );
  checkDelegation<bool>(
    'CheckVersionAvailableUsecase',
    repoCall: (r) => r.checkVersionAvailable(version: VersionAvailableType.LDB),
    run: (r) => CheckVersionAvailableUsecase(r)(VersionAvailableType.LDB),
    value: true,
  );
}
