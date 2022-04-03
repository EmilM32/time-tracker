import 'package:flutter/material.dart';
import 'package:time_tracker/screens/registration_screen.dart';
import 'package:time_tracker/components/info_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker/screens/dashboard_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:time_tracker/helpers/device_screen.dart';
import 'package:time_tracker/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  String email = '';
  String password = '';

  bool isLoading = false;

  void checkAuth() {
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushNamed(context, DashboardScreen.id);
      }
    });
  }

  void logIn() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showInfoDialog(AppLocalizations.of(context)!.wrongEmail);
      } else if (e.code == 'wrong-password') {
        showInfoDialog(AppLocalizations.of(context)!.wrongPassword);
      } else if (e.code == 'invalid-email') {
        showInfoDialog(AppLocalizations.of(context)!.wrongEmail);
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
  void initState() {
    super.initState();
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          Screens deviceScreen = getDeviceScreen(constraints.maxWidth);
          double? width = deviceScreen == Screens.mobile ? null : kFormMaxWidth;

          return Center(
            child: Padding(
              padding: kPagePadding,
              child: SizedBox(
                width: width,
                child: Form(
                  key: _formKeyLogin,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: kBorderRounded,
                          ),
                          labelText: AppLocalizations.of(context)!.email,
                          icon: const Icon(Icons.email),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.required;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: kBorderRounded,
                          ),
                          labelText: AppLocalizations.of(context)!.password,
                          icon: const Icon(Icons.password),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.required;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        style: kLoadingButtonStyle,
                        onPressed: () {
                          if (_formKeyLogin.currentState!.validate()) {
                            logIn();
                          }
                        },
                        child: (isLoading)
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(AppLocalizations.of(context)!.login),
                      ),
                      TextButton(
                        style: kSubTextStyle,
                        onPressed: () {
                          Navigator.pushNamed(context, RegistrationScreen.id);
                        },
                        child: Text(AppLocalizations.of(context)!.signUp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
