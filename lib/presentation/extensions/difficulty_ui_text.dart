import '../../domain/enums/difficulty.dart';

extension DifficultyUIText on Difficulty {
  static const _texts = {
    Difficulty.easy: 'Fácil',
    Difficulty.medium: 'Médio',
    Difficulty.hard: 'Difícil',
  };

  String toUIText() => _texts[this]!;
}
