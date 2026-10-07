import 'package:easygold_app_v3/core/errors/exceptions.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('exceptions', () {
    test('compare by message and type', () {
      expect(const ServerException('x'), const ServerException('x'));
      expect(const ServerException('x'), isNot(const ServerException('y')));
      expect(const ServerException('x') == const CacheException('x'), isFalse);
    });
  });

  group('failures', () {
    test('compare by message and type', () {
      expect(const ServerFailure('x'), const ServerFailure('x'));
      expect(const ServerFailure('x'), isNot(const ServerFailure('y')));
      expect(const ServerFailure('x') == const CacheFailure('x'), isFalse);
    });

    test('expose the message', () {
      expect(const CacheFailure('boom').msg, 'boom');
    });
  });
}
