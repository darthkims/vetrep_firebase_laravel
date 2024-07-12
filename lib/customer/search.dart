import 'package:flutter/material.dart';
import 'package:vetrep/customer/customer_appointment_list.dart';
import 'package:vetrep/customer/customer_navbar.dart';
import 'customer_book_appointment.dart';
import 'customer_home.dart';
import 'customer_profile.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final int currentPageIndex = 1;

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
            context, MaterialPageRoute(builder: (context) => Book()));
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
      appBar: AppBar(
        title: Text('Search For Vet Clinic Around You'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: Navbar(
          currentPageIndex: currentPageIndex, onItemTapped: onItemTapped),
    );
  }
}
