import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/answer_entry.dart';
import '../../domain/enums/answer_category.dart';
import '../../domain/enums/difficulty.dart';
import '../../domain/repositories/answer_repository.dart';
import '../models/answer_entry_model.dart';

class AnswerRepositoryImpl implements AnswerRepository {
  List<AnswerEntry> _entries = [];
  final Random _random = Random();

  @override
  Future<void> loadEntries() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/hangman.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      if (jsonData.containsKey('entries')) {
        final List<dynamic> entriesList = jsonData['entries'];
        _entries = entriesList.map((entryJson) {
          return AnswerEntryModel.fromJson(entryJson as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('JSON file does not contain "entries" key');
      }
    } catch (e) {
      debugPrint('Error loading answer entries: $e');
      _entries = [];
    }
  }

  @override
  List<AnswerEntry> filterEntries({
    AnswerCategory? category,
    Difficulty? difficulty,
  }) {
    return _entries.where((entry) {
      final matchesCategory = category == null || entry.category == category;
      final matchesDifficulty = difficulty == null || entry.difficulty == difficulty;
      return matchesCategory && matchesDifficulty;
    }).toList();
  }

  @override
  AnswerEntry? getRandomEntry({
    AnswerCategory? category,
    Difficulty? difficulty,
    Set<String> excludeAnswers = const {},
  }) {
    final filtered = filterEntries(
      category: category,
      difficulty: difficulty,
    ).where((entry) => !excludeAnswers.contains(entry.answer)).toList();

    if (filtered.isEmpty) {
      return null;
    }

    final randomIndex = _random.nextInt(filtered.length);
    return filtered[randomIndex];
  }
}
