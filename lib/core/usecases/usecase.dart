import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';

abstract class UseCase<Result, Params> {
  Future<Either<Failure, Result>> call(Params params);
}
