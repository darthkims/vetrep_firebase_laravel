import 'package:flutter/material.dart';

class AdminNavbar extends StatelessWidget {
  final int currentPageIndex;
  final Function(int) onItemTapped;

  const AdminNavbar({
    required this.currentPageIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
        data: NavigationBarThemeData(

        ),
        child: NavigationBar(
          height: 75,
          destinations: const <Widget> [
            NavigationDestination(
                icon: Icon(Icons.home),
                label: "Home"),
            NavigationDestination(
                icon: Icon(Icons.link),
                label: "Register Clinic"),
            NavigationDestination(
                icon: Icon(Icons.link),
                label: "Link"),
          ],
        )
    );
  }
}
