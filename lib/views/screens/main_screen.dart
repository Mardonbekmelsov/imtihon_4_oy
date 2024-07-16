import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imtihon_4_oy/views/screens/login_screen.dart';
import 'package:imtihon_4_oy/views/widgets/custom_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // ignore: unused_field
  User? _user;

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
        if (user != null) {
          _checkTokenValidity(user);
        }
      });
    });
  }

  Future<void> _checkTokenValidity(User user) async {
    try {
      IdTokenResult tokenResult = await user.getIdTokenResult(true);
      DateTime? expirationTime = tokenResult.expirationTime;
      if (expirationTime != null && expirationTime.isBefore(DateTime.now())) {
        auth.signOut();
      }
    } catch (e) {
      print('Error checking token validity: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Main Screen"),
        centerTitle: true,
      ),
    );
  }
}
