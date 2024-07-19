import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imtihon_4_oy/models/event_model.dart';
import 'package:imtihon_4_oy/services/events_firebase_services.dart';
import 'package:imtihon_4_oy/services/geocoding_service.dart';

// ignore: must_be_immutable
class EditEventScreen extends StatefulWidget {
  EventModel event;
  EditEventScreen({super.key, required this.event});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  LatLng? latLng;
  Set<Marker> markers = {};
  MapType mapType = MapType.normal;
  late GoogleMapController myController;
  String? locationName;
  final formKey = GlobalKey<FormState>();
  final eventsServices = EventsFirebaseServices();
  final curentUser = FirebaseAuth.instance.currentUser!.uid;

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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 1000),
      ),
    );
    // ignore: unrelated_type_equality_checks
    if (pickedDate != null && pickedDate != selectedTime) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  File? imageFile;

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
        imageQuality: 50);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera,
        requestFullMetadata: false,
        imageQuality: 50);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.event.title;
    descriptionController.text = widget.event.description;
  }

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    }

    try {
      await eventsServices.editEvent(
        widget.event.id,
        curentUser,
        titleController.text,
        descriptionController.text,
        selectedDate == null
            ? widget.event.date.toString()
            : selectedDate.toString(),
        selectedTime == null
            ? widget.event.time
            : "${selectedTime!.hour}:${selectedTime!.minute}",
        imageFile,
        [],
        [],
        latLng == null ? widget.event.lat : latLng!.latitude,
        latLng == null ? widget.event.lng : latLng!.longitude,
        locationName ?? widget.event.placeName,
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Event"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                child: TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Title"),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  _selectTime(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  // height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 3,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      selectedTime != null
                          ? Text(selectedTime!.format(context))
                          : Text(widget.event.time),
                      const Icon(
                        Icons.watch_later_outlined,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  // height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 3,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      selectedDate != null
                          ? Text(
                              "${months[selectedDate!.month - 1]} ${selectedDate!.day}, ${selectedDate!.year}")
                          : Text(
                              "${months[widget.event.date.month - 1]} ${widget.event.date.day}, ${widget.event.date.year}"),
                      const Icon(
                        Icons.calendar_month,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                child: TextFormField(
                  controller: descriptionController,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "description"),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      openGallery();
                    },
                    label: const Text("Gallery"),
                    icon: const Icon(
                      Icons.photo,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      openCamera();
                    },
                    label: const Text("Camera"),
                    icon: const Icon(
                      Icons.camera,
                    ),
                  ),
                ],
              ),
              imageFile != null
                  ? Container(
                      height: 200,
                      width: double.infinity,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 200,
                      width: double.infinity,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.network(
                        widget.event.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                height: 300,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber)),
                child: Stack(
                  children: [
                    GoogleMap(
                      // ignore: prefer_collection_literals
                      gestureRecognizers: Set()
                        ..add(Factory<EagerGestureRecognizer>(
                            () => EagerGestureRecognizer())),
                      onTap: (LatLng location) async {
                        String? locationNameLocal =
                            await GeocodingService.getAddressFromCoordinates(
                                location.latitude, location.longitude);
                        setState(() {
                          // markerTapCheck = false;
                          // mapTapCheck = true;
                          latLng =
                              LatLng(location.latitude, location.longitude);
                          locationName = locationNameLocal;
                          markers.clear();
                          markers.add(
                            Marker(
                              markerId: const MarkerId("event"),
                              position:
                                  LatLng(location.latitude, location.longitude),
                              icon: BitmapDescriptor.defaultMarker,
                            ),
                          );
                        });
                      },
                      markers: markers,
                      mapType: mapType,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(widget.event.lat.toDouble(),
                              widget.event.lng.toDouble()),
                          zoom: 15),
                      onMapCreated: onMapCreated,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  submit();
                },
                child: const Text(
                  "Tahrirlash",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
