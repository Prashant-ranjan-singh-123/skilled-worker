import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../utils/snakbar.dart';

class Tokens{
  Future<void> deleteTokens(String ?num) async {
    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(num)
          .get();
      var userGroup = userSnapshot.data()?['selectGroup'];

      await FirebaseFirestore.instance
          .collection('Types')
          .doc(userGroup)
          .update({
        'tokens.$num': FieldValue.delete(),
      });

      // Delete token from 'users' collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(num)
          .update({
        'token': FieldValue.delete(),
      });

      print('Tokens deleted successfully');
    } catch (e) {
      SnakbarCustom().show('Error', 'Error In Backend Inundation Process: $e.');
    }
  }


  Future<void> delToken(String ?num) async {
    try {
      print('Number is: $num');
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(num)
          .get();
      String selectGroup = documentSnapshot.data()?['selectGroup'];
      print('Group is: $selectGroup');

      // Delete token from 'Plans' collection
      await FirebaseFirestore.instance
          .collection('Types')
          .doc(selectGroup)
          .update({
        'tokens.$num': FieldValue.delete(),
      });
      print('$selectGroup token deleted.');

      // Delete token from 'users' collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(num)
          .update({
        'token': FieldValue.delete(),
      });
      print('Users token deleted.');
    } catch (e) {
      print('Error deleting token: $e');
    }
  }

  Future<void> getToken(String num, String ?selctGroup, [bool isUserGroupGiven = true]) async {
    // String? rTypeToken;
    try {
      await FirebaseMessaging.instance.getToken().then((token) async {
        print('after token: ');
        print(token);
        // await FirebaseFirestore.instance
        //     .collection('Plans')
        //     .doc('Basic')
        //     .set({
        //   'tokens': FieldValue.arrayUnion([token]),
        // }, SetOptions(merge: true));
        if(isUserGroupGiven) {
          await FirebaseFirestore.instance
              .collection('Types')
              .doc(selctGroup)
              .set({
            'tokens': {
              num: token
            }
          }, SetOptions(merge: true));
        }else{
          var userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(num)
              .get();
          var userGroup = userSnapshot.data()?['selectGroup'];

          await FirebaseFirestore.instance
              .collection('Types')
              .doc(userGroup)
              .set({
            'tokens': {
              num: token
            }
          }, SetOptions(merge: true));
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(num)
            .set({
          'token': token,
        }, SetOptions(merge: true));
        return token;
      });
    } catch (e){
      getToken(num, selctGroup);
    }
  }

  Future<void> updateToken(String? num, String previousGroup, String newGroup) async {
    if (num == null) {
      return;
    }

    // Delete token from 'Types' collection under previousGroup
    await FirebaseFirestore.instance
        .collection('Types')
        .doc(previousGroup)
        .update({
      'tokens.$num': FieldValue.delete(),
    });

    print('$previousGroup token Deleted');

    // Get the new token
    var userSnapshot2 = await FirebaseFirestore.instance
        .collection('users')
        .doc(num)
        .get();

    String token = userSnapshot2.data()?['token'];

    // Set the token under the newGroup
    if (token != null) {
      print('New token: $token');

      print('Setting token for new group: $newGroup');
      await FirebaseFirestore.instance
          .collection('Types')
          .doc(newGroup)
          .set({
        'tokens': {
          num: token
        }
      }, SetOptions(merge: true));
      print('Setted token for new group: $newGroup');


      // print('Setting token for users: $num');
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(num)
      //     .update({
      //   'token': token,
      // });
      // print('Setted token for users: $num');
    } else {
      // Handle the case where token is null, maybe log an error or return early
      return;
    }
  }

}