import 'package:flutter/foundation.dart';

import '../../domain/enums/answer_category.dart';
import '../../domain/enums/difficulty.dart';
import '../../domain/enums/round_status.dart';
import '../../domain/services/game_rules.dart';
import '../../domain/entities/game_session.dart';
import '../../domain/repositories/answer_repository.dart';

class GameNotifier extends ChangeNotifier {
  final AnswerRepository _repository;
  final Set<String> _usedAnswers = {};

  GameSession? _session;

  GameNotifier({required this._repository});

  GameSession? get session => _session;

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
    if (status == RoundStatus.playing) {
      return false;
    }

    final entry = _repository.getRandomEntry(
      category: category,
      difficulty: difficulty,
      excludeAnswers: Set<String>.unmodifiable(_usedAnswers),
    );

    if (entry == null) {
      return false;
    }

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

    if (currentSession == null) {
      return;
    }

    final updateSession = GameRules.applyGuess(
      currentSession,
      guess,
    );

    if (identical(currentSession, updateSession)) {
      return;
    }

    _session = updateSession;
    notifyListeners();
  }
}
