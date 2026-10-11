import 'package:PiliPlus/utils/custom_buvid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('blank means existing random identity', () {
    expect(CustomBuvid.normalize(' \n '), isNull);
  });
  test('only outer whitespace is removed', () {
    expect(CustomBuvid.normalize(' fixture-device-Ab1234\n'), 'fixture-device-Ab1234');
  });
  test('rejects malformed input instead of silently changing identity', () {
    for (final value in ['short', 'https://example.com/device', 'abc def ghi jkl mno', List.filled(129, 'x').join()]) {
      expect(() => CustomBuvid.normalize(value), throwsFormatException);
    }
  });
}
