import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/constants/enums/version_type.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/usecases/usecase.dart';
import 'package:easygold_app_v3/features/home/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CheckVersionAvailableUsecase extends UseCase<bool, VersionAvailableType> {
  final AppRepository _appRepository;
  CheckVersionAvailableUsecase(this._appRepository);
  @override
  Future<Either<Failure, bool>> call(VersionAvailableType params) async {
    return await _appRepository.checkVersionAvailable(version: params);
  }
}