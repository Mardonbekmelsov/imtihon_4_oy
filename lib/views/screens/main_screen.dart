import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imtihon_4_oy/models/event_model.dart';
import 'package:imtihon_4_oy/models/user_model.dart';
import 'package:imtihon_4_oy/services/events_firebase_services.dart';
import 'package:imtihon_4_oy/services/users_firebase_services.dart';
import 'package:imtihon_4_oy/views/screens/event_details_screen.dart';
import 'package:imtihon_4_oy/views/screens/messages_screen.dart';
import 'package:imtihon_4_oy/views/widgets/custom_drawer.dart';
import 'package:imtihon_4_oy/views/widgets/event_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final UsersFirebaseServices usersFirebaseServices = UsersFirebaseServices();
  final searchController = TextEditingController();

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

  final eventsServices = EventsFirebaseServices();
  Timer? debounce;
  String searchQuery = '';
  String searchMode = 'name';

  Future<void> _checkTokenValidity(User user) async {
    try {
      IdTokenResult tokenResult = await user.getIdTokenResult(true);
      DateTime? expirationTime = tokenResult.expirationTime;
      if (expirationTime != null && expirationTime.isBefore(DateTime.now())) {
        auth.signOut();
      }
    } catch (e) {
      print('Error checking token validity: $e');
    }
  }

  void onSearchChanged(String query) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = query;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: usersFirebaseServices.getUserById(auth.currentUser!.uid),
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
          dynamic user = snapshot.data;
          if (user == null || user.data() == null) {
            return const Center(
              child: Text("User topilmadi:("),
            );
          }
          user = UserModel.fromJson(user);
          // print(user/['isMessageRead']);

          return Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(
              title: const Text("Main Screen"),
              centerTitle: true,
              actions: [
                user.isMessageActive
                    ? IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessagesScreen()));
                                  usersFirebaseServices.changeMessageActivity(user.id);
                        },
                        icon: Icon(
                          CupertinoIcons.bell_circle,
                          size: 35,
                          color: Colors.red,
                        ))
                    : IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.bell_circle_fill,
                          size: 35,
                        ))
              ],
            ),
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
                    child: Text("Ma'lumotlar topilmadi"),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                final events = snapshot.data!.docs;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        onChanged: onSearchChanged,
                        controller: searchController,
                        decoration: InputDecoration(
                          suffixIcon: PopupMenuButton(itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                child: const Text("Tadbir nomi bo'ticha"),
                                onTap: () {
                                  setState(() {
                                    searchMode = 'name';
                                  });
                                },
                              ),
                              PopupMenuItem(
                                child: const Text("Tadbir manzili bo'ticha"),
                                onTap: () {
                                  setState(() {
                                    searchMode = 'location';
                                  });
                                },
                              )
                            ];
                          }),
                          hintText: "Search",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Flexible(
                        flex: 5,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = EventModel.fromQuery(events[index]);
                            if (event.date.isBefore(DateTime.now()
                                    .add(const Duration(days: 7))) &&
                                DateTime.now().isBefore(event.date)) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EventDetailsScreen(
                                                  event: event)));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height: 300,
                                  width: 380,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage(event.imageUrl),
                                        fit: BoxFit.cover),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.black,
                                            ),
                                            padding: const EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "${event.date.day}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Text(
                                                  months[event.date.month - 1],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                if (user.likedEvents
                                                    .contains(event.id)) {
                                                  usersFirebaseServices
                                                      .removeLikedEvent(
                                                          auth.currentUser!.uid,
                                                          event.id);
                                                } else {
                                                  usersFirebaseServices
                                                      .addLikedEvent(
                                                          auth.currentUser!.uid,
                                                          event.id);
                                                }
                                              },
                                              icon: user.likedEvents
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
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        "Barcha tadbirlar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Flexible(
                      flex: 7,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = EventModel.fromQuery(events[index]);
                          if (searchQuery.isEmpty) {
                            if (event.creatorId != user.id) {
                              return EventWidget(event: event);
                            } else {
                              return const SizedBox();
                            }
                          } else {
                            if (searchMode == "name") {
                              if (event.creatorId != user.id) {
                                if (event.title.contains(searchQuery)) {
                                  return EventWidget(event: event);
                                }
                              } else {
                                return const SizedBox();
                              }
                            } else {
                              if (event.creatorId != user.id) {
                                if (event.placeName
                                    .toLowerCase()
                                    .contains(searchQuery)) {
                                  return EventWidget(event: event);
                                }
                              } else {
                                return const SizedBox();
                              }
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }
}
