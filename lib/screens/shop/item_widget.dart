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
    // star
    // item name
    // item image
    // onPurchase
    // onSelect
  });

  final void Function(Item item) switchItem;
  final Item item;
  final int index;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final shopStar = context.watch<ShopData>().star;
    bool isDefaultItem = item.cost == 0 && item.riveId == 0 ? true : false;

    return SizedBox(
      height: 200,
      width: 150,
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
              children: [
                Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    image: DecorationImage(fit: BoxFit.scaleDown, image: AssetImage('assets/images/item_box.png')),
                  ),
                  child: Center(
                    child: Image.asset('assets/images/shop_items/items/${item.path}'),
                  ),
                  // color: Colors.amber,
                ),
                // Container(
                //   width: constraints.maxWidth,
                //   child: Center(child: Text('Test')),
                // ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 35,
                  child: Center(
                    child: Text(
                      item.name,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Visibility(
                  visible: !isDefaultItem,
                  child: Positioned(
                    left: 0,
                    right: 0,
                    bottom: 55,
                    child: Center(
                      child: Visibility(
                        visible: item.purchased,
                        replacement: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amberAccent,
                            ),
                            Text(
                              '${item.cost}',
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ],
                        ),
                        child: Text(
                          selected ? context.watch<LanguageProvider>().equiped : '',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !isDefaultItem,
                  child: Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    // width: 150,
                    height: 30,
                    child: Center(
                      child: Visibility(
                        visible: !item.purchased,
                        child: SizedBox(
                          width: 75,
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
                                            '${context.watch<LanguageProvider>().purchaseItemDialog1} ${item.name} ${context.watch<LanguageProvider>().forString} ${item.cost} stars?',
                                          ),
                                          SizedBox(
                                            height: 24,
                                          ),
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
                                                  height: 75,
                                                  width: 200,
                                                  decoration: BoxDecoration(
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
                                                  height: 75,
                                                  width: 200,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: AssetImage('assets/images/plank wood.png'),
                                                    ),
                                                  ),
                                                  child:
                                                      Center(child: Text(context.watch<LanguageProvider>().noThanks)),
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
                                  //     'You want to buy ${item.name} for ${item.cost} stars?',
                                  //     style: TextStyle(color: Colors.white),
                                  //   ),
                                  //   actions: [
                                  //     ElevatedButton(
                                  //       onPressed: (shopStar < item.cost)
                                  //           ? null
                                  //           : () {
                                  //               context.read<ShopData>().purchaseItem(item);
                                  //               AudioManager.instance.playSfx(AudioSfx.katching);
                                  //               context.pop();
                                  //             },
                                  //       child: Text(shopStar < item.cost ? 'Not Enough Star =(' : 'Yes Please!'),
                                  //     ),
                                  //     ElevatedButton(
                                  //       onPressed: () {
                                  //         AudioManager.instance.playSfx(AudioSfx.click);
                                  //         context.pop();
                                  //       },
                                  //       child: Text('No, thanks'),
                                  //     )
                                  //   ],
                                  // );
                                },
                              );
                            },
                            child: Text(context.watch<LanguageProvider>().buy, style: TextStyle(fontSize: 10)),
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
}
