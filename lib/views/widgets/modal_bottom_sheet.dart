import 'package:flutter/material.dart';
import 'package:imtihon_4_oy/models/event_model.dart';
import 'package:imtihon_4_oy/models/user_model.dart';
import 'package:imtihon_4_oy/services/events_firebase_services.dart';
import 'package:imtihon_4_oy/services/users_firebase_services.dart';
import 'package:imtihon_4_oy/views/screens/main_screen.dart';

// ignore: must_be_immutable
class ModalBottomSheet extends StatefulWidget {
  EventModel event;
  UserModel user;
  ModalBottomSheet({super.key, required this.event, required this.user});
  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  final EventsFirebaseServices eventsFirebaseServices =
      EventsFirebaseServices();
  final UsersFirebaseServices usersFirebaseServices = UsersFirebaseServices();
  int visitorCount = 0;

  int? selectedIndex;

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
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Ro'yxatdan o'tish",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.clear,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Joylar Sonini Tanlang",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: IconButton(
                    onPressed: () {
                      if (visitorCount > 0) {
                        setState(() {
                          visitorCount -= 1;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.remove,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "$visitorCount",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        visitorCount += 1;
                      });
                    },
                    icon: const Icon(
                      Icons.add,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "To'lov Turini Tanlang",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ListTile(
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
              tileColor: Colors.white,
              minVerticalPadding: 10,
              leading: Container(
                height: 30,
                width: 30,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                  10,
                )),
                child: Image.network(
                  "https://static10.tgstat.ru/channels/_0/56/5658e449ee736d57903551c4b5347183.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              title: const Text(
                "Click",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              trailing: selectedIndex == 0
                  ? const Icon(
                      Icons.check_circle_outline,
                      color: Colors.blue,
                    )
                  : const Icon(
                      Icons.circle_outlined,
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
              tileColor: Colors.white,
              minVerticalPadding: 10,
              leading: Container(
                height: 30,
                width: 30,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                  10,
                )),
                child: Image.network(
                  "https://is2-ssl.mzstatic.com/image/thumb/Purple113/v4/b4/3e/c8/b43ec8b3-e314-61ee-44f1-9d2f4f2fcc57/AppIcon-0-0-1x_U007emarketing-0-0-0-8-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/600x600wa.png",
                  fit: BoxFit.cover,
                ),
              ),
              title: const Text(
                "Payme",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              trailing: selectedIndex == 1
                  ? const Icon(
                      Icons.check_circle_outline,
                      color: Colors.blue,
                    )
                  : const Icon(
                      Icons.circle_outlined,
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
              },
              tileColor: Colors.white,
              minVerticalPadding: 10,
              leading: Container(
                height: 30,
                width: 30,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                  10,
                )),
                child: Image.network(
                  "https://i.artfile.ru/2560x1600_1287486_[www.ArtFile.ru].jpg",
                  fit: BoxFit.cover,
                ),
              ),
              title: const Text(
                "Naqd",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              trailing: selectedIndex == 2
                  ? const Icon(
                      Icons.check_circle_outline,
                      color: Colors.blue,
                    )
                  : const Icon(
                      Icons.circle_outlined,
                    ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    eventsFirebaseServices.addVisitor(
                        widget.event.id, widget.user.userId, visitorCount);
                    usersFirebaseServices.participateToEvent(widget.event.id);
                    usersFirebaseServices.sendParticipateMessage(
                        widget.event.creatorId,
                        widget.user.imageurl,
                        widget.user.fname,
                        widget.user.lname,
                        "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}, ${months[DateTime.now().month - 1]} ${DateTime.now().day}, ${DateTime.now().year}",
                        "${widget.event.title} tadbiringizga qatnashoqchiman, qabul qila olasizmi?");

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const MainScreen();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.orange.shade100,
                  ),
                  child: const Text(
                    "Keyingi",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
