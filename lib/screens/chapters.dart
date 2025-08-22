import 'package:dino_run/models/player_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChaptersScreen extends StatelessWidget {
  const ChaptersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  context.read<PlayerData>().setChapter(index);
                  context.go('/game');
                },
                child: Container(
                  height: 32,
                  width: 32,
                  color: Colors.amber,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
