import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:dino_run/models/player_data.dart';
import 'package:dino_run/widgets/settings_menu.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> levels = [
      {
        'quarter': '1st',
        'title': 'Materials',
      },
      {
        'quarter': '2nd',
        'title': 'Living Things',
      },
      {
        'quarter': '3rd',
        'title': 'Force, Motion and Energy',
      },
      {
        'quarter': '4th',
        'title': 'Earth And Space',
      },
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.white,
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('hello'.tr()),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          context.go('/shop');
                        },
                        child: Icon(Icons.shop),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: SettingsMenu(),
                              );
                            },
                          );
                        },
                        child: Icon(Icons.settings),
                      ),
                      Icon(Icons.translate),
                    ],
                  ),
                ],
              ),
              // width: double.infinity,
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    color: Colors.blue,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            context.read<PlayerData>().setLevel(index);
                            context.read<QuizData>().setLevel(index + 1);
                            context.go('/chapters');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AspectRatio(
                              aspectRatio: 10 / 16,
                              child: Container(
                                color: Colors.primaries[index],
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${levels[index]['title']}',
                                          // textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize,
                                          ),
                                        ),
                                        Text(
                                          '${levels[index]['quarter']} Quarter',
                                          // textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
