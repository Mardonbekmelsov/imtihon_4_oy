import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:imtihon_4_oy/controller/users_controller.dart';
import 'package:imtihon_4_oy/controllers/thememode_controller.dart';
import 'package:imtihon_4_oy/firebase_options.dart';
import 'package:imtihon_4_oy/services/location_services.dart';
import 'package:imtihon_4_oy/views/screens/login_screen.dart';
import 'package:imtihon_4_oy/views/screens/main_screen.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  LocationServices.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            return ThememodeController();
          }),
          ChangeNotifierProvider(create: (context) => UsersController()),
        ],
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Provider.of<ThememodeController>(context).nightmode
                ? ThemeData.dark()
                : ThemeData.light(),
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LoginScreen();
                  }
                  return MainScreen();
                }),
          );
        });
  }
}
