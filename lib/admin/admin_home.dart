import 'package:flutter/material.dart';
import 'package:vetrep/admin/add_clinic.dart';
import 'package:vetrep/admin/admin_navbar.dart';
import 'package:vetrep/admin/admin_view_clinic.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'token_manager.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final int currentPageIndex = 0;
  List<dynamic> clinics = [];

  @override
  void initState() {
    super.initState();
    _fetchClinics();
  }

  Future<void> _fetchClinics() async {
    String? token = await SecureSessionManager.getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No token found. Please log in again.')),
      );
      return;
    }

    final response = await http.get(
      Uri.parse('http://192.168.0.7:8080/api/v1/secured/admin/all-clinics'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        clinics = json.decode(response.body);
      });
    } else {
      print('Failed to fetch clinics: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch clinics.')),
      );
    }
  }

  void _viewClinic(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminViewClinic(id: id),
      ),
    );
  }

  void onItemTapped(int index) {
    switch (index) {
      case 0:
      // Handle navigation or action for item 0
        break;
      case 1:
      // Handle navigation or action for item 1
        break;
      case 2:
      // Handle navigation or action for item 2
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('All Clinics'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddClinicPage()));
              },
              child: Text('Register New Clinic'),
            ),
          ],
        ),
      ),
      body: clinics.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: clinics.length,
        itemBuilder: (context, index) {
          var clinic = clinics[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(clinic['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Address: ${clinic['address']}'),
                  Text('Phone: ${clinic['phone_no']}'),
                ],
              ),
              onTap: () {
                _viewClinic(clinic['id']);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: AdminNavbar(currentPageIndex: currentPageIndex, onItemTapped: onItemTapped),
    );
  }
}
