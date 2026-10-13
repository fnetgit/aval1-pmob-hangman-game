import 'package:flutter/material.dart';

import '../controllers/game_instance.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  String _percentage(double value) => '${value.toStringAsFixed(1)}%';

  @override
  Widget build(BuildContext context) {
    final stats = gameNotifier.stats;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Estatísticas')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Estatísticas da sessão', style: textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  stats.totalRounds == 0
                      ? 'Nenhuma rodada concluída ainda.'
                      : 'Os dados são zerados ao fechar o aplicativo.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Card(
                  child: Column(
                    children: [
                      _StatTile(
                        icon: Icons.sports_esports,
                        label: 'Rodadas realizadas',
                        value: '${stats.totalRounds}',
                      ),
                      _StatTile(
                        icon: Icons.emoji_events,
                        label: 'Vitórias',
                        value: '${stats.wins} (${_percentage(stats.winPercentage)})',
                      ),
                      _StatTile(
                        icon: Icons.sentiment_dissatisfied,
                        label: 'Derrotas',
                        value: '${stats.losses} (${_percentage(stats.lossPercentage)})',
                      ),
                      _StatTile(
                        icon: Icons.close,
                        label: 'Erros cometidos',
                        value: '${stats.totalErrors}',
                      ),
                      _StatTile(
                        icon: Icons.lightbulb,
                        label: 'Dicas utilizadas',
                        value: '${stats.hintsUsed}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: Text(value, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
