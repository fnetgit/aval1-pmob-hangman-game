import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/services/game_rules.dart';
import '../../domain/services/letter_normalizer.dart';
import '../controllers/game_instance.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: gameNotifier,
      builder: (context, child) {
        final session = gameNotifier.session;

        final answer = session?.currentEntry.answer ?? 'QUATI SUL-AMERICANO';

        final guessedLetters = session?.guessedLetters ?? const {'A', 'I', 'O', 'Z'};

        return Scaffold(
          appBar: AppBar(
            title: const Text('Jogo da Forca'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _AnswerView(
                  answer: answer,
                  guessedLetters: guessedLetters,
                ),
                const SizedBox(height: 32),
                _Keyboard(
                  guessedLetters: guessedLetters,
                  requiredLetters: GameRules.requiredLetters(answer),
                  onLetterPressed: (letter) {
                    gameNotifier.guessLetter(letter);
                  },
                ),
              ],
            ),
          ),
        );
      },
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

class _Keyboard extends StatelessWidget {
  const _Keyboard({
    required this.guessedLetters,
    required this.requiredLetters,
    required this.onLetterPressed,
  });

  final Set<String> guessedLetters;
  final Set<String> requiredLetters;
  final ValueChanged<String> onLetterPressed;

  static const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final letter in alphabet.split(''))
          _LetterButton(
            letter: letter,
            state: _stateFor(letter),
            onPressed: onLetterPressed,
          ),
      ],
    );
  }

  LetterState _stateFor(String letter) {
    if (!guessedLetters.contains(letter)) {
      return LetterState.available;
    }

    if (requiredLetters.contains(letter)) {
      return LetterState.correct;
    }

    return LetterState.wrong;
  }
}

class _LetterButton extends StatelessWidget {
  const _LetterButton({
    required this.letter,
    required this.state,
    required this.onPressed,
  });

  final String letter;
  final LetterState state;
  final ValueChanged<String> onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: AppTheme.letterButton(state),
      onPressed: state == LetterState.available ? () => onPressed(letter) : null,
      child: Text(letter),
    );
  }
}
