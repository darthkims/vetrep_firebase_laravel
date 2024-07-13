import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vetrep/models/appoinment.dart';

Future<List<Appointment>> fetchAppointments() async {
  final response = await http.get(Uri.parse('http://192.168.0.8:80/api/v1/public/clinics/view-bookings?clinic_id=1&date=2024-07-12'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((appointment) => Appointment.fromJson(appointment)).toList();
  } else {
    throw Exception('Failed to load appointments');
  }
}
