import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:vetrep/models/appoinment.dart';

Future<List<Appointment>> fetchAppointments() async {

  String phoneNum = await _fetchPhoneNumber();
  final response = await http.get(Uri.parse('http://10.82.196.20:80/api/v1/public/clinics/view-bookings/$phoneNum'));

  print(response.body);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((appointment) => Appointment.fromJson(appointment)).toList();
  } else {
    throw Exception('Failed to load appointments');
  }
}

Future<String> _fetchPhoneNumber() async {
  User? user = FirebaseAuth.instance.currentUser;
  String userId = user!.uid;
  print(userId);
  DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

  if (userDoc.exists) {
    Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
    if (data != null && data.containsKey('phoneNum')) {
      return data['phoneNum'];
    } else {
      throw Exception('Phone number not found in user document');
    }
  } else {
    throw Exception('User document does not exist');
  }
}
