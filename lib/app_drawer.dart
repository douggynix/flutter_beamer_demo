import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Main'),
              //selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                context.beamToNamed('/');
              },
            ),
            ListTile(
              title: const Text('Business'),
              //selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('School'),
              //selected: _selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
  }
}
