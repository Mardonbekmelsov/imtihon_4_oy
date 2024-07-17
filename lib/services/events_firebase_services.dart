// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class EventsFirebaseServices {
  final eventsCollection = FirebaseFirestore.instance.collection('events');
  final eventsImagesStorage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getEvents() async* {
    yield* eventsCollection.snapshots();
  }

  Future<void> deleteEvent(String id) async {
    await eventsCollection.doc(id).delete();
  }

  Future<void> addEvent(
      String creatorId,
      String title,
      String description,
      String date,
      String time,
      File? imageFile,
      List visitorsId,
      List likedUsersId,
      num lat,
      num lng,
      String placeName) async {
    if (imageFile != null) {
      final imageReference = eventsImagesStorage
          .ref()
          .child("events")
          .child("images")
          .child("${randomAlphaNumeric(16)}.jpg");

      final uploadTask = await imageReference.putFile(imageFile);

      final imageUrlDownload = await imageReference.getDownloadURL();

      await eventsCollection.add({
        "creatorId": creatorId,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
        'imageUrl': imageUrlDownload,
        "visitorsId": visitorsId,
        "likedUsersId": likedUsersId,
        'participantsAmount': 0,
        "lat": lat,
        "lng": lng,
        'placeName': placeName,
      });
    } else {
      await eventsCollection.add({
        "creatorId": creatorId,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
        'imageUrl': null,
        "visitorsId": visitorsId,
        "likedUsersId": likedUsersId,
        'participantsAmount': 0,
        "lat": lat,
        "lng": lng,
        'placeName': placeName,
      });
    }
  }

  Future<void> editEvent(
      String id,
      String creatorId,
      String title,
      String description,
      String date,
      String time,
      File? imageFile,
      List<String> visitorsId,
      List<String> likedUsersId,
      num lat,
      num lng,
      String placeName) async {
    if (imageFile != null) {
      final imageReference = eventsImagesStorage
          .ref()
          .child("events")
          .child("images")
          .child("${randomAlphaNumeric(16)}.jpg");

      final uploadTask = await imageReference.putFile(imageFile);

      final imageUrlDownload = await imageReference.getDownloadURL();

      eventsCollection.doc(id).update({
        "creatorId": creatorId,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
        'imageUrl': imageUrlDownload,
        "visitorsId": visitorsId,
        "likedUsersId": likedUsersId,
        "lat": lat,
        "lng": lng,
        'placeName': placeName,
      });
    } else {
      await eventsCollection.doc(id).update({
        "creatorId": creatorId,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
        "visitorsId": visitorsId,
        "likedUsersId": likedUsersId,
        "lat": lat,
        "lng": lng,
        'placeName': placeName,
      });
    }
  }

  Future<void> addVisitor(
      String eventId, String visitorId, int visitorsAmount) async {
    final eventBox = await eventsCollection.doc(eventId).get();
    final event = eventBox.data();
    event!['visitorsId'].add(visitorId);
    event['participantsAmount'] += visitorsAmount;
    eventsCollection.doc(eventId).update({
      "visitorsId": event['visitorsId'],
      'participantsAmount': event['participantsAmount']
    });
  }
  
}
