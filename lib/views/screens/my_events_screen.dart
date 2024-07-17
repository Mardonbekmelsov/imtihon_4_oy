import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imtihon_4_oy/models/event_model.dart';
import 'package:imtihon_4_oy/services/events_firebase_services.dart';
import 'package:imtihon_4_oy/views/screens/add_event_screen.dart';
import 'package:imtihon_4_oy/views/screens/edit_event_screen.dart';

class MyEventsScreen extends StatelessWidget {
  final eventsServices = EventsFirebaseServices();
  final curUser = FirebaseAuth.instance.currentUser!.uid;
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
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

          final events = snapshot.data?.docs;
          return ListView.builder(
            padding: EdgeInsets.only(top: 10),
            itemCount: events!.length,
            itemBuilder: (context, index) {
              final event = EventModel.fromQuery(events[index]);

              if (event.creatorId == curUser) {
                print("-----------------------------enter");
                return Container(
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.network(
                          event.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${event.time}  ${months[event.date.month - 1]} ${event.date.day}, ${event.date.year}",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.place_outlined,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "${event.placeName.split(" ")[1]}  ${event.placeName.split(" ")[2]}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert_outlined),
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem<String>(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditEventScreen(
                                                      event: event)));
                                    },
                                    value: 'Tahrirlash',
                                    child: Text('Tahrirlash'),
                                  ),
                                  PopupMenuItem<String>(
                                    onTap: () async {
                                      await eventsServices
                                          .deleteEvent(event.id);
                                    },
                                    value: "O'chirish",
                                    child: Text("O'chirish"),
                                  ),
                                ];
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox();
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
              builder: (context) => AddEventScreen(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
