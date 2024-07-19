import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imtihon_4_oy/models/event_model.dart';
import 'package:imtihon_4_oy/services/events_firebase_services.dart';
import 'package:imtihon_4_oy/services/users_firebase_services.dart';
import 'package:imtihon_4_oy/views/screens/edit_event_screen.dart';
import 'package:imtihon_4_oy/views/screens/event_details_screen.dart';

// ignore: must_be_immutable
class EventWidget extends StatelessWidget {
  EventModel event;
  EventWidget({required this.event});
  final EventsFirebaseServices eventsFirebaseServices =
      EventsFirebaseServices();
  final UsersFirebaseServices usersFirebaseServices = UsersFirebaseServices();

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
    return InkWell(
      onTap:  event.creatorId==FirebaseAuth.instance.currentUser!.uid? null: (){Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EventDetailsScreen(
                                                    event: event)));},
      child: Container(
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
              child: StreamBuilder(
                  stream: usersFirebaseServices
                      .getUserById(FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("User topilmadi:("),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
      
                    final user = snapshot.data;
                    return Column(
                      mainAxisAlignment: event.creatorId ==
                              FirebaseAuth.instance.currentUser!.uid
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        event.creatorId==FirebaseAuth.instance.currentUser!.uid?  PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert_outlined),
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem<String>(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditEventScreen(event: event)));
                                },
                                value: 'Tahrirlash',
                                child: Text('Tahrirlash'),
                              ),
                              PopupMenuItem<String>(
                                onTap: () async {
                                  await eventsFirebaseServices
                                      .deleteEvent(event.id);
                                },
                                value: "O'chirish",
                                child: Text("O'chirish"),
                              ),
                            ];
                          },
                        ):IconButton(
                                                  onPressed: () {
                                                    if (user['likedEvents']
                                                        .contains(event.id)) {
                                                      usersFirebaseServices
                                                          .removeLikedEvent(
                                                              FirebaseAuth.instance.currentUser!
                                                                  .uid,
                                                              event.id);
                                                    } else {
                                                      usersFirebaseServices
                                                          .addLikedEvent(
                                                              FirebaseAuth.instance.currentUser!
                                                                  .uid,
                                                              event.id);
                                                    }
                                                  },
                                                  icon: user!['likedEvents']
                                                          .contains(event.id)
                                                      ? const Icon(
                                                          Icons.favorite,
                                                          color: Colors.red,
                                                        )
                                                      : const Icon(
                                                          Icons.favorite_border,
                                                          color: Colors.grey,
                                                        ),
                                                ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
