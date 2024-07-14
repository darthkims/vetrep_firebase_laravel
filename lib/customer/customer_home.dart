import 'package:flutter/material.dart';
import 'package:vetrep/customer/customer_appointment_list.dart';
import 'package:vetrep/customer/customer_navbar.dart';
import 'package:vetrep/customer/customer_profile.dart';
import 'package:vetrep/customer/search.dart';

import 'customer_book_appointment.dart';

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
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchPage())
        );
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Book()));

        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F3F2),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1, // Takes 1/3 of the height
              child: Container(
                color: Colors.green,
                child: Center(
                  child: Image.asset("assets/images/splash_icon.png"),
                ),
              ),
            ),
            Expanded(
              flex: 2, // Takes 2/3 of the height
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.transparent, // Just for visibility, change as needed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.transparent)
                        ),
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2, // Takes 1/3 of the height
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text("View appointment", style: TextStyle(fontSize: 25),),
                              ),
                            ),
                            VerticalDivider(),
                            Expanded(
                                flex: 1, // Takes 1/3 of the height
                                child: Container(
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerAppointmentList()));},
                                      icon: Icon(Icons.calendar_month, size: 40,))
                                )),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(
          currentPageIndex: currentPageIndex, onItemTapped: onItemTapped),
    );
  }
}
