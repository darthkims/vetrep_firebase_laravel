import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vetrep/customer/customer_appointment_list.dart';
import 'package:vetrep/customer/customer_book_appointment.dart';
import 'package:vetrep/customer/customer_home.dart';
import 'package:vetrep/customer/customer_navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final int currentPageIndex = 4;

  void onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home())
        );

        break;
      case 1:

        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Book())
        );

        break;
      case 3:
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomerAppointmentList())
        );
        break;
      case 4:

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String displayName = user?.displayName ?? 'User';
    String email = user?.email ?? 'Email';

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
                child: Text("Welcome $displayName", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)),
            Text(email),

          ],
        ),
      ),
      bottomNavigationBar: Navbar(currentPageIndex: currentPageIndex, onItemTapped: onItemTapped),
    );
  }
}
