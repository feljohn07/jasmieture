import 'package:dino_run/models/shop/background.dart';
import 'package:dino_run/models/shop/character.dart';
import 'package:dino_run/models/shop/item.dart';
import 'package:dino_run/models/shop/shop.dart';
import 'package:dino_run/repositories/data/item_data.dart';
import 'package:dino_run/repositories/shop_repository.dart';
import 'package:flutter/widgets.dart';

enum SwapDirection {
  left,
  right,
}

class ShopData extends ChangeNotifier {
  final ShopRepository shopRepository;

  late Shop shop;

  List<Character> characters = [];
  List<Item> characterItems = [];
  List<Background> backgrounds = [];

  int get star => shop.star;

  int get selectedCharacterIndex => characters.indexOf(characterPreview);

  late Character characterPreview;

  void swapCharacter(SwapDirection direction) {
    // 1. Find the current index of the selected character.
    // This is a safe way to get the index.
    // final currentIndex = characters.indexOf(shop.characterSelected);
    final currentIndex = characters.indexOf(characterPreview);

    print('${characters.indexOf(shop.characterSelected)} ${shop.characterSelected.toString()}');

    // 2. If for some reason no character is selected or it's not in the list,
    // we can't proceed, so we exit the function.
    if (currentIndex == -1) {
      return;
    }

    // 3. Calculate the next index using modular arithmetic for looping.
    // This removes the need for boundary checks.
    final int newIndex;
    if (direction == SwapDirection.left) {
      // This formula handles wrapping around to the end when currentIndex is 0.
      newIndex = (currentIndex - 1 + characters.length) % characters.length;
    } else {
      // This handles SwapDirection.right
      // This formula handles wrapping around to the beginning when at the end of the list.
      newIndex = (currentIndex + 1) % characters.length;
    }

    // TODO - conditional: if character is not purchased, dont save as selected,

    characterPreview = characters[newIndex];

    if (characters[newIndex].purchased) {
      // 4. Update the selected character with the new one from the list.
      shop.characterSelected = characters[newIndex];
      // 5. Persist the change and notify any listeners to update the UI.
      shop.save();
    }

    notifyListeners();

    // Optional: A print statement for debugging to confirm the swap.
    print("Swapped to character: ${shop.characterSelected.riveId}");
  }

  void setItem(Item item) {
    print(' === ${shopRepository.getItems().toList().toString()}');

    if (item.riveInputCategory == RiveItemCategory.headChoices.name) {
      shop.headItemSelected = item;
      shop.save();
    } else if (item.riveInputCategory == RiveItemCategory.eyeChoices.name) {
      shop.eyeItemSelected = item;
      shop.save();
    } else if (item.riveInputCategory == RiveItemCategory.shirtPrintChoices.name) {
      shop.shirtItemSelected = item;
      shop.save();
    }
    notifyListeners();
  }

  void setBackground(Background background) {
    shop.backgroundSelected = background;
    shop.save();
    notifyListeners();
  }

  void setStar(int value) async {
    await shopRepository.setStar(value);
    notifyListeners();
  }

  void purchaseItem(Item item) async {
    await shopRepository.purchaseItem(item);
    notifyListeners();
  }

  List<Item> get headItems =>
      characterItems.where((element) => element.riveInputCategory == RiveItemCategory.headChoices.name).toList();
  List<Item> get eyeItems =>
      characterItems.where((element) => element.riveInputCategory == RiveItemCategory.eyeChoices.name).toList();
  List<Item> get shirtItems =>
      characterItems.where((element) => element.riveInputCategory == RiveItemCategory.shirtPrintChoices.name).toList();

  ShopData({required this.shopRepository}) {
    _init();
  }

  Future<void> _init() async {
    characters = shopRepository.getCharacters();
    characterItems = shopRepository.getItems();
    backgrounds = shopRepository.getBackgrounds();
    shop = shopRepository.getShop();

    characterPreview = shop.characterSelected;

    shop.star = 500; // TODO - for testing only, delete in production.
  }

  void purchaseBackground(Background background) {
    shopRepository.purchaseBackground(background);
    notifyListeners();
  }

  void purchaseCharacter(Character character) {
    shopRepository.purchaseCharacter(character);
    shop.characterSelected = character;
    shop.save();
    notifyListeners();
  }
}
