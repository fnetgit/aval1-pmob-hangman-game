import '../../domain/entities/answer_entry.dart';
import '../../domain/enums/answer_category.dart';
import '../../domain/enums/difficulty.dart';

class AnswerEntryModel extends AnswerEntry {
  const AnswerEntryModel({
    required super.answer,
    required super.category,
    required super.difficulty,
    required super.hints,
  });

  factory AnswerEntryModel.fromJson(Map<String, dynamic> json) {
    return AnswerEntryModel(
      answer: json['answer'] as String,
      category: AnswerCategory.values.byName(json['category'] as String),
      difficulty: Difficulty.values.byName(json['difficulty'] as String),
      hints: (json['hints'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }
}
