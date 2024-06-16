import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:v_bhartiya/user_pages/landingPage.dart';
import 'package:v_bhartiya/user_pages/user_bottom_navigation_screen.dart';
import '../notifications_things_plus_num_fetch/notification_expand_page.dart';
import '../shimmer/notification_shimmer.dart';
import '../utils/Internet/CheckInternetConnectionWidget.dart';
import '../utils/snakbar.dart';
import 'createNotification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({Key? key}) : super(key: key);

  @override
  State<UserNotification> createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  String imagePath = '';
  String? _number;
  String? _currentPlan;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late List<dynamic> _title = [];
  late List<dynamic> _body = [];
  late List<dynamic> _image = [];


  void disableTouch(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return NotificationShimmer(isAppBar: true);
      },
    );
  }

  void enableTouch(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> removeItem(int index) async {
    disableTouch(context);
    int firebase_array_ele=_body.length-1-index;
    print(firebase_array_ele);
    _body.removeAt(index);
    _title.removeAt(index);
    _image.removeAt(index);
    await deleteFirebaseNotificationAtIndex(firebase_array_ele);
    if(_body.isNotEmpty){
      _isEmptyInbox=false;
    }else{
      _isEmptyInbox=true;
    }
    enableTouch(context);
    setState(() {});
  }

  // initInfo() {
  //   var androidInitialize = const AndroidInitializationSettings(
  //       '@mipmap/ic_launcher');
  //   var initializationSettings = InitializationSettings(
  //       android: androidInitialize);
  //
  //   flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //     onDidReceiveNotificationResponse:
  //         (NotificationResponse notificationResponse) {
  //           switch (notificationResponse.notificationResponseType) {
  //             case NotificationResponseType.selectedNotification:
  //               Get.to(const MainScreenUser(pageNumber: 1,), transition: Transition.upToDown, duration: const Duration(seconds: 0));
  //               break;
  //             case NotificationResponseType.selectedNotificationAction:
  //               break;
  //           }
  //     },
  //     onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  //   );
  //
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     print('..............ON Message...........');
  //     print('onMessage: ${message.notification?.title}/${message.notification
  //         ?.body}');
  //
  //     // final int id = NotificationService().generateRandomNumber();
  //     // NotificationService().showNotification(id: id, title: message.notification?.title, body: message.notification?.body);
  //     // print('Shown Notification');
  //     getNotificationsFromFirebase();
  //
  //     // Storing notifications Shared Pref
  //     // await UserNotificationStorage.addNotification(
  //     //     message.notification?.title,
  //     //     message.notification?.body);
  //     // Retrieving notifications Shared Pref
  //     // _notificationTotal = await UserNotificationStorage.getNotifications();
  //
  //     BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
  //       message.notification!.body.toString(),
  //       htmlFormatBigText: true,
  //       contentTitle: message.notification!.title.toString(),
  //       htmlFormatContentTitle: true,
  //     );
  //
  //     AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'dbfood', // Channel ID
  //       'dbfood', // Channel Name
  //       importance: Importance.max,
  //       styleInformation: bigTextStyleInformation,
  //       priority: Priority.max,
  //       playSound: true,
  //       enableVibration: true,
  //     );
  //
  //
  //     NotificationDetails platformChannelSpecifics = NotificationDetails(
  //         android: androidPlatformChannelSpecifics);
  //     await flutterLocalNotificationsPlugin.show(
  //       0,
  //       message.notification?.title,
  //       message.notification?.body,
  //       platformChannelSpecifics,
  //       payload: message.data['title'],
  //     );
  //   });
  // }

  void notificationTapBackground(NotificationResponse notificationResponse) {
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      print(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }

  static Future<void> backgroundNotificationHandler(NotificationResponse notificationResponse) async {
    // Here you can perform any background tasks or handle the notification response
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      print(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }

  void initInfo() async {
    var androidInitialize = const AndroidInitializationSettings(
        '@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: androidInitialize);

    await flutterLocalNotificationsPlugin.initialize(
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
      onDidReceiveBackgroundNotificationResponse: backgroundNotificationHandler,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('..............ON Message...........');
      print('onMessage: ${message.notification?.title}/${message.notification?.body}');

      getNotificationsFromFirebase();

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

      NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        payload: message.data['title'],
      );
    });
  }


  Future<String?> getLogInNum() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? num = pref.getString('logedInNum');
    _number = num;
    print('Number is: $_number');
    var documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(num).get();
    _currentPlan = documentSnapshot.data()?['plan'] as String?;
  }

  Future<void> getNotificationsFromFirebase() async {
    // print('Number is: $_number');
    // _notificationTotal = await UserNotificationStorage.getNotificationsFromFirebase(_number);
    // print('Notification: $_notificationTotal');
    Future<void> chkAlertPramFire(DocumentSnapshot userSnapshot2) async {
      if (userSnapshot2.exists) {
        Map<String, dynamic>? data = userSnapshot2.data() as Map<String, dynamic>?;
        if (data != null) {
          if (!data.containsKey('notificationBody')) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(_number)
                .update({'notificationBody': []});
          }
          if (!data.containsKey('notificationTitle')) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(_number)
                .update({'notificationTitle': []});
          }
          if (!data.containsKey('notificationImage')) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(_number)
                .update({'notificationImage': []});
          }
        }
      }
    }

    var userSnapshot2 = await FirebaseFirestore.instance
        .collection('users')
        .doc(_number)
        .get();

    if(userSnapshot2.data()?['notificationBody']==null ||
        userSnapshot2.data()?['notificationTitle']==null ||
        userSnapshot2.data()?['notificationImage']==null
    ){
      chkAlertPramFire(userSnapshot2);
      setState(() {
        if(_title.isNotEmpty||_body.isNotEmpty){
          _isEmptyInbox=false;
        }else{
          _isEmptyInbox=true;
        }
        _notificationsLoaded = true;
      });
      return;
    }
    
    
    _body = userSnapshot2.data()?['notificationBody'];
    _title = userSnapshot2.data()?['notificationTitle'];
    _image = userSnapshot2.data()?['notificationImage'];
    

    if(isTrimmedAndCleaned()){
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_number)
            .update({
          'notificationBody': _body,
          'notificationTitle': _title,
          'notificationImage': _image
        });
        print('Update successful');
      } catch (e) {
        SnakbarCustom().show('Error', 'Error In Backend Inundation Process: $e.');
      }
    }

    reverseArry();

    for(int i=_body.length-1;i>-1;i--){
      print('Title: ${_title[i]}');
      print('Body: ${_body[i]}');
      print('Image: ${_image[i]}');
    }

    setState(() {
      if(_title.isNotEmpty||_body.isNotEmpty){
        _isEmptyInbox=false;
      }else{
        _isEmptyInbox=true;
      }
      _notificationsLoaded = true;
    });
  }

  bool isTrimmedAndCleaned() {
    // It will check all 3 array length are equal or not if it is equal it will return false else true
    int originalImageLength = _image.length;
    int originalTitleLength = _title.length;
    int originalBodyLength = _body.length;
    int smallestLength = _image.length;
    if (_title.length < smallestLength) smallestLength = _title.length;
    if (_body.length < smallestLength) smallestLength = _body.length;
    _image.length = smallestLength;
    _title.length = smallestLength;
    _body.length = smallestLength;
    return !(_image.length == originalImageLength) ||
           !(_title.length == originalTitleLength) ||
           !(_body.length == originalBodyLength);
  }

  void reverseArry(){
    int p1=0;
    int p2=_title.length-1;
    while(p1<=p2){
      String temp = _title[p1];
      String temp2 = _body[p1];
      String temp3 = _image[p1];
      _title[p1]=_title[p2];
      _title[p2]=temp;
      _body[p1]=_body[p2];
      _body[p2]=temp2;
      _image[p1]=_image[p2];
      _image[p2]=temp3;
      p1++;
      p2--;
    }
  }

  Future<void> deleteFirebaseNotificationAtIndex(int index) async {
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(_number);
    try {
      DocumentSnapshot documentSnapshot = await userDocRef.get();
      List<dynamic> notificationBody = documentSnapshot['notificationBody'];
      List<dynamic> notificationTitle = documentSnapshot['notificationTitle'];
      List<dynamic> notificationImage = documentSnapshot['notificationImage'];
      notificationBody.removeAt(index);
      notificationTitle.removeAt(index);
      notificationImage.removeAt(index);
      await userDocRef.update({'notificationBody': notificationBody});
      await userDocRef.update({'notificationTitle': notificationTitle});
      await userDocRef.update({'notificationImage': notificationImage});
      print('Notification at index $index deleted successfully.');
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }


  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        sound: true,
        badge: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User Granted Permission');
    } else
    if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User Granted Provisional Permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void listenForNotifications() {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    databaseReference.child('notifications').onChildAdded.listen((event) {
      var notification = event.snapshot.value;
      print('New Notification: $notification');
    });
  }

  Future<void> addNotification() async {
    // final int id = NotificationService().generateRandomNumber();
    // NotificationService().showNotification(id: id, title: 'hello', body: 'body');
    if (_currentPlan == null) {
      // return;
    } else if (_currentPlan == 'Basic') {
      Get.dialog(
        AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary, // Set the background color to white
          shadowColor: Colors.black,
          title: Text(
            "Plan Upgrade Required",
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.background, fontWeight: FontWeight.w700, fontFamily: 'Oswald'),
          ),
          content: Text(
            "This functionality is available on our higher tiers. Explore our upgrade options to see which plan best suits your needs.",
            style: TextStyle(color:Theme.of(context).colorScheme.background.withOpacity(0.9), fontWeight: FontWeight.w500),
          ),
          actions: [
            MaterialButton(
              color: Theme.of(context).colorScheme.error,
              onPressed: (){
                Get.back(result: false);
              },
              child: Text(
                "OK",
                style: TextStyle(color:Theme.of(context).colorScheme.background.withOpacity(0.9), fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
    } else if (_currentPlan == 'Standard') {
      Get.to(CreateNotification(), transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 500));
    } else if (_currentPlan == 'Premium') {
      Get.to(CreateNotification(), transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 500));
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await getLogInNum();
    getNotificationsFromFirebase();
    requestPermission();
    initInfo();
  }

  bool _notificationsLoaded = false;
  bool _isEmptyInbox = true;

  @override
  Widget build(BuildContext context) {
    imagePath = 'assets/onboarding/notification.png';
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .background,
          foregroundColor: Theme
              .of(context)
              .colorScheme
              .background,
          automaticallyImplyLeading: false,
          title: const Center(child: Text("Notification")),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      body: _notificationsLoaded
          ?
        _isEmptyInbox?
        EmptyInbox(context):
        NotificationShown(context)
          : NotificationShimmer(isAppBar: false,),
    );
  }
  Widget notificationCard(BuildContext context, int index) {
    String key = _title[index];
    // String key = index;
    String value = _body[index];
    bool isRead = true; // Assuming all notifications are read initially

    return Dismissible(
      key: Key(key),
      onDismissed: (direction) {
        setState(() {
          removeItem(index);
        });
      },
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
        color: Colors.red,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: InkWell(
        onTap: (){
          Get.to(NotificationExpand(title: _title[index], body: _body[index], image: _image[index],),transition: Transition.rightToLeft, duration: const Duration(milliseconds: 500));
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
          decoration: ShapeDecoration(
            color: isRead ? null : Theme
                .of(context)
                .colorScheme
                .primary
                ,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isRead ? null : Theme
                          .of(context)
                          .colorScheme
                          .onBackground,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 54,
                    height: 54,
                    decoration: ShapeDecoration(shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                    child: Card(
                      elevation: 5,
                      color: Theme.of(context).colorScheme.background,
                        child: Image.asset(imagePath)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _title[index],
                          style: TextStyle(
                            color: isRead ? Theme
                                .of(context)
                                .colorScheme
                                .onPrimary : Theme
                                .of(context)
                                .colorScheme
                                .onBackground,
                            fontSize: 13,
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _body[index],
                          style: TextStyle(
                            color: isRead ? Theme
                                .of(context)
                                .colorScheme
                                .onPrimary : Theme
                                .of(context)
                                .colorScheme
                                .onBackground,
                            fontSize: 10,
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                      onTap: () {
                        setState(() {
                          removeItem(index);
                        });
                      },
                      child: Icon(Icons.delete_outline, color: Theme
                          .of(context)
                          .colorScheme
                          .onPrimary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget NotificationShown(BuildContext context){
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 19),
                itemCount: _body.length,
                itemBuilder: (context, index) =>
                    notificationCard(context, index),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
        Align(
          alignment: const Alignment(0.82, 0.72),
          child: SizedBox(
            width: 60, // Adjust width as needed
            height: 60, // Adjust height as needed
            child: Material(
              shape: const CircleBorder(),
              elevation: 5,
              color: Theme.of(context).colorScheme.primary,
              child: IconButton(
                icon: const Icon(Icons.notification_add, size: 25,),
                onPressed: () {
                  addNotification();
                },
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget EmptyInbox(BuildContext context){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.2,),
            Center(child: Card(elevation: 10, color: Theme.of(context).colorScheme.background,
                child: Image.asset('assets/onboarding/noNotification.png'))),
            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
            Text('Start by adding a alert',style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
                fontFamily: 'Roboto'
            ),),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            Row(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                  flex: 8,
                  child: Text('Click on the button at the bottom to add a new notification',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontFamily: 'Roboto'
                    ),),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.15,),
            Card(
              elevation: 10,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 53,
                child: ElevatedButton(
                  onPressed: () {
                    addNotification();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0, // Remove elevation (shadow) effect
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_active_sharp, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          'ADD ALERT',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}