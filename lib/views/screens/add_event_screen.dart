import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imtihon_4_oy/services/events_firebase_services.dart';
import 'package:imtihon_4_oy/services/geocoding_service.dart';

class AddEventScreen extends StatefulWidget {
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
        Duration(days: 1000),
      ),
    );
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

    if (selectedDate != null && selectedTime != null && latLng != null) {
      eventsServices.addEvent(
          titleController.text,
          selectedTime.toString(),
          selectedDate.toString(),
          descriptionController.text,
          [],
          [],
          latLng!.latitude,
          latLng!.longitude);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Vaqt, Sana va joylashuv kiritish shart"),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Event"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
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
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Title"),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  _selectTime(context);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
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
                          ? Text("${selectedTime!.format(context)}")
                          : Text("Time"),
                      Icon(
                        Icons.watch_later_outlined,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
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
                          : Text("Date"),
                      Icon(
                        Icons.calendar_month,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
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
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  decoration: InputDecoration(
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
                    label: Text("Gallery"),
                    icon: Icon(
                      Icons.photo,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      openCamera();
                    },
                    label: Text("Camera"),
                    icon: Icon(
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
              SizedBox(
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
                      onTap: (LatLng location) async {
                        GeocodingService geocodingService = GeocodingService(
                            apiKey: "cc8ca831-bc74-4ae4-ad76-186813085a45");
                        String? locationNameLocal =
                            await geocodingService.getAddressFromCoordinates(
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
                              markerId: const MarkerId("restaurant"),
                              position:
                                  LatLng(location.latitude, location.longitude),
                              icon: BitmapDescriptor.defaultMarker,
                            ),
                          );
                        });
                      },
                      markers: markers,
                      mapType: mapType,
                      initialCameraPosition:
                          CameraPosition(target: LatLng(42, 69), zoom: 15),
                      onMapCreated: onMapCreated,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  submit();
                },
                child: Text(
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
