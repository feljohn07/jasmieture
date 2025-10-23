import 'package:dino_run/models/shop/background.dart';
import 'package:dino_run/models/shop/item.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/screens/shop/item_widget.dart';
import 'package:dino_run/view_models.dart/language_provider.dart';
import 'package:dino_run/view_models.dart/shop_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:dino_run/game/audio_manager.dart';

class ItemsView extends StatelessWidget {
  final void Function(Item item) switchItem;
  const ItemsView({super.key, required this.switchItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: colorOrange,
      decoration: BoxDecoration(
        image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/images/backgrounds/wood texture 01.png')),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.watch<LanguageProvider>().head,
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: context.watch<ShopData>().headItems.length,
                  itemBuilder: (context, index) {
                    Item item = context.watch<ShopData>().headItems[index];

                    return LayoutBuilder(builder: (context, constraints) {
                      // print(
                      //     '${item == context.watch<ShopData>().shop.headItemSelected} ${context.watch<ShopData>().shop.headItemSelected.toString()}');
                      return ItemWidget(
                        switchItem: switchItem,
                        item: item,
                        index: index,
                        selected: item == context.watch<ShopData>().shop.headItemSelected,
                      );
                    });
                  },
                ),
              ),
              Text(
                context.watch<LanguageProvider>().eye,
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: context.watch<ShopData>().eyeItems.length,
                  itemBuilder: (context, index) {
                    Item item = context.watch<ShopData>().eyeItems[index];
                    return ItemWidget(
                      switchItem: switchItem,
                      item: item,
                      index: index,
                      selected: item == context.watch<ShopData>().shop.eyeItemSelected,
                    );
                  },
                ),
              ),
              Text(
                context.watch<LanguageProvider>().shirt,
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: context.watch<ShopData>().shirtItems.length,
                  itemBuilder: (context, index) {
                    Item item = context.watch<ShopData>().shirtItems[index];
                    return ItemWidget(
                      switchItem: switchItem,
                      item: item,
                      index: index,
                      selected: item == context.watch<ShopData>().shop.shirtItemSelected,
                    );
                  },
                ),
              ),
              Text(
                'Background',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: context.watch<ShopData>().backgrounds.length,
                  itemBuilder: (context, index) {
                    Background background = context.watch<ShopData>().backgrounds[index];
                    final shopStar = context.watch<ShopData>().star;
                    bool isSelected = context.watch<ShopData>().shop.backgroundSelected == background;

                    return InkWell(
                      onTap: !background.purchased
                          ? null
                          : () {
                              context.read<ShopData>().setBackground(background);
                              AudioManager.instance.playSfx(AudioSfx.click);
                            },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Stack(
                          children: [
                            Container(
                              height: 150,
                              width: 300,
                              // color: Colors.amber,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(background.thumbnail),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !background.purchased,
                              child: Positioned(
                                right: 4,
                                top: 4,
                                child: Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amberAccent),
                                    Text('${background.cost}', style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 4,
                              top: 4,
                              child: Text(background.name, style: TextStyle(color: Colors.white)),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Visibility(
                                visible: !background.purchased,
                                replacement: isSelected
                                    ? Text(
                                        'Selected',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : Text(
                                        'Owned',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                child: SizedBox(
                                  height: 32,
                                  width: 56,
                                  child: ElevatedButton(
                                    onPressed: () {
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
                                                  image:
                                                      DecorationImage(image: AssetImage('assets/images/Purchase.png')),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Confirm Purchase',
                                                    ),
                                                    Text(
                                                      'You want to buy ${background.name} for ${background.cost}?',
                                                    ),
                                                    SizedBox(
                                                      height: 24,
                                                    ),
                                                    Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: (shopStar < background.cost)
                                                              ? null
                                                              : () {
                                                                  context
                                                                      .read<ShopData>()
                                                                      .purchaseBackground(background);
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
                                                              child: Text(shopStar < background.cost
                                                                  ? context.watch<LanguageProvider>().notEnoughtStar
                                                                  : context.watch<LanguageProvider>().yesPlease),
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            context.pop();
                                                            AudioManager.instance.playSfx(AudioSfx.click);
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
                                                            child: Center(
                                                                child:
                                                                    Text(context.watch<LanguageProvider>().noThanks)),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );

                                            // return AlertDialog(
                                            //   backgroundColor: const Color.fromARGB(255, 205, 113, 2),
                                            //   title: Text(
                                            //     'Confirm Purchase',
                                            //     style: TextStyle(color: Colors.white),
                                            //   ),
                                            //   content: Text(
                                            //     'You want to buy ${background.name} for ${background.cost}?',
                                            //     style: TextStyle(color: Colors.white),
                                            //   ),
                                            //   actions: [
                                            //     ElevatedButton(
                                            //       onPressed: (shopStar < background.cost)
                                            //           ? null
                                            //           : () {
                                            //               context.read<ShopData>().purchaseBackground(background);
                                            //               AudioManager.instance.playSfx(AudioSfx.katching);
                                            //               context.pop();
                                            //             },
                                            //       child: Text(shopStar < background.cost
                                            //           ? 'Not Enough Star =('
                                            //           : 'Yes Please!'),
                                            //     ),
                                            //     ElevatedButton(
                                            //       onPressed: () {
                                            //         context.pop();
                                            //         AudioManager.instance.playSfx(AudioSfx.click);
                                            //       },
                                            //       child: Text('No, thanks'),
                                            //     )
                                            //   ],
                                            // );
                                          });
                                      // context.read<ShopData>().setBackground(background);
                                      print('play');
                                    },
                                    child: Text(context.watch<LanguageProvider>().buy),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Text(
              //   'Music',
              //   style: TextStyle(fontSize: 24),
              // ),
              // SizedBox(
              //   height: 150,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (context, index) {
              //       return Padding(
              //         padding: const EdgeInsets.only(right: 8.0),
              //         child: Container(
              //           height: 150,
              //           width: 150,
              //           color: Colors.amber,
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
