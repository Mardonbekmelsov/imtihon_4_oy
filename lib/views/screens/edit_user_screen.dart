import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imtihon_4_oy/models/user_model.dart';
import 'package:imtihon_4_oy/services/users_firebase_services.dart';
import 'package:imtihon_4_oy/views/screens/main_screen.dart';

class EditUserScreen extends StatefulWidget {
  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final UsersFirebaseServices usersFirebaseServices = UsersFirebaseServices();

  final fnameController = TextEditingController();

  final lnameController = TextEditingController();
  File? imageFile;

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
        imageQuality: 50);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera,
        requestFullMetadata: false,
        imageQuality: 50);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: usersFirebaseServices
            .getUserById(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text("Malumotlar topilmadi"),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final user = UserModel.fromJson(snapshot.data!);
          fnameController.text = user.fname;
          lnameController.text = user.lname;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: fnameController,
                decoration: const InputDecoration(
                  hintText: "Enter first name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Iltimos ismingizni kiriting";
                  }

                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: lnameController,
                decoration: const InputDecoration(
                  hintText: "Enter last name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Iltimos ismingizni kiriting";
                  }

                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      openGallery();
                    },
                    label: const Text(
                      "Gallery",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(
                      Icons.photo,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      openCamera();
                    },
                    label: const Text(
                      "Camera",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(
                      Icons.camera,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 100,
                width: 100,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: imageFile == null
                    ? Image.network(
                        user.imageurl,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (fnameController.text.isNotEmpty &&
                      lnameController.text.isNotEmpty) {
                    await usersFirebaseServices.editUser(
                        FirebaseAuth.instance.currentUser!.uid,
                        fnameController.text,
                        lnameController.text,
                        imageFile ?? user.imageurl).then((value){Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MainScreen()));});
                    
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
