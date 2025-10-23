import 'package:dino_run/models/shop/background.dart';
import 'package:dino_run/models/shop/character.dart';
import 'package:dino_run/models/shop/item.dart';
import 'package:dino_run/models/shop/shop.dart';
import 'package:dino_run/repositories/data/datasource.dart';
import 'package:dino_run/repositories/data/item_data.dart';
import 'package:dino_run/repositories/shop_repository.dart';
import 'package:hive/hive.dart';

class ShopRepositoryImpl implements ShopRepository {
  final Datasource datasource;

  ShopRepositoryImpl({required this.datasource});

  Box<Character> get _characterBox => datasource.characterBox;
  Box<Item> get _itemBox => datasource.itemBox;
  Box<Background> get _backgroundBox => datasource.backgroundBox;
  Box<Shop> get _shopBox => datasource.shopBox;

  // late Box<Character> _characterBox;
  // late Box<Item> _itemBox;
  // late Box<Background> _backgroundBox;
  // late Box<Shop> _shopBox;

  // @override
  // Future<void> init() async {
  //   if (!Hive.isAdapterRegistered(8)) Hive.registerAdapter(CharacterAdapter());
  //   if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(ItemAdapter());
  //   if (!Hive.isAdapterRegistered(7)) Hive.registerAdapter(BackgroundAdapter());
  //   if (!Hive.isAdapterRegistered(9)) Hive.registerAdapter(ShopAdapter());

  //   _characterBox = await Hive.openBox<Character>('character');
  //   _itemBox = await Hive.openBox<Item>('item');
  //   _backgroundBox = await Hive.openBox<Background>('background');
  //   _shopBox = await Hive.openBox<Shop>('shop');

  //   await _shopBox.clear();
  //   await _characterBox.clear();
  //   await _itemBox.clear();
  //   await _backgroundBox.clear();

  //   if (_characterBox.isEmpty) {
  //     await _characterBox.addAll(characterData);
  //   }
  //   if (_itemBox.isEmpty) {
  //     await _itemBox.addAll([...headItemData, ...eyeItemData, ...shirtItemData]);
  //   }

  //   if (_backgroundBox.isEmpty) {
  //     _backgroundBox.addAll(backgroundData);
  //   }
  // }

  @override
  List<Character> getCharacters() {
    return _characterBox.values.toList();
  }

  @override
  List<Item> getItems() {
    return _itemBox.values.toList();
  }

  @override
  List<Background> getBackgrounds() {
    return _backgroundBox.values.toList();
  }

  @override
  Future<void> purchaseItem(Item item) async {
    item.purchased = true;
    getShop()
      ..star -= item.cost
      ..save();
    await item.save();
  }

  @override
  Future<void> purchaseBackground(Background background) async {
    background.purchased = true;
    await background.save();
    getShop()
      ..star -= background.cost
      ..save();
  }

  @override
  Shop getShop() {
    if (_shopBox.isEmpty) {
      _shopBox.add(
        Shop(
          star: 0,
          characterSelected: _characterBox.values.first,
          headItemSelected:
              getItems().where((element) => element.riveInputCategory == RiveItemCategory.headChoices.name).first,
          eyeItemSelected:
              getItems().where((element) => element.riveInputCategory == RiveItemCategory.eyeChoices.name).first,
          shirtItemSelected:
              getItems().where((element) => element.riveInputCategory == RiveItemCategory.shirtPrintChoices.name).first,
          backgroundSelected: getBackgrounds().first,
        ),
      );
    }

    print('${_shopBox.values.toString()}');

    return _shopBox.values.first;
  }

  @override
  Future<void> setStar(int star) async {
    _shopBox.values.first
      ..star = star
      ..save();
    // await _shopBox.values.first.save();
  }

  @override
  Future<void> purchaseCharacter(Character character) async {
    character.purchased = true;
    await character.save();
    getShop()
      ..star -= character.cost
      ..save();
  }
}
