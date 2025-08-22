import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/widgets/hud.dart';
import '/game/dino_run.dart';
import '/widgets/main_menu.dart';
import '/game/audio_manager.dart';
import '/models/player_data.dart';

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

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatElapsedTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
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
                    Text(
                      'Time: ${_formatElapsedTime(_elapsedSeconds)}',
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    const Text(
                      'Question N',
                      style: TextStyle(color: Colors.white),
                    ),
                    const Text(
                      'Which materials absorb water which do not',
                      style: TextStyle(color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {
                        context.read<PlayerData>().currentScore++;
                        widget.game.overlays.remove(QuestionOverlay.id);
                        widget.game.overlays.add(Hud.id);
                        widget.game.resumeEngine();
                        AudioManager.instance.resumeBgm();
                      },
                      child: const Text(
                        'a. choice 1',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.read<PlayerData>().lives--;
                        widget.game.overlays.remove(QuestionOverlay.id);
                        widget.game.overlays.add(Hud.id);
                        widget.game.resumeEngine();
                        AudioManager.instance.resumeBgm();
                      },
                      child: const Text(
                        'b. choice 2',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Text(
                      'c. choice 3',
                      style: TextStyle(color: Colors.white),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     widget.game.overlays.remove(QuestionOverlay.id);
                    //     widget.game.overlays.add(Hud.id);
                    //     widget.game.resumeEngine();
                    //     AudioManager.instance.resumeBgm();
                    //   },
                    //   child: const Text(
                    //     'Proceed',
                    //     style: TextStyle(fontSize: 30),
                    //   ),
                    // ),
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
