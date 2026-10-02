import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/background_detail_model.dart';
import 'package:easygold_app_v3/core/usecases/no_params.dart';
import 'package:easygold_app_v3/core/usecases/usecase.dart';
import 'package:easygold_app_v3/features/home/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetBillBackgroundUseCase
    implements UseCase<BackgroundDetailModel?, NoParams> {
  final AppRepository _repository;
  GetBillBackgroundUseCase(this._repository);
  @override
  Future<Either<Failure, BackgroundDetailModel?>> call(NoParams params) async {
    return await _repository.getBillBackground();
  }
}
