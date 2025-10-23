import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:flutter/material.dart';
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
    // final score = context.watch<QuizData>().score;
    // final level = context.watch<QuizData>().level;

    return ChangeNotifierProvider.value(
      value: game.quizData,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    );
                  },
                ),
                // Selector<PlayerData, int>(
                //   selector: (_, quizData) => quizData.highScore,
                //   builder: (_, highScore, __) {
                //     return Text(
                //       'High: $highScore ',
                //       style: const TextStyle(color: Colors.white),
                //     );
                //   },
                // ),
                // Selector<PlayerData, int>(
                //   selector: (_, playerData) => playerData.currentScore,
                //   builder: (_, stars, __) {
                //     return Text(
                //       'Stars: $stars',
                //       style: const TextStyle(color: Colors.white),
                //     );
                //   },
                // ),

                // Text('$level'),
                // Text('$chapter'),
              ],
            ),
            TextButton(
              onPressed: () {
                game.overlays.remove(Hud.id);
                game.overlays.add(PauseMenu.id);
                game.pauseEngine();
                AudioManager.instance.pauseBgm();
              },
              child: const Icon(Icons.pause, color: Colors.white),
            ),
            Selector<QuizData, int>(
              selector: (_, quizData) => quizData.lives,
              builder: (_, lives, __) {
                return Row(
                  children: List.generate(3, (index) {
                    if (index < lives) {
                      return const Icon(Icons.favorite, color: Colors.red);
                    } else {
                      return const Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      );
                    }
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
