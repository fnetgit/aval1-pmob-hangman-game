import 'package:hangman_game/domain/entities/game_session.dart';
import 'package:hangman_game/domain/services/letter_normalizer.dart';

import '../enums/round_status.dart';

class GameRules {
  static Set<String> requiredLetters(String answer) {
    return answer
        .split('')
        .where(LetterNormalizer.isLetter)
        .map(LetterNormalizer.normalize)
        .toSet();
  }

  static RoundStatus statusOf(GameSession session) {
    if (session.errors >= session.maxErrors) {
      return RoundStatus.lost;
    }

    final letters = requiredLetters(session.currentEntry.answer);

    if (letters.isNotEmpty && session.guessedLetters.containsAll(letters)) {
      return RoundStatus.won;
    }

    return RoundStatus.playing;
  }

  static String visibleAnswer(GameSession session) {
    final answer = session.currentEntry.answer;

    if (statusOf(session) != RoundStatus.playing) {
      return answer;
    }

    return answer.split('').map((charater) {
      if (!LetterNormalizer.isLetter(charater)) {
        return charater;
      }

      return '-';
    }).join();
  }
}
