# Zxcvbn-Dart

[![Build Status](https://travis-ci.org/careapp-inc/zxcvbn-dart.svg?branch=master)](https://travis-ci.org/careapp-inc/zxcvbn-dart)

[`zxcvbn`](https://github.com/dropbox/zxcvbn) is a password strength estimator inspired by password crackers, developed by DropBox. This project is a Dart port of the original CoffeeScript, for use in Flutter and other Dart projects.

## Usage

Zxcvbn accepts a password input and returns a score from 0-4, giving an indication of the password strength.

```dart
import 'package:zxcvbn/zxcvbn.dart';

void main() {
  final zxcvbn = Zxcvbn();

  final result = zxcvbn.evaluate('P@ssw0rd');

  print('Password: ${result.password}');
  print('Score: ${result.score}');
  print(result.feedback.warning);
  for (final suggestion in result.feedback.suggestions) {
    print(suggestion);
  }
}
```

The `Result` object includes lots more information about the password strength. This project has the same feature set as the Official Zxcvbn, so check out their [documentation](https://github.com/dropbox/zxcvbn#usage).

### Levenshtein Distance Matching

This library includes Levenshtein distance matching, a feature from the modern TypeScript rewrite [zxcvbn-ts](https://github.com/zxcvbn-ts/zxcvbn). This feature detects passwords that are similar to common dictionary words but contain typos.

For example, "alaphant" (a typo of "elephant") or "passwrod" (a typo of "password") will be detected as weak passwords even though they're not exact dictionary matches.

To enable Levenshtein distance matching:

```dart
import 'package:zxcvbn/zxcvbn.dart';
import 'package:zxcvbn/src/matching.dart' as matching;

void main() {
  // Enable Levenshtein distance matching
  matching.USE_LEVENSHTEIN_DISTANCE = true;
  matching.LEVENSHTEIN_THRESHOLD = 2; // Maximum edit distance (default: 2)

  final zxcvbn = Zxcvbn();
  final result = zxcvbn.evaluate('alaphant'); // Typo of "elephant"
  
  // Check if a match used Levenshtein distance
  for (final match in result.sequence) {
    if (match.levenshtein_distance != null) {
      print('Matched "${match.levenshtein_distance_entry}" with distance ${match.levenshtein_distance}');
    }
  }
}
```

**Configuration Options:**
- `USE_LEVENSHTEIN_DISTANCE`: Set to `true` to enable fuzzy matching (default: `false`)
- `LEVENSHTEIN_THRESHOLD`: Maximum number of character edits allowed (default: `2`)

**Notes:**
- Levenshtein matching only applies to the full password, not substrings, to avoid performance issues and false positives
- For short passwords, the threshold is automatically adjusted to `max(ceil(password.length / 4), 1)` to provide reasonable matching
- This feature slightly increases computation time but significantly improves password strength detection

## Acknowledgements

- This project is a manual port of the official Zxcvbn CoffeeScript source code, and would not be possible without DropBox creating and open sourcing the library

- This project made use of Xcvbnm's source code to verify Dart ports, and a bit of Copy-Paste here and there to speed up porting. We thank the original authors of Xcvbnm.
