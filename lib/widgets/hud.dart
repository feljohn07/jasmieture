import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // 1. Import this
import 'package:provider/provider.dart';

import '/game/dino_run.dart';
import '/game/audio_manager.dart';
import '/models/player_data.dart';
import '/widgets/pause_menu.dart';

// This represents the head up display in game.
// It consists of, current score, high score,
// a pause button and number of remaining lives.
class Hud extends StatelessWidget {
  // An unique identified for this overlay.
  static const id = 'Hud';

  // Reference to parent game.
  final DinoRun game;

  const Hud(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: game.quizData,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. LEFT SECTION (Info) ---
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'level: ${context.watch<QuizData>().level} chapter: ${context.watch<QuizData>().chapter}',
                  style: const TextStyle(color: Colors.white),
                ),
                Selector<QuizData, int>(
                  selector: (_, quizData) => quizData.score,
                  builder: (_, score, __) {
                    return Row(
                      children: [
                        Icon(Icons.star, color: Colors.amberAccent),
                        Text(
                          '$score',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        )
                        // Optional: Small pop when score changes
                            .animate(key: ValueKey(score))
                            .scale(duration: 200.ms, curve: Curves.easeOutBack),
                      ],
                    );
                  },
                ),
              ],
            )
                .animate() // Animate Left Section Down
                .slideY(begin: -1, end: 0, duration: 500.ms, curve: Curves.easeOutBack)
                .fade(duration: 500.ms),

            // --- 2. MIDDLE SECTION (Pause) ---
            TextButton(
              onPressed: () {
                game.overlays.remove(Hud.id);
                game.overlays.add(PauseMenu.id);
                game.pauseEngine();
                AudioManager.instance.pauseBgm();
              },
              child: const Icon(Icons.pause, color: Colors.white),
            )
                .animate(delay: 100.ms) // Animate Middle Section Down (Delayed)
                .slideY(begin: -2, end: 0, duration: 500.ms, curve: Curves.easeOutBack)
                .fade(duration: 500.ms),

            // --- 3. RIGHT SECTION (Lives) ---
            Selector<QuizData, int>(
              selector: (_, quizData) => quizData.lives,
              builder: (_, lives, __) {
                return Row(
                  children: List.generate(3, (index) {
                    if (index < lives) {
                      return const Icon(Icons.favorite, color: Colors.red)
                          .animate(key: ValueKey('life_$index')) // Pulse on load
                          .scale(duration: 400.ms, curve: Curves.elasticOut);
                    } else {
                      return const Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      );
                    }
                  }),
                );
              },
            )
                .animate(delay: 200.ms) // Animate Right Section Down (Delayed more)
                .slideY(begin: -2, end: 0, duration: 500.ms, curve: Curves.easeOutBack)
                .fade(duration: 500.ms),
          ],
        ),
      ),
    );
  }
}