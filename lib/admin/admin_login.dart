import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'admin_home.dart';
import 'token_manager.dart';

class AdminLogin extends StatelessWidget {
  static const routeName = '/login';

  const AdminLogin({super.key});

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
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://192.168.0.6:80/api/v1/public/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];
      await SecureSessionManager.setToken(token);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AdminHome()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // email
          TextFormField(
            controller: _emailController,
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
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),

          SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                _login();
              }
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