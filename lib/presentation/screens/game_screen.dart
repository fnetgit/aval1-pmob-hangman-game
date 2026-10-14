import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/enums/round_status.dart';
import '../../domain/enums/start_round_result.dart';
import '../../domain/services/game_rules.dart';
import '../../domain/services/letter_normalizer.dart';
import '../controllers/game_instance.dart';
import '../extensions/answer_category_ui_text.dart';
import '../extensions/difficulty_ui_text.dart';

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

    final isWon = status == RoundStatus.won;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Erros cometidos:'),
                  Text(
                    '${session.errors} de ${session.maxErrors}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dica utilizada:'),
                  Text(
                    session.isHintUsed ? 'Sim' : 'Não',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _backToHome,
              child: const Text('Voltar ao Início'),
            ),
            FilledButton(
              onPressed: _playAgain,
              child: const Text('Jogar Novamente'),
            ),
          ],
        );
      },
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
                _AnswerView(
                  answer: answer,
                  guessedLetters: guessedLetters,
                  isGameOver: !isPlaying && session != null,
                ),
                const SizedBox(height: 32),
                _Keyboard(
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

class _AnswerView extends StatelessWidget {
  const _AnswerView({
    required this.answer,
    required this.guessedLetters,
    required this.isGameOver,
  });

  static const _wordSeparator = ' ';

  final String answer;
  final Set<String> guessedLetters;
  final bool isGameOver;

  @override
  Widget build(BuildContext context) {
    // Cada palavra é um Row indivisível: o Wrap só quebra linha entre palavras.
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 24,
      runSpacing: 12,
      children: [
        for (final word in answer.split(_wordSeparator))
          if (word.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final character in word.split(''))
                  _CharacterTile(
                    character: character,
                    isGuessed:
                        isGameOver ||
                        guessedLetters.contains(
                          LetterNormalizer.normalize(character),
                        ),
                  ),
              ],
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
    if (!LetterNormalizer.isLetter(character)) {
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
    required this.isPlaying,
    required this.onLetterPressed,
  });

  final Set<String> guessedLetters;
  final Set<String> requiredLetters;
  final bool isPlaying;
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
