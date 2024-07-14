import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'token_manager.dart';
import 'package:intl/intl.dart';

class AdminViewClinic extends StatefulWidget {
  final int id;

  AdminViewClinic({required this.id});

  @override
  _AdminViewClinicState createState() => _AdminViewClinicState();
}

class _AdminViewClinicState extends State<AdminViewClinic> {
  Map<String, dynamic>? clinic;
  bool isLoading = true;
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchClinicDetails();
    _fetchBookings();
  }

  Future<void> _fetchClinicDetails() async {
    String? token = await SecureSessionManager.getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No token found. Please log in again.')),
      );
      return;
    }

    final response = await http.get(
      Uri.parse('http://192.168.0.6:80/api/v1/secured/admin/clinics/${widget.id}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        clinic = json.decode(response.body);
        isLoading = false;
      });
    } else {
      print('Failed to fetch clinic details: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch clinic details.')),
      );
    }
  }

  Future<void> _fetchBookings() async {
    String? token = await SecureSessionManager.getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No token found. Please log in again.')),
      );
      return;
    }

    final response = await http.get(
      Uri.parse('http://192.168.0.7:8080/api/v1/secured/admin/bookings/${widget.id}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        bookings = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to fetch bookings: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch bookings.')),
      );
    }
  }

  void _showEditClinicPopup(String field) {
    TextEditingController _controller = TextEditingController(text: clinic![field]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${field[0].toUpperCase() + field.substring(1)}'),
          content: field == 'address'
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'New Address'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapSelectionPage()),
                  );

                  if (result != null && result is LatLng) {
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                      result.latitude,
                      result.longitude,
                    );

                    if (placemarks.isNotEmpty) {
                      Placemark placemark = placemarks.first;
                      String address = '${placemark.street}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}';
                      setState(() {
                        _controller.text = address;
                      });
                    }
                  }
                },
                child: Text('Select Address on Map'),
              ),
            ],
          )
              : TextFormField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'New ${field[0].toUpperCase() + field.substring(1)}'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String? token = await SecureSessionManager.getToken();
                if (token == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No token found. Please log in again.')),
                  );
                  return;
                }

                final response = await http.put(
                  Uri.parse('http://192.168.0.7:8080/api/v1/secured/admin/clinics/${widget.id}'),
                  headers: {
                    'Authorization': 'Bearer $token',
                    'Content-Type': 'application/json',
                  },
                  body: json.encode({
                    field: _controller.text,
                  }),
                );

                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${field[0].toUpperCase() + field.substring(1)} updated successfully!')),
                  );
                  setState(() {
                    clinic![field] = _controller.text;
                  });
                  Navigator.of(context).pop();
                } else {
                  print('Failed to update ${field}: ${response.statusCode}');
                  print('Response body: ${response.body}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update ${field}.')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchAvailableTimeslots(DateTime date) async {
    String? token = await SecureSessionManager.getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No token found. Please log in again.')),
      );
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.7:8080/api/v1/public/clinics/availability?clinic_id=${widget.id}&year=${date.year}&month=${date.month}&day=${date.day}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('response timeslots: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['${date.toIso8601String().substring(0, 10)}']);
      } else {
        print('Failed to fetch timeslots: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch timeslots: ${response.body}')),
        );
        return [];
      }
    } catch (e) {
      print('Error fetching timeslots: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching timeslots: $e')),
      );
      return [];
    }
  }

  void _showEditBookingPopup(Map<String, dynamic> booking) {
    TextEditingController userPhoneNoController = TextEditingController(text: booking['user_phone_no']);
    TextEditingController bookingDateController = TextEditingController(text: booking['booking_date']);
    TextEditingController petNameController = TextEditingController(text: booking['pet_name']);
    TextEditingController petGenderController = TextEditingController(text: booking['pet_gender']);
    TextEditingController petAgeController = TextEditingController(text: booking['pet_age']);

    DateTime bookingDate = DateTime.parse(booking['booking_date']);
    List<Map<String, dynamic>> availableTimeslots = [];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Booking'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: userPhoneNoController,
                  decoration: InputDecoration(labelText: 'User Phone No'),
                ),
                TextFormField(
                  controller: bookingDateController,
                  decoration: InputDecoration(labelText: 'Booking Date'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: bookingDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null && pickedDate != bookingDate) {
                      setState(() {
                        bookingDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                        bookingDate = pickedDate;
                      });
                      availableTimeslots = await _fetchAvailableTimeslots(pickedDate);
                    }
                  },
                ),
                TextFormField(
                  controller: petNameController,
                  decoration: InputDecoration(labelText: 'Pet Name'),
                ),
                TextFormField(
                  controller: petGenderController,
                  decoration: InputDecoration(labelText: 'Pet Gender'),
                ),
                TextFormField(
                  controller: petAgeController,
                  decoration: InputDecoration(labelText: 'Pet Age'),
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchAvailableTimeslots(bookingDate),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      print('FutureBuilder error: ${snapshot.error}');
                      return Text('Error fetching timeslots');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No available timeslots');
                    } else {
                      availableTimeslots = snapshot.data!;
                      return Column(
                        children: availableTimeslots.map((timeslot) {
                          bool isBooked = timeslot['status'] == 'booked';
                          return ListTile(
                            title: Text('${timeslot['time']}'),
                            trailing: isBooked ? Icon(Icons.block) : Icon(Icons.check),
                            enabled: !isBooked,
                            onTap: isBooked
                                ? null
                                : () {
                              setState(() {
                                booking['timeslot'] = timeslot;
                              });
                              Navigator.of(context).pop();
                            },
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String? token = await SecureSessionManager.getToken();
                if (token == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No token found. Please log in again.')),
                  );
                  return;
                }

                final response = await http.put(
                  Uri.parse('http://192.168.0.7:8080/api/v1/secured/admin/bookings/${booking['id']}'),
                  headers: {
                    'Authorization': 'Bearer $token',
                    'Content-Type': 'application/json',
                  },
                  body: json.encode({
                    'user_phone_no': userPhoneNoController.text,
                    'booking_date': bookingDateController.text,
                    'pet_name': petNameController.text,
                    'pet_gender': petGenderController.text,
                    'pet_age': petAgeController.text,
                    'timeslot': booking['timeslot'],
                  }),
                );

                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Booking updated successfully!')),
                  );
                  _fetchBookings();
                  Navigator.of(context).pop();
                } else {
                  print('Failed to update booking: ${response.statusCode}');
                  print('Response body: ${response.body}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update booking.')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clinic Details'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Clinic Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Card(
              child: ListView(
                padding: EdgeInsets.all(16),
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text('Name'),
                    subtitle: Text(clinic!['name'] ?? 'N/A'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditClinicPopup('name');
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Location'),
                    subtitle: Text(clinic!['location'] ?? 'N/A'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditClinicPopup('location');
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Phone Number'),
                    subtitle: Text(clinic!['phone_no'] ?? 'N/A'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditClinicPopup('phone_no');
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Address'),
                    subtitle: Text(clinic!['address'] ?? 'N/A'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditClinicPopup('address');
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Bookings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      var booking = bookings[index];
                      var bookingDate = DateTime.parse(booking['booking_date']);
                      var formattedDate = DateFormat('d MMMM yyyy').format(bookingDate);

                      var timeslotTime = booking['timeslot']?['time'];
                      var formattedTimeslot = 'N/A';
                      if (timeslotTime != null) {
                        var timeslotDateTime = DateFormat('HH:mm:ss').parse(timeslotTime);
                        formattedTimeslot = DateFormat('h:mm a').format(timeslotDateTime);
                      }
                      return ListTile(
                        title: Text('Booked on $formattedDate'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('User Phone No: ${booking['user_phone_no']}'),
                            Text('Pet Name: ${booking['pet_name']}'),
                            Text('Pet Gender: ${booking['pet_gender']}'),
                            Text('Pet Age: ${booking['pet_age']}'),
                            Text('Reference No: ${booking['reference_no']}'),
                            Text('Timeslot: $formattedTimeslot'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditBookingPopup(booking);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapSelectionPage extends StatefulWidget {
  @override
  _MapSelectionPageState createState() => _MapSelectionPageState();
}

class _MapSelectionPageState extends State<MapSelectionPage> {
  GoogleMapController? _controller;
  LatLng? _selectedLocation;
  final TextEditingController _searchController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _onTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _confirmSelection() {
    Navigator.pop(context, _selectedLocation);
  }

  Future<void> _searchPlace(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);
        _controller?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
        setState(() {
          _selectedLocation = latLng;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Place not found: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        actions: [
          if (_selectedLocation != null)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _confirmSelection,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search location',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchPlace(_searchController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(0.0, 0.0), // Initial position, update as needed
                zoom: 2.0,
              ),
              onTap: _onTap,
              markers: _selectedLocation != null
                  ? {
                Marker(
                  markerId: MarkerId('selected'),
                  position: _selectedLocation!,
                ),
              }
                  : {},
            ),
          ),
        ],
      ),
    );
  }
}
