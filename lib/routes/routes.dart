import 'package:dino_run/screens/levels.dart';
import 'package:dino_run/screens/shop.dart';
import 'package:go_router/go_router.dart';

final routes = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) {
      return LevelScreen();
    },
  ),
  GoRoute(
    path: '/',
    builder: (context, state) {
      return ShopScreen();
    },
  ),
]);
