import 'package:flutter/material.dart';
import 'package:time_tracker/screens/registration_screen.dart';
import 'package:time_tracker/components/info_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  String email = '';
  String password = '';

  bool checkRequiredFields() {
    return email.isNotEmpty && password.isNotEmpty;
  }

  void checkAuth() {
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushNamed(context, DashboardScreen.id);
      }
    });
  }

  void logIn() async {
    try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showInfoDialog('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showInfoDialog('Wrong password provided for that user.');
      }
    }
  }

  Future<void> showInfoDialog(String text) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return InfoDialog(text: text);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  icon: Icon(Icons.password),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: checkRequiredFields()
                    ? () {
                        logIn();
                      }
                    : null,
                child: const Text('Login'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
