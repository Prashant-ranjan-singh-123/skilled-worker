import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotificationStorage {
  static const String _notificationTitleKey = 'notificationTitle';
  static const String _notificationBodyKey = 'notificationBody';

  static Future<void> addNotification(String? title, String? body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> titles = prefs.getStringList(_notificationTitleKey) ?? [];
    List<String> bodies = prefs.getStringList(_notificationBodyKey) ?? [];

    titles.add(title ?? '');
    bodies.add(body ?? '');

    await prefs.setStringList(_notificationTitleKey, titles);
    await prefs.setStringList(_notificationBodyKey, bodies);
  }

  static Future<void> addNotifiFirebase(String? title, String? body, String? num, String? imageUrl) async {
    if(title!='' && body!='') {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(num)
          .update({
        'notificationTitle': FieldValue.arrayUnion(
            [title]),
        'notificationBody': FieldValue.arrayUnion(
            [body]),
        'notificationImage': FieldValue.arrayUnion(
            [imageUrl])
      });
    }
  }

  static Future<Map<String, String>> getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> titles = prefs.getStringList(_notificationTitleKey) ?? [];
    List<String> bodies = prefs.getStringList(_notificationBodyKey) ?? [];

    Map<String, String> notificationMap = {};

    for (int i = 0; i < titles.length && i < bodies.length; i++) {
      notificationMap[titles[i]] = bodies[i];
    }

    return notificationMap;
  }

  static Future<Map<String, String>> getNotificationsFromFirebase(String? num) async {
    Map<String, String> notificationMap = {};
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(num)
        .get();
    List<dynamic>? titles = documentSnapshot.data()?['notificationTitle'];
    List<dynamic>? bodies = documentSnapshot.data()?['notificationBody'];
    if (titles != null && bodies != null) {
      for (int i = titles.length - 1; i >= 0 && i < bodies.length; i--) {
        notificationMap[titles[i].toString()] = bodies[i].toString();
      }
    }
    return notificationMap;
  }


  static Future<void> clearNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationTitleKey);
    await prefs.remove(_notificationBodyKey);
  }
}