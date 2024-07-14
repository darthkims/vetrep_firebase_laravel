import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'customer_home.dart';
import 'customer_navbar.dart';
import 'customer_profile.dart';
import 'search.dart';
import 'package:intl/intl.dart';

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
  String _petName = '';
  String _petGender = '';
  String _petAge = '';
  DateTime _selectedDate = DateTime.now();
  bool _isConfirmed = false;
  List<Map<String, dynamic>> availableTimeslots = [];
  List<Map<String, dynamic>> clinics = [];

  @override
  void initState() {
    super.initState();
    _fetchClinics();
  }

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
    }
  }

  Future<void> _fetchClinics() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.7:8080/api/v1/public/clinics'),
      );

      if (response.statusCode == 200) {
        setState(() {
          clinics = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        print('Failed to fetch clinics: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching clinics: $e');
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
      List<Map<String, dynamic>> timeslots = await _fetchAvailableTimeslots(picked);
      setState(() {
        availableTimeslots = timeslots;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchAvailableTimeslots(DateTime date) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.7:8080/api/v1/public/clinics/availability?clinic_id=$_clinicId&year=${date.year}&month=${date.month}&day=${date.day}'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['${date.toIso8601String().substring(0, 10)}']);
      } else {
        print('Failed to fetch timeslots: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching timeslots: $e');
      return [];
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var url = Uri.parse('http://192.168.0.7:8080/api/v1/public/clinics/book'); // Replace with your API URL
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
          'pet_name': _petName,
          'pet_gender': _petGender,
          'pet_age': _petAge,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking created successfully')),
        );
        setState(() {
          _isConfirmed = true; // Update the switch state
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create booking')),
        );
      }
    }
  }

  String _formatTime(String time) {
    final parsedTime = DateFormat("HH:mm:ss").parse(time);
    return DateFormat("hh:mm a").format(parsedTime);
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
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Clinic',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                items: clinics.map((clinic) {
                  return DropdownMenuItem<String>(
                    value: clinic['id'].toString(),
                    child: Text(clinic['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _clinicId = value ?? ''; // Ensure _clinicId is not null
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a clinic';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ListTile(
                title: Text("Booking Date"),
                subtitle: Text("${_selectedDate.toLocal()}".split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 16.0),
              if (availableTimeslots.isNotEmpty) ...[
                Text('Select Timeslot'),
                Column(
                  children: availableTimeslots.map((timeslot) {
                    return RadioListTile<String>(
                      title: Text(_formatTime(timeslot['time'])),
                      value: timeslot['slot_id'].toString(),
                      groupValue: _slotId,
                      onChanged: (value) {
                        setState(() {
                          _slotId = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              ] else if (_clinicId.isNotEmpty && _selectedDate != DateTime.now()) ...[
                Text('No available timeslots for the selected date.'),
              ],
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: Colors.black87),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Phone Number';
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Pet Name',
                  labelStyle: TextStyle(color: Colors.black87),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Pet Name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _petName = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text('Pet Gender'),
              RadioListTile<String>(
                title: const Text('Male'),
                value: 'Male',
                groupValue: _petGender,
                onChanged: (value) {
                  setState(() {
                    _petGender = value!;
                  });
                },
                activeColor: Colors.green,
              ),
              RadioListTile<String>(
                title: const Text('Female'),
                value: 'Female',
                groupValue: _petGender,
                onChanged: (value) {
                  setState(() {
                    _petGender = value!;
                  });
                },
                activeColor: Colors.green,
              ),
              RadioListTile<String>(
                title: const Text('Other'),
                value: 'Other',
                groupValue: _petGender,
                onChanged: (value) {
                  setState(() {
                    _petGender = value!;
                  });
                },
                activeColor: Colors.green,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Pet Age',
                  labelStyle: TextStyle(color: Colors.black87),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Pet Age';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _petAge = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              SwitchListTile(
                title: Text('Confirmed'),
                value: _isConfirmed,
                activeColor: Colors.green,
                onChanged: (bool value) {
                  setState(() {
                    _isConfirmed = value;
                  });
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Set the border radius
                  ),
                ),
                child: Text(
                  'Book Now',
                  style: TextStyle(color: Colors.black45), // Text color
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
