import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iotec/app/layouts/destinations.dart';

class LayoutScaffoldWithNav extends StatelessWidget {
  const LayoutScaffoldWithNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("LayoutScaffold")),
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
