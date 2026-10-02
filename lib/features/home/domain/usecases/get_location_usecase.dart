import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/contact_model.dart';
import 'package:easygold_app_v3/core/usecases/no_params.dart';
import 'package:easygold_app_v3/core/usecases/usecase.dart';
import 'package:easygold_app_v3/features/home/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetLocationUseCase implements UseCase<LocationModel, NoParams> {
  final AppRepository _repository;
  GetLocationUseCase(this._repository);

  @override
  Future<Either<Failure, LocationModel>> call(NoParams params) async {
    return await _repository.getLocation();
  }
}
