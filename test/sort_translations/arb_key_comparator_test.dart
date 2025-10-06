import 'package:test/test.dart';
import 'package:translations_cleaner/src/sort_terms.dart';

void main() {
  test("when keys are the same, should return 0", () {
    expect(arbKeyComparator("a", "a"), 0);
  });

  test("when both starts with @@, should compare by base", () {
    final keyA = "@@a";
    final keyB = "@@b";
    expect(arbKeyComparator(keyA, keyB), -1);
    expect(arbKeyComparator(keyB, keyA), 1);
  });

  test("when one key starts with @@, should be first", () {
    final keyA = "@@a";
    final keyB = "@b";
    expect(arbKeyComparator(keyA, keyB), -1);
    expect(arbKeyComparator(keyB, keyA), 1);
  });

  test("when key and its metadata, should sort key first and metadata then", () {
    final key = "a";
    final metadata = "@a";
    expect(arbKeyComparator(key, metadata), -1);
    expect(arbKeyComparator(metadata, key), 1);
  });

  test("when keyA and some metadata in keyB, should sort by base key", () {
    expect(arbKeyComparator("@ba", "bb"), -1);
    expect(arbKeyComparator("@bb", "ba"), 1);
  });

  test("when keyB and some metadata in keyA, should sort by base key", () {
    expect(arbKeyComparator("ba", "@bb"), -1);
    expect(arbKeyComparator("bb", "@ba"), 1);
  });

  test("when two metadata, should sort by base key", () {
    final keyA = "@a";
    final keyB = "@b";
    expect(arbKeyComparator(keyA, keyB), -1);
    expect(arbKeyComparator(keyB, keyA), 1);
  });

  test("when two keys, should compare them", () {
    final keyA = "a";
    final keyB = "b";
    expect(arbKeyComparator(keyA, keyB), -1);
    expect(arbKeyComparator(keyB, keyA), 1);
  });
}
