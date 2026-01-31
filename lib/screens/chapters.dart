import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/models/quiz_models/chapter.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/core/shared/colors.dart';
import 'package:dino_run/view_models.dart/language_provider.dart';
import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:dino_run/widgets/plank_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // IMPORT THIS
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChaptersScreen extends StatefulWidget {
  final int level;
  const ChaptersScreen({super.key, required this.level});

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  late List<Chapter> chapters;

  @override
  void initState() {
    super.initState();
    chapters = context.read<QuizData>().chapters;
  }

  @override
  Widget build(BuildContext context) {
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
              top: constraints.maxHeight * 0.16,
              left: constraints.maxHeight * 0.04,
              child: Container(
                height: constraints.maxHeight * 0.60,
                width: constraints.maxWidth * 0.94,
                padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.1),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    // --- ANIMATED GRID ITEM ---
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              AudioManager.instance.playSfx(AudioSfx.click);
                              if (chapters[index].lock) {
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
                                                  .chapterLockDialog,
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
                                context.read<QuizData>().setChapter(index + 1);
                                context.read<QuizData>().resetTimer();
                                context.go('/game');
                              }
                            },
                            child: Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/bg_square.png')),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${context.watch<LanguageProvider>().chapter} ${chapters[index].chapter}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(height: 14),
                                    Text(
                                      chapters[index].title,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 14),
                                    Text(
                                      '${chapters[index].questions.length} ${context.watch<LanguageProvider>().questions}',
                                      style: TextStyle(fontSize: 8),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: chapters[index].lock,
                          child: Positioned(
                            right: 0,
                            top: 0,
                            child: Image.asset(
                              'assets/images/locked.png',
                              height: 42,
                              width: 42,
                            )
                            // Lock Pulse Animation
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
                    )
                    // Grid Item Entrance: Pop in one by one
                        .animate(delay: (100 + (index * 50)).ms)
                        .fade(duration: 400.ms)
                        .scale(begin: const Offset(0.5, 0.5), curve: Curves.easeOutBack);
                  },
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.03,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset('assets/images/chapters.png',
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
                  context.go('/levels');
                },
                child: Image.asset(
                  'assets/images/back arrow.png',
                ),
              ),
            )
            // Back button slides in from left
                .animate(delay: 200.ms)
                .fade()
                .moveX(begin: -30, end: 0, curve: Curves.easeOut),
          ],
        ),
      );
    });
  }
}