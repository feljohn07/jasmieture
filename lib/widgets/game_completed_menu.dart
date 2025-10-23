import 'dart:ui' show ImageFilter;

import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/game/dino_run.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/core/shared/colors.dart';
import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GameCompletedMenu extends StatefulWidget {
  static const id = 'GameCompletedMenu';
  final DinoRun game;

  const GameCompletedMenu(this.game, {super.key});

  @override
  State<GameCompletedMenu> createState() => _GameCompletedMenuState();
}

class _GameCompletedMenuState extends State<GameCompletedMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<int> _scoreAnimation;
  late final Animation<int> _bonusAnimation;
  // 1. Add an Animation for the time.
  late final Animation<int> _timeAnimation;

  late int _finalScore;
  late int _finalBonus;
  // 2. Add a variable for the final time.
  late int _finalTime;

  // Add a new state flag for the time animation phase.
  bool _isBonusPhase = false;
  bool _isTimePhase = false; // New state flag
  bool _isAnimationFinished = false;

  @override
  void initState() {
    super.initState();
    AudioManager.instance.stopBgm();
    AudioManager.instance.playSfx(AudioSfx.gameCompleted);

    final quizData = Provider.of<QuizData>(context, listen: false);
    _finalScore = quizData.score;
    _finalBonus = quizData.bonus;
    // 3. Get the final time from QuizData.
    _finalTime = quizData.elapsedSeconds;

    _controller = AnimationController(
      // Make the animation a bit longer to accommodate the new phase.
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scoreAnimation = IntTween(begin: 0, end: _finalScore).animate(curvedAnimation);
    _bonusAnimation = IntTween(begin: 0, end: _finalBonus).animate(curvedAnimation);
    // 4. Create the IntTween for the time animation.
    _timeAnimation = IntTween(begin: 0, end: _finalTime).animate(curvedAnimation);

    // 5. Update the listener to handle the new three-phase sequence.
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Phase 1 (Score) is complete, start Phase 2 (Bonus).
        if (!_isBonusPhase && !_isTimePhase) {
          setState(() {
            _isBonusPhase = true;
          });
          _controller.reset();
          _controller.forward();
        }
        // Phase 2 (Bonus) is complete, start Phase 3 (Time).
        else if (_isBonusPhase && !_isTimePhase) {
          setState(() {
            _isTimePhase = true;
          });
          _controller.reset();
          _controller.forward();
        }
        // Phase 3 (Time) is complete, finish the animation.
        else if (_isBonusPhase && _isTimePhase) {
          setState(() {
            _isAnimationFinished = true;
          });
        }
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.game.playerData,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Completed Menu.png'),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 130,
                    horizontal: 100,
                  ),
                  child: Column(
                    children: [
                      // 6. Wrap the entire Row in the AnimatedBuilder.
                      // This allows both score and time to be animated by the same controller.
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'You Score',
                                    style: TextStyle(fontSize: 28, color: colorBlack),
                                  ),
                                  // Final State: Show total score.
                                  if (_isAnimationFinished)
                                    Row(
                                      children: [
                                        Text(
                                          '${_finalScore + _finalBonus}',
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: colorBlack,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.star,
                                          size: 45,
                                          color: Colors.yellowAccent.shade200,
                                        ),
                                      ],
                                    )
                                  // Phase 3: Time is animating, score/bonus are static.
                                  else if (_isTimePhase)
                                    Text(
                                      '$_finalScore + ( $_finalBonus )',
                                      style: const TextStyle(fontSize: 28, color: colorBlack),
                                    )
                                  // Phase 2: Bonus is animating.
                                  else if (_isBonusPhase)
                                    Text(
                                      '$_finalScore + ( ${_bonusAnimation.value} )',
                                      style: const TextStyle(fontSize: 28, color: colorBlack),
                                    )
                                  // Phase 1: Score is animating.
                                  else
                                    Text(
                                      '${_scoreAnimation.value}',
                                      style: const TextStyle(fontSize: 28, color: colorBlack),
                                    ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 14),
                                height: 65,
                                width: 4,
                                color: colorBlack,
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'Time Taken',
                                    style: TextStyle(fontSize: 28, color: colorBlack),
                                  ),
                                  // Animate the time value based on the current phase.
                                  Text(
                                    // Phase 3: Time is animating.
                                    (_isTimePhase && !_isAnimationFinished)
                                        ? '${_timeAnimation.value} sec/s'
                                        // After Phase 3: Show final static time.
                                        : _isAnimationFinished
                                            ? '$_finalTime sec/s'
                                            // Before Phase 3: Show 0.
                                            : '0 sec/s',
                                    style: const TextStyle(fontSize: 28, color: colorBlack),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: InkWell(
                          child: Container(
                            height: 75,
                            width: 200,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/images/plank wood.png'),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Exit',
                                style: TextStyle(fontSize: 30, color: colorBlack),
                              ),
                            ),
                          ),
                          onTap: () {
                            AudioManager.instance.playSfx(AudioSfx.click);
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
        ),
      ),
    );
  }
}
