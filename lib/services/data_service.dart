import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/bani.dart';

class DataService {
  static List<Bani>? _cache;

  static Future<List<Bani>> loadAllBanis() async {
    if (_cache != null) {
      return _cache!;
    }

    const files = [
      'assets/data/CountryData1.json',
      'assets/data/CountryData2.json',
      'assets/data/CountryData3.json',
      'assets/data/CountryData4.json',
      'assets/data/CountryData5.json',
      'assets/data/CountryData6.json',
    ];

    final List<Bani> allBanis = [];

    for (final file in files) {
      final jsonString = await rootBundle.loadString(file);

      final List<dynamic> jsonData = jsonDecode(jsonString);

      allBanis.addAll(
        jsonData.map((e) => Bani.fromJson(e)),
      );
    }

    _cache = List.unmodifiable(allBanis);

    return _cache!;
  }
}