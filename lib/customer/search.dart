import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
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
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  final List<Marker> _allMarkers = [];
  List<Marker> _displayedMarkers = [];
  LatLng? _currentLocation;
  TextEditingController _searchController = TextEditingController();
  List<String> _clinicNames = [];
  List<String> _filteredClinicNames = [];
  bool _showSuggestions = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchClinicData();
    _getCurrentLocation();
  }

  Future<void> _fetchClinicData() async {
    try {
      final response = await http.get(Uri.parse('YOUR_API_ENDPOINT_HERE'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _setMarkers(data);
          _clinicNames = _allMarkers.map((marker) => marker.infoWindow.title!).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load clinic data');
      }
    } catch (e) {
      print('Error fetching clinic data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setMarkers(List<dynamic> data) {
    _allMarkers.clear();
    data.forEach((clinic) {
      _allMarkers.add(
        Marker(
          markerId: MarkerId(clinic['id'].toString()),
          position: LatLng(clinic['latitude'], clinic['longitude']),
          infoWindow: InfoWindow(
            title: clinic['name'],
            snippet: clinic['address'],
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
    _displayedMarkers = List.from(_allMarkers);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _getCurrentLocation() async {
    Location location = new Location();
    LocationData currentLocation = await location.getLocation();
    setState(() {
      _currentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      _allMarkers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: _currentLocation!,
          infoWindow: InfoWindow(
            title: 'Your Location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
      _displayedMarkers = List.from(_allMarkers);
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 14.0),
      );
    });
  }

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
            MaterialPageRoute(builder: (context) => ProfilePage())
        );
        break;
    }
  }

  void _goToCurrentLocation() {
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_currentLocation!, 14.0),
    );
  }

  void _filterClinicNames(String query) {
    List<String> filteredNames = [];

    if (query.isNotEmpty) {
      filteredNames = _clinicNames
          .where((name) =>
          name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {
        _filteredClinicNames = filteredNames;
        _showSuggestions = true;
      });
    } else {
      setState(() {
        _filteredClinicNames.clear();
        _showSuggestions = false;
      });
    }
  }

  void _navigateToClinicLocation(String clinicName) {
    Marker selectedMarker = _allMarkers.firstWhere(
          (marker) => marker.infoWindow.title == clinicName,
      orElse: () => _allMarkers.first,
    );

    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(selectedMarker.position, 14.0), // Zoom to 14.0
    );

    // Hide the list of suggestions
    setState(() {
      _showSuggestions = false;
      _searchController.clear(); // Optionally clear the search input
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search For Vet Clinic Around You'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Vet Clinics',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                _filterClinicNames(value);
              },
            ),
          ),
          if (_showSuggestions && _filteredClinicNames.isNotEmpty)
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: _filteredClinicNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_filteredClinicNames[index]),
                    onTap: () {
                      _navigateToClinicLocation(_filteredClinicNames[index]);
                    },
                  );
                },
              ),
            ),
          Expanded(
            flex: _showSuggestions && _filteredClinicNames.isNotEmpty ? 7 : 10,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              markers: Set<Marker>.of(_displayedMarkers),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _goToCurrentLocation();
        },
        tooltip: 'Go to Current Location',
        child: Icon(Icons.my_location),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: Navbar(
          currentPageIndex: currentPageIndex, onItemTapped: onItemTapped),
    );
  }
}
