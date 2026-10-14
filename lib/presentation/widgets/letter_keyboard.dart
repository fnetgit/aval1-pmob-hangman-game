import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class LetterKeyboard extends StatelessWidget {
  const LetterKeyboard({
    super.key,
    required this.guessedLetters,
    required this.requiredLetters,
    required this.isPlaying,
    required this.onLetterPressed,
  });

  static const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  final Set<String> guessedLetters;
  final Set<String> requiredLetters;
  final bool isPlaying;
  final ValueChanged<String> onLetterPressed;

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
            isPlaying: isPlaying,
            onPressed: onLetterPressed,
          ),
      ],
    );
  }

  LetterState _stateFor(String letter) {
    if (!guessedLetters.contains(letter)) {
      return isPlaying ? LetterState.available : LetterState.disabled;
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
    required this.isPlaying,
    required this.onPressed,
  });

  final String letter;
  final LetterState state;
  final bool isPlaying;
  final ValueChanged<String> onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: AppTheme.letterButton(state),
      onPressed: isPlaying && state == LetterState.available ? () => onPressed(letter) : null,
      child: Text(letter),
    );
  }
}
