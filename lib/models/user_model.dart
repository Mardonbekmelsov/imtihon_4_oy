import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId;
  double lat;
  double lng;
  String fname;
  String lname;
  String email;
  String imageurl;
  List<String> createdEvents;
  List<String> participatedEvents;
  List<String> canceledEvents;

  UserModel({
    required this.userId,
    required this.lat,
    required this.lng,
    required this.fname,
    required this.lname,
    required this.email,
    required this.imageurl,
    required this.createdEvents,
    required this.participatedEvents,
    required this.canceledEvents,
  });

  factory UserModel.fromQuery(QueryDocumentSnapshot query) {
    return UserModel(
        userId: query.id,
        lat: query['lat'],
        lng: query['lng'],
        fname: query['fname'],
        lname: query['lname'],
        email: query['email'],
        imageurl: query['imageUrl'],
        createdEvents: query['createdEvents'],
        participatedEvents: query['participatedEvents'],
        canceledEvents: query['canceledEvents']);
  }
}
