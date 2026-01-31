import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/models/shop/item.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/view_models.dart/language_provider.dart';
import 'package:dino_run/view_models.dart/shop_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.switchItem,
    required this.item,
    required this.index,
    required this.selected,
  });

  final void Function(Item item) switchItem;
  final Item item;
  final int index;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final shopStar = context.watch<ShopData>().star;
    bool isDefaultItem = item.cost == 0 && item.riveId == 0;

    return SizedBox(
      height: 140, // Reduced from 200
      width: 110,  // Reduced from 150
      child: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: InkWell(
            onTap: !item.purchased
                ? null
                : () {
              switchItem(item);
              AudioManager.instance.playSfx(AudioSfx.swipe);
            },
            child: Stack(
                clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(24), // Reduced from 32
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.scaleDown,
                        image: AssetImage('assets/images/item_box.png')),
                  ),
                  child: Center(
                    child: Image.asset('assets/images/shop_items/items/${item.path}'),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 25, // Adjusted from 35
                  child: Center(
                    child: Text(
                      item.name,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                Visibility(
                  visible: !isDefaultItem,
                  child: Positioned(
                    left: 0,
                    right: 0,
                    bottom: 35, // Adjusted from 55
                    child: Center(
                      child: Visibility(
                        visible: item.purchased,
                        replacement: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.amberAccent, size: 16),
                            Text(
                              '${item.cost}',
                              style: const TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                        child: Text(
                          selected ? context.watch<LanguageProvider>().equiped : '',
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !isDefaultItem,
                  child: Positioned(
                    bottom: -10, // Adjusted from 10
                    left: 0,
                    right: 0,
                    height: 25, // Adjusted from 30
                    child: Center(
                      child: Visibility(
                        visible: !item.purchased,
                        child: SizedBox(
                          width: 65, // Adjusted from 75
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                            onPressed: () {
                              AudioManager.instance.playSfx(AudioSfx.click);
                              _showOriginalDialog(context, shopStar);
                            },
                            child: Text(context.watch<LanguageProvider>().buy, style: const TextStyle(fontSize: 10)),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  // Extracted the dialog to keep the widget tree clean, but kept the design 1:1 with yours
  void _showOriginalDialog(BuildContext context, int shopStar) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          child: Container(
            height: 320, // Reduced from 400 for mobile
            width: 400,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/Purchase.png')),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.watch<LanguageProvider>().confirmPurchase),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '${context.watch<LanguageProvider>().purchaseItemDialog1} ${item.name} ${context.watch<LanguageProvider>().forString} ${item.cost} stars?',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    InkWell(
                      onTap: (shopStar < item.cost)
                          ? null
                          : () {
                        context.read<ShopData>().purchaseItem(item);
                        AudioManager.instance.playSfx(AudioSfx.katching);
                        context.pop();
                      },
                      child: Container(
                        height: 60, // Reduced from 75
                        width: 180, // Reduced from 200
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/images/plank wood.png')),
                        ),
                        child: Center(
                          child: Text(shopStar < item.cost
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
                        height: 60,
                        width: 180,
                        decoration: const BoxDecoration(
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
  }
}