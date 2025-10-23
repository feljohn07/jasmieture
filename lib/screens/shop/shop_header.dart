import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/view_models.dart/shop_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ShopHeader extends StatelessWidget {
  const ShopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final stars = context.watch<ShopData>().star;

    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              height: 50,
              width: 100,
              child: InkWell(
                onTap: () {
                  context.go('/');
                  AudioManager.instance.playSfx(AudioSfx.click);
                },
                child: Image.asset(
                  'assets/images/back arrow.png',
                ),
              ),
            ),
          ),
          // InkWell(
          //   onTap: () {
          //     context.go('/');
          //     AudioManager.instance.playSfx(AudioSfx.click);
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 14.0),
          //     child: Row(
          //       spacing: 0,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Icon(Icons.arrow_back_ios, color: Colors.white),
          //         Text('Back', style: TextStyle(fontSize: 24, color: Colors.white)),
          //       ],
          //     ),
          //   ),
          // ),
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amberAccent,
              ),
              Text(
                '$stars',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
