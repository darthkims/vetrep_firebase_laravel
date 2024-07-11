import 'package:flutter/material.dart';
import 'package:vetrep/customer/customer_home.dart';
import 'package:vetrep/customer/customer_navbar.dart';
import 'package:vetrep/customer/customer_profile.dart';

import 'customer_book_appointment.dart';

class CustomerAppointmentList extends StatefulWidget {
  const CustomerAppointmentList({super.key});

  @override
  State<CustomerAppointmentList> createState() => _CustomerAppointmentListState();
}

class _CustomerAppointmentListState extends State<CustomerAppointmentList> {
  final int currentPageIndex = 3;

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
        title: Text("My Appointment"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              GestureDetector(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: Text('Choose your action'),
                        children: <Widget>[
                          SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context);
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => Login()),
                                // );
                              },
                              child: ListTile(
                                leading: Icon(Icons.calendar_month_outlined),
                                title: Text('Reschedule'),
                              )
                          ),
                          SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(builder: (context) => AdminLogin())
                                // );
                              },
                              child: ListTile(
                                leading: Icon(Icons.delete),
                                title: Text('Delete'),
                              )
                          ),
                        ],
                      );
                    },
                  );
                },
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context){
                        return Container(
                          padding: EdgeInsets.all(10),
                          width: double.infinity, // Ensure the modal sheet takes full width
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Center(
                                    child: Text(
                                        'Pet Details',
                                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                    )
                                ),
                              ),
                              Divider(),
                              Text("Name:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                              Text("Meow", style: TextStyle(fontSize: 25),),
                              SizedBox(height: 10),
                              // Add more content here as needed
                            ],
                          ),
                        );
                      });
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xffBAE7D2),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Column for Name, Age, Date on the left side
                      Positioned(
                        left: 10,
                        top: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '5 June 2024',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black54),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Name: Meow',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Age: 2',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  'Clinics: Klinik Haiwan Jasin',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                ),
                                SizedBox(width: 10,),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: IconButton(
                                      onPressed: () {
                                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                                        scaffoldMessenger.showSnackBar(
                                          const SnackBar(
                                            content: Text('Location Clicked'),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.location_on)
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                      // Status indicator on the top right
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Completed',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 60, // Adjust the top position as needed
                        right: 30,
                        child: Icon(
                            Icons.male, // Example: replace with your gender icon
                            size: 60,
                            color: Colors.blue, // Example: customize the icon color
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(currentPageIndex: currentPageIndex, onItemTapped: onItemTapped),
    );
  }
}
