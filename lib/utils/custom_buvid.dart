/// Validates user-supplied App identities without changing their case or content.
abstract final class CustomBuvid {
  static String? normalize(String input) {
    final value = input.trim();
    if (value.isEmpty) return null;
    if (!RegExp(r'^[A-Za-z0-9-]{16,128}$').hasMatch(value)) {
      throw const FormatException('BUVID 需为 16–128 位字母、数字或连字符');
    }
    return value;
  }
}
