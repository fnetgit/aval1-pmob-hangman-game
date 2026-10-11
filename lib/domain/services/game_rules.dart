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

  static GameSession applyGuess(GameSession session, String guess) {
    if (statusOf(session) != RoundStatus.playing) {
      return session;
    }

    if (!LetterNormalizer.isLetter(guess)) {
      return session;
    }

    final letter = LetterNormalizer.normalize(guess);

    if (session.guessedLetters.contains(letter)) {
      return session;
    }

    final isCorrect = requiredLetters(
      session.currentEntry.answer,
    ).contains(letter);

    final updatedLetters = Set<String>.unmodifiable({
      ...session.guessedLetters,
      letter,
    });

    return session.copyWith(
      guessedLetters: updatedLetters,
      errors: session.errors + (isCorrect ? 0 : 1),
    );
  }
}
