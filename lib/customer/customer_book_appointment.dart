import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'customer_home.dart';
import 'customer_navbar.dart';
import 'customer_profile.dart';
import 'search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VetRep',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Book(),
    );
  }
}

class Book extends StatefulWidget {
  const Book({super.key});

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  final int currentPageIndex = 2;
  final _formKey = GlobalKey<FormState>();
  String _clinicId = '';
  String _slotId = '';
  String _userPhoneNo = '';
  DateTime _selectedDate = DateTime.now();
  bool _isConfirmed = false;

  void onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
        break;
      case 2:
      // Current page, no navigation needed
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    // case 4:
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => ProfilePage())
    //   );
    //   break;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var url = Uri.parse('http://yourlaravelapi.com/api/clinic-bookings'); // Replace with your API URL
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'clinic_id': _clinicId,
          'slot_id': _slotId,
          'user_phone_no': _userPhoneNo,
          'booking_date': _selectedDate.toIso8601String().split('T')[0], // Format: YYYY-MM-DD
          'is_confirmed': _isConfirmed ? 1 : 0,
        }),
      );

      if (response.statusCode == 201) {
        // Successfully stored
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking created successfully')),
        );
      } else {
        // Error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create booking')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Book Appointment'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Clinic ID',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Clinic ID';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _clinicId = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Slot ID',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Slot ID';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _slotId = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'User Phone Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter User Phone Number';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _userPhoneNo = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ListTile(
                title: Text("Booking Date: ${_selectedDate.toLocal()}".split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 16.0),
              Text("Selected Date: ${_selectedDate.toLocal()}".split(' ')[0], style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16.0),
              SwitchListTile(
                title: Text('Is Confirmed'),
                value: _isConfirmed,
                onChanged: (bool value) {
                  setState(() {
                    _isConfirmed = value;
                  });
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(currentPageIndex: currentPageIndex, onItemTapped: onItemTapped),
    );
  }
}
