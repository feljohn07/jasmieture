import 'package:dino_run/models/shop/item.dart';
import 'package:dino_run/screens/shop/item_view.dart';
import 'package:dino_run/screens/shop/player_view.dart';
import 'package:dino_run/view_models.dart/rive_provider.dart';
import 'package:dino_run/view_models.dart/shop_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  static const id = 'ShopScreen';

  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  // StateMachineController? _controller;
  // SMIInput<double>? _headItem;
  // SMIInput<double>? _eyeItem;
  // SMIInput<double>? _shirtItem;

  @override
  void initState() {
    super.initState();
    // always display the current selected character on the preview.
    syncShopAndRiveData();
  }

  void syncShopAndRiveData() {
    context.read<ShopData>().characterPreview = context.read<ShopData>().shop.characterSelected;
    Provider.of<RiveProvider>(context, listen: false)
        .loadCharacterArtboard(context.read<ShopData>().characterPreview, context.read<ShopData>().shop);
  }

  // void _onRiveInit(Artboard artboard) async {
  //   _controller = StateMachineController.fromArtboard(artboard, 'State Machine');
  //   if (_controller != null) {
  //     artboard.addController(_controller!);
  //     _headItem = _controller!.findInput<double>('head_choices');
  //     _eyeItem = _controller!.findInput<double>('eye_choices');
  //     _shirtItem = _controller!.findInput<double>('shirt_print_choices');
  //     _headItem?.value = context.read<ShopData>().shop.headItemSelected.riveId;
  //     _eyeItem?.value = context.read<ShopData>().shop.eyeItemSelected.riveId;
  //     _shirtItem?.value = context.read<ShopData>().shop.shirtItemSelected.riveId;
  //   }

  //   // print('init called');
  // }

  void _switchItem(Item item) {
    // setState(() {
    //   if (item.riveInputCategory == RiveItemCategory.headChoices.name) {
    //     _headItem?.value = item.riveId;
    //     if ((_headItem?.value ?? 0) > 10) _headItem?.value = 0;
    //   } else if (item.riveInputCategory == RiveItemCategory.eyeChoices.name) {
    //     _eyeItem?.value = item.riveId;
    //     if ((_eyeItem?.value ?? 0) > 10) _eyeItem?.value = 0;
    //   } else if (item.riveInputCategory == RiveItemCategory.shirtPrintChoices.name) {
    //     _shirtItem?.value = item.riveId;
    //     if ((_shirtItem?.value ?? 0) > 10) _shirtItem?.value = 0;
    //   }
    // });

    context.read<ShopData>().setItem(item);
    context
        .read<RiveProvider>()
        .loadCharacterArtboard(context.read<ShopData>().characterPreview, context.read<ShopData>().shop);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: PlayerView(
                        // onRiveInit: _onRiveInit,
                        // characterName: characterNames[selectedCharacter],
                        // swapCharacter: swapCharacter,
                        // switchItem: _switchItem,
                        ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ItemsView(
                      switchItem: _switchItem,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
