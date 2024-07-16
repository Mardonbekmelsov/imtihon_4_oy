import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class UsersFirebaseServices {
  final usersCollection = FirebaseFirestore.instance.collection("users");
  final usersImageStorage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getUsers() async* {
    yield* usersCollection.snapshots();
  }

  void addUser(double lat, double lng, String fname, String lname, String email,
      File? image) {
    if (image != null) {
      final imageReference = usersImageStorage
          .ref()
          .child("users")
          .child("images")
          .child("${randomAlphaNumeric(16)}.jpg");
      final uploadTask = imageReference.putFile(
        image,
      );

      uploadTask.snapshotEvents.listen((status) {});

      uploadTask.whenComplete(() async {
        final imageUrl = await imageReference.getDownloadURL();
        usersCollection.add({
          'lat': lat,
          'lng': lng,
          'fname': fname,
          'lname': lname,
          "email": email,
          'imageUrl': imageUrl,
          'createdEvents': [],
          'participatedEvents': [],
          'canceledEvents': [],
        });
      });
    }
  }
}
