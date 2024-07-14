class Locations {
  final int clinicId;
  final String name;
  final String location;
  final String phoneNum;
  final String address;
  final String latitude;
  final String longitude;


  Locations(
      {required this.clinicId,
        required this.name,
        required this.location,
        required this.phoneNum,
        required this.address,
        required this.latitude,
        required this.longitude,
      });

  factory Locations.fromJson(Map<String, dynamic> json) {
    return Locations(
      clinicId: json['id'],
      name: json['name'],
      location: json['location'],
      phoneNum: json['phone_no'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}