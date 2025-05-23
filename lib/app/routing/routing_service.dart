import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iotec/app/layouts/layout_with_scaffold.dart';
import 'package:iotec/app/routing/routes.dart';
import 'package:iotec/features/user_videos/presentation/screens/user_videos_screen.dart';
import 'package:iotec/features/video_stream/presentation/screens/home_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: "root",
);

class RoutingService {
  RoutingService();
  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true, //? for debugging

    initialLocation: Routes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) => LayoutScaffoldWithNav(
              navigationShell: navigationShell,
              title: state.matchedLocation,
            ),
        branches: <StatefulShellBranch>[
          // ? branch 1: Home
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: Routes.home,
                path: Routes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // ? branch 2 : user videos
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: Routes.videos,
                path: Routes.videos,
                builder: (context, state) => const UserVideosScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
