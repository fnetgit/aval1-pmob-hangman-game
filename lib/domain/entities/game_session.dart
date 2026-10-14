import 'answer_entry.dart';

class GameSession {
  final AnswerEntry currentEntry;
  final Set<String> guessedLetters;
  final int errors;
  final int maxErrors;
  final bool isHintUsed;

  const GameSession({
    required this.currentEntry,
    this.guessedLetters = const {},
    this.errors = 0,
    this.maxErrors = 6,
    this.isHintUsed = false,
  });

  GameSession copyWith({
    AnswerEntry? currentEntry,
    Set<String>? guessedLetters,
    int? errors,
    int? maxErrors,
    bool? isHintUsed,
  }) {
    return GameSession(
      currentEntry: currentEntry ?? this.currentEntry,
      guessedLetters: guessedLetters ?? this.guessedLetters,
      errors: errors ?? this.errors,
      maxErrors: maxErrors ?? this.maxErrors,
      isHintUsed: isHintUsed ?? this.isHintUsed,
    );
  }
}
