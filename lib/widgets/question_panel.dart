import 'dart:async';
import 'dart:ui';

import 'package:dino_run/models/quiz_models/choice.dart';
import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:dino_run/widgets/pause_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/widgets/hud.dart';
import '/game/dino_run.dart';
import '/game/audio_manager.dart';

class QuestionOverlay extends StatefulWidget {
  static const id = 'Question';
  final DinoRun game;

  const QuestionOverlay(this.game, {super.key});

  @override
  State<QuestionOverlay> createState() => _QuestionOverlayState();
}

class _QuestionOverlayState extends State<QuestionOverlay> {
  late Timer _timer;
  int _elapsedSeconds = 0;

  List<Widget> choices = [];

  @override
  void initState() {
    super.initState();
    // _startTimer();

    final timerProvider = Provider.of<QuizData>(context, listen: false);
    timerProvider.startTimer();

    choices = List.generate(
      context.read<QuizData>().question?.choices.length ?? 0,
      (index) {
        final choice = context.read<QuizData>().question!.choices[index];
        return InkWell(
          onTap: () async {
            await context.read<QuizData>().check(choice.choiceId, (isCorrect, gameEnded) {
              if (gameEnded) {
                widget.game.overlays.remove(QuestionOverlay.id);
                widget.game.overlays.add(PauseMenu.id);
                widget.game.pauseEngine();
                timerProvider.pauseTimer();
                return;
              }

              if (isCorrect) {
                widget.game.overlays.remove(QuestionOverlay.id);
                widget.game.overlays.add(Hud.id);
                widget.game.resumeEngine();
                AudioManager.instance.resumeBgm();
                timerProvider.pauseTimer();
              }
            });
          },
          child: Text(
            '${choice.choiceId} ${choice.choice}',
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );

    // shuffle the list after generation
    choices.shuffle();
  }

  // void _startTimer() {
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     setState(() {
  //       _elapsedSeconds++;
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   super.dispose();
  // }

  // String _formatElapsedTime(int seconds) {
  //   final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  //   final secs = (seconds % 60).toString().padLeft(2, '0');
  //   return '$minutes:$secs';
  // }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<QuizData>(context, listen: false);

    return ChangeNotifierProvider.value(
      value: widget.game.playerData,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.black.withAlpha(100),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 100,
                ),
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    // Text('${context.watch<QuizData>().level}'),
                    // Text('${context.watch<QuizData>().chapter}'),
                    // Text(
                    //   'Time: ${_formatElapsedTime(_elapsedSeconds)}',
                    //   style: const TextStyle(fontSize: 30, color: Colors.white),
                    // ),
                    Consumer<QuizData>(
                      builder: (_, timer, __) {
                        final minutes = (timer.elapsedSeconds ~/ 60).toString().padLeft(
                              2,
                              '0',
                            );
                        final seconds = (timer.elapsedSeconds % 60).toString().padLeft(
                              2,
                              '0',
                            );

                        return Text(
                          "$minutes:$seconds",
                          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                    const Text(
                      'Question N',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '${context.watch<QuizData>().question?.question}',
                      style: TextStyle(color: Colors.white),
                    ),
                    ...choices,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
