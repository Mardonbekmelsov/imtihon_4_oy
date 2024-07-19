import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imtihon_4_oy/models/event_model.dart';
import 'package:imtihon_4_oy/models/user_model.dart';
import 'package:imtihon_4_oy/services/users_firebase_services.dart';
import 'package:imtihon_4_oy/views/screens/main_screen.dart';
import 'package:imtihon_4_oy/views/widgets/modal_bottom_sheet.dart';

// ignore: must_be_immutable
class EventDetailsScreen extends StatefulWidget {
  final EventModel event;
  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

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
    return Scaffold(
      body: StreamBuilder(
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
                child: Text("User topilmadi"),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            final user = UserModel.fromJson(snapshot.data!);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      image: DecorationImage(
                          image: NetworkImage(
                            widget.event.imageUrl,
                          ),
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (user.likedEvents
                                    .contains(widget.event.id)) {
                                  usersFirebaseServices.removeLikedEvent(
                                      auth.currentUser!.uid, widget.event.id);
                                } else {
                                  usersFirebaseServices.addLikedEvent(
                                      auth.currentUser!.uid, widget.event.id);
                                }
                              },
                              icon:
                                  user.likedEvents.contains(widget.event.id)
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
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: Text(
                            widget.event.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          // width: double.infinity,
                          // height: 110,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.teal.shade100,
                              ),
                              child: const Icon(
                                Icons.calendar_today_rounded,
                                size: 40,
                              ),
                            ),
                            title: Text(
                              "${months[widget.event.date.month - 1]} ${widget.event.date.day}, ${widget.event.date.year}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("Time: ${widget.event.time}"),
                          ),
                        ),
                        Container(
                          // width: double.infinity,
                          // height: 110,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.teal.shade100,
                              ),
                              child: const Icon(
                                Icons.place,
                                size: 40,
                              ),
                            ),
                            title: Text(
                              "${widget.event.placeName.split(" ")[1]} ${widget.event.placeName.split(" ")[2]}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          // width: double.infinity,
                          // height: 110,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.teal.shade100,
                              ),
                              child: const Icon(
                                Icons.people,
                                size: 40,
                              ),
                            ),
                            title: Text(
                              "${widget.event.participantsAmount} kishi bormoqda",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: const Text("Siz ham ro'yhatdan o'ting"),
                          ),
                        ),
                        Container(
                          // width: double.infinity,
                          // height: 110,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: Container(
                              height: 70,
                              width: 70,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.teal.shade100,
                              ),
                              child: StreamBuilder(
                                stream: usersFirebaseServices
                                    .getUserById(widget.event.creatorId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: Text("User topilmadi"),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(snapshot.error.toString()),
                                    );
                                  }
                                  final creator = UserModel.fromJson(snapshot.data!);

                                  return Image.network(
                                    creator.imageurl,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              "${months[widget.event.date.month - 1]} ${widget.event.date.day}, ${widget.event.date.year}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("Time: ${widget.event.time}"),
                          ),
                        ),
                        const Text(
                          "Tadbir haqida",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(1),
                          child: Expanded(
                            child: Text(
                              widget.event.description,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Manzil",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            "${widget.event.placeName.split(" ")[1]}, ${widget.event.placeName.split(" ")[2]}"),
                        const SizedBox(
                          height: 10,
                        ),
                        widget.event.date.isAfter(DateTime.now())
                            ? !user.participatedEvents
                                    .contains(widget.event.id)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 70),
                                          side: const BorderSide(
                                              color: Colors.orange, width: 3),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          backgroundColor:
                                              Colors.orange.shade50,
                                        ),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return ModalBottomSheet(
                                                  user: user,
                                                  event: widget.event,
                                                );
                                              });
                                        },
                                        child: const Text(
                                          "Royxatdan O'tish",
                                          style: TextStyle(
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          TextButton(
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 70),
                                              side: const BorderSide(
                                                  color: Colors.red, width: 3),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              backgroundColor:
                                                  Colors.red.shade50,
                                            ),
                                            onPressed: () {
                                              usersFirebaseServices
                                                  .cancelEvent(widget.event.id);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const MainScreen()));
                                            },
                                            child: const Text(
                                              "Bekor Qilish",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 70),
                                    // height: 30,
                                    // width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade300,
                                      border: Border.all(
                                          color: Colors.grey.shade600,
                                          width: 3),
                                    ),
                                    child: Text(
                                      "Tadbir Yakunlandi",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.grey.shade600),
                                    ),
                                  )
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
