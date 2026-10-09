import 'answer_entry.dart';

class GameSession {
  final AnswerEntry currentEntry;
  final Set<String> guessedLetters;
  final int errors;
  final int maxErrors;
  final bool isHintUsed;
  final Set<String> usedAnswers;

  const GameSession({
    required this.currentEntry,
    this.guessedLetters = const {},
    this.errors = 0,
    this.maxErrors = 6,
    this.isHintUsed = false,
    this.usedAnswers = const {},
  });

  GameSession copyWith({
    AnswerEntry? currentEntry,
    Set<String>? guessedLetters,
    int? errors,
    int? maxErrors,
    bool? isHintUsed,
    Set<String>? usedAnswers,
  }) {
    return GameSession(
      currentEntry: currentEntry ?? this.currentEntry,
      guessedLetters: guessedLetters ?? this.guessedLetters,
      errors: errors ?? this.errors,
      maxErrors: maxErrors ?? this.maxErrors,
      isHintUsed: isHintUsed ?? this.isHintUsed,
      usedAnswers: usedAnswers ?? this.usedAnswers,
    );
  }
}
