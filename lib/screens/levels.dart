import 'package:flutter/material.dart';

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
      home: Scaffold(
        body: Stack(
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
                  return Padding(
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
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize,
                                  ),
                                ),
                                Text(
                                  '${levels[index]['quarter']} Quarter',
                                  textDirection: TextDirection.rtl,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
