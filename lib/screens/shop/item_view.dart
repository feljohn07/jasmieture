import 'package:dino_run/models/shop/background.dart';
import 'package:dino_run/models/shop/item.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/screens/shop/item_widget.dart';
import 'package:dino_run/view_models.dart/language_provider.dart';
import 'package:dino_run/view_models.dart/shop_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:dino_run/game/audio_manager.dart';

class ItemsView extends StatelessWidget {
  final void Function(Item item) switchItem;
  const ItemsView({super.key, required this.switchItem});

  @override
  Widget build(BuildContext context) {
    final shopData = context.read<ShopData>();
    final lang = context.watch<LanguageProvider>();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/backgrounds/wood texture 01.png')),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- REUSABLE SECTIONS ---

            // HEAD
            _ItemCategorySection(
              title: lang.head,
              items: shopData.headItems,
              selector: (_, provider) => provider.shop.headItemSelected,
              switchItem: switchItem,
              delayStart: 0,
            ),

            // EYES
            _ItemCategorySection(
              title: lang.eye,
              items: shopData.eyeItems,
              selector: (_, provider) => provider.shop.eyeItemSelected,
              switchItem: switchItem,
              delayStart: 200,
            ),

            // SHIRT
            _ItemCategorySection(
              title: lang.shirt,
              items: shopData.shirtItems,
              selector: (_, provider) => provider.shop.shirtItemSelected,
              switchItem: switchItem,
              delayStart: 400,
            ),

            // --- BACKGROUND SECTION ---
            _BackgroundSection(delayStart: 600),
          ],
        ),
      ),
    );
  }
}

/// A reusable widget for Head, Eye, and Shirt lists to reduce code duplication
class _ItemCategorySection extends StatelessWidget {
  final String title;
  final List<Item> items;
  final Item? Function(BuildContext, ShopData) selector;
  final void Function(Item) switchItem;
  final int delayStart;

  const _ItemCategorySection({
    required this.title,
    required this.items,
    required this.selector,
    required this.switchItem,
    required this.delayStart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KeepAliveWrapper(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ).animate(delay: delayStart.ms).fade().moveX(begin: -20, end: 0),
          ),
        ),
        SizedBox(
          // REDUCED HEIGHT: 230 -> 140 for better mobile viewing
          height: 140,
          child: ListView.builder(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return KeepAliveWrapper(
                child: Selector<ShopData, Item?>(
                  selector: selector,
                  builder: (context, selectedItem, child) {
                    return ItemWidget(
                      switchItem: switchItem,
                      item: item,
                      index: index,
                      selected: item == selectedItem,
                    );
                  },
                )
                    .animate(delay: (delayStart + (index * 50)).ms) // Faster stagger
                    .fade(duration: 400.ms)
                    .scale(curve: Curves.easeOutBack),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

/// Separated Background Logic to keep main code clean
class _BackgroundSection extends StatelessWidget {
  final int delayStart;
  const _BackgroundSection({required this.delayStart});

  @override
  Widget build(BuildContext context) {
    final shopData = context.read<ShopData>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KeepAliveWrapper(
          child: const Text(
            'Background',
            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ).animate(delay: delayStart.ms).fade().moveX(begin: -20, end: 0),
        ),
        const SizedBox(height: 8),
        SizedBox(
          // REDUCED HEIGHT: 150 -> 130
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: shopData.backgrounds.length,
            itemBuilder: (context, index) {
              final background = shopData.backgrounds[index];
              return KeepAliveWrapper(
                child: _BackgroundCard(
                  background: background,
                  delay: delayStart + (index * 100),
                ),
              );
            },
          ),
        ),
        // Add extra padding at bottom so FABs or nav bars don't cover content
        const SizedBox(height: 40),
      ],
    );
  }
}

class _BackgroundCard extends StatelessWidget {
  final Background background;
  final int delay;

  const _BackgroundCard({required this.background, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopData>(
      builder: (context, provider, child) {
        final isSelected = provider.shop.backgroundSelected == background;

        return InkWell(
          onTap: !background.purchased
              ? null
              : () {
            context.read<ShopData>().setBackground(background);
            AudioManager.instance.playSfx(AudioSfx.click);
          },
          child: Container(
            // REDUCED WIDTH: 300 -> 220 to fit more on mobile screens
            width: 220,
            margin: const EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: Colors.white, width: 3)
                    : Border.all(color: Colors.white24, width: 1),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(background.thumbnail),
                ),
                boxShadow: [
                  const BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(2, 2))
                ]
            ),
            child: Stack(
              children: [
                // Price Tag
                if (!background.purchased)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amberAccent, size: 16),
                          const SizedBox(width: 4),
                          Text('${background.cost}',
                              style: const TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),

                // Name
                Positioned(
                  left: 8,
                  top: 8,
                  child: Text(
                      background.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black, blurRadius: 4)]
                      )
                  ),
                ),

                // Button
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: !background.purchased
                      ? SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white
                      ),
                      onPressed: () => _showPurchaseDialog(context, background),
                      child: Text(context.watch<LanguageProvider>().buy),
                    ),
                  )
                      : Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    color: isSelected ? Colors.black54 : Colors.transparent,
                    child: Text(
                      isSelected ? 'Selected' : 'Owned',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    )
        .animate(delay: delay.ms)
        .fade()
        .moveX(begin: 50, end: 0, curve: Curves.easeOut);
  }

  void _showPurchaseDialog(BuildContext context, Background background) {
    AudioManager.instance.playSfx(AudioSfx.click);
    showDialog(
        context: context,
        builder: (context) {
          // Capture context for provider usage
          final shopData = context.watch<ShopData>();
          final lang = context.watch<LanguageProvider>();
          final canAfford = shopData.star >= background.cost;

          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 320, // Reduced height for mobile
              width: 400,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/Purchase.png')
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Confirm Purchase', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  Text(
                    'Buy ${background.name} for ${background.cost}?',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Confirm Button
                  InkWell(
                    onTap: !canAfford
                        ? null
                        : () {
                      context.read<ShopData>().purchaseBackground(background);
                      AudioManager.instance.playSfx(AudioSfx.katching);
                      context.pop();
                    },
                    child: _DialogButton(
                      text: canAfford ? lang.yesPlease : lang.notEnoughtStar,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Cancel Button
                  InkWell(
                    onTap: () {
                      context.pop();
                      AudioManager.instance.playSfx(AudioSfx.click);
                    },
                    child: _DialogButton(text: lang.noThanks),
                  ),
                ],
              ),
            ).animate().scale(curve: Curves.elasticOut, duration: 600.ms).fade(),
          );
        }
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String text;
  const _DialogButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55, // Reduced from 75
      width: 180, // Reduced from 200
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/plank wood.png'),
        ),
      ),
      child: Center(
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}