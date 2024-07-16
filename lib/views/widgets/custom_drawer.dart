import 'package:flutter/material.dart';
import 'package:imtihon_4_oy/controllers/thememode_controller.dart';
import 'package:imtihon_4_oy/services/firebase_auth_services.dart';
import 'package:imtihon_4_oy/views/screens/events_screen.dart';
import 'package:imtihon_4_oy/views/screens/login_screen.dart';
import 'package:imtihon_4_oy/views/screens/my_events_screen.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  final authService = FirebaseAuthServices();
  CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThememodeController>(context);
    return Drawer(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Menu"),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventsScreen()));
                    },
                    title: Text("Mening tadbirlarim"),
                    trailing: const Icon(
                      Icons.keyboard_arrow_right,
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    title: Text("Profil ma'lumotlari"),
                    trailing: const Icon(
                      Icons.keyboard_arrow_right,
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    title: Text("Tillarni o'zgartirish"),
                    trailing: const Icon(
                      Icons.keyboard_arrow_right,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      themeController.changeMode();
                    },
                    title: Text("Mode"),
                    trailing: const Icon(
                      Icons.keyboard_arrow_right,
                    ),
                  ),
                ],
              ),
              ListTile(
                onTap: () {
                  authService.logout();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                },
                title: Text("Log Out"),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
