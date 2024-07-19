import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imtihon_4_oy/models/event_model.dart';
import 'package:imtihon_4_oy/services/events_firebase_services.dart';
import 'package:imtihon_4_oy/views/screens/add_event_screen.dart';
import 'package:imtihon_4_oy/views/widgets/event_widget.dart';

class MyEventsScreen extends StatelessWidget {
  final eventsServices = EventsFirebaseServices();
  final curUser = FirebaseAuth.instance.currentUser!.uid;

  MyEventsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: eventsServices.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Malumotlar topilmadi"),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final events = snapshot.data?.docs;
          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: events!.length,
            itemBuilder: (context, index) {
              final event = EventModel.fromQuery(events[index]);

              if (event.creatorId == curUser) {
                return EventWidget(event: event);
              } else {
                return const SizedBox();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEventScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
