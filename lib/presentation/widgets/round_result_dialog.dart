import 'package:flutter/material.dart';

import '../../domain/entities/game_session.dart';

class RoundResultDialog extends StatelessWidget {
  const RoundResultDialog({
    super.key,
    required this.session,
    required this.isWon,
    required this.onPlayAgain,
    required this.onBackToHome,
  });

  final GameSession session;
  final bool isWon;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToHome;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        isWon ? Icons.emoji_events : Icons.sentiment_very_dissatisfied,
        size: 56,
        color: isWon ? Colors.green : Colors.red,
      ),
      title: Text(
        isWon ? 'Vitória!' : 'Fim de Jogo',
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isWon ? 'Parabéns! Você descobriu a resposta:' : 'A resposta correta era:',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              session.currentEntry.answer,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _ResultRow(
            label: 'Erros cometidos:',
            value: '${session.errors} de ${session.maxErrors}',
          ),
          const SizedBox(height: 8),
          _ResultRow(
            label: 'Dica utilizada:',
            value: session.isHintUsed ? 'Sim' : 'Não',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onBackToHome,
          child: const Text('Voltar ao Início'),
        ),
        FilledButton(
          onPressed: onPlayAgain,
          child: const Text('Jogar Novamente'),
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
