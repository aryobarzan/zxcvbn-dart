class PasswordMatch {
  // Core required fields - always set for every match
  final String pattern;
  final int i;
  final int j;
  final String token;

  // Calculated fields - set during scoring
  double? guesses;
  double? guesses_log10;

  // Optional fields - vary by pattern type
  String? matched_word;
  int? rank;
  String? dictionary_name;
  bool? reversed;
  bool? l33t;
  int? base_guesses;
  int? repeat_count;
  bool? ascending;
  String? regex_name;
  RegExpMatch? regex_match;
  int? year;
  int? month;
  int? day;
  String? separator;
  String? graph;
  int? turns;
  int? shifted_count;
  int? uppercase_variations;
  int? l33t_variations;
  Map? sub;
  String? base_token;
  List<PasswordMatch>? base_matches;
  bool? has_full_year;
  String? sub_display;
  String? sequence_name;
  int? sequence_space;
  int? levenshtein_distance;
  String? levenshtein_distance_entry;

  PasswordMatch({
    required this.pattern,
    required this.i,
    required this.j,
    required this.token,
    this.matched_word,
    this.rank,
    this.dictionary_name,
    this.reversed,
    this.l33t,
    this.guesses,
    this.guesses_log10,
    this.base_guesses,
    this.repeat_count,
    this.ascending,
    this.regex_name,
    this.regex_match,
    this.year,
    this.month,
    this.day,
    this.separator,
    this.graph,
    this.turns,
    this.shifted_count,
    this.uppercase_variations,
    this.l33t_variations,
    this.sub,
    this.base_token,
    this.base_matches,
    this.has_full_year,
    this.sub_display,
    this.sequence_name,
    this.sequence_space,
    this.levenshtein_distance,
    this.levenshtein_distance_entry,
  });

  /// The javascript version uses a mix of array index access and dot notation
  /// Dart doesn't support that on classes, so we we are overriding operator[]
  /// to fake it
  dynamic operator [](String arg) {
    switch (arg) {
      case 'pattern':
        return pattern;
      case 'i':
        return i;
      case 'j':
        return j;
      case 'token':
        return token;
      case 'matched_word':
        return matched_word;
      case 'rank':
        return rank;
      case 'dictionary_name':
        return dictionary_name;
      case 'reversed':
        return reversed;
      case 'l33t':
        return l33t;
      case 'guesses':
        return guesses;
      case 'guesses_log10':
        return guesses_log10;
      case 'base_guesses':
        return base_guesses;
      case 'repeat_count':
        return repeat_count;
      case 'ascending':
        return ascending;
      case 'regex_name':
        return regex_name;
      case 'regex_match':
        return regex_match;
      case 'year':
        return year;
      case 'month':
        return month;
      case 'day':
        return day;
      case 'separator':
        return separator;
      case 'graph':
        return graph;
      case 'turns':
        return turns;
      case 'shifted_count':
        return shifted_count;
      case 'uppercase_variations':
        return uppercase_variations;
      case 'l33t_variations':
        return l33t_variations;
      case 'sub':
        return sub;
      case 'base_token':
        return base_token;
      case 'base_matches':
        return base_matches;
      case 'has_full_year':
        return has_full_year;
      case 'sub_display':
        return sub_display;
      case 'sequence_name':
        return sequence_name;
      case 'sequence_space':
        return sequence_space;
      case 'levenshtein_distance':
        return levenshtein_distance;
      case 'levenshtein_distance_entry':
        return levenshtein_distance_entry;
    }
  }
}
