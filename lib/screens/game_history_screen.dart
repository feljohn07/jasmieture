import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/models/game/history.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GameHistoryScreen extends StatelessWidget {
  const GameHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<History> histories = context.watch<QuizData>().histories;

    return Scaffold(
      // appBar: AppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/question background.png',
            fit: BoxFit.fill, // Ensures the image covers the whole screen
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.14,
            bottom: MediaQuery.sizeOf(context).height * 0.21,
            left: MediaQuery.sizeOf(context).width * 0.12,
            right: MediaQuery.sizeOf(context).width * 0.13,
            child: Visibility(
              visible: histories.isNotEmpty,
              replacement: Center(child: Text('No History')),
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: histories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Level ${histories[index].level} Chapter ${histories[index].chapter}'),
                    subtitle: Text('Time Taken is ${histories[index].timeTaken} seconds'),
                    trailing: Text('${histories[index].score} stars'),
                  );
                },
              ),
            ),
          ),
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
          ),
        ],
      ),
    );
  }
}
