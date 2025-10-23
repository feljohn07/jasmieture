import 'dart:ui';

import 'package:dino_run/models/quiz_models/choice.dart';
import 'package:dino_run/models/quiz_models/question.dart';
import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/widgets/hud.dart';
import '/game/dino_run.dart';
import '/game/audio_manager.dart';

import 'package:audioplayers/audioplayers.dart';

class QuestionOverlay extends StatefulWidget {
  static const id = 'Question';
  final DinoRun game;

  const QuestionOverlay(this.game, {super.key});

  @override
  State<QuestionOverlay> createState() => _QuestionOverlayState();
}

// Add this enum outside of your class, near the top of the file.
enum AnswerStatus { none, correct, incorrect }

class _QuestionOverlayState extends State<QuestionOverlay> {
  final player = AudioPlayer();
  Question? question;

  late final List<Choice> shuffledChoices;
  List<String> letters = ['A', 'B', 'C', 'D'];

  List<String> _audioPlaylist = [];
  int _currentAudioIndex = 0;
  int _currentlyPlayingChoiceIndex = -1;

  // New state variable to control the feedback icon's visibility and type.
  AnswerStatus _answerStatus = AnswerStatus.none;

  void check(Choice choice) {
    // Prevent multiple taps while the icon is being shown.
    if (_answerStatus != AnswerStatus.none) return;

    final quizData = Provider.of<QuizData>(context, listen: false);

    // The callback contains the logic to run after the check and delay.
    quizData.check(choice.choiceId, (isCorrect) async {
      // 1. Stop the audio playlist.
      player.stop();

      // 2. Update the state to show the icon.
      setState(() {
        _answerStatus = isCorrect ? AnswerStatus.correct : AnswerStatus.incorrect;
      });

      // 3. Wait for 1 second to show the icon.
      await Future.delayed(const Duration(seconds: 1));

      // 4. After the delay, close the overlay and resume the game.
      // It's good practice to check if the widget is still in the tree.
      if (mounted) {
        widget.game.overlays.remove(QuestionOverlay.id);
        widget.game.overlays.add(Hud.id);
        widget.game.resumeEngine();
        AudioManager.instance.resumeBgm();
        quizData.pauseTimer();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    AudioManager.instance.pauseBgm();

    player.onPlayerComplete.listen((event) {
      _currentAudioIndex++;
      _playCurrentTrack();
    });

    final quizData = Provider.of<QuizData>(context, listen: false);
    quizData.startTimer();
    question = quizData.question;

    shuffledChoices = List.from(quizData.choices)..shuffle();

    setupAndPlayQuestionAudio();
  }

  void setupAndPlayQuestionAudio() {
    if (question?.audio == null) return;

    _audioPlaylist = [
      'audio/${question!.audio}',
      'audio/letters/letters-01.wav',
      'audio/${shuffledChoices[0].audio}',
      'audio/letters/letters-02.wav',
      'audio/${shuffledChoices[1].audio}',
      'audio/letters/letters-03.wav',
      'audio/${shuffledChoices[2].audio}',
      'audio/letters/letters-04.wav',
      'audio/${shuffledChoices[3].audio}',
    ];

    _audioPlaylist.removeWhere((path) => path == 'audio/');

    _currentAudioIndex = 0;
    _playCurrentTrack();
  }

  void _playCurrentTrack() {
    // Don't play the next audio if an answer has already been submitted.
    if (_answerStatus != AnswerStatus.none) return;

    if (_currentAudioIndex < _audioPlaylist.length) {
      setState(() {
        if (_currentAudioIndex >= 2 && _currentAudioIndex % 2 == 0) {
          _currentlyPlayingChoiceIndex = (_currentAudioIndex - 2) ~/ 2;
        } else {
          _currentlyPlayingChoiceIndex = -1;
        }
      });

      final assetPath = _audioPlaylist[_currentAudioIndex];
      player.play(AssetSource(assetPath));
    } else {
      setState(() {
        _currentlyPlayingChoiceIndex = -1;
      });
      print('Audio playlist finished.');
    }
  }

  @override
  void dispose() {
    super.dispose();
    AudioManager.instance.resumeBgm();
    player.stop();
    player.dispose();
  }

  List<Widget> _buildChoiceWidgets() {
    if (shuffledChoices.any((element) => element.imagePath.isNotEmpty)) {
      return [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(shuffledChoices.length, (index) {
              final choice = shuffledChoices[index];
              final isPlaying = (index == _currentlyPlayingChoiceIndex);

              return AnimatedScale(
                scale: isPlaying ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: InkWell(
                  onTap: () => check(choice),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            image: DecorationImage(image: AssetImage(choice.imagePath)),
                            boxShadow: const [BoxShadow(color: Color.fromARGB(74, 0, 0, 0), blurRadius: 4)],
                          ),
                          width: 150,
                          height: 150,
                          margin: const EdgeInsets.only(bottom: 4),
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            '${letters[index]} . ${choice.choice}',
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        )
      ];
    } else {
      return List.generate(shuffledChoices.length, (index) {
        final choice = shuffledChoices[index];
        final isPlaying = (index == _currentlyPlayingChoiceIndex);

        return AnimatedScale(
          scale: isPlaying ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: InkWell(
            onTap: () => check(choice),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '${letters[index]}. ${choice.choice}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        );
      });
    }
  }

  // New widget to display the feedback icon overlay.
  Widget _buildFeedbackIcon() {
    if (_answerStatus == AnswerStatus.none) {
      // Return an empty container when no answer has been submitted.
      return const SizedBox.shrink();
    }

    final isCorrect = _answerStatus == AnswerStatus.correct;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.greenAccent : Colors.redAccent,
                size: 120,
              ),
            ),
            SizedBox(
              height: 14,
            ),
             Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
              ),
              child: Text(isCorrect ? 'Correct!' : 'Wrong!'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ChangeNotifierProvider.value(
        value: widget.game.playerData,
        child: Stack(
          children: [
            // Your existing UI
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/question background.png'), fit: BoxFit.fill),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: constraints.maxWidth * 0.13,
                  right: constraints.maxWidth * 0.15,
                  top: constraints.maxHeight * 0.15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${context.watch<QuizData>().question?.question}',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 24),
                    ..._buildChoiceWidgets(),
                  ],
                ),
              ),
            ),
            Positioned(
              top: constraints.maxHeight * 0.01,
              left: 0,
              right: 0,
              child: Consumer<QuizData>(
                builder: (_, timer, __) {
                  final minutes = (timer.elapsedSeconds ~/ 60).toString().padLeft(2, '0');
                  final seconds = (timer.elapsedSeconds % 60).toString().padLeft(2, '0');

                  return Center(
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/images/plank wood.png')),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 14),
                          const Icon(Icons.alarm, size: 32),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              "$minutes:$seconds",
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: constraints.maxHeight * 0.25,
              right: constraints.maxWidth * 0.15,
              child: Text(
                'Question ${context.watch<QuizData>().remainingQuestions} / ${context.watch<QuizData>().totalQuestions}',
              ),
            ),
            // Add the feedback icon on top of everything.
            _buildFeedbackIcon(),
          ],
        ),
      );
    });
  }
}
