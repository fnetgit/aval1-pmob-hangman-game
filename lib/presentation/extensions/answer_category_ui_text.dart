import '../../domain/enums/answer_category.dart';

extension AnswerCategoryUIText on AnswerCategory {
  static const _texts = {
    AnswerCategory.animals: 'Animais',
    AnswerCategory.humanBody: 'Corpo humano',
    AnswerCategory.sports: 'Esportes',
    AnswerCategory.technology: 'Tecnologia',
  };

  String toUIText() => _texts[this]!;
}
