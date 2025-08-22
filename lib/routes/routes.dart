import 'package:dino_run/main.dart';
import 'package:dino_run/screens/chapters.dart';
import 'package:dino_run/screens/levels.dart';
import 'package:dino_run/screens/shop.dart';
import 'package:go_router/go_router.dart';

final routes = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return LevelScreen();
      },
    ),
    GoRoute(
      path: '/chapters',
      builder: (context, state) {
        return ChaptersScreen();
      },
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) {
        return GameScreen();
      },
    ),
    GoRoute(
      path: '/shop',
      builder: (context, state) {
        return ShopScreen();
      },
    ),
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) {
    //     return ShopScreen();
    //   },
    // ),
  ],
);
