import 'package:flutter/material.dart';

import '../../core/routing/app_routes.dart';
import '../../domain/enums/answer_category.dart';
import '../../domain/enums/difficulty.dart';
import '../../domain/enums/round_status.dart';
import '../../domain/enums/start_round_result.dart';
import '../controllers/game_instance.dart';
import '../extensions/answer_category_ui_text.dart';
import '../extensions/difficulty_ui_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AnswerCategory? _category;
  Difficulty? _difficulty;

  bool get _canStart => _category != null && _difficulty != null;

  void _openGame() {
    Navigator.pushNamed(context, AppRoutes.game);
  }

  void _startRound() {
    if (!_canStart) {
      return;
    }

    final result = gameNotifier.startRound(
      category: _category!,
      difficulty: _difficulty!,
    );

    switch (result) {
      case StartRoundResult.started:
        _openGame();
        return;

      case StartRoundResult.roundInProgress:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Existe uma rodada em andamento.'),
          ),
        );
        return;

      case StartRoundResult.noAnswersAvailable:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Não há respostas disponíveis para esta combinação, ou todas já '
              'foram usadas nesta sessão. Escolha outra categoria ou nível.',
            ),
          ),
        );
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Forca'),
        actions: [
          IconButton(
            tooltip: 'Estatísticas da sessão',
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.stats),
          ),
          IconButton(
            tooltip: 'Equipe',
            icon: const Icon(Icons.groups),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.developers),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Configure a partida',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                _Field(
                  label: 'Categoria',
                  child: DropdownButton<AnswerCategory>(
                    isExpanded: true,
                    value: _category,
                    hint: const Text('Selecione uma categoria'),
                    items: [
                      for (final category in gameNotifier.availableCategories)
                        DropdownMenuItem(
                          value: category,
                          child: Text(category.toUIText()),
                        ),
                    ],
                    onChanged: (value) => setState(() => _category = value),
                  ),
                ),
                const SizedBox(height: 16),
                _Field(
                  label: 'Nível de dificuldade',
                  child: DropdownButton<Difficulty>(
                    isExpanded: true,
                    value: _difficulty,
                    hint: const Text('Selecione um nível'),
                    items: [
                      for (final difficulty in gameNotifier.availableDifficulties)
                        DropdownMenuItem(
                          value: difficulty,
                          child: Text(difficulty.toUIText()),
                        ),
                    ],
                    onChanged: (value) => setState(() => _difficulty = value),
                  ),
                ),
                const SizedBox(height: 24),
                _SelectionSummary(category: _category, difficulty: _difficulty),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: gameNotifier,
                  builder: (context, child) {
                    final isPlaying = gameNotifier.status == RoundStatus.playing;

                    return FilledButton(
                      onPressed: isPlaying ? _openGame : (_canStart ? _startRound : null),
                      child: Text(isPlaying ? 'Continuar rodada' : 'Iniciar rodada'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        child,
      ],
    );
  }
}

class _SelectionSummary extends StatelessWidget {
  const _SelectionSummary({required this.category, required this.difficulty});

  final AnswerCategory? category;
  final Difficulty? difficulty;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categoria: ${category?.toUIText() ?? 'não selecionada'}'),
            const SizedBox(height: 4),
            Text('Nível: ${difficulty?.toUIText() ?? 'não selecionado'}'),
          ],
        ),
      ),
    );
  }
}
