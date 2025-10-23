import 'package:dino_run/models/shop/character.dart';
import 'package:dino_run/models/shop/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RiveProvider extends ChangeNotifier {
  late RiveFile _file;
  late ByteData _data;

  Artboard? _artboard;
  StateMachineController? _controller;

  Artboard? get artboard => _artboard;
  StateMachineController? get controller => _controller;

  SMIInput<double>? _headItem;
  SMIInput<double>? _eyeItem;
  SMIInput<double>? _shirtItem;

  Future<void> initRive(Shop shop) async {
    _data = await rootBundle.load('assets/rive/running_and_jumping (13).riv');
    _file = RiveFile.import(_data);
    final artboard = _file.artboards.firstWhere(
      (a) => a.name == shop.characterSelected.riveId,
      orElse: () => _file.mainArtboard,
    );

    final controller = StateMachineController.fromArtboard(artboard, 'State Machine');
    if (controller != null) {
      artboard.addController(controller);
    }

    _artboard = artboard;
    _controller = controller;

    _headItem = _controller!.findInput<double>('head_choices');
    _eyeItem = _controller!.findInput<double>('eye_choices');
    _shirtItem = _controller!.findInput<double>('shirt_print_choices');
    _headItem?.value = shop.headItemSelected.riveId;
    _eyeItem?.value = shop.eyeItemSelected.riveId;
    _shirtItem?.value = shop.shirtItemSelected.riveId;

    notifyListeners();
  }

  Future<void> loadCharacterArtboard(Character character, Shop shop) async {
    final artboard = _file.artboards.firstWhere(
      (a) => a.name == character.riveId,
      orElse: () => _file.mainArtboard,
    );

    final controller = StateMachineController.fromArtboard(artboard, 'State Machine');
    if (controller != null) {
      artboard.addController(controller);
    }

    _artboard = artboard;
    _controller = controller;

    _headItem = _controller!.findInput<double>('head_choices');
    _eyeItem = _controller!.findInput<double>('eye_choices');
    _shirtItem = _controller!.findInput<double>('shirt_print_choices');
    _headItem?.value = shop.headItemSelected.riveId;
    _eyeItem?.value = shop.eyeItemSelected.riveId;
    _shirtItem?.value = shop.shirtItemSelected.riveId;

    notifyListeners();
  }

  // Future<void>
}
