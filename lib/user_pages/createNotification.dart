import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_bhartiya/main.dart';
import 'package:v_bhartiya/shimmer/pushnotification_shimmer.dart';
import 'package:v_bhartiya/shimmer/waiting_page.dart';
import 'package:v_bhartiya/user_pages/user_bottom_navigation_screen.dart';
import 'package:v_bhartiya/user_pages/utils/dropdown_menu.dart';
import '../notifications_things_plus_num_fetch/save_notification_shared_pref.dart';
import '../shimmer/notification_shimmer.dart';
import '../utils/snakbar.dart';

class CreateNotification extends StatefulWidget {
  @override
  _CreateNotificationState createState() => _CreateNotificationState();
}

class _CreateNotificationState extends State<CreateNotification> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  XFile? _image;
  String? _imageUrl;
  bool _titleNotFilledSubmit=false;
  bool _bodyNotFilledSubmit=false;
  bool _imageNotFilledSubmit=false;
  bool _groupNotFilledSubmit=false;
  final List<String> items = [
    'Doctor',
    'Photographer',
    'Programmer',
    'Recruiter',
    'Student',
    'Writer',
    'All',
  ];
  String? dropDownMenuValue;

  void notificationTapBackground(NotificationResponse notificationResponse) {
    // ignore: avoid_print
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }

  initInfo() {
    var androidInitialize = const AndroidInitializationSettings(
        '@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: androidInitialize);

    final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            Get.to(const MainScreenUser(pageNumber: 1,), transition: Transition.upToDown, duration: const Duration(seconds: 0));
            break;
          case NotificationResponseType.selectedNotificationAction:
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );


    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Create notification');
      print('..............ON Message...........');
      print('onMessage: ${message.notification?.title}/${message.notification
          ?.body}');




      // final int id = NotificationService().generateRandomNumber();
      // NotificationService().showNotification(id: id, title: message.notification?.title, body: message.notification?.body);
      // print('Shown Notification');
      // getNotificationsFromFirebase();

      // Storing notifications Shared Pref
      // await UserNotificationStorage.addNotification(
      //     message.notification?.title,
      //     message.notification?.body);
      // Retrieving notifications Shared Pref
      // _notificationTotal = await UserNotificationStorage.getNotifications();

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'dbfood', // Channel ID
        'dbfood', // Channel Name
        importance: Importance.max,
        styleInformation: bigTextStyleInformation,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
      );


      final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        // payload: message.data['title'],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    initInfo();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }


  Future<void> sendNotification() async {
    print('Image Url is haha: $_imageUrl');
    var startTime = DateTime.now();
    String titleString = _titleController.text;
    String bodyString = _messageController.text;

    print('title: $titleString');
    print('body: $bodyString');
    print('DropDown: $dropDownMenuValue');
    print('imageUrl: $_imageUrl');

    if(titleString!=''&&bodyString!=''&&dropDownMenuValue!=null&&_imageUrl!=null){
      Get.to(const WaitingPage());
      print('Back Called 6');
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? num = pref.getString('logedInNum');
      if(dropDownMenuValue!='All') {
        print('Back Called 5');
        var documentSnapshot = await FirebaseFirestore.instance.collection(
            'Types').doc(dropDownMenuValue).get();
        if (documentSnapshot.exists) {
          var tokens = documentSnapshot.data()?['tokens'] ?? {};
          tokens.forEach((key, value) async {
            print('Push Notification Num: $key');
            sendPushMessage(value, titleString, bodyString);
            // print('Image url: $_imageUrl');
            await UserNotificationStorage.addNotifiFirebase(
                titleString,
                bodyString,
                key,
                _imageUrl,
                );
            print('Number is: $key, Token values: $value');
          });
        } else {
          SnakbarCustom().show('No Users', 'Regrettably, There are currently no users affiliated with the category $dropDownMenuValue.');
        }
        print('Back Called 4');
      } else{
        for(int i=0;i<items.length-1;++i){
          var documentSnapshot = await FirebaseFirestore.instance.collection(
              'Types').doc(items[i]).get();
          if (documentSnapshot.exists) {
            var tokens = documentSnapshot.data()?['tokens'] ?? {};
            tokens.forEach((key, value) async {
              print('Push Notification Num: $key Req');
              sendPushMessage(value, titleString, bodyString);
              print('Push Notification Num: $key Done');
              // print('Image url: $_imageUrl');
              // print('Phone Number: $key');
              await UserNotificationStorage.addNotifiFirebase(
                titleString,
                bodyString,
                key,
                _imageUrl,
              );
              print('Back Called 2');
              print('Number is: $key, Token values: $value');
            });
          }
        }
      }
      print('Back Called 1');
      int elapsedTime = Duration(milliseconds: DateTime.now().difference(startTime).inMilliseconds).inSeconds;
      if (elapsedTime < 5) {
        int remainingTime = 5 - elapsedTime;
        if (remainingTime > 0) {
          await Future.delayed(Duration(seconds: remainingTime));
        }
      }
      print('Back Called');
      Get.offUntil(GetPageRoute(page: () => const MainScreenUser(pageNumber: 0,)), (route) => Get.currentRoute == '/');
      // Get.back();
      // Get.back();
    } else{
      if(titleString==''){
        _titleNotFilledSubmit=true;
      }else{
        _titleNotFilledSubmit=false;
      }
      if(bodyString==''){
        _bodyNotFilledSubmit=true;
      }else{
        _bodyNotFilledSubmit=false;
      }
      if(dropDownMenuValue==null){
        _groupNotFilledSubmit=true;
      }else{
        _groupNotFilledSubmit=false;
      }
      if(_imageUrl==null){
        _imageNotFilledSubmit=true;
      }else{
        _imageNotFilledSubmit=false;
      }
      setState(() {});
    }
  }

  void disableTouch(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const PushNotificationShimmer();
      },
    );
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = pickedFile;
      setState(() {});
      disableTouch(context);
      uploadImageToFirebase().then((imageUrl) async {
        print('Image Uploaded: $imageUrl');
        var newImageUrl = imageUrl?.replaceAll('https://', '');
        newImageUrl = imageUrl?.replaceAll(RegExp(r'/{2,}'), '/');
        print('Image Uploaded updated: $newImageUrl');
        _imageUrl=newImageUrl;
        Get.back();
        if(_imageNotFilledSubmit) {
          _imageNotFilledSubmit = false;
          setState(() {});
        }
      }).catchError((error) {
        print('Error uploading image: $error');
        Get.back();
      });
    } else {
      // SnakbarCustom().show('Null Value', "You haven't picked any Image.");
      if(!_imageNotFilledSubmit) {
        _imageNotFilledSubmit = true;
        setState(() {});
      }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Set to true to resize when keyboard appears
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.background,
          title: const Text('Push Notification'),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                Center(
                  child: Text(
                    'Title',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                TextField(
                  controller: _titleController,
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w500),
                  onChanged: (_){
                    if(_titleNotFilledSubmit) {
                      _titleNotFilledSubmit = false;
                      setState(() {});
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.title, color: Theme.of(context).colorScheme.onSecondary),
                    hintText: 'Ex: Freshers Hiring',
                    hintStyle: const TextStyle(color: Colors.black45, fontFamily: 'Roboto'),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5), // Blue border when not focused
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2), // Blue border when not focused
                    ),
                  ),
                ),
                SizedBox(
                  child: _titleNotFilledSubmit
                      ? Center(
                    child: Text(
                      'Title is Required',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  )
                      : const SizedBox(),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Center(
                  child: Text(
                    'Message',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                TextField(
                  maxLines: 5,
                  controller: _messageController,
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w500),
                  onChanged: (_){
                    if(_bodyNotFilledSubmit) {
                      _bodyNotFilledSubmit = false;
                      setState(() {});
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.messenger, color: Theme.of(context).colorScheme.onSecondary),
                    hintText: 'Write a message you want to Broadcast.',
                    hintStyle: const TextStyle(color: Colors.black45, fontFamily: 'Roboto'),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 0.5), // Blue border when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2), // Blue border when not focused
                      ),
                  ),
                ),

                SizedBox(
                  child: _bodyNotFilledSubmit
                      ? Center(
                    child: Text(
                      'Message is Required',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  )
                      : const SizedBox(),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Center(
                  child: Text(
                    'Select User Group',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                Card(
                  color: Theme.of(context).colorScheme.background,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                    child: CustomDropdownMenu(context: context,
                      title: 'Select Group',
                      items: items,
                      selectedValue: dropDownMenuValue,
                      onChanged: (String? value) {
                        setState(() {
                          dropDownMenuValue = value;
                          if(_groupNotFilledSubmit) {
                            _groupNotFilledSubmit = false;
                            setState(() {});
                          }
                        });
                        // Do something with the selected value
                        print('Selected value: $value');
                      }, isBlackSelectGroup: true,),
                  ),
                ),
                SizedBox(
                  child: _groupNotFilledSubmit
                      ? Center(
                    child: Text(
                      'Group Selection is Required',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  )
                      : const SizedBox(),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Center(
                  child: Text(
                    'Upload Image',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Center(
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.5,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(45.0),
                        ),
                        child: InkWell(
                          onTap: (){
                              getImage();
                          },
                          child: _image != null
                              ? Image.file(File(_image!.path), fit: BoxFit.cover,)
                              : Icon(
                            Icons.camera_alt,
                            size: 50.0,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                    ),
                SizedBox(
                  child: _imageNotFilledSubmit
                      ? Center(
                    child: Text(
                      'Image is Required',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  )
                      : const SizedBox(),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.045),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.65, 53),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0, // Remove elevation (shadow) effect
                    ),
                    onPressed: () {
                      sendNotification();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Roboto'),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendPushMessage(token, String titleString, String bodyString) async {
    try{
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers:<String, String>{
          // 'Authorization': 'key=AAAAjYF7Edc:APA91bGYpUeebkbuZbrJXCwQ-BWKaJgbe_sz5Ajd6uizszj6kKEJXGFm0B_5V-Hgs5j9d0aLqBYyYy4B3NCiuRbiLlSsqDHfG-Jde0BJ__nFbo4JMy-sdFYXdGYfsgHFVTP2rIPHmp-P',
          'Authorization': 'key=AAAAjYF7Edc:APA91bGYpUeebkbuZbrJXCwQ-BWKaJgbe_sz5Ajd6uizszj6kKEJXGFm0B_5V-Hgs5j9d0aLqBYyYy4B3NCiuRbiLlSsqDHfG-Jde0BJ__nFbo4JMy-sdFYXdGYfsgHFVTP2rIPHmp-P',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority':'high',
            'data':<String, dynamic>{
              'click_action':'FLUTTER_NOTIFICATION_CLICK',
              'status':'done',
              'body':bodyString,
              'title': titleString,
              // 'image': _imageUrl,
            },

            "notification":<String, dynamic>{
              'title': titleString,
              'body':bodyString,
              'android_channel_id':'dbfood',
              // 'image': _imageUrl,
            },
            'to': token
          }
        )
      );
    }catch (Exception){
      print(Exception);
    }
  }
}
