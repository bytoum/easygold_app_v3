import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/usecases/no_params.dart';
import 'package:easygold_app_v3/core/usecases/usecase.dart';
import 'package:easygold_app_v3/core/usecases/usecase_sync.dart';
import 'package:flutter_test/flutter_test.dart';

class _Double implements UseCase<int, int> {
  @override
  Future<Either<Failure, int>> call(int params) async => Right(params * 2);
}

class _Negate implements SynchronousUseCase<int, int> {
  @override
  int call(int params) => -params;
}

void main() {
  test('NoParams instances are equal', () {
    expect(NoParams(), NoParams());
  });

  test('UseCase contract returns an Either asynchronously', () async {
    expect(await _Double()(3), const Right<Failure, int>(6));
  });

  test('SynchronousUseCase contract returns the result directly', () {
    expect(_Negate()(4), -4);
  });
}
