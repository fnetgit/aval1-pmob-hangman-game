import 'package:flutter/foundation.dart';

import '../../domain/enums/answer_category.dart';
import '../../domain/enums/difficulty.dart';
import '../../domain/enums/round_status.dart';
import '../../domain/services/game_rules.dart';
import '../../domain/entities/game_session.dart';
import '../../domain/repositories/answer_repository.dart';
import '../../domain/entities/session_stats.dart';

class GameNotifier extends ChangeNotifier {
  final AnswerRepository _repository;
  final Set<String> _usedAnswers = {};

  SessionStats _stats = const SessionStats();
  GameSession? _session;

  GameNotifier(this._repository);

  SessionStats get stats => _stats;
  GameSession? get session => _session;

  List<AnswerCategory> get availableCategories => AnswerCategory.values
      .where((category) => _repository.filterEntries(category: category).isNotEmpty)
      .toList();

  RoundStatus? get status {
    final currentSession = _session;

    return currentSession == null ? null : GameRules.statusOf(currentSession);
  }

  String get visibleAnswer {
    final currentSession = _session;

    return currentSession == null ? '' : GameRules.visibleAnswer(currentSession);
  }

  bool startRound({
    required AnswerCategory category,
    required Difficulty difficulty,
  }) {
    if (status == RoundStatus.playing) return false;

    final entry = _repository.getRandomEntry(
      category: category,
      difficulty: difficulty,
      excludeAnswers: Set<String>.unmodifiable(_usedAnswers),
    );

    if (entry == null) return false;

    _usedAnswers.add(entry.answer);

    _session = GameSession(
      currentEntry: entry,
      usedAnswers: Set<String>.unmodifiable(_usedAnswers),
    );

    notifyListeners();
    return true;
  }

  void guessLetter(String guess) {
    final currentSession = _session;

    if (currentSession == null) return;

    final updatedSession = GameRules.applyGuess(currentSession, guess);

    if (identical(currentSession, updatedSession)) return;

    final previousStatus = GameRules.statusOf(currentSession);
    final updatedStatus = GameRules.statusOf(updatedSession);

    _session = updatedSession;

    if (previousStatus == RoundStatus.playing && updatedStatus != RoundStatus.playing) {
      _stats = _stats.recordRound(
        won: updatedStatus == RoundStatus.won,
        errors: updatedSession.errors,
      );
    }
    notifyListeners();
  }

  String? useHint() {
    final currentSession = _session;

    if (currentSession == null) return null;

    final hints = currentSession.currentEntry.hints;

    if (hints.isEmpty) return null;

    if (currentSession.isHintUsed) return hints.first;

    if (GameRules.statusOf(currentSession) != RoundStatus.playing) return null;

    _session = currentSession.copyWith(isHintUsed: true);
    _stats = _stats.recordHint();

    notifyListeners();
    return hints.first;
  }
}
