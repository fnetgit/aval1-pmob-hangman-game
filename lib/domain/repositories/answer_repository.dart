import '../entities/answer_entry.dart';
import '../enums/answer_category.dart';
import '../enums/difficulty.dart';

abstract class AnswerRepository {
  Future<void> loadEntries();

  List<AnswerEntry> filterEntries({
    AnswerCategory? category,
    Difficulty? difficulty,
  });

  AnswerEntry? getRandomEntry({
    AnswerCategory? category,
    Difficulty? difficulty,
    Set<String> excludeAnswers = const {},
  });
}
