import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/extensions/either_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EitherExtension', () {
    final Either<String, int> right = right_(1);
    final Either<String, int> left = left_('err');

    test('getRight returns the value on Right and null on Left', () {
      expect(right.getRight, 1);
      expect(left.getRight, isNull);
    });

    test('getLeft returns the value on Left and null on Right', () {
      expect(left.getLeft, 'err');
      expect(right.getLeft, isNull);
    });
  });
}

Either<String, int> right_(int v) => Right(v);
Either<String, int> left_(String v) => Left(v);
