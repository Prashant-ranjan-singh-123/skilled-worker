import 'package:shared_preferences/shared_preferences.dart';

class GetNum{
  Future<String?> getLogInNum() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? num = pref.getString('logedInNum');
    return num;
  }
}