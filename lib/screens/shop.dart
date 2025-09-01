import 'package:dino_run/game/dino_run.dart';
import 'package:dino_run/models/player_data.dart';
import 'package:dino_run/widgets/main_menu.dart';
import 'package:dino_run/widgets/pause_menu.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  static const id = 'ShopScreen';

  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<String> characterNames = [
    'Character 1',
    'Character 2',
    'Character 2',
  ];

  int selectedCharacter = 0;

  // 🔹 Rive Variables moved here
  StateMachineController? _controller;
  SMIInput<double>? _headItem;
  SMIInput<double>? _eyeItem;
  SMIInput<double>? _shirtItem;

  double head = 0;
  double eye = 0;
  double shirt = 0;

  @override
  void initState() {
    super.initState();
    eye = context.read<PlayerData>().eyeItem;
    head = context.read<PlayerData>().headItem;
    shirt = context.read<PlayerData>().shirtItem;
    selectedCharacter = characterNames.indexOf(context.read<PlayerData>().character);
  }

  void _onRiveInit(Artboard artboard) async {
    _controller = StateMachineController.fromArtboard(artboard, 'State Machine');
    if (_controller != null) {
      artboard.addController(_controller!);
      _headItem = _controller!.findInput<double>('head_choices');
      _eyeItem = _controller!.findInput<double>('eye_choices');
      _shirtItem = _controller!.findInput<double>('shirt_print_choices');
      _headItem?.value = head;
      _eyeItem?.value = eye;
      _shirtItem?.value = shirt;
    }

    print('init called');
  }

  void _switchItem(String item, double num) {
    setState(() {
      if (item == 'head') {
        _headItem?.value = num + 1;
        if ((_headItem?.value ?? 0) > 10) _headItem?.value = 0;
      } else if (item == 'eye') {
        _eyeItem?.value = num + 1;
        if ((_eyeItem?.value ?? 0) > 10) _eyeItem?.value = 0;
      } else if (item == 'shirt') {
        _shirtItem?.value = num + 1;
        if ((_shirtItem?.value ?? 0) > 10) _shirtItem?.value = 0;
      }
    });
  }

  swapCharacter(String direction) {
    head = _headItem?.value ?? 0;
    eye = _eyeItem?.value ?? 0;
    shirt = _shirtItem?.value ?? 0;

    if (direction == 'LEFT') {
      selectedCharacter = (selectedCharacter - 1 + characterNames.length) % characterNames.length;
    } else if (direction == 'RIGHT') {
      selectedCharacter = (selectedCharacter + 1) % characterNames.length;
    }

    context.read<PlayerData>().setCharacter(characterNames[selectedCharacter]);

    // print('HEad item - ${_headItem?.value}');
    print('shop - ${characterNames[selectedCharacter]}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _PlayerView(
                    onRiveInit: _onRiveInit,
                    characterName: characterNames[selectedCharacter],
                    swapCharacter: swapCharacter,
                    // switchItem: _switchItem,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _ItemsView(
                    switchItem: _switchItem,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// 🔹 PlayerView now just consumes the callbacks
class _PlayerView extends StatelessWidget {
  final void Function(Artboard) onRiveInit;
  final String characterName;
  final Function(String direction) swapCharacter;
  // final void Function(double) switchItem;

  const _PlayerView({
    required this.onRiveInit,
    this.characterName = 'Character ',
    required this.swapCharacter,
    // required this.switchItem,
  });

  @override
  Widget build(BuildContext context) {
    // print(characterName);
    return Container(
      color: Colors.green,
      child: Stack(
        children: [
          _ShopHeader(),
          Center(
            child: Padding(
              padding: EdgeInsetsGeometry.all(74),
              child: RiveAnimation.asset(
                'assets/rive/running_and_jumping (9).riv',
                artboard: characterName,
                stateMachines: ['State Machine'],
                onInit: onRiveInit,
                fit: BoxFit.contain,
                placeHolder: const CircularProgressIndicator(),
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    swapCharacter('LEFT');
                    // context.read<PlayerData>().setCharacter(characterName);
                  },
                  child: Icon(Icons.arrow_back),
                ),
                InkWell(
                  onTap: () {
                    swapCharacter('RIGHT');
                    // context.read<PlayerData>().setCharacter(characterName);
                  },
                  child: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ItemsView extends StatelessWidget {
  final void Function(String item, double num) switchItem;
  const _ItemsView({required this.switchItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Head',
                  style: TextStyle(fontSize: 24),
                ),
                Text('Clear')
              ],
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () {
                        switchItem('head', double.parse('$index'));
                        context.read<PlayerData>().setHeadItem = double.parse('$index');
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        color: Colors.amber,
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Glasses',
                  style: TextStyle(fontSize: 24),
                ),
                Text('Clear')
              ],
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      switchItem('eye', double.parse('$index'));
                      context.read<PlayerData>().setEyeItem = double.parse('$index');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        height: 150,
                        width: 150,
                        color: Colors.amber,
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shirts',
                  style: TextStyle(fontSize: 24),
                ),
                Text('Clear')
              ],
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      switchItem('shirt', double.parse('$index'));
                      context.read<PlayerData>().setShirtItem = double.parse('$index');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        height: 150,
                        width: 150,
                        color: Colors.amber,
                      ),
                    ),
                  );
                },
              ),
            ),
            Text(
              'Background and Theme',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      height: 150,
                      width: 300,
                      color: Colors.amber,
                    ),
                  );
                },
              ),
            ),
            Text(
              'Music',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      height: 150,
                      width: 150,
                      color: Colors.amber,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopHeader extends StatelessWidget {
  const _ShopHeader();

  @override
  Widget build(BuildContext context) {
    final stars = context.watch<PlayerData>().shopStar;

    return Container(
      height: 75,
      color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(
            onPressed: () {
              context.go('/');
            },
          ),
          Row(
            children: [
              Icon(Icons.star),
              Text('$stars'), // TODO - display here the current stars own by the player
            ],
          ),
        ],
      ),
    );
  }
}
