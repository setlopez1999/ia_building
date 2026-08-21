import 'package:shared_preferences/shared_preferences.dart';

class RememberRepository {
  Future<void> cleanRemember() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.remove('ru');
    await sharedPrefs.remove('rp');
  }

  Future<void> setRemember(String user, String pass) async{
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString('ru', user);
    await sharedPrefs.setString('rp', pass);
  }

  Future<String> getRemember() async{
    final sharedPrefs = await SharedPreferences.getInstance();
    final ru =  sharedPrefs.getString('ru');
    final rp = sharedPrefs.getString('rp');

    if(ru == null || rp == null) {
      return '';
    }

    return '$ru __ $rp';
  }

}