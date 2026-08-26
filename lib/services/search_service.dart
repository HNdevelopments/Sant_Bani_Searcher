import '../models/bani.dart';
import 'search_utils.dart';

class SearchService {
  static List<Bani> search(
    String query,
    List<Bani> allBanis,
  ) {
    query = query.trim();

    if (query.isEmpty) {
      return allBanis;
    }

    final bool romanSearch = SearchUtils.isRoman(query);

    final String normalizedQuery = romanSearch
        ? SearchUtils.normalizeRoman(query)
        : SearchUtils.normalizeHindi(query);

    final results = <Map<String, dynamic>>[];

    for (final bani in allBanis) {
      final int score;

      if (romanSearch) {
        score = SearchUtils.calculateScore(
          bani.roman,
          normalizedQuery,
        );
      } else {
        score = SearchUtils.calculateScore(
          bani.bani,
          normalizedQuery,
        );
      }

      if (score > 0) {
        results.add({
          "bani": bani,
          "score": score,
        });
      }
    }

    results.sort(
      (a, b) =>
          (b["score"] as int).compareTo(a["score"] as int),
    );

    return results
        .map((e) => e["bani"] as Bani)
        .toList(growable: false);
  }

  static List<String> suggestions(
    String query,
    List<Bani> allBanis,
  ) {
    query = query.trim();

    if (query.isEmpty) {
      return [];
    }

    final bool romanSearch = SearchUtils.isRoman(query);

    final normalizedQuery = romanSearch
        ? SearchUtils.normalizeRoman(query)
        : SearchUtils.normalizeHindi(query);

    final suggestions = <String>{};

    for (final bani in allBanis) {
      final text = romanSearch
          ? SearchUtils.normalizeRoman(bani.roman)
          : SearchUtils.normalizeHindi(bani.bani);

      if (text.startsWith(normalizedQuery)) {
        suggestions.add(
          romanSearch ? bani.roman : bani.bani,
        );
      }

      if (suggestions.length >= 10) {
        break;
      }
    }

    return suggestions.toList(growable: false);
  }
}