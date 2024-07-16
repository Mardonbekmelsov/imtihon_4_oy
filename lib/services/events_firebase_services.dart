import 'package:cloud_firestore/cloud_firestore.dart';

class EventsFirebaseServices {
  final eventColllection = FirebaseFirestore.instance.collection("events");

  Stream<QuerySnapshot> getEvents() async* {
    yield* eventColllection.snapshots();
  }

  void editEvent(
      String id,
      String newTitle,
      String newTime,
      String newdate,
      String newDescription,
      List<String> visitorsId,
      List<String> likedUsersId,
      double newLat,
      double newLng) {
    eventColllection.doc(id).update({
      'title': newTitle,
      'time': newTime,
      'date': newdate,
      'description': newDescription,
      'visitorsId': visitorsId,
      'likedUsersId': likedUsersId,
      'lat': newLat,
      'lng': newLng,
    });
  }

  void addEvent(
      String title,
      String time,
      String date,
      String description,
      List<String> visitorsId,
      List<String> likedUsersId,
      double lat,
      double lng) {
    eventColllection.add({
      'title': title,
      'time': time,
      'date': date,
      'description': description,
      'visitorsId': visitorsId,
      'likedUsersId': likedUsersId,
      'lat': lat,
      'lng': lng,
    });
  }
}
