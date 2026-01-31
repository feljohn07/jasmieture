import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/models/quiz_models/level.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/view_models.dart/language_provider.dart';
import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:dino_run/widgets/plank_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // IMPORT THIS
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  List<Color> colors = [
    const Color.fromARGB(170, 105, 240, 175),
    const Color.fromARGB(180, 255, 153, 0),
    const Color.fromARGB(178, 255, 109, 64),
    const Color.fromARGB(155, 244, 67, 54)
  ];

  @override
  Widget build(BuildContext context) {
    List<Level> levels = context.read<QuizData>().levels;

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/question background.png',
              fit: BoxFit.fill,
            ),
            Positioned(
              top: constraints.maxHeight * 0.12,
              left: constraints.maxHeight * 0.02,
              right: constraints.maxHeight * 0.03,
              child: Container(
                height: constraints.maxHeight * 0.65,
                width: constraints.maxWidth * 0.95,
                padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.1),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            // --- ANIMATED LIST ITEM START ---
                            // We wrap the list item Padding widget with animate()
                            return Padding(
                              padding: const EdgeInsets.only(right: 24),
                              child: InkWell(
                                onTap: () {
                                  // ... (Existing tap logic) ...
                                  AudioManager.instance.playSfx(AudioSfx.click);
                                  if (levels[index].lock) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor:
                                          const Color.fromARGB(0, 0, 0, 0),
                                          child: Container(
                                            height: 400,
                                            width: 500,
                                            padding: EdgeInsets.all(50),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/lock.png')),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  context
                                                      .watch<LanguageProvider>()
                                                      .levelLockDialog,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 24,
                                                ),
                                                PlankButton(
                                                  onTap: () {
                                                    AudioManager.instance
                                                        .playSfx(AudioSfx.click);
                                                    context.pop();
                                                  },
                                                  label: 'Ok',
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    context
                                        .read<QuizData>()
                                        .setLevel(levels[index].level);
                                    context.go('/chapters',
                                        extra: levels[index].level);
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Image.asset('assets/images/paper_bg.png'),
                                    Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: AspectRatio(
                                        aspectRatio: 10 / 16,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  levels[index].title,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  '${context.watch<LanguageProvider>().quarter} ${levels[index].level}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  '${levels[index].chapters.length} ${context.watch<LanguageProvider>().chapters}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                  ),
                                                ),
                                                Gap(14),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: colors[index],
                                            borderRadius:
                                            BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Colors.black87)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(levels[index].difficulty),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: levels[index].lock,
                                      child: Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Image.asset(
                                          'assets/images/locked.png',
                                          height: 42,
                                          width: 42,
                                        )
                                        // Add a subtle pulse to the lock icon
                                            .animate(
                                          onPlay: (controller) =>
                                              controller.repeat(reverse: true),
                                        )
                                            .scaleXY(
                                            begin: 1.0,
                                            end: 1.1,
                                            duration: 1000.ms,
                                            curve: Curves.easeInOut),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            // Staggered entrance animation based on index
                                .animate(delay: (300 + (index * 150)).ms)
                                .fade(duration: 600.ms)
                                .slideY(
                                begin: 0.2, end: 0, curve: Curves.easeOutBack);
                            // --- ANIMATED LIST ITEM END ---
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.03,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset('assets/images/levels.png',
                    height: MediaQuery.sizeOf(context).height * 0.12,
                    width: MediaQuery.sizeOf(context).width * 0.45),
              ),
            )
            // Title drops down
                .animate()
                .fade(duration: 500.ms)
                .moveY(begin: -50, end: 0, curve: Curves.easeOut),

            Positioned(
              height: MediaQuery.sizeOf(context).height * 0.1,
              width: MediaQuery.sizeOf(context).width * 0.1,
              top: 14,
              left: 14,
              child: InkWell(
                onTap: () {
                  AudioManager.instance.playSfx(AudioSfx.click);
                  context.go('/');
                },
                child: Image.asset(
                  'assets/images/back arrow.png',
                ),
              ),
            )
            // Back arrow slides in from left
                .animate(delay: 200.ms)
                .fade()
                .moveX(begin: -30, end: 0, curve: Curves.easeOut),

            Positioned(
              right: 14,
              bottom: 14,
              height: 50,
              width: 200,
              child: PlankButton(
                  onTap: () {
                    AudioManager.instance.playSfx(AudioSfx.click);
                    context.push('/history');
                  },
                  label: 'History'),
            )
            // History button slides up from bottom right
                .animate(delay: 800.ms)
                .fade()
                .moveY(begin: 50, end: 0, curve: Curves.easeOutBack),
          ],
        ),
      );
    });
  }
}