import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker/components/info_dialog.dart';
import 'package:time_tracker/screens/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email = '';
  String password = '';
  String confirmPassword = '';

  bool emailNotSet = false;
  bool passwordNotSet = false;
  bool confirmPasswordNotSet = false;
  bool passwordsDoNotMatch = false;

  bool isLoading = false;

  bool checkRequiredFields() {
    setState(() {
      if (email.isEmpty) {
        emailNotSet = true;
      } else {
        emailNotSet = false;
      }

      if (password.isEmpty) {
        passwordNotSet = true;
      } else {
        passwordNotSet = false;
      }

      if (confirmPassword.isEmpty) {
        confirmPasswordNotSet = true;
      } else {
        confirmPasswordNotSet = false;
      }

      if (password.isNotEmpty && password != confirmPassword) {
        passwordsDoNotMatch = true;
        showInfoDialog('Passwords do not match');
      } else {
        passwordsDoNotMatch = false;
      }
    });

    return !emailNotSet &&
        !passwordNotSet &&
        !confirmPasswordNotSet &&
        !passwordsDoNotMatch;
  }

  void createNewUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushNamed(context, LoginScreen.id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showInfoDialog('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showInfoDialog('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        showInfoDialog('The email address is not valid.');
      }
    } catch (e) {
      throw Exception(e);
    }
    setState(() {
      isLoading = false;
    });
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
                  email = value;
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Email',
                  icon: const Icon(Icons.email),
                  errorText: emailNotSet ? 'required' : null,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  icon: const Icon(Icons.password),
                  errorText: passwordNotSet ? 'required' : null,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  confirmPassword = value;
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Confirm password',
                  icon: const Icon(Icons.password),
                  errorText: confirmPasswordNotSet ? 'required' : null,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  if (checkRequiredFields()) {
                    createNewUser();
                  }
                },
                child: (isLoading)
                    ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                    : const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
