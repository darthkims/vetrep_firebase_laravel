import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final int currentPageIndex;
  final Function(int) onItemTapped;

  const Navbar({
    required this.currentPageIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        // labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
        //       (Set<WidgetState> states) => states.contains(WidgetState.selected)
        //       ? const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)
        //       : const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        // ),
      ),
      child: NavigationBar(
        height: 75,
        onDestinationSelected: onItemTapped,
        indicatorColor: Colors.white,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month_outlined, size: 30, color: Colors.green,),
            icon: Icon(Icons.calendar_month, size: 30, color: Colors.green,),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.search_outlined, size: 30, color: Colors.green,),
            icon: Icon(Icons.search, color: Colors.green, size: 30, ),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.add_circle_outline, size: 30, color: Colors.green,),
            icon: Icon(Icons.add_circle, color: Colors.green, size: 30,),
            label: 'Book Now', // Empty label for a cleaner look (optional)
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle_outlined, size: 30, color: Colors.green,),
            icon: Icon(Icons.account_circle, color: Colors.green, size: 30,),
            label: 'Profile', // Empty label for a cleaner look (optional)
          ),
        ],
      ),
    );
  }
}
