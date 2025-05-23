import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iotec/app/layouts/destinations.dart';
import 'package:iotec/app/routing/routes.dart';

class LayoutScaffoldWithNav extends StatelessWidget {
  const LayoutScaffoldWithNav({
    super.key,
    required this.navigationShell,
    required this.title,
  });

  final StatefulNavigationShell navigationShell;
  final String title;

  @override
  Widget build(BuildContext context) {
    String appBarTitle = "";
    if (title == Routes.home) {
      appBarTitle = "Home";
      print("Should be home: $title");
    } else {
      appBarTitle = "Videos";
      print("Should be videos: $title");
    }
    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      // resizeToAvoidBottomInset: false,
      body:
      //  SafeArea(child:
      SafeArea(child: navigationShell),
      // )
      bottomNavigationBar: NavigationBar(
        destinations:
            destinations
                .map(
                  (d) => NavigationDestination(
                    icon: Icon(d.icon),
                    label: d.label,
                    selectedIcon: Icon(d.icon),
                  ),
                )
                .toList(),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
      ),
    );
  }
}
