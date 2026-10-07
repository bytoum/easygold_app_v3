import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/extensions/either_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EitherExtension', () {
    test('Right exposes value via getRight and null via getLeft', () {
      const Either<Failure, int> either = Right(42);
      expect(either.getRight, 42);
      expect(either.getLeft, isNull);
    });

    test('Left exposes failure via getLeft and null via getRight', () {
      const Either<Failure, int> either = Left(ServerFailure('boom'));
      expect(either.getLeft, const ServerFailure('boom'));
      expect(either.getRight, isNull);
    });
  });
}
