import 'package:flutter/material.dart';
import 'package:imtihon_4_oy/views/screens/canceled_events_screen.dart';
import 'package:imtihon_4_oy/views/screens/my_events_screen.dart';
import 'package:imtihon_4_oy/views/screens/nearby_events_screen.dart';
import 'package:imtihon_4_oy/views/screens/participated_events_screen.dart';
import 'package:imtihon_4_oy/views/widgets/custom_drawer.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Mening tadbirlarim'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_none_outlined),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Tashkil qilganlarim'),
              Tab(text: 'Yaqinda'),
              Tab(text: 'Ishtirok etganlarim'),
              Tab(text: 'Bekor qilinganlar'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyEventsScreen(),
            NearbyEventsScreen(),
            ParticipatedEventsScreen(),
            CanceledEventsScreen(),
          ],
        ),
      ),
    );
  }
}
