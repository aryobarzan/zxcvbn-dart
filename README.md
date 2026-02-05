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

## Development

This project was created as a fork of DropBox's CoffeeScript Zxcvbn library for use in Dart. Note there is already an existing Dart implementation, [Xcvbnm](https://pub.dev/packages/xcvbnm). However, we found that Xcvbnm returned vastly different results compared to Zxcvbn official. Xcvbnm's readme also makes it clear the library is incomplete:

> Please note, that library did not port all functionality but is already used in production.

This project was started with the goals:

- Give exactly the same results for the same inputs as the CoffeeScript
- Port all tests from CoffeeScript
- Be as close to the original CoffeeScript as possible in order to aid implementing and debugging dart, as well as making it easier to bring upstream changes
- Hide the coffee-like implementation from users of this library, so from the outside it feels like Dart

As this is a close port of CoffeeScript, rather than a clean room implementation, the Dart code inside `src` is somewhat ugly and non-standard Dart in a lot of ways. However, keeping it close to CoffeeScript is seen as more important.

## Contributing

### Bugs

This library should give the exact same output for a password input as the official library. The official library can be tested [online](https://lowe.github.io/tryzxcvbn/). If this library gives a different result (`score`, or `guesses_log10`), please file a bug report, detailing the password input, user dictionaries (if used), and the expected result.

### API

While the internals of this library need to stay as close to the CoffeeScript as possible, we want this to be a nice library to use. Contributions that improve the API for users are welcome. The goal is to hide the internals as much as possible, giving a nice API from the outside.

### Upstream Changes

Zxcvbn hasn't been updated for several years, but that doesn't mean it won't ever see updates. We welcome contributions that bring over upstream changes - again, keeping the internal Dart code as close to the CoffeeScript as possible.

## Acknowledgements

- This project is a manual port of the official Zxcvbn CoffeeScript source code, and would not be possible without DropBox creating and open sourcing the library

- This project made use of Xcvbnm's source code to verify Dart ports, and a bit of Copy-Paste here and there to speed up porting. We thank the original authors of Xcvbnm.
