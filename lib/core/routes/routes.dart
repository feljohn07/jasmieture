import 'package:dino_run/models/game/history.dart';
import 'package:dino_run/models/player_data.dart';
import 'package:dino_run/screens/chapters.dart';
import 'package:dino_run/screens/create_player_screen.dart';
import 'package:dino_run/screens/game_history_screen.dart';
import 'package:dino_run/screens/levels.dart';
import 'package:dino_run/screens/main_menu_screen.dart';
import 'package:dino_run/screens/profile_screen.dart';
import 'package:dino_run/screens/settings_screen.dart';
import 'package:dino_run/screens/game_screen.dart';
import 'package:dino_run/screens/shop/shop.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final routes = GoRouter(
  // initialLocation: CreateProfileScreen.path,
  initialLocation: '/',
  redirect: (context, state) {
    final player = context.read<PlayerData>().playerRepository.getPlayer();
    if (player == null) {
      return CreateProfileScreen.path;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: MainMenuScreen.path,
      pageBuilder: (context, state) {
        return NoTransitionPage(child: MainMenuScreen());
      },
    ),
    GoRoute(
      path: '/history',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: GameHistoryScreen());
      },
    ),
    GoRoute(
      path: '/levels',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: LevelScreen());
      },
    ),
    GoRoute(
      path: '/chapters',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: ChaptersScreen(level: state.extra as int));
      },
    ),
    GoRoute(
      path: '/game',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: GameScreen());
      },
    ),
    GoRoute(
      path: '/shop',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: ShopScreen());
      },
    ),
    GoRoute(
      path: '/profile',
      // builder: (context, state) {
      //   return  ProfileScreen();
      // },
      pageBuilder: (context, state) => NoTransitionPage(child: ProfileScreen()),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) {
        return NoTransitionPage(child: SettingsScreen());
      },
    ),
    GoRoute(
      path: CreateProfileScreen.path,
      pageBuilder: (context, state) {
        return NoTransitionPage(child: CreateProfileScreen());
      },
    ),
    GoRoute(
      path: ProfileScreen.path,
      pageBuilder: (context, state) {
        return NoTransitionPage(child: ProfileScreen());
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
