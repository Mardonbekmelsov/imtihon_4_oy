import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({
          'lat': lat,
          'lng': lng,
          'fname': fname,
          'lname': lname,
          "email": email,
          'imageUrl': imageUrl,
          'likedEvents': [],
          'createdEvents': [],
          'participatedEvents': [],
          'canceledEvents': [],
        });
      });
    }
  }

  Future<void> addLikedEvent(String userId, String eventId) async {
    final userBox = await usersCollection.doc(userId).get();
    final user = userBox.data();
    user!['likedEvents'].add(eventId);
    await usersCollection
        .doc(userId)
        .update({'likedEvents': user['likedEvents']});
  }

  Future<void> removeLikedEvent(String userId, String eventId) async {
    final userBox = await usersCollection.doc(userId).get();
    final user = userBox.data();
    user!['likedEvents'].removeWhere((element) {
      return element == eventId;
    });
    await usersCollection
        .doc(userId)
        .update({'likedEvents': user['likedEvents']});
  }

  Stream<DocumentSnapshot> getUserById(String userId) async* {
    print(userId);
    final userBox = await usersCollection.doc(userId).snapshots();
    // print(userBox);
    // final user = userBox.data();
    // print("--------------------------$user");
    yield* userBox;
  }

  Future<void> participateToEvent(String eventId) async {
    final userBox =
        await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    final userData = userBox.data();
    userData!['participatedEvents'].add(eventId);
    usersCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'participatedEvents': userData['participatedEvents']});
  }

  Future<void> cancelEvent(String eventId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userBox = await usersCollection.doc(userId).get();
    final userData = userBox.data();
    userData!['canceledEvents'].add(eventId);
    userData['participatedEvents'].removeWhere((element) {
      return element == eventId;
    });
    usersCollection.doc(userId).update({
      "participatedEvents": userData['participatedEvents'],
      "canceledEvents": userData['canceledEvents']
    });
  }
}
