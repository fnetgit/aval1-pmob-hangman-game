import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../../domain/entities/answer_entry.dart';
import '../../domain/enums/answer_category.dart';
import '../../domain/enums/difficulty.dart';
import '../../domain/repositories/answer_repository.dart';
import '../models/answer_entry_model.dart';

class AnswerRepositoryImpl implements AnswerRepository {
  static const _entriesAssetPath = 'assets/data/hangman.json';

  List<AnswerEntry> _entries = [];
  final Random _random = Random();

  @override
  Future<void> loadEntries() async {
    final jsonString = await rootBundle.loadString(_entriesAssetPath);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final entriesJson = jsonData['entries'] as List<dynamic>;

    _entries = entriesJson
        .map((entry) => AnswerEntryModel.fromJson(entry as Map<String, dynamic>))
        .toList();
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
