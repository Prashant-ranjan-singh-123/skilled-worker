import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:v_bhartiya/user_pages/utils/dropdown_menu.dart';
import 'package:v_bhartiya/user_pages/utils/edit_text_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:v_bhartiya/user_pages/utils/userDeviceTokensWork.dart';
import 'package:intl/intl.dart';

import '../utils/snakbar.dart';


class UserProfileEdit extends StatefulWidget {
  @override
  _UserProfileEditState createState() => _UserProfileEditState();
}

class _UserProfileEditState extends State<UserProfileEdit> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  late SharedPreferences pref;
  String? _number;
  XFile? _image;
  bool _isFullNameNotWritten = false;
  bool _isAgeNotWritten = false;
  bool _isHeightNotWritten = false;
  bool _isWeightNotWritten = false;
  bool _isGroupNotWritten = false;
  bool _isBirthNotWritten = false;
  bool _isMarriedNotWritten = false;
  bool _isBloodNotWritten = false;
  bool _isLoactionNotWritten = false;
  final List<String> itemsGroup = [
    'Doctor',
    'Photographer',
    'Programmer',
    'Recruiter',
    'Student',
    'Writer'
  ];
  String? dropDownMenuValueGroup;

  final List<String> itemsMarrage = [
    'Single',
    'Married',
  ];
  String? dropDownMenuValueMarrage;

  String StateIs = 'State';
  String CityIs = 'City';
  String PincodeIs = 'Pin Code';
  String? state;
  String? city;
  String? pinCode;

  final List<String> itemsBloodGroup = [
  'A+',
  'A-',
  'B+',
  'B-',
  'AB+',
  'AB-',
  'O+',
  'O-'
  ];
  String? dropDownMenuValueBloodGroup;

  bool isRequiredFieldFilled() {
    bool doesThingsMessed=false;

    if(_nameController.text.isEmpty){
      _isFullNameNotWritten = true;
      doesThingsMessed = true;
    }
    if(_dobController.text.isEmpty){
      _isBirthNotWritten = true;
      doesThingsMessed = true;
    }
    if(_ageController.text.isEmpty){
      _isAgeNotWritten = true;
      doesThingsMessed = true;
    }
    if(dropDownMenuValueGroup==null){
      _isGroupNotWritten = true;
      doesThingsMessed = true;
    }
    if(dropDownMenuValueBloodGroup==null){
      _isBloodNotWritten = true;
    }
    if(dropDownMenuValueMarrage==null){
      _isMarriedNotWritten = true;
    }
    if(dropDownMenuValueGroup==null){
      _isGroupNotWritten = true;
    }

    String age_str = _ageController.text;
    int age = int.tryParse(age_str) ?? 0;
    // 54.6-271
    String height_str = _heightController.text;
    int height = int.tryParse(height_str)?? 0;

    String weight_str = _weightController.text;
    int weight = int.tryParse(weight_str) ?? 0;

    if(!(age>= 8 && age <= 100)){
      _isAgeNotWritten = true;
      doesThingsMessed = true;
    }else{
      _isAgeNotWritten = false;
    }
    if(!(height>= 55 && height <= 271)){
      _isHeightNotWritten = true;
      doesThingsMessed = true;
    }else{
      print('hahahahahahaha');
      _isHeightNotWritten = false;
    }
    if(!(weight>= 30 && weight <= 150)){
      _isWeightNotWritten = true;
      doesThingsMessed = true;
    }else{
      _isWeightNotWritten = false;
    }
    if(
    StateIs=='State'||
        StateIs=='Location services are disabled.'||
        StateIs=='Enable Location permission.'||
        StateIs=='Permissions Permanently denied.'||
        StateIs=='Loading...'){
      _isLoactionNotWritten = true;
      doesThingsMessed = true;
    }
    if(
    CityIs=='City'||
        CityIs=='Location services are disabled.'||
        CityIs=='Enable Location permission.'||
        CityIs=='Permissions Permanently denied.'||
        CityIs=='Loading...'){
      _isLoactionNotWritten = true;
      doesThingsMessed = true;
    }
    if(
    PincodeIs=='Pin Code'||
        PincodeIs=='Location services are disabled.'||
        PincodeIs=='Enable Location permission.'||
        PincodeIs=='Permissions Permanently denied.'||
        PincodeIs=='Loading...'){
      _isLoactionNotWritten = true;
      doesThingsMessed = true;
    }
    setState(() {});
    if(doesThingsMessed) {
      return false;
    }
    return true;
  }

  Future<void> getLocation() async {
    setState(() {
      StateIs = 'Loading...';
      CityIs = 'Loading...';
      PincodeIs = 'Loading...';
    });
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        state = "Location services are disabled.";
        city = "Location services are disabled.";
        pinCode = "Enable Location Services";
        Get.dialog(
          AlertDialog(
            backgroundColor: Colors.white,
            shadowColor: Colors.black,
            title: Text(
              "Location is Off",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              "To utilize all features, please enable location services.",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close the dialog
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.dialog(
          AlertDialog(
            backgroundColor: Colors.white,
            shadowColor: Colors.black,
            title: Text(
              "Location Permission Denied",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              "Our app requires access to location services to provide you with the best experience. Unfortunately, you have chosen to deny this permission permanently. As a result, certain features may be limited or unavailable. To enable location services and unlock the full functionality of the app, please navigate to your device settings and adjust the permissions accordingly.",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close the dialog
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        setState(() {
          state = "Enable Location permission.";
          city = 'Enable Location permission.';
          pinCode = 'Enable Location permission.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          title: Text(
            "Location Permission Denied Permanently",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            "Our app requires access to location services to provide you with the best experience. Unfortunately, you have chosen to deny this permission permanently. As a result, certain features may be limited or unavailable. To enable location services and unlock the full functionality of the app, please navigate to your device settings and adjust the permissions accordingly\n\nOR REINSTALL THE APP AND GRANT PERMISSION WHEN ASKED.",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      setState(() {
        state = "Permissions Permanently denied.";
        city = "Permissions Permanently denied.";
        pinCode = "Permissions Permanently denied.";
      });
      return;
    }


    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
      );

      for (Placemark placemark in placemarks) {
        setState(() {
          state = placemark.administrativeArea;
          city = placemark.locality;
          pinCode = placemark.postalCode;
        });
      }
      setState(() {
        _isLoactionNotWritten = false;
      });

    } catch (e) {
      setState(() {
        state = "Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        StateIs='State';
        CityIs='City';
        PincodeIs='Pin Code';
      });
    }
  }


  Future<String?> uploadImageToFirebase() async {
    UploadTask? uploadTask;
    if (_image == null) return null;

    final path = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(_image!.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapShot = await uploadTask!.whenComplete(() {});

    return await snapShot.ref.getDownloadURL();
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = pickedFile;
      setState(() {});
      uploadImageToFirebase().then((imageUrl) async {
        if (imageUrl != null) {
          try {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(_number)
                .update({
              'profilePhoto': imageUrl
            });
          } catch(e){
            SnakbarCustom().show('Error uploading image', "$e");
          }
        } else {
          print('Failed to upload image or image is null.');
        }
      }).catchError((error) {
        SnakbarCustom().show('Error uploading image', "$error");
      });
    } else {
      // SnakbarCustom().show('Null Image', "You haven't picked any Image.");
    }
  }


  // void showAlertDialog() {
  //
  // }

  Future<void> submitButton() async {
    if (isRequiredFieldFilled()) {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_number)
          .get();
      var previousSelectGroup = documentSnapshot.data()?['selectGroup'];
      // var pass1 = documentSnapshot.data()?['pass1'];
      // print('Started Updating Token');
      // print('Previous Group: $previousSelectGroup');
      // print('Current Group: $dropDownMenuValue');

      await Tokens().updateToken(_number, previousSelectGroup, dropDownMenuValueGroup!);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_number)
          .update({
        'fullName': _nameController.text,
        'dateOfBirth': _dobController.text,
        'state': StateIs,
        'city': CityIs,
        'pincode': PincodeIs,
        // 'phoneNum': _mobileController.text,
        'age': _ageController.text,
        'martialStatus': dropDownMenuValueMarrage,
        'height': _heightController.text,
        'weight': _weightController.text,
        'bloodGroup': dropDownMenuValueBloodGroup,
        'selectGroup':dropDownMenuValueGroup,
        // 'pass1': pass1
      });
      Get.back();
    }
      
      // Get.dialog(
      //   AlertDialog(
      //     backgroundColor: Colors.white,
      //     shadowColor: Colors.black,
      //     title: Text(
      //       "Field is required",
      //       textAlign: TextAlign.center,
      //       style: TextStyle(
      //         color: Theme.of(context).colorScheme.error,
      //         fontWeight: FontWeight.w700,
      //       ),
      //     ),
      //     content: Text(
      //       "Enter a value in all required fields before proceeding.",
      //       style: TextStyle(
      //         color: Theme.of(context).colorScheme.onPrimary,
      //         fontWeight: FontWeight.w500,
      //       ),
      //     ),
      //     actions: [
      //       TextButton(
      //         onPressed: () {
      //           Get.back(); // Close the dialog
      //         },
      //         child: Container(
      //           decoration: BoxDecoration(
      //             color: Theme.of(context).colorScheme.background,
      //             borderRadius: BorderRadius.circular(8),
      //           ),
      //           padding: EdgeInsets.all(12.0),
      //           child: Text(
      //             "OK",
      //             style: TextStyle(
      //               color: Theme.of(context).colorScheme.onPrimary,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // );
  }


  Future<void> getNum() async {
    pref = await SharedPreferences.getInstance();
    String? num = pref.getString('logedInNum');
    _number = num;
    setState(() {});
  }

  void _setState(){
    setState(() {});
  }


  @override
  void initState() {
    getNum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        title: const Text("Profile"),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30,),

              Center(
                child: GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                    width: 154, // Width + 2 * border width
                    height: 154, // Height + 2 * border width
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4), // Adjust opacity if needed
                          blurRadius: 30, // Increase blurRadius for a softer shadow
                          spreadRadius: 10, // Increase spreadRadius for a wider shadow
                          offset: const Offset(0, 10),)
                      ],
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    clipBehavior: Clip.antiAlias, // Ensure the border is rendered outside the circle
                    child: _image != null
                        ? Image.file(File(_image!.path), fit: BoxFit.cover,)
                        : Image.asset('assets/onboarding/profilePhoto.png', fit: BoxFit.fill,),
                  ),
                ),
              ),
              // Replace the profile image with the user's image

              const SizedBox(height: 50,),
              // General Information Section
              // Add editable text fields for each user detail
              Text("General Information",
                style: TextStyle(
                    fontSize: 19,
                    height: 1.38,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                    color: Theme.of(context).colorScheme.onPrimary
                ),
              ),
              const SizedBox(height: 20,),
              CustomTextField(
                isNum: false,
                controller: _nameController,
                onChange: (){
                  print('object123');
                  _isFullNameNotWritten = false;
                  setState(() {});
                },
                hintText: 'ex: Rohan Singh',
                label: 'Full Name',
                trailingIcon: Icons.location_history_rounded,
              ),

              _isFullNameNotWritten ? errorTextProfile(text: 'Format: Name Surname') : const SizedBox(),

              Card(
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                  child: CustomDropdownMenu(context: context,
                    title: 'Select Group',
                    items: itemsGroup,
                    selectedValue: dropDownMenuValueGroup,
                    onChanged: (String? value) {
                      setState(() {
                        dropDownMenuValueGroup = value;
                        setState(() {
                          _isGroupNotWritten = false;
                        });
                      });
                      // Do something with the selected value
                      print('Selected value: $value');
                    }, isBlackSelectGroup: true,),
                ),
              ),

              _isGroupNotWritten ? errorTextProfile(text: 'Required Field') : const SizedBox(),

              // TextFormField(
              //   controller: _dobController,
              //   decoration: InputDecoration(),
              // ),

              // CustomTextField(
              //   isNum: false,
              //   controller: _dobController,
              //   hintText: '12/05/2002',
              //   label: 'Date Of Birth',
              //   trailingIcon: Icons.date_range,
              // ),

              dateOfBirth(
                controller: _dobController,
                hintText: '12/05/2002',
                label: 'Date Of Birth',
                trailingIcon: Icons.date_range,
                onTap: (){
                  setState(() {
                    _isBirthNotWritten = false;
                  });
                }
              ),

              _isBirthNotWritten ? errorTextProfile(text: 'Required Field') : const SizedBox(),

              // TextFormField(
              //   controller: _ageController,
              //   decoration: InputDecoration(labelText: 'Age'),
              // ),

              CustomTextField(
                isNum: true,
                controller: _ageController,
                onChange: (){
                  setState(() {
                    _isAgeNotWritten = false;
                  });
                },
                hintText: '28',
                label: 'Age',
                trailingIcon: Icons.person_rounded,
              ),

              _isAgeNotWritten ? errorTextProfile(text: 'Age Range: 8-100') : const SizedBox(),

              // TextFormField(
              //   controller: _maritalStatusController,
              //   decoration: InputDecoration(labelText: 'Marital Status'),
              // ),

              Card(
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                  child: CustomDropdownMenu(context: context,
                    title: 'Marital Status',
                    items: itemsMarrage,
                    selectedValue: dropDownMenuValueMarrage,
                    onChanged: (String? value) {
                      setState(() {
                        dropDownMenuValueMarrage = value;
                        setState(() {
                          _isMarriedNotWritten = false;
                        });
                      });
                      // Do something with the selected value
                      print('Selected value: $value');
                    }, isBlackSelectGroup: true,),
                ),
              ),

              _isMarriedNotWritten ? errorTextProfile(text: 'Required Field') : const SizedBox(),

              // CustomTextField(
              //   isNum: false,
              //   controller: _maritalStatusController,
              //   hintText: 'Single',
              //   label: 'Marital Status',
              //   trailingIcon: Icons.group_rounded,
              // ),

              //
              // TextFormField(
              //   controller: _heightController,
              //   decoration: InputDecoration(labelText: 'Height'),
              // ),


              CustomTextField(
                isNum: true,
                controller: _heightController,
                onChange: (){
                  setState(() {
                    _isHeightNotWritten = false;
                  });
                },
                hintText: '180 cm',
                label: 'Height (cm)',
                trailingIcon: Icons.height_rounded,
              ),

              _isHeightNotWritten ? errorTextProfile(text: 'Range: 55cm-271cm') : const SizedBox(),
              // TextFormField(
              //   controller: _weightController,
              //   decoration: InputDecoration(labelText: 'Weight'),
              // ),


              CustomTextField(
                isNum: true,
                controller: _weightController,
                onChange: (){
                  setState(() {
                    _isWeightNotWritten = false;
                  });
                },
                hintText: '70 Kg',
                label: 'Weight (Kg)',
                trailingIcon: Icons.kitchen_rounded,
              ),

              _isWeightNotWritten ? errorTextProfile(text: 'Range: 30kg-150kg') : const SizedBox(),

              // TextFormField(
              //   controller: _bloodGroupController,
              //   decoration: InputDecoration(labelText: 'Blood Group'),
              // ),

              // CustomTextField(
              //   isNum: false,
              //   controller: _bloodGroupController,
              //   hintText: 'O+',
              //   label: 'Blood Group',
              //   trailingIcon: Icons.bloodtype,
              // ),


              Card(
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                  child: CustomDropdownMenu(context: context,
                    title: 'Blood Group',
                    items: itemsBloodGroup,
                    selectedValue: dropDownMenuValueBloodGroup,
                    onChanged: (String? value) {
                      setState(() {
                        dropDownMenuValueBloodGroup = value;
                        setState(() {
                          _isBloodNotWritten = false;
                        });
                      });
                      // Do something with the selected value
                      print('Selected value: $value');
                    }, isBlackSelectGroup: true,),
                ),
              ),

              _isBloodNotWritten ? errorTextProfile(text: 'Required Field') : const SizedBox(),



              const SizedBox(height: 35,),

              // Contact Detail Section
              // Add editable text fields for contact details
              Divider(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1), thickness: 2,),

              const SizedBox(height: 35,),

              Text(
                "Location Detail",
                style: TextStyle(
                    fontSize: 19,
                    height: 1.38,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Roboto',
                    color: Theme.of(context).colorScheme.onPrimary
                ),
              ),
              const SizedBox(height: 20,),

              // TextFormField(
              //   controller: _mobileController,
              //   decoration: InputDecoration(labelText: 'Mobile Number'),
              // ),

              // CustomTextField(
              //   isNum: true,
              //   controller: _mobileController,
              //   hintText: '7056794079',
              //   label: 'Mobile Number',
              //   trailingIcon: Icons.phone,
              // ),


              // TextFormField(
              //   controller: _stateController,
              //   decoration: InputDecoration(labelText: 'State'),
              // ),

              GestureDetector(
                onTap: () {
                  getLocation().then((_) {
                    setState(() {
                      StateIs=state!;
                      CityIs=city!;
                      PincodeIs=pinCode!;
                    });
                  });
                },
                child: getLocationDetailWidget(
                  label: StateIs,
                  trailingIcon: Icons.location_searching,
                ),
              ),
              
              _isLoactionNotWritten ? errorTextProfile(text: 'Location is Required Tap On It') : const SizedBox(),


              // GestureDetector(
              //   onTap: (){
              //     getLocation();
              //     print('State: $state');
              //     print('City: $city');
              //     print('Pin Code: $pinCode');
              //   },
              //   child: MaterialButton(
              //     onPressed: (){
              //       getLocation();
              //       print('State: $state');
              //       print('City: $city');
              //       print('Pin Code: $pinCode');
              //     },
              //     child: Text('hello'),
              //   )
              // ),


              // TextFormField(
              //   controller: _cityController,
              //   decoration: InputDecoration(labelText: 'City'),
              // ),



              GestureDetector(
                onTap: () {
                  getLocation().then((_) {
                    setState(() {
                      StateIs=state!;
                      CityIs=city!;
                      PincodeIs=pinCode!;
                    });
                  });
                },
                child: getLocationDetailWidget(
                  label: CityIs,
                  trailingIcon: Icons.location_city_rounded,
                ),
              ),

              // TextFormField(
              //   controller: _pinCodeController,
              //   decoration: InputDecoration(labelText: 'Pin code'),
              // ),

              GestureDetector(
                onTap: () {
                  getLocation().then((_) {
                    setState(() {
                      StateIs=state!;
                      CityIs=city!;
                      PincodeIs=pinCode!;
                    });
                  });
                },
                child: getLocationDetailWidget(
                  label: PincodeIs,
                  trailingIcon: Icons.pin,
                ),
              ),

              const SizedBox(height: 30,),

              // Save Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.65,
                      53,
                    ), backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0, // Remove elevation (shadow) effect
                  ),
                  onPressed: () {
                    submitButton();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40,)
            ],
          ),
        ),
      ),
    );
  }
  Widget dateOfBirth({
    required TextEditingController controller,
    required String hintText,
    required String label,
    required IconData trailingIcon,
    required Function onTap
  }) {
    return Card(
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: TextFormField(
          readOnly: true,
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData.light().copyWith( // Customize the dialog theme
                    dialogBackgroundColor: Colors.white, // Set background color to white
                    primaryColor: Colors.black
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              // Format the selected date as "dd/mm/yyyy"
              onTap();
              final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
              // Update the controller with the formatted date
              controller.text = formattedDate;
            }
          },
          keyboardType: TextInputType.datetime,
          controller: controller,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: Icon(
              trailingIcon,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.black45,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
            labelText: label,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: 'Roboto',
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget errorTextProfile({
      required String text
    }){
    return Padding(
      padding: const EdgeInsets.only(left: 10,bottom: 10),
      child: Text(text, style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.error,
      ),),
    );
  }

  Widget getLocationDetailWidget({
    required final String label,
    required IconData trailingIcon,
  }){
    return Card(
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(height: 48,),
                Text(label, style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                    fontSize: 15
                ),),
              ],
            ),
            Icon(
              trailingIcon,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ],
        )
      ),
    );
  }
}