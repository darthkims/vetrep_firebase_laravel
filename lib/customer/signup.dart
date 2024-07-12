import 'package:flutter/material.dart';
import 'package:vetrep/authentication.dart';
import 'package:vetrep/customer/customer_home.dart';
import 'package:vetrep/customer/customer_login.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff93A18E),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          SizedBox(height: 80),
          // logo
          Column(
            children: [
              Image.asset(
                'assets/images/splash_icon.png',
                // Adjust the path based on your project structure
                width: 800,
                height: 200,
              ),
            ],
          ),
          Center(
            child: Text(
              'Meet The Vet, Treat Your Pet',
              style: TextStyle(fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,),
            ),
          ),

          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SignupForm(),
          ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 20),
                    SizedBox(height: 60),
                    Text('Have account?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text(' Login here',
                          style: TextStyle(fontSize: 20, color: Colors.blue)),
                    )
                  ],
                )
              ],
            ),
        ],
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  String? name;
  String? phoneNum;
  bool _obscureText = false;

  bool agree = false;

  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        const Radius.circular(100.0),
      ),
    );

    var space = SizedBox(height: 10);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                fillColor: Color(0xff517954),
                filled: true,
                prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white), // Set the label text color
                border: border),
            style: TextStyle(color: Colors.white), // Set the input text color

            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (val) {
              email = val;
            },
            keyboardType: TextInputType.emailAddress,
          ),

          space,

          // password
          TextFormField(
            controller: pass,
            decoration: InputDecoration(
              fillColor: Color(0xff517954),
              filled: true,
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.white), // Set the label text color
              prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
              border: border,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.white, // Set the input text color

                ),
              ),
            ),
            style: TextStyle(color: Colors.white), // Set the input text color

            onSaved: (val) {
              password = val;
            },
            obscureText: !_obscureText,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          space,
          // confirm passwords
          TextFormField(
            decoration: InputDecoration(
              fillColor: Color(0xff517954),
              filled: true,
              labelText: 'Confirm Password',
              labelStyle: TextStyle(color: Colors.white), // Set the label text color
              prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
              border: border,
            ),
            style: TextStyle(color: Colors.white), // Set the input text color

            obscureText: true,
            validator: (value) {
              if (value != pass.text) {
                return 'password not match';
              }
              return null;
            },
          ),
          space,
          // name
          TextFormField(
            decoration: InputDecoration(
              fillColor: Color(0xff517954),
              filled: true,
              labelText: 'Full name',
              labelStyle: TextStyle(color: Colors.white), // Set the label text color
              prefixIcon: Icon(Icons.account_circle, color: Colors.white),
              border: border,
            ),
            style: TextStyle(color: Colors.white), // Set the input text color

            onSaved: (val) {
              name = val;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some name';
              }
              return null;
            },
          ),
          space,
          // name
          TextFormField(
            decoration: InputDecoration(
              fillColor: Color(0xff517954),
              filled: true,
              labelText: 'Phone Number',
              labelStyle: TextStyle(color: Colors.white), // Set the label text color
              prefixIcon: Icon(Icons.phone, color: Colors.white),
              border: border,
            ),
            style: TextStyle(color: Colors.white), // Set the input text color

            onSaved: (val) {
              phoneNum = val;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter phone number';
              }
              return null;
            },
          ),
          SizedBox(height: 30,),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  AuthenticationHelper()
                      .signUp(email: email!, password: password!, name: name!, phoneNum: phoneNum!)
                      .then((result) {
                    if (result == null) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          result,
                          style: TextStyle(fontSize: 16),
                        ),
                      ));
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
              child: Text(
                'Sign Up',
              ),
            ),
        ],
      ),
    );
  }
}