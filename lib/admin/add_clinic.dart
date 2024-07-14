import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'token_manager.dart';
import 'admin_home.dart';

class AddClinicPage extends StatefulWidget {
  @override
  _AddClinicPageState createState() => _AddClinicPageState();
}

class _AddClinicPageState extends State<AddClinicPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  LatLng? _selectedLocation;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? token = await SecureSessionManager.getToken();
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No token found. Please log in again.')),
        );
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.0.6:80/api/v1/secured/admin/clinics'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'application/json';

      request.fields['name'] = _nameController.text;
      request.fields['location'] = _locationController.text;
      request.fields['phone_no'] = _phoneController.text;
      request.fields['address'] = _addressController.text;
      if (_selectedLocation != null) {
        request.fields['latitude'] = _selectedLocation!.latitude.toString();
        request.fields['longitude'] = _selectedLocation!.longitude.toString();
      }

      try {
        var response = await request.send();

        // Log the response for debugging
        var responseString = await response.stream.bytesToString();
        print('Response status: ${response.statusCode}');
        print('Response body: $responseString');

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Clinic added successfully!')),
          );
          // Redirect to admin home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHome()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add clinic.')),
          );
        }
      } catch (e) {
        // Log any error that occurs during the request
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred.')),
        );
      }
    }
  }

  Future<void> _selectLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapSelectionPage()),
    );

    if (result != null && result is LatLng) {
      setState(() {
        _selectedLocation = result;
      });

      // Get the address from the selected location
      List<Placemark> placemarks = await placemarkFromCoordinates(
        result.latitude,
        result.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address =
            '${placemark.name}, ${placemark.thoroughfare}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.administrativeArea}, ${placemark.country}';
        _addressController.text = address;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Clinic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Clinic Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter clinic name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Clinic Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter clinic location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
                readOnly: true,
                onTap: _selectLocation,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Clinic'),
              ),
            ],
          ),
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
