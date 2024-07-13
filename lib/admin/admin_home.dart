import 'package:flutter/material.dart';
import 'package:vetrep/admin/add_clinic.dart';
import 'package:vetrep/admin/admin_navbar.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final int currentPageIndex = 0;

  void onItemTapped(int index) {
    switch (index) {
      case 0:
      // Handle navigation or action for item 0
        break;
      case 1:
      // Handle navigation or action for item 1
        break;
      case 2:
      // Handle navigation or action for item 2
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network("https://media.tenor.com/YUo9TqxYo0IAAAAM/speed-ishowspeed.gif"),
              SizedBox(height: 20),
              Image.network("https://media.tenor.com/t3eKwU-odDgAAAAM/sui-siu.gif"),
              SizedBox(height: 20),
              Image.network("https://media4.giphy.com/media/9mlhTFNmxWGkwKvNlL/200w.gif?cid=6c09b952mgb4ecwkx2g1cww11bctnrxas80claemhgtju67j&ep=v1_gifs_search&rid=200w.gif&ct=g"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add functionality for the button here
                  // For example, navigate to another screen:
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddClinicPage()));
                },
                child: Text('Your Button Text'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AdminNavbar(currentPageIndex: currentPageIndex, onItemTapped: onItemTapped),
    );
  }
}

class YourNextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Next Screen'),
      ),
      body: Center(
        child: Text('This is your next screen.'),
      ),
    );
  }
}
