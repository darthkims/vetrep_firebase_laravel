import 'package:flutter/material.dart';
import '../authentication.dart';
import 'admin_home.dart';

class AdminLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff93A18E),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          SizedBox(height: 80),
          // logo
          Column(
            children: [
              Image.asset(
                'assets/images/splash_icon.png', // Adjust the path based on your project structure
                width: 800,
                height: 200,
              ),
              Text(
                'Hello Admin.',
                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                'Cute Patients, Await You!',
                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          SizedBox(
            height: 50,
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LoginForm(),
          ),

          SizedBox(height: 20),

          Row(
            children: <Widget>[
            ],
          ),
        ],
      ),
    );
  }


}

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // email
          TextFormField(
            // initialValue: 'Input text',
            decoration: InputDecoration(
              fillColor: Color(0xff517954),
              filled: true,
              prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.white), // Set the label text color
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  const Radius.circular(100.0),
                ),
              ),
            ),
            style: TextStyle(color: Colors.white), // Set the input text color
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter email';
              }
              return null;
            },
            onSaved: (val) {
              email = val;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            // initialValue: 'Input text',
            decoration: InputDecoration(
              fillColor: Color(0xff517954),
              filled: true,
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.white), // Set the label text color
              prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  const Radius.circular(100.0),
                ),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.white
                ),
              ),
            ),
            style: TextStyle(color: Colors.white), // Set the input text color
            obscureText: _obscureText,
            onSaved: (val) {
              password = val;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
          ),

          SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHome()));
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24.0))
                )
            ),
            child: Text(
              'Login',
              // style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}