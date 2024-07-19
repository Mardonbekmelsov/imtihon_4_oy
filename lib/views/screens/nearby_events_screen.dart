import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imtihon_4_oy/models/event_model.dart';
import 'package:imtihon_4_oy/services/events_firebase_services.dart';
import 'package:imtihon_4_oy/services/users_firebase_services.dart';
import 'package:imtihon_4_oy/views/widgets/event_widget.dart';

class NearbyEventsScreen extends StatelessWidget {
  final eventsServices = EventsFirebaseServices();
  final UsersFirebaseServices usersFirebaseServices = UsersFirebaseServices();
  final curUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: eventsServices.getEvents(),
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

          final events = snapshot.data!.docs;

          return StreamBuilder(
              stream: usersFirebaseServices.getUserById(curUser),
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

                final user = snapshot.data;
                return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = EventModel.fromQuery(events[index]);
                      if (user!['participatedEvents'].contains(event.id) &&
                          event.date.isAfter(DateTime.now())) {
                        return EventWidget(event: event);
                      } else {
                        return SizedBox();
                      }
                    });
              });
        },
      ),
    );
  }
}
