import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imtihon_4_oy/services/location_services.dart';
import 'package:imtihon_4_oy/services/users_firebase_services.dart';
import 'package:imtihon_4_oy/views/screens/main_screen.dart';

// ignore: must_be_immutable
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final formKey = GlobalKey<FormState>();
  final UsersFirebaseServices usersFirebaseServices = UsersFirebaseServices();

  final fnameController = TextEditingController();

  final lnameController = TextEditingController();

  bool isLoading = false;
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

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });
      try {
        final curUser = FirebaseAuth.instance.currentUser;
        final curLocation = await LocationServices.getCurrentLocation();
        usersFirebaseServices.addUser(
            curLocation.latitude,
            curLocation.longitude,
            fnameController.text,
            lnameController.text,
            curUser!.email!,
            imageFile);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return MainScreen();
            },
          ),
        );
      } on Exception catch (e) {
        String message = e.toString();
        if (e.toString().contains("EMAIL_EXISTS")) {
          message = "Email mavjud";
        }
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Xatolik"),
              content: Text(message),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Account"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: fnameController,
              decoration: InputDecoration(
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
            TextFormField(
              controller: lnameController,
              decoration: InputDecoration(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    openGallery();
                  },
                  label: Text(
                    "Gallery",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: Icon(
                    Icons.photo,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    openCamera();
                  },
                  label: Text(
                    "Camera",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: Icon(
                    Icons.camera,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                submit();
              },
              child: Text(
                "Continue",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
            if (imageFile != null)
              Container(
                height: 150,
                width: 150,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
