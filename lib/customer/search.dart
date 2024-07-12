import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _getCurrentLocation();
  }

  void _setMarkers() {
    _allMarkers.addAll([
      Marker(
        markerId: MarkerId('clinic1'),
        position: LatLng(45.531563, -122.677433),
        infoWindow: InfoWindow(
          title: 'Happy Paws Vet Clinic',
          snippet: 'Affordable care for your pets',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
      Marker(
        markerId: MarkerId('clinic2'),
        position: LatLng(45.511563, -122.667433),
        infoWindow: InfoWindow(
          title: 'Healthy Pets Vet Clinic',
          snippet: 'Best services for your pets',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    ]);
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

  void _goToCurrentLocation() {
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_currentLocation!, 14.0),
    );
  }

  void _filterMarkers(String query) {
    List<Marker> filteredMarkers = _allMarkers
        .where((marker) =>
        marker.infoWindow.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _displayedMarkers = filteredMarkers;
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
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: Set<Marker>.of(_displayedMarkers),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                _goToCurrentLocation();
              },
              tooltip: 'Go to Current Location',
              child: Icon(Icons.my_location),
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(
          currentPageIndex: currentPageIndex, onItemTapped: onItemTapped),
    );
  }
}
