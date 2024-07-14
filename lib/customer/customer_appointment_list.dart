import 'package:flutter/material.dart';
import 'package:vetrep/models/appoinment.dart';
import 'package:vetrep/models/fetchappoinment.dart';


class CustomerAppointmentList extends StatefulWidget {
  const CustomerAppointmentList({super.key});

  @override
  State<CustomerAppointmentList> createState() => _CustomerAppointmentListState();
}

class _CustomerAppointmentListState extends State<CustomerAppointmentList> {
  late Future<List<Appointment>> futureAppointments;

  @override
  void initState() {
    super.initState();
    futureAppointments = fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Appointment"),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Appointment>>(
        future: futureAppointments,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Appointment>? appointments = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: appointments!.map((appointment) => GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: Text('Choose your action'),
                            children: <Widget>[
                              SimpleDialogOption(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Handle reschedule
                                  },
                                  child: ListTile(
                                    leading: Icon(Icons.calendar_month_outlined),
                                    title: Text('Reschedule'),
                                  )
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Center(
                                          child: Text(
                                            'Pet Details',
                                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                          )
                                      ),
                                    ),
                                    Divider(),
                                    Text("Name:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    Text("${appointment.petName}", style: TextStyle(fontSize: 25),),
                                    SizedBox(height: 10),
                                    Text("Gender:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    Text("${appointment.petGender}", style: TextStyle(fontSize: 25),),
                                    SizedBox(height: 10),
                                    Text("Age:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    Text("${appointment.petAge}", style: TextStyle(fontSize: 25),),
                                    Text("Booking date:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    Text("${appointment.bookingDate}", style: TextStyle(fontSize: 25),),
                                    Text("Time:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    Text("${appointment.timeslot.time}", style: TextStyle(fontSize: 25),),
                                    Text("Clinic Name:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    Text("${appointment.timeslot.clinic.name}", style: TextStyle(fontSize: 25),),
                                    Text("Location:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    Text("${appointment.timeslot.clinic.address}", style: TextStyle(fontSize: 25),),
                                    Text("Reference:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    Text("${appointment.ref}", style: TextStyle(fontSize: 25),),
                                    SizedBox(height: 10),
                                    // Add more content here as needed
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15),
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Color(0xffBAE7D2),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 10,
                            top: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${appointment.getFormattedBookingDate()}, ${appointment.timeslot.time}",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black54),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Name: ${appointment.petName}',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Age: ${appointment.petAge}',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Clinic: ${appointment.timeslot.clinic.name}",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),
                                ),
                                SizedBox(width: 10,),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 60,
                            right: 30,
                            child: Icon(
                              appointment.petGender == 'male' ? Icons.male : Icons.female,
                              size: 60,
                              color: appointment.petGender == 'male' ? Colors.blue : Colors.pink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

