import 'package:dino_run/models/player_data.dart';
import 'package:dino_run/models/quiz_models/chapter.dart';
import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChaptersScreen extends StatefulWidget {
  final int level;
  const ChaptersScreen({super.key, required this.level});

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  late Future<List<Chapter>> chapters;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chapters = context.read<QuizData>().getChapters(widget.level);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: FutureBuilder(
            future: chapters,
            builder: (context, asyncSnapshot) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemCount: asyncSnapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        // context.read<PlayerData>().setChapter(index);
                        context.read<QuizData>().setChapter(index + 1);
                        context.read<QuizData>().resetTimer();

                        context.go('/game');
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        color: Colors.amber,
                        child: Column(
                          children: [
                            Text('${asyncSnapshot.data?[index].title}'),
                            Text('${asyncSnapshot.data?[index].chapter}'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
