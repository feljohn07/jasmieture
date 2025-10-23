// 🔹 PlayerView now just consumes the callbacks
import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/models/shop/character.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/screens/shop/shop_header.dart';
import 'package:dino_run/view_models.dart/language_provider.dart';
import 'package:dino_run/view_models.dart/rive_provider.dart';
import 'package:dino_run/view_models.dart/shop_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' hide LinearGradient, Image;

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/images/backgrounds/character bg.png')),
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsetsGeometry.all(0),
              child: Consumer<RiveProvider>(
                builder: (context, riveProvider, _) {
                  final artboard = riveProvider.artboard;
                  if (artboard == null) {
                    return const CircularProgressIndicator();
                  }

                  return Rive(
                    artboard: artboard,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 124,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [
                    Color.fromARGB(30, 223, 123, 0),
                    Color.fromARGB(130, 183, 100, 0),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              ShopHeader(),
              Spacer(),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        // swapCharacter('LEFT');
                        context.read<ShopData>().swapCharacter(SwapDirection.left);
                        context.read<RiveProvider>().loadCharacterArtboard(
                            context.read<ShopData>().characterPreview, context.read<ShopData>().shop);
                        AudioManager.instance.playSfx(AudioSfx.swipe);
                      },
                      child: SizedBox(height: 42, width: 42, child: Image.asset('assets/images/arrow - left.png')),
                    ),
                    InkWell(
                      onTap: () {
                        context.read<ShopData>().swapCharacter(SwapDirection.right);
                        context.read<RiveProvider>().loadCharacterArtboard(
                            context.read<ShopData>().characterPreview, context.read<ShopData>().shop);
                        AudioManager.instance.playSfx(AudioSfx.swipe);
                      },
                      child: SizedBox(height: 42, width: 42, child: Image.asset('assets/images/arrow - right.png')),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Column(
                children: [
                  Column(
                    children: [
                      Text(
                        context.watch<ShopData>().characterPreview.name,
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${context.watch<ShopData>().selectedCharacterIndex + 1} / ${context.watch<ShopData>().characters.length}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  Visibility(
                    visible: !context.watch<ShopData>().characterPreview.purchased,
                    replacement: SizedBox(
                      height: 42,
                      child: Text(
                        context.watch<LanguageProvider>().selected,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    child: SizedBox(
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () {
                          Character character = context.read<ShopData>().characterPreview;
                          bool hasEnoughStar =
                              context.read<ShopData>().star < context.read<ShopData>().characterPreview.cost;
                          AudioManager.instance.playSfx(AudioSfx.click);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                                child: Container(
                                  height: 400,
                                  width: 500,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: AssetImage('assets/images/Purchase.png')),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        context.watch<LanguageProvider>().confirmPurchase,
                                      ),
                                      Text(
                                        '${context.watch<LanguageProvider>().purchaseCharacterDialog1} ${character.name} ${context.watch<LanguageProvider>().forString} ${character.cost} stars?',
                                      ),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: hasEnoughStar
                                                ? null
                                                : () {
                                                    context.read<ShopData>().purchaseCharacter(character);
                                                    AudioManager.instance.playSfx(AudioSfx.katching);
                                                    context.pop();
                                                  },
                                            child: Container(
                                              height: 75,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage('assets/images/plank wood.png')),
                                              ),
                                              child: Center(
                                                child: Text(hasEnoughStar
                                                    ? context.watch<LanguageProvider>().notEnoughtStar
                                                    : context.watch<LanguageProvider>().yesPlease),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              AudioManager.instance.playSfx(AudioSfx.click);
                                              context.pop();
                                            },
                                            child: Container(
                                              height: 75,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage('assets/images/plank wood.png'),
                                                ),
                                              ),
                                              child: Center(child: Text(context.watch<LanguageProvider>().noThanks)),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                '${context.watch<LanguageProvider>().buyFor} ${context.watch<ShopData>().characterPreview.cost}'),
                            Icon(Icons.star, color: Colors.amberAccent)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
