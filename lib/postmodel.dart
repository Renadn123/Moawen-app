import 'package:shared_preferences/shared_preferences.dart';

class PostModel {
  late String postText;
  late String image;
  late String userid;
  late String name;
  late String username;
  late String imageUser;
  late String time;
  PostModel({
    required this.image,
    required this.time,
    required this.postText,
    required this.userid,
    required this.imageUser,
    required this.name,
    required this.username,
  });

  PostModel.json(Map data) {
    postText = data['PostText'].toString();
    time = data['Time'].toString();
    userid = data['UserID'].toString();
    image = data['image'].toString();
    imageUser = data['imageUser'].toString();
    name = data['name'].toString();
    username = data['username'].toString();
  }
}

class CatchHelper {
  static SharedPreferences? prf;
  static String? uid;
  static String? type;

  static init() async {
    prf = await SharedPreferences.getInstance();
  }

  static Future<bool> setData(String? value) async {
    return await prf!.setString('uid', value!);
  }

  static getUid() {
    uid = CatchHelper.prf!.getString('uid');
  }

  static Future<bool> setDataType(String? value) async {
    return await prf!.setString('type', value!);
  }

  static getType() {
    type = CatchHelper.prf!.getString('type');
  }
}

class PostModelProfile {
  late String postText;
  late String image;
  late String userid;
  late String time;
  PostModelProfile({
    required this.image,
    required this.time,
    required this.postText,
    required this.userid,
  });

  PostModelProfile.json(Map data) {
    postText = data['PostText'].toString();
    time = data['Time'].toString();
    userid = data['UserID'].toString();
    image = data['image'].toString();
  }
}
