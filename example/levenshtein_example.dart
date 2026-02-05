import 'package:zxcvbn/zxcvbn.dart';
import 'package:zxcvbn/src/matching.dart' as matching;

void main() {
  final zxcvbn = Zxcvbn();

  print('=== Levenshtein Distance Matching Demo ===\n');

  // Example 1: Common password with typo - Without Levenshtein
  print('Example 1: Evaluating "P@ssw0rd!" WITHOUT Levenshtein');
  matching.USE_LEVENSHTEIN_DISTANCE = false;
  var result = zxcvbn.evaluate('P@ssw0rd!');
  print('Score: ${result.score}/4');
  print('Guesses (log10): ${result.guesses_log10.toStringAsFixed(2)}');
  print('');

  // Example 2: Common password with typo - With Levenshtein
  print('Example 2: Evaluating "P@ssw0rd!" WITH Levenshtein');
  matching.USE_LEVENSHTEIN_DISTANCE = true;
  matching.LEVENSHTEIN_THRESHOLD = 2;
  result = zxcvbn.evaluate('P@ssw0rd!');
  print('Score: ${result.score}/4');
  print('Guesses (log10): ${result.guesses_log10.toStringAsFixed(2)}');

  // Show dictionary matches
  print('Dictionary matches found:');
  for (final match in result.sequence) {
    if (match.pattern == 'dictionary') {
      print('  → Token: "${match.token}"');
      print('    Matched word: "${match.matched_word}"');
      if (match.levenshtein_distance != null) {
        print(
          '    Levenshtein match: "${match.levenshtein_distance_entry}" (distance: ${match.levenshtein_distance})',
        );
      }
    }
  }
  print('');

  // Example 3: Testing with obvious typos
  print('Example 3: Password with obvious typo');
  final passwords = ['password123', 'passwrod123', 'passw0rd123'];

  for (final password in passwords) {
    result = zxcvbn.evaluate(password);
    print('  "$password"');
    print('    Score: ${result.score}/4');

    final dictMatches = result.sequence
        .where(
          (m) => m.pattern == 'dictionary' && m.levenshtein_distance != null,
        )
        .toList();
    if (dictMatches.isNotEmpty) {
      for (final match in dictMatches) {
        print(
          '    Levenshtein: matched "${match.levenshtein_distance_entry}" (distance: ${match.levenshtein_distance})',
        );
      }
    } else {
      print('    No Levenshtein matches');
    }
  }
  print('');

  // Example 4: Full password Levenshtein (not substrings)
  print('Example 4: Levenshtein applies only to full passwords');

  // This full password has a distance from "password"
  result = zxcvbn.evaluate('passwrod');
  final hasFullMatch = result.sequence.any(
    (m) =>
        m.pattern == 'dictionary' &&
        m.i == 0 &&
        m.j == 'passwrod'.length - 1 &&
        m.levenshtein_distance != null,
  );
  print(
    '  "passwrod" (full password): ${hasFullMatch ? "Has Levenshtein match" : "No Levenshtein match"}',
  );

  // This password contains a typo but it's not the full password
  result = zxcvbn.evaluate('xpasswrodx');
  final hasSubMatch = result.sequence.any(
    (m) => m.token == 'passwrod' && m.levenshtein_distance != null,
  );
  print(
    '  "xpasswrodx" (typo in middle): ${hasSubMatch ? "Has Levenshtein match on substring" : "No Levenshtein match on substring"}',
  );
  print('');

  // Clean up
  matching.USE_LEVENSHTEIN_DISTANCE = false;
  matching.LEVENSHTEIN_THRESHOLD = 2;

  print('=== Demo Complete ===');
}
