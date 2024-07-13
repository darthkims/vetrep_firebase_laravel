class Appointment {
  final int slotId;
  final String phoneNum;
  final String ref;
  final String timeStamp;

  Appointment(
      {required this.slotId,
        required this.phoneNum,
        required this.ref,
        required this.timeStamp,
        });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      slotId: json['slot_id'],
      phoneNum: json['user_phone_no'],
      ref: json['reference_no'],
      timeStamp: json['booking_date'],
    );
  }
}
