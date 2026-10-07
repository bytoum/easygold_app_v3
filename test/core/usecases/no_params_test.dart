import 'package:easygold_app_v3/core/usecases/no_params.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all NoParams instances are equal', () {
    expect(NoParams(), NoParams());
    expect(NoParams().hashCode, NoParams().hashCode);
  });
}
