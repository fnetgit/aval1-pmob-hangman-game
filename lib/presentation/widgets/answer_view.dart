import 'package:flutter/material.dart';

class AnswerView extends StatelessWidget {
  const AnswerView({super.key, required this.visibleAnswer});

  static const _wordSeparator = ' ';

  final String visibleAnswer;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 24,
      runSpacing: 12,
      children: [
        for (final word in visibleAnswer.split(_wordSeparator))
          if (word.isNotEmpty)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final character in word.split('')) _CharacterTile(character: character),
                ],
              ),
            ),
      ],
    );
  }
}

class _CharacterTile extends StatelessWidget {
  const _CharacterTile({required this.character});

  final String character;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 40,
      child: Center(
        child: Text(
          character,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
