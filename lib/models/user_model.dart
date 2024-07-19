import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId;
  double lat;
  double lng;
  String fname;
  String lname;
  String email;
  String imageurl;
  List likedEvents;
  List createdEvents;
  List participatedEvents;
  List canceledEvents;
  bool isMessageActive;
  List messages;

  UserModel(
      {required this.userId,
      required this.lat,
      required this.lng,
      required this.fname,
      required this.lname,
      required this.email,
      required this.imageurl,
      required this.likedEvents,
      required this.createdEvents,
      required this.participatedEvents,
      required this.canceledEvents,
      required this.isMessageActive,
      required this.messages});

  factory UserModel.fromJson(DocumentSnapshot query) {
    return UserModel(
      userId: query.id,
      lat: query['lat'],
      lng: query['lng'],
      fname: query['fname'],
      lname: query['lname'],
      email: query['email'],
      imageurl: query['imageUrl'],
      likedEvents: query['likedEvents'],
      createdEvents: query['createdEvents'],
      participatedEvents: query['participatedEvents'],
      canceledEvents: query['canceledEvents'],
      isMessageActive: query['isMessageActive'],
      messages: query['messages'],
    );
  }
}
