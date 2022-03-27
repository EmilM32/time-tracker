import 'package:flutter/material.dart';
import 'package:time_tracker/screens/registration_screen.dart';
import 'package:time_tracker/components/info_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker/screens/dashboard_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        showInfoDialog(AppLocalizations.of(context)!.wrongEmail);
      } else if (e.code == 'wrong-password') {
        showInfoDialog(AppLocalizations.of(context)!.wrongPassword);
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
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.email,
                  icon: const Icon(Icons.email),
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
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.password,
                  icon: const Icon(Icons.password),
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
                child: Text(AppLocalizations.of(context)!.login),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                child: Text(AppLocalizations.of(context)!.signUp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
