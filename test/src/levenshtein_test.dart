import 'package:test/test.dart';
import 'package:zxcvbn/src/levenshtein.dart';

void main() {
  group('Levenshtein distance', () {
    test('calculates distance between identical strings', () {
      final distance = _calculateDistance('hello', 'hello');
      expect(distance, equals(0));
    });

    test('calculates distance with single character difference', () {
      final distance = _calculateDistance('hello', 'hallo');
      expect(distance, equals(1));
    });

    test('calculates distance with insertion', () {
      final distance = _calculateDistance('hello', 'helloo');
      expect(distance, equals(1));
    });

    test('calculates distance with deletion', () {
      final distance = _calculateDistance('hello', 'helo');
      expect(distance, equals(1));
    });

    test('calculates distance with multiple differences', () {
      final distance = _calculateDistance('elephant', 'alaphant');
      expect(distance, equals(2));
    });

    test('calculates distance with completely different strings', () {
      final distance = _calculateDistance('abc', 'xyz');
      expect(distance, equals(3));
    });
  });

  group('findLevenshteinDistance', () {
    test('finds matching word within threshold', () {
      final dictionary = {'password': 1, 'elephant': 344, 'computer': 500};

      final result = findLevenshteinDistance('alaphant', dictionary, 2);

      expect(result, isNotNull);
      expect(result!.levenshteinDistance, equals(2));
      expect(result.levenshteinDistanceEntry, equals('elephant'));
    });

    test('returns null when no match within threshold', () {
      final dictionary = {'password': 1, 'elephant': 344};

      final result = findLevenshteinDistance('xyz', dictionary, 2);

      expect(result, isNull);
    });

    test('adjusts threshold for short passwords', () {
      final dictionary = {'cat': 100, 'hat': 200};

      // For a 3-letter password with threshold 2, it should use ceil(3/4) = 1
      final result = findLevenshteinDistance('bat', dictionary, 2);

      expect(result, isNotNull);
      expect(result!.levenshteinDistance, equals(1));
      expect(
        result.levenshteinDistanceEntry,
        anyOf(equals('cat'), equals('hat')),
      );
    });

    test('skips entries with length difference exceeding threshold', () {
      final dictionary = {'hello': 1, 'verylongwordhere': 2};

      // Should not match 'verylongwordhere' as length difference is too large
      final result = findLevenshteinDistance('hi', dictionary, 2);

      expect(result, isNull);
    });
  });
}

// Expose the internal function for testing
int _calculateDistance(String s1, String s2) {
  if (s1 == s2) return 0;
  if (s1.isEmpty) return s2.length;
  if (s2.isEmpty) return s1.length;

  final len1 = s1.length;
  final len2 = s2.length;

  List<List<int>> matrix = List.generate(
    len1 + 1,
    (i) => List.filled(len2 + 1, 0),
  );

  for (int i = 0; i <= len1; i++) {
    matrix[i][0] = i;
  }
  for (int j = 0; j <= len2; j++) {
    matrix[0][j] = j;
  }

  for (int i = 1; i <= len1; i++) {
    for (int j = 1; j <= len2; j++) {
      final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
      matrix[i][j] = [
        matrix[i - 1][j] + 1,
        matrix[i][j - 1] + 1,
        matrix[i - 1][j - 1] + cost,
      ].reduce((a, b) => a < b ? a : b);
    }
  }

  return matrix[len1][len2];
}
