import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/constants/enums/version_type.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/contact_model.dart';
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
  setUpAll(() => registerFallbackValue(VersionAvailableType.BCEL));

  late _MockRepository repo;
  const failure = Left<Failure, Never>(ServerFailure('x'));

  setUp(() => repo = _MockRepository());

  test(
    'CheckVersionAvailableUsecase forwards the version and result',
    () async {
      when(() => repo.checkVersionAvailable(version: VersionAvailableType.APB))
          .thenAnswer((_) async => const Right(true));

      final result = await CheckVersionAvailableUsecase(repo)(
        VersionAvailableType.APB,
      );

      expect(result, const Right<Failure, bool>(true));
      verify(
        () => repo.checkVersionAvailable(version: VersionAvailableType.APB),
      ).called(1);
    },
  );

  test('CheckVersionAvailableUsecase passes failures through', () async {
    when(() => repo.checkVersionAvailable(version: any(named: 'version')))
        .thenAnswer((_) async => failure);
    expect(
      await CheckVersionAvailableUsecase(repo)(VersionAvailableType.APB),
      failure,
    );
  });

  test('each NoParams use case returns its repository result', () async {
    const contact = ContactModel(id: 'c');
    when(() => repo.getContact()).thenAnswer((_) async => const Right(contact));
    when(() => repo.getSocialMedia())
        .thenAnswer((_) async => const Right(contact));
    when(() => repo.getLocation())
        .thenAnswer((_) async => const Right(LocationModel(id: 'l')));
    when(() => repo.getTitle())
        .thenAnswer((_) async => const Right(TitleModel(title: 't')));
    when(() => repo.getBillBackground())
        .thenAnswer((_) async => const Right(null));
    when(() => repo.getVersionDetail())
        .thenAnswer((_) async => const Right(null));

    expect(
      await GetContactUseCase(repo)(NoParams()),
      const Right<Failure, ContactModel>(contact),
    );
    expect(
      await GetSocialMediaUseCase(repo)(NoParams()),
      const Right<Failure, ContactModel>(contact),
    );
    expect(
      (await GetLocationUseCase(repo)(NoParams())).getOrElse(() => throw 0).id,
      'l',
    );
    expect(
      (await GetTitleUseCase(repo)(NoParams())).getOrElse(() => throw 0).title,
      't',
    );
    expect(
      (await GetBillBackgroundUseCase(repo)(NoParams())).isRight(),
      isTrue,
    );
    expect(
      (await GetVersionDetailUseCase(repository: repo)(NoParams())).isRight(),
      isTrue,
    );
  });

  test('NoParams use cases pass failures through', () async {
    when(() => repo.getContact()).thenAnswer((_) async => failure);
    expect(await GetContactUseCase(repo)(NoParams()), failure);
  });
}
