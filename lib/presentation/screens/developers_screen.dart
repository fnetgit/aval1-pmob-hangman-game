import 'package:flutter/material.dart';

class DevelopersScreen extends StatelessWidget {
  const DevelopersScreen({super.key});

  static const _members = [
    'Ruan Pedro de Araujo Anjos',
    'Francisco Alves Ribeiro Neto',
    'Fabrício Fontenele Vieira',
    'Willamy Josué dos Santos Serejo',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Equipe')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Desenvolvido por', style: textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  'Programação para Dispositivos Móveis · UESPI',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Card(
                  child: Column(
                    children: [
                      for (final member in _members)
                        ListTile(
                          leading: CircleAvatar(child: Text(member[0])),
                          title: Text(member),
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
