import 'package:flutter/material.dart';

import '../../domain/enums/round_status.dart';
import '../../domain/enums/start_round_result.dart';
import '../../domain/services/game_rules.dart';
import '../controllers/game_instance.dart';
import '../extensions/answer_category_ui_text.dart';
import '../extensions/difficulty_ui_text.dart';
import '../widgets/answer_view.dart';
import '../widgets/letter_keyboard.dart';
import '../widgets/round_result_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    gameNotifier.addListener(_handleGameStatusChange);
  }

  @override
  void dispose() {
    gameNotifier.removeListener(_handleGameStatusChange);
    super.dispose();
  }

  void _handleGameStatusChange() {
    final status = gameNotifier.status;
    final isGameOver = status == RoundStatus.won || status == RoundStatus.lost;

    if (!_dialogShown && isGameOver) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showResultDialog();
        }
      });
    }
  }

  void _playAgain() {
    Navigator.of(context).pop();

    final session = gameNotifier.session;
    if (session == null) return;

    final result = gameNotifier.startRound(
      category: session.currentEntry.category,
      difficulty: session.currentEntry.difficulty,
    );

    if (result == StartRoundResult.started) {
      setState(() {
        _dialogShown = false;
      });
    } else if (result == StartRoundResult.noAnswersAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não há mais respostas disponíveis para esta categoria e dificuldade.',
          ),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void _backToHome() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void _showHintDialog() {
    final hint = gameNotifier.useHint();
    if (hint == null) return;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.lightbulb,
            color: Colors.amber,
            size: 40,
          ),
          title: const Text('Dica'),
          content: Text(
            hint,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Entendi'),
            ),
          ],
        );
      },
    );
  }

  void _showResultDialog() {
    final session = gameNotifier.session;
    final status = gameNotifier.status;
    if (session == null || status == null) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RoundResultDialog(
        session: session,
        isWon: status == RoundStatus.won,
        onPlayAgain: _playAgain,
        onBackToHome: _backToHome,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: gameNotifier,
      builder: (context, child) {
        final session = gameNotifier.session;
        final status = gameNotifier.status;

        final isPlaying = session != null && status == RoundStatus.playing;

        final errors = session?.errors ?? 0;
        final hangmanStage = (errors + 1).clamp(1, 7);

        final answer = session?.currentEntry.answer ?? '';
        final guessedLetters = session?.guessedLetters ?? const <String>{};

        return Scaffold(
          appBar: AppBar(
            title: const Text('Jogo da Forca'),
            actions: [
              IconButton(
                tooltip: 'Pedir dica',
                icon: Icon(
                  session?.isHintUsed ?? false ? Icons.lightbulb : Icons.lightbulb_outline,
                  color: session?.isHintUsed ?? false ? Colors.amber : null,
                ),
                onPressed: isPlaying ? _showHintDialog : null,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (session != null) ...[
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.category_outlined, size: 18),
                        label: Text(session.currentEntry.category.toUIText()),
                      ),
                      Chip(
                        avatar: const Icon(Icons.speed, size: 18),
                        label: Text(session.currentEntry.difficulty.toUIText()),
                      ),
                      Chip(
                        avatar: const Icon(Icons.heart_broken_outlined, size: 18),
                        label: Text('Erros: ${session.errors}/${session.maxErrors}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                Image.asset(
                  'assets/images/hangman/hang$hangmanStage.png',
                  height: 180,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                AnswerView(visibleAnswer: gameNotifier.visibleAnswer),
                const SizedBox(height: 32),
                LetterKeyboard(
                  guessedLetters: guessedLetters,
                  requiredLetters: GameRules.requiredLetters(answer),
                  isPlaying: isPlaying,
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
