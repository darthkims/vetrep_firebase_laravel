import 'package:intl/intl.dart';

class Clinic {
  final int id;
  final String name;
  final String location;
  final String phoneNum;
  final String address;

  Clinic({required this.id, required this.name, required this.location, required this.phoneNum, required this.address});

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'],
      name: (json['name']),
      location: json['location'],
      phoneNum: json['phone_no'],
      address: json['address'],
    );
  }
}

class TimeSlot {
  final int id;
  final int clinicId;
  final String time;
  final Clinic clinic;

  TimeSlot({required this.id, required this.clinicId, required this.time, required this.clinic});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'],
      clinicId: (json['clinic_id']),
      time: json['time'],
      clinic: Clinic.fromJson(json['clinic']),
    );
  }
}

class Appointment {
  final int id;
  final int slotId;
  final String phoneNum;
  final String ref;
  final DateTime bookingDate;
  final bool isConfirmed;
  final String? petName;
  final String? petGender;
  final String? petAge;
  final TimeSlot timeslot;

  Appointment({
    required this.id,
    required this.slotId,
    required this.phoneNum,
    required this.ref,
    required this.bookingDate,
    required this.isConfirmed,
    this.petName,
    this.petGender,
    this.petAge,
    required this.timeslot,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      slotId: json['slot_id'],
      phoneNum: json['user_phone_no'],
      ref: json['reference_no'],
      bookingDate: DateTime.parse(json['booking_date']),
      isConfirmed: json['is_confirmed'] == 1,
      petName: json['pet_name'],
      petGender: json['pet_gender'],
      petAge: json['pet_age'],
      timeslot: TimeSlot.fromJson(json['timeslot']),
    );
  }

  String getFormattedBookingDate() {
    return DateFormat('d MMMM yyyy').format(bookingDate);
  }

}
