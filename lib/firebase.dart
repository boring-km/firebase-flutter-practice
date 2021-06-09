import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseImpl {
  static addTest(String data) {
    Firestore.instance
        .collection('test')
        .document("realDocId")
        .setData({'myName': data});
  }

  static Future<String> readTest() async{
    var result = "not started";
    await Firestore.instance
        .collection('test')
        .document("realDocId").get()
        .then((snapshot) => result = snapshot.data['myName']);
    return result;
  }
}