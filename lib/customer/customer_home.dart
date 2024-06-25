import 'package:flutter/material.dart';
import 'package:vetrep/customer/customer_appointment_list.dart';
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
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomerAppointmentList())
          );
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
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network("https://media.tenor.com/-dM-IPQYv_MAAAAM/antony-antony-substitute.gif",),
            Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLKQAA8zurKr57uEztdBJPgXopAwWGoUCXFQ&s")
          ],
        ),
      ),
      bottomNavigationBar: Navbar(currentPageIndex: currentPageIndex, onItemTapped: onItemTapped),
    );
  }
}
