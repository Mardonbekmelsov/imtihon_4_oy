import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imtihon_4_oy/models/event_model.dart';
import 'package:imtihon_4_oy/services/events_firebase_services.dart';
import 'package:imtihon_4_oy/services/users_firebase_services.dart';
import 'package:imtihon_4_oy/views/screens/main_screen.dart';

// ignore: must_be_immutable
class ModalBottomSheet extends StatefulWidget {
  EventModel event;
  ModalBottomSheet({required this.event});
  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  final EventsFirebaseServices eventsFirebaseServices =
      EventsFirebaseServices();
  final UsersFirebaseServices usersFirebaseServices = UsersFirebaseServices();
  int visitorCount = 0;

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
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
                    icon: Icon(
                      Icons.clear,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Joylar Sonini Tanlang",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(
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
                    icon: Icon(
                      Icons.remove,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "$visitorCount",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
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
                    icon: Icon(
                      Icons.add,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "To'lov Turini Tanlang",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
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
              title: Text(
                "Click",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              trailing: selectedIndex == 0
                  ? Icon(
                      Icons.check_circle_outline,
                      color: Colors.blue,
                    )
                  : Icon(
                      Icons.circle_outlined,
                    ),
            ),
            SizedBox(
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
              title: Text(
                "Payme",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              trailing: selectedIndex == 1
                  ? Icon(
                      Icons.check_circle_outline,
                      color: Colors.blue,
                    )
                  : Icon(
                      Icons.circle_outlined,
                    ),
            ),
            SizedBox(
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
              title: Text(
                "Naqd",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              trailing: selectedIndex == 2
                  ? Icon(
                      Icons.check_circle_outline,
                      color: Colors.blue,
                    )
                  : Icon(
                      Icons.circle_outlined,
                    ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    eventsFirebaseServices.addVisitor(widget.event.id,
                        FirebaseAuth.instance.currentUser!.uid, visitorCount);
                    usersFirebaseServices.participateToEvent(widget.event.id);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return MainScreen();
                    }));
                  },
                  child: Text(
                    "Keyingi",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.orange.shade100,
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
