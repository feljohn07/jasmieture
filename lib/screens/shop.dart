import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            _ShopHeader(),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _PlayerView(),
                  ),
                  Expanded(
                    flex: 2,
                    child: _ItemsView(),
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

class _ShopHeader extends StatelessWidget {
  const _ShopHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(),
          Row(
            children: [
              Icon(Icons.star),
              Text('999999'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerView extends StatefulWidget {
  const _PlayerView();

  @override
  State<_PlayerView> createState() => __PlayerViewState();
}

class __PlayerViewState extends State<_PlayerView> {
  // Controller for the Rive animation
  StateMachineController? _controller;

  // Input for the state machine
  SMIInput<double>? _headItem;
  SMIInput<bool>? _jump;

  void _onRiveInit(Artboard artboard) {
    // Get the state machine controller
    _controller = StateMachineController.fromArtboard(artboard, 'State Machine');
    if (_controller != null) {
      artboard.addController(_controller!);
      // Get the boolean input from the state machine
      _headItem = _controller!.findInput<double>('head_choices');
      _jump = _controller!.findInput<bool>('Jump');
      // Set the initial value
      _headItem?.value = 0;
      _jump?.value = false;
    }
  }

  void _switchItem(double num) {
    setState(() {
      _headItem!.value = _headItem!.value + 1;
      if (_headItem!.value > 5) _headItem!.value = 0;
      _jump?.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Stack(
        children: [
          Center(
            child: InkWell(
              onTap: () {
                _switchItem(1);
              },
              child: RiveAnimation.asset(
                'assets/rive/running_and_jumping (3).riv',
                artboard: 'Character 1',
                stateMachines: ['State Machine'],
                onInit: _onRiveInit,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Icon(Icons.arrow_back), Icon(Icons.arrow_forward)],
            ),
          )
        ],
      ),
    );
  }
}

class _ItemsView extends StatelessWidget {
  const _ItemsView();

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
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () {},
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
                itemCount: 5,
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
                itemCount: 5,
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
