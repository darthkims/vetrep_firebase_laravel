import 'package:flutter/material.dart';
import 'package:vetrep/admin/admin_login.dart';
import 'package:vetrep/customer/customer_login.dart';
import 'package:vetrep/signup.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xff93A18E),
          // image: DecorationImage(
          //   image: AssetImage('assets/images/login.jpg'), // Adjust the path based on your project structure
          //   fit: BoxFit.cover,
          //   colorFilter: ColorFilter.mode(
          //     Colors.black.withOpacity(0.5), // Adjust the opacity to control brightness
          //     BlendMode.darken,
          //   ),
          // ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/splash_icon.png', // Adjust the path based on your project structure
                width: 300,
                height: 300,
              ),
              Center(
                child: Text(
                  "Welcome to VetRep",
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: Text('Choose your role'),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Login()),
                              );
                            },
                            child: ListTile(
                              leading: Icon(Icons.account_circle_outlined),
                              title: Text('Customer'),
                            )
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => AdminLogin())
                              );
                            },
                            child: ListTile(
                              leading: Icon(Icons.shield_outlined),
                              title: Text('Admin'),
                            )
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Login'),
              ),

              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()
                    )
                  );
                },
                child: Text('Signup'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
