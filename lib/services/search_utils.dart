import 'roman_aliases.dart';

class SearchUtils {
  static final RegExp _multiSpace = RegExp(r'\s+');
  static final RegExp _romanRegex = RegExp(r'^[a-zA-Z0-9 ]+$');
  static final RegExp _romanCleaner = RegExp(r'[^a-z0-9 ]');

  static String normalizeHindi(String text) {
    return text
        .toLowerCase()
        .replaceAll('\n', ' ')
        .replaceAll('।', ' ')
        .replaceAll('॥', ' ')
        .replaceAll(',', ' ')
        .replaceAll('.', ' ')
        .replaceAll('?', ' ')
        .replaceAll('!', ' ')
        .replaceAll(':', ' ')
        .replaceAll(';', ' ')
        .replaceAll('(', ' ')
        .replaceAll(')', ' ')
        .replaceAll('"', ' ')
        .replaceAll("'", ' ')
        .replaceAll(_multiSpace, ' ')
        .trim();
  }

  static String normalizeRoman(String text) {
    return text
        .toLowerCase()
        .replaceAll('\n', ' ')
        .replaceAll(_romanCleaner, ' ')
        .replaceAll(_multiSpace, ' ')
        .trim();
  }

  static bool isRoman(String text) {
    return _romanRegex.hasMatch(text.trim());
  }

  static String applyAliases(String query) {
    query = normalizeRoman(query);

    if (query.isEmpty) return query;

    final words = query.split(' ');

    for (int i = 0; i < words.length; i++) {
      final alias = romanAliases[words[i]];
      if (alias != null) {
        words[i] = alias;
      }
    }

    return normalizeHindi(words.join(' '));
  }

  static int calculateScore(
    String text,
    String query,
  ) {
    if (query.trim().isEmpty) return 0;

    if (isRoman(query)) {
      text = normalizeRoman(text);
      query = normalizeRoman(query);
    } else {
      text = normalizeHindi(text);
      query = normalizeHindi(query);
    }

    if (text.isEmpty || query.isEmpty) return 0;

    int score = 0;

    if (text == query) {
      return 100000;
    }

    if (text.startsWith(query)) {
      score += 50000;
    }

    if (text.contains(query)) {
      score += 30000;
    }

    final words = query.split(' ');

    bool allPresent = true;

    for (final word in words) {
      if (word.isEmpty) continue;

      if (text.contains(word)) {
        score += 500;
      } else {
        allPresent = false;
      }
    }

    if (allPresent) {
      score += 10000;
    }

    return score;
  }
}