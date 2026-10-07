import 'package:easygold_app_v3/core/errors/exceptions.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure', () {
    test('compares by type and message', () {
      expect(const ServerFailure('a'), const ServerFailure('a'));
      expect(const ServerFailure('a'), isNot(const ServerFailure('b')));
      expect(const ServerFailure('a'), isNot(const CacheFailure('a')));
    });

    test('exposes msg', () {
      expect(const CacheFailure('x').msg, 'x');
    });
  });

  group('CustomException', () {
    test('compares by type and message', () {
      expect(const ServerException('a'), const ServerException('a'));
      expect(const ServerException('a'), isNot(const ServerException('b')));
      expect(const ServerException('a'), isNot(const CacheException('a')));
    });

    test('exposes message', () {
      expect(const ServerException('x').message, 'x');
    });
  });
}
