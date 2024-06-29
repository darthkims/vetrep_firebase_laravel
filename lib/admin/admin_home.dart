import 'package:flutter/material.dart';
import 'package:vetrep/admin/admin_navbar.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
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

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network("https://media.tenor.com/YUo9TqxYo0IAAAAM/speed-ishowspeed.gif"),
              Image.network("https://media.tenor.com/t3eKwU-odDgAAAAM/sui-siu.gif"),
              Image.network("https://media4.giphy.com/media/9mlhTFNmxWGkwKvNlL/200w.gif?cid=6c09b952mgb4ecwkx2g1cww11bctnrxas80claemhgtju67j&ep=v1_gifs_search&rid=200w.gif&ct=g")
            ],
          ),
        )
      ),
      bottomNavigationBar: AdminNavbar(currentPageIndex: currentPageIndex, onItemTapped: onItemTapped),
    );
  }
}
