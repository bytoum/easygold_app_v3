import 'package:dartz/dartz.dart';

extension EitherExtension<L, R> on Either<L, R> {
  R? get getRight => fold((_) => null, (right) => right);
  L? get getLeft => fold((left) => left, (_) => null);
}
