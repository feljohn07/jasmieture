import 'dart:ui';

import 'package:dino_run/main.dart';
import 'package:dino_run/screens/shop/shop.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/widgets/hud.dart';
import '/game/dino_run.dart';

// This represents the main menu overlay.
class MainMenu extends StatelessWidget {
  // An unique identified for this overlay.
  static const id = 'MainMenu';

  // Reference to parent game.
  final DinoRun game;

  const MainMenu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    // final testValue = context.watch<TestProvider>();

    return Center(
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
                    'Jasmieture',
                    style: TextStyle(fontSize: 50, color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      game.startGamePlay();
                      game.overlays.remove(MainMenu.id);
                      game.overlays.add(Hud.id);
                    },
                    child: const Text('Play', style: TextStyle(fontSize: 30)),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     context.read<TestProvider>().increment();
                  //   },
                  //   child: const Text('Increment', style: TextStyle(fontSize: 30)),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     game.overlays.remove(MainMenu.id);
                  //     game.overlays.add(SettingsMenu.id);
                  //   },
                  //   child: const Text(
                  //     'Settings',
                  //     style: TextStyle(fontSize: 30),
                  //   ),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     game.overlays.remove(MainMenu.id);
                  //     game.overlays.add(ShopScreen.id);
                  //   },
                  //   child: const Text(
                  //     'Shop',
                  //     style: TextStyle(fontSize: 30),
                  //   ),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/');
                    },
                    child: const Text(
                      'Exit',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
