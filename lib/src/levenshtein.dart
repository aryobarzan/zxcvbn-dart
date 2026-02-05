import 'dart:math' as Math;

/// Results from finding a Levenshtein distance match in a dictionary
class LevenshteinResult {
  final int levenshteinDistance;
  final String levenshteinDistanceEntry;

  LevenshteinResult({
    required this.levenshteinDistance,
    required this.levenshteinDistanceEntry,
  });
}

/// Calculate Levenshtein distance between two strings
/// This is the minimum number of single-character edits (insertions, deletions, or substitutions)
/// required to change one string into the other
int _calculateDistance(String s1, String s2) {
  if (s1 == s2) return 0;
  if (s1.isEmpty) return s2.length;
  if (s2.isEmpty) return s1.length;

  final len1 = s1.length;
  final len2 = s2.length;

  // Create a matrix to store distances
  List<List<int>> matrix = List.generate(
    len1 + 1,
    (i) => List.filled(len2 + 1, 0),
  );

  // Initialize first column and row
  for (int i = 0; i <= len1; i++) {
    matrix[i][0] = i;
  }
  for (int j = 0; j <= len2; j++) {
    matrix[0][j] = j;
  }

  // Calculate distances
  for (int i = 1; i <= len1; i++) {
    for (int j = 1; j <= len2; j++) {
      final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
      matrix[i][j] = Math.min(
        Math.min(
          matrix[i - 1][j] + 1, // deletion
          matrix[i][j - 1] + 1, // insertion
        ),
        matrix[i - 1][j - 1] + cost, // substitution
      );
    }
  }

  return matrix[len1][len2];
}

/// Determine the appropriate threshold to use based on password and entry lengths
int _getUsedThreshold(String password, String entry, int threshold) {
  final isPasswordTooShort = password.length <= entry.length;
  final isThresholdLongerThanPassword = password.length <= threshold;
  final shouldUsePasswordLength =
      isPasswordTooShort || isThresholdLongerThanPassword;

  // If password is too small, use the password length divided by 4 while the threshold needs to be at least 1
  return shouldUsePasswordLength
      ? Math.max((password.length / 4).ceil(), 1)
      : threshold;
}

/// Find a dictionary entry that matches the password within the Levenshtein distance threshold
/// Returns null if no match is found
LevenshteinResult? findLevenshteinDistance(
  String password,
  Map<String, int> rankedDictionary,
  int threshold,
) {
  int foundDistance = 0;

  final found = rankedDictionary.keys.firstWhere((entry) {
    final usedThreshold = _getUsedThreshold(password, entry, threshold);

    // Quick check: if the length difference is too large, skip calculation
    if ((password.length - entry.length).abs() > usedThreshold) {
      return false;
    }

    final foundEntryDistance = _calculateDistance(password, entry);
    final isInThreshold = foundEntryDistance <= usedThreshold;

    if (isInThreshold) {
      foundDistance = foundEntryDistance;
    }

    return isInThreshold;
  }, orElse: () => '');

  if (found.isNotEmpty) {
    return LevenshteinResult(
      levenshteinDistance: foundDistance,
      levenshteinDistanceEntry: found,
    );
  }

  return null;
}
