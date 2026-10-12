import 'package:flutter/material.dart';

import 'data/repositories/answer_repository_impl.dart';
import 'presentation/controllers/game_instance.dart';
import 'presentation/controllers/game_notifier.dart';
import 'presentation/screens/game_screen.dart';

void main() {
  gameNotifier = GameNotifier(
    AnswerRepositoryImpl(),
  );

  runApp(
    const MaterialApp(
      home: GameScreen(),
    ),
  );
}
