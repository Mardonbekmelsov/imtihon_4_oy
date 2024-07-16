import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String id;
  String creatorId;
  String title;
  DateTime time;
  String date;
  String description;
  String imageUrl;
  List visitorsId;
  List likedUsersId;
  num lat;
  num lng;

  EventModel({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.time,
    required this.date,
    required this.description,
    required this.imageUrl,
    required this.visitorsId,
    required this.likedUsersId,
    required this.lat,
    required this.lng,
  });

  factory EventModel.fromQuery(QueryDocumentSnapshot query) {
    return EventModel(
        id: query.id,
        creatorId: query['creatorId'],
        title: query['title'],
        time: query['time'],
        date: query['date'],
        description: query['description'],
        imageUrl: query['imageUrl'],
        visitorsId: query['visitorsId'],
        likedUsersId: query['likedUsersId'],
        lat: query['lat'] as double,
        lng: query['lng'] as double);
  }

  toQuery(EventModel event) {
    return {
      "title": event.title,
      "time": event.time,
      'date': event.date,
      'description': event.description,
      'imageUrl': event.imageUrl,
      'visitorsId': event.visitorsId,
      'likedUsersId': event.likedUsersId,
      'lat': event.lat,
      "lng": event.lng,
    };
  }
}
