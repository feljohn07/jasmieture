import 'dart:ui';

import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/core/shared/colors.dart';
import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/game/dino_run.dart';

// This represents the game over overlay,
// displayed with dino runs out of lives.
class GameOverMenu extends StatelessWidget {
  // An unique identified for this overlay.
  static const id = 'GameOverMenu';

  // Reference to parent game.
  final DinoRun game;

  const GameOverMenu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    AudioManager.instance.stopBgm();
    AudioManager.instance.playSfx(AudioSfx.gameOver);

    return ChangeNotifierProvider.value(
      value: game.playerData,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration:
                    BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/Game Over Menu.png'))),
                child: Padding(
                  padding: EdgeInsets.all(14),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 50,
                        horizontal: 100,
                      ),
                      child: Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: [
                          // Selector<QuizData, int>(
                          //   selector: (_, quizData) => quizData.score,
                          //   builder: (_, score, __) {
                          //     return Text(
                          //       'You Score: ${context.watch<QuizData>().score} + ${context.watch<QuizData>().bonus}',
                          //       style: const TextStyle(
                          //         fontSize: 40,
                          //         color: Colors.white,
                          //       ),
                          //     );
                          //   },
                          // ),
                          SizedBox(height: 14),
                          Selector<QuizData, int>(
                            selector: (_, quizData) => quizData.elapsedSeconds,
                            builder: (_, time, __) {
                              return Column(
                                children: [
                                  Text(
                                    'Time Taken: ',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      color: colorBlack,
                                    ),
                                  ),
                                  Text(
                                    '$time second/s',
                                    style: const TextStyle(
                                      fontSize: 40,
                                      color: colorBlack,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          // ElevatedButton(
                          //   child: const Text(
                          //     'Restart',
                          //     style: TextStyle(fontSize: 30),
                          //   ),
                          //   onPressed: () {
                          //     game.overlays.remove(GameOverMenu.id);
                          //     game.overlays.add(Hud.id);
                          //     game.resumeEngine();
                          //     game.reset();
                          //     game.startGamePlay();
                          //     AudioManager.instance.resumeBgm();
                          //   },
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 32.0),
                            child: InkWell(
                              child: Container(
                                height: 75,
                                width: 200,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill, image: AssetImage('assets/images/plank wood.png'))),
                                child: Center(
                                    child: const Text('Exit', style: TextStyle(fontSize: 30, color: colorBlack))),
                              ),
                              onTap: () {
                                // game.overlays.remove(GameOverMenu.id);
                                // game.overlays.add(MainMenu.id);
                                // game.resumeEngine();
                                // game.reset();
                                // AudioManager.instance.resumeBgm();
                                context.go('/');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
