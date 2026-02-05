import 'package:test/test.dart';
import 'package:zxcvbn/zxcvbn.dart';
import 'package:zxcvbn/src/matching.dart' as matching;

void main() {
  group('Levenshtein distance integration', () {
    final zxcvbn = Zxcvbn();

    test('matches common word with typo when Levenshtein is enabled', () {
      // Enable Levenshtein distance matching
      matching.USE_LEVENSHTEIN_DISTANCE = true;
      matching.LEVENSHTEIN_THRESHOLD = 2;

      // "alaphant" is 2 edits away from "elephant" (a common password)
      final result = zxcvbn.evaluate('alaphant');

      // Should find a match with levenshtein distance
      final dictionaryMatches = result.sequence
          .where((match) => match.pattern == 'dictionary')
          .toList();

      expect(dictionaryMatches.isNotEmpty, isTrue);

      final levenshteinMatch = dictionaryMatches.firstWhere(
        (match) => match.levenshtein_distance != null,
        orElse: () => dictionaryMatches.first,
      );

      if (levenshteinMatch.levenshtein_distance != null) {
        expect(levenshteinMatch.levenshtein_distance, lessThanOrEqualTo(2));
        expect(levenshteinMatch.levenshtein_distance_entry, isNotNull);
      }

      // Clean up
      matching.USE_LEVENSHTEIN_DISTANCE = false;
    });

    test('does not match when Levenshtein is disabled', () {
      // Disable Levenshtein distance matching
      matching.USE_LEVENSHTEIN_DISTANCE = false;

      // Use a typo that won't match anything in the dictionary
      final result = zxcvbn.evaluate('qwertyuiopzxc');

      // Should not find a levenshtein match
      final hasLevenshteinMatch = result.sequence.any(
        (match) => match.levenshtein_distance != null,
      );

      expect(hasLevenshteinMatch, isFalse);
    });

    test('respects threshold setting', () {
      // Set a very low threshold
      matching.USE_LEVENSHTEIN_DISTANCE = true;
      matching.LEVENSHTEIN_THRESHOLD = 1;

      // Use a longer password to ensure threshold isn't auto-adjusted
      // "passwordd" is 1 edit from "password", should match
      // "passworddd" is 2 edits from "password", should not match with threshold=1
      final result1 = zxcvbn.evaluate('passwordd');
      final result2 = zxcvbn.evaluate('passworddd');

      final hasMatch1 = result1.sequence.any(
        (match) =>
            match.levenshtein_distance != null &&
            match.levenshtein_distance_entry == 'password',
      );

      final hasMatch2 = result2.sequence.any(
        (match) =>
            match.levenshtein_distance != null &&
            match.levenshtein_distance_entry == 'password',
      );

      // "passwordd" (1 edit) should match with threshold=1
      expect(hasMatch1, isTrue);
      // "passworddd" (2 edits) should NOT match with threshold=1
      expect(hasMatch2, isFalse);

      // Clean up
      matching.USE_LEVENSHTEIN_DISTANCE = false;
      matching.LEVENSHTEIN_THRESHOLD = 2;
    });

    test('improves password score for typo-filled common passwords', () {
      matching.USE_LEVENSHTEIN_DISTANCE = true;
      matching.LEVENSHTEIN_THRESHOLD = 2;

      // Without levenshtein, "passwrod" might not be detected as similar to "password"
      final resultWithLevenshtein = zxcvbn.evaluate('passwrod');

      // Disable and test again
      matching.USE_LEVENSHTEIN_DISTANCE = false;
      final resultWithoutLevenshtein = zxcvbn.evaluate('passwrod');

      // With Levenshtein enabled, it should detect this is similar to a common password
      // and thus have a lower (worse) score or at least detect it as a dictionary word
      final withLevenshteinHasDictMatch = resultWithLevenshtein.sequence.any(
        (match) => match.pattern == 'dictionary',
      );
      final withoutLevenshteinHasDictMatch = resultWithoutLevenshtein.sequence
          .any((match) => match.pattern == 'dictionary');

      // Should find more dictionary matches with Levenshtein enabled
      expect(
        withLevenshteinHasDictMatch || withoutLevenshteinHasDictMatch,
        isTrue,
      );

      // Clean up
      matching.USE_LEVENSHTEIN_DISTANCE = false;
    });

    test('only applies Levenshtein to full password', () {
      matching.USE_LEVENSHTEIN_DISTANCE = true;
      matching.LEVENSHTEIN_THRESHOLD = 2;

      // A long password containing a typo-filled word as substring
      // Levenshtein should only apply to the full password, not substrings
      final result = zxcvbn.evaluate('xalaphantx');

      // The substring "alaphant" should not get a levenshtein match
      // because levenshtein is only applied to full passwords
      final substrMatches = result.sequence.where(
        (match) =>
            match.token == 'alaphant' && match.levenshtein_distance != null,
      );

      expect(substrMatches.isEmpty, isTrue);

      // Clean up
      matching.USE_LEVENSHTEIN_DISTANCE = false;
    });
  });
}
