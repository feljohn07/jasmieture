import 'dart:ui';

import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/core/shared/colors.dart';
import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:dino_run/widgets/question_panel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/widgets/hud.dart';
import '/game/dino_run.dart';
import '/game/audio_manager.dart';

// This represents the pause menu overlay.
class PauseMenu extends StatelessWidget {
  // An unique identified for this overlay.
  static const id = 'PauseMenu';

  // Reference to parent game.
  final DinoRun game;

  const PauseMenu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    AudioManager.instance.playSfx(AudioSfx.swipe);
    return ChangeNotifierProvider.value(
      value: game.playerData,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/Paused Menu.png'))),
            child: Padding(
              padding: EdgeInsets.all(14),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 100,
                    horizontal: 100,
                  ),
                  child: Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: [
                      Selector<QuizData, int>(
                        selector: (_, playerData) => playerData.score,
                        builder: (_, score, __) {
                          return Row(
                            children: [],
                          );
                        },
                      ),
                      InkWell(
                        onTap: () {
                          AudioManager.instance.playSfx(AudioSfx.click);
                          game.overlays.remove(PauseMenu.id);
                          game.overlays.remove(QuestionOverlay.id);
                          game.overlays.add(Hud.id);
                          game.resumeEngine();
                          AudioManager.instance.resumeBgm();
                        },
                        child: Container(
                          height: 75,
                          width: 200,
                          decoration: BoxDecoration(
                              image:
                                  DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/images/plank wood.png'))),
                          child: Center(
                            child: const Text(
                              'Resume',
                              style: TextStyle(fontSize: 30, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          game.reset();
                          AudioManager.instance.playSfx(AudioSfx.click);
                          context.go('/');
                        },
                        child: Container(
                          height: 75,
                          width: 200,
                          decoration: BoxDecoration(
                              image:
                                  DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/images/plank wood.png'))),
                          child: Center(
                            child: const Text(
                              'Exit',
                              style: TextStyle(fontSize: 30, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
