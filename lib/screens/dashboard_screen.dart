import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker/screens/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  static const String id = 'dashboard_screen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      print(currentUser);
    } else {
      Navigator.pushNamed(context, LoginScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Dashboard',
      style: TextStyle(fontSize: 30),
    );
  }
}
