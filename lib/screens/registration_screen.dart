import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker/components/info_dialog.dart';
import 'package:time_tracker/screens/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:time_tracker/helpers/device_screen.dart';
import 'package:time_tracker/constants.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKeySignUp = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';

  bool isLoading = false;

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
        showInfoDialog(AppLocalizations.of(context)!.passwordTooWeak);
      } else if (e.code == 'email-already-in-use') {
        showInfoDialog(AppLocalizations.of(context)!.accountExists);
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
                  key: _formKeySignUp,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          email = value;
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
                          password = value;
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
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        onChanged: (value) {
                          confirmPassword = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: kBorderRounded,
                          ),
                          labelText:
                              AppLocalizations.of(context)!.confirmPassword,
                          icon: const Icon(Icons.password),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.required;
                          }
                          if (value != password) {
                            return AppLocalizations.of(context)!
                                .passwordsDoNotMatch;
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
                          if (_formKeySignUp.currentState!.validate()) {
                            createNewUser();
                          }
                        },
                        child: (isLoading)
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(AppLocalizations.of(context)!.signUp),
                      ),
                      TextButton(
                        style: kSubTextStyle,
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                        child: Text(AppLocalizations.of(context)!.login),
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
