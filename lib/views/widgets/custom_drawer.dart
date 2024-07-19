import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imtihon_4_oy/controllers/thememode_controller.dart';
import 'package:imtihon_4_oy/models/user_model.dart';
import 'package:imtihon_4_oy/services/firebase_auth_services.dart';
import 'package:imtihon_4_oy/services/users_firebase_services.dart';
import 'package:imtihon_4_oy/views/screens/edit_user_screen.dart';
import 'package:imtihon_4_oy/views/screens/events_screen.dart';
import 'package:imtihon_4_oy/views/screens/login_screen.dart';
import 'package:imtihon_4_oy/views/screens/main_screen.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  final UsersFirebaseServices usersFirebaseServices = UsersFirebaseServices();
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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 260,
                width: double.infinity,
                color: Colors.teal,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: usersFirebaseServices
                      .getUserById(FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Xatolik yuz berdi: ${snapshot.error}'),
                      );
                    }

                    final userDoc = snapshot.data!;
                    final user = UserModel.fromJson(userDoc);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (user.imageurl.isNotEmpty)
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(user.imageurl),
                          ),
                        const SizedBox(height: 10),
                        Text(
                          '${user.fname} ${user.lname}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()));
                    },
                    title: const Text("Bosh Sahifa"),
                    trailing: const Icon(
                      Icons.keyboard_arrow_right,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EventsScreen()));
                    },
                    title: const Text("Mening tadbirlarim"),
                    trailing: const Icon(
                      Icons.keyboard_arrow_right,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditUserScreen()));
                    },
                    title: const Text("Profil ma'lumotlari"),
                    trailing: const Icon(
                      Icons.keyboard_arrow_right,
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    title: const Text("Tillarni o'zgartirish"),
                    trailing: const Icon(
                      Icons.keyboard_arrow_right,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      themeController.changeMode();
                    },
                    title: const Text("Mode"),
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
                title: const Text("Log Out"),
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
