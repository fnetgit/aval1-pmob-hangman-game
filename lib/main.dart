import 'package:flutter/material.dart';

import 'core/routing/app_routes.dart';
import 'data/repositories/answer_repository_impl.dart';
import 'presentation/controllers/game_instance.dart';
import 'presentation/controllers/game_notifier.dart';
import 'presentation/screens/game_screen.dart';
import 'presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = AnswerRepositoryImpl();
  await repository.loadEntries();

  gameNotifier = GameNotifier(repository);

  runApp(
    MaterialApp(
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.game: (_) => const GameScreen(),
      },
    ),
  );
}
