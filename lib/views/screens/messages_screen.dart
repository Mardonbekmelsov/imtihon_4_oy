import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imtihon_4_oy/models/user_model.dart';
import 'package:imtihon_4_oy/services/users_firebase_services.dart';

class MessagesScreen extends StatelessWidget {
  final UsersFirebaseServices usersFirebaseServices = UsersFirebaseServices();

  MessagesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    usersFirebaseServices
        .changeMessageActivity(FirebaseAuth.instance.currentUser!.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: usersFirebaseServices
            .getUserById(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("User topilmadi:("),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final user = UserModel.fromJson(snapshot.data!);
          return ListView.builder(
            itemCount: user.messages.length,
            itemBuilder: (context, index) {
              final message = user.messages[index];
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      height: 70,
                      width: 70,
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.network(
                        message['senderImage'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      "${message['senderFname']} ${message['senderLname']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      message['time'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      message['message'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
