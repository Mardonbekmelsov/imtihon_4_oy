import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imtihon_4_oy/services/events_firebase_services.dart';
import 'package:imtihon_4_oy/services/geocoding_service.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
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
  Map<PolylineId, Polyline> polylines = {};
  LatLng curPlace = const LatLng(41.2856806, 69.2034646);

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

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    }

    try {
      if (selectedDate != null && selectedTime != null && latLng != null) {
      

        await eventsServices.addEvent(
            curentUser,
            titleController.text,
            descriptionController.text,
            selectedDate.toString(),
            "${selectedTime!.hour}:${selectedTime!.minute}",
            imageFile!,
            [],
            [],
            latLng!.latitude,
            latLng!.longitude,
            locationName!);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Error"),
              content: Text("Vaqt, Sana va joylashuv kiritish shart"),
            );
          },
        );
      }
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
                          : const Text("Time"),
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
                          : const Text("Date"),
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
              if (imageFile != null)
                Container(
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
                ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                height: 350,
                // clipBehavior: Clip.hardEdge,
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
                          latLng =
                              LatLng(location.latitude, location.longitude);
                          locationName = locationNameLocal;
                          markers.clear();
                          markers.add(
                            Marker(
                              markerId: const MarkerId("tadbiro"),
                              position:
                                  LatLng(location.latitude, location.longitude),
                              icon: BitmapDescriptor.defaultMarker,
                            ),
                          );
                        });
                      },
                      polylines: Set<Polyline>.of(polylines.values),
                      markers: markers,
                      mapType: mapType,
                      initialCameraPosition:
                          CameraPosition(target: curPlace, zoom: 10),
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
                  "Qo'shish",
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
