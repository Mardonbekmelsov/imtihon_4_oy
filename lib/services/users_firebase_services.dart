import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class UsersFirebaseServices {
  final usersCollection = FirebaseFirestore.instance.collection("users");
  final usersImageStorage = FirebaseStorage.instance;

 

  void addUser(double lat, double lng, String fname, String lname, String email,
      File? image) async {
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

      await uploadTask.whenComplete(() async {
        final imageUrl = await imageReference.getDownloadURL();
        await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({
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
          'isMessageActive': false,
          'messages': []
        });
      });
    }

  }
    Future<void> sendParticipateMessage(
        String creatorId,
        String senderImage,
        String senderFname,
        String senderLname,
        String time,
        String message) async {
      final userBox = await usersCollection.doc(creatorId).get();
      final userData = userBox.data();
      userData!['messages'].add({
        "senderFname": senderFname,
        "senderLname": senderLname,
        "senderImage": senderImage,
        "message": message,
        "time": time
      });
      userData['isMessageActive'] = true;

      usersCollection.doc(creatorId).update({
        'messages': userData['messages'],
        "isMessageActive": userData['isMessageActive'],
      });
    }

  Future<void> changeMessageActivity(String id) async {
    usersCollection.doc(id).update({"isMessageActive": false});
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
    final userBox =  usersCollection.doc(userId).snapshots();
  
    yield* userBox;
  }

  Future<void> participateToEvent(String eventId) async {
    final userBox =
        await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    final userData = userBox.data();
    userData!['participatedEvents'].add(eventId);
    userData['canceledEvents'].removeWhere((element) {
      return element == eventId;
    });
    usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
      'participatedEvents': userData['participatedEvents'],
      "canceledEvents": userData["canceledEvents"]
    });
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

  Future<void> editUser(
      String userId, String fname, String lname, var image) async {
    final userBox = await usersCollection.doc(userId).get();
    final userData = userBox.data();
    userData!['fname'] = fname;
    userData['lname'] = lname;
    if (image.runtimeType == String) {
      print(
          "- - - -  - -  - - -  - - - - - - - - - - - - --  - - - --- - - -- ");
      userData['imageUrl'] = image;
      usersCollection.doc(userId).update({
        'fname': userData['fname'],
        'lname': userData['lname'],
        'imageUrl': userData['imageUrl']
      });
    } else {
      print("_______________________________________________-image");
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
        userData['imageUrl'] = imageUrl;
        usersCollection.doc(userId).update({
          'fname': userData['fname'],
          'lname': userData['lname'],
          'imageUrl': userData['imageUrl']
        });
      });
    }
  }
}
