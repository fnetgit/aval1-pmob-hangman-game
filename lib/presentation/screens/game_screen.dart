import 'package:flutter/material.dart';

import '../../domain/services/letter_normalizer.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const answer = 'QUATI SUL-AMERICANO';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Forca'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _AnswerView(
            answer: answer,
            guessedLetters: const {'A', 'I', 'O'},
          ),
        ),
      ),
    );
  }
}

class _AnswerView extends StatelessWidget {
  const _AnswerView({
    required this.answer,
    required this.guessedLetters,
  });

  final String answer;
  final Set<String> guessedLetters;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 12,
      children: [
        for (final character in answer.split(''))
          _CharacterTile(
            character: character,
            isGuessed: guessedLetters.contains(
              LetterNormalizer.normalize(character),
            ),
          ),
      ],
    );
  }
}

class _CharacterTile extends StatelessWidget {
  const _CharacterTile({
    required this.character,
    required this.isGuessed,
  });

  final String character;
  final bool isGuessed;

  @override
  Widget build(BuildContext context) {
    if (character == ' ') {
      return const SizedBox(
        width: 20,
        height: 40,
      );
    }

    if (character == '-') {
      return const SizedBox(
        width: 28,
        height: 40,
        child: Center(
          child: Text('-'),
        ),
      );
    }

    return SizedBox(
      width: 28,
      height: 40,
      child: Center(
        child: Text(
          isGuessed ? character : '_',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
