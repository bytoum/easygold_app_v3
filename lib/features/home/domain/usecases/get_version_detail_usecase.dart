import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/version_info_model.dart';
import 'package:easygold_app_v3/core/usecases/no_params.dart';
import 'package:easygold_app_v3/core/usecases/usecase.dart';
import 'package:easygold_app_v3/features/home/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetVersionDetailUseCase implements UseCase<VersionInfoModel?, NoParams> {
  final AppRepository _repository;
  GetVersionDetailUseCase({required this._repository});
  @override
  Future<Either<Failure, VersionInfoModel?>> call(NoParams params) async {
    return await _repository.getVersionDetail();
  }
}
