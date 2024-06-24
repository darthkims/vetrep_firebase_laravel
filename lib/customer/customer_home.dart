import 'package:flutter/material.dart';
import 'package:vetrep/customer/customer_navbar.dart';
import 'package:vetrep/customer/customer_profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int currentPageIndex = 0;

  void onItemTapped(int index) {
      switch (index) {
        case 0:

          break;
        case 1:

          break;
        case 2:

          break;
        case 3:

          break;
        case 4:
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage())
          );
          break;
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

      ),
      bottomNavigationBar: Navbar(currentPageIndex: currentPageIndex, onItemTapped: onItemTapped),
    );
  }
}
